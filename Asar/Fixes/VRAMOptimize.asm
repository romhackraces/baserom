; Lunar Magic's "VRAM Patch" Optimization patch
; made by KevinM - inspired by Selicre's rants about this problem
;
; This patch moves Lunar Magic's modified stripe image code from NMI to outside of blank time
; (at the end of the game loop), thus freeing up a lot of blank time for other code to run,
; reducing the chances of blank overflows in a level (i.e., black bars flickering at the top
; of the screen, glitchy HDMA gradients, etc.).
; Do note that it uses a small amount of unused ROM space in bank 0, at $00BA4D.
; If you have some other resource using that space, you'll need to change it with the define below.

; Uses 8 bytes. Must be in bank 0. Default should be fine in most cases.
!freespace_bank0 = $00BA56

; Addresses of the stripe image table. You should never need to change this.
!stripe_index = $7F837B
!stripe_table = $7F837D

if read1($00FFD5) == $23
    sa1rom
    !addr = $6000
    !bank = $000000
else
    lorom
    !addr = $0000
    !bank = $800000
endif

; We need to run this at the end of the frame
; (it's before Addmusic but it doesn't matter).
org $008072
    jsr main

; Free space in bank 0
org !freespace_bank0
main:
    ; Restore original code
    jsr $9322

    ; Do our magic
    autoclean jsl vram
    rts

; Remove Lunar Magic's hijack
; This is what usually clobbers NMI
org $008751
    rep #$20
    lda $03

freecode

; Adapted from $00871E
vram:
    ; Lunar Magic's modifications only happen in certain gamemodes
    lda $0100|!addr
    cmp #$14 : beq .ok
    cmp #$07 : beq .ok
    cmp #$13 : beq .ok
    cmp #$05 : beq .ok
    rtl
.ok:
    rep #$30

    ; Write the stripe table pointer to $00
    lda.w #!stripe_table : sta $00
    lda.w #!stripe_table>>8 : sta $01

    ; Loop through the entire stripe table
    ldy #$0000
.loop:
    ; If the end bit is set, return
    lda [$00],y : bit #$0080 : beq +
    sep #$30
    rtl
+   
    ; Copy the first header word in $03
    xba : sta $03

    ; Set RLE flag in $05
    iny #2
    lda [$00],y : and #$0040 : sta $05

    ; Compute the new VRAM destination
    jmp lm_stripe

.change:
    ; Set the new destination in the stripe table
    dey #2
    xba : sta [$00],y
    iny #2

    ; Check if RLE is used
    lda $05 : bne ..rle
..no_rle:
    ; If not RLE, the data is 2 + (length+1) additional bytes
    lda [$00],y : xba : and #$3FFF
    inc #3
    sta $03
    tya : clc : adc $03 : tay
    bra .loop
..rle:
    ; If RLE, the data is only 4 additional bytes
    iny #4
    bra .loop

; Adapted from Lunar Magic's code
; If it looks bad to you, blame Fusoya :P
lm_stripe:
    ; Skip if destination is not layer 1 tilemap
    lda $03 : and #$7000 : cmp #$2000 : bne .not_layer1

    ; This seems to check if the tile is being drawn outside of the layer 1 tilemap's range or something
    lda $03 : lsr #5 : and #$001F : sta $0B
    lda $03 : and #$0800 : xba : asl #2 : tsb $0B
    lda $1C : lsr #3 : dec #2 : and #$003F : sta $09
    
    sep #$20
    clc : adc #$20 : bit #$40 : bne +
    lda $0B : cmp $09 : bcs ++
    jmp .skip
++  lda $09 : clc : adc #$20 : cmp $0B : bcs ++
    jmp .skip
+   lda $0B : cmp $09 : bcs ++
    lda $09 : clc : adc #$20 : and #$3F : cmp $0B : bcs ++
    jmp .skip
++  rep #$20

    ; Layer 1: $2000 -> $3000
    lda $03 : and #$07FF : ora #$3000
    jmp vram_change

.not_layer1:
    ; Skip if destination is not layer 2 tilemap
    cmp #$3000 : bne .not_layer2

    ; This seems to check if the tile is being drawn outside of the layer 2 tilemap's range or something
    lda $03 : lsr #5 : and #$001F : sta $0B
    lda $03 : and #$0800 : xba : asl #2 : tsb $0B
    lda $20 : lsr #3 : dec #2 : and #$003F : sta $09

    sep #$20
    clc : adc #$20 : bit #$40 : bne +
    lda $0B : cmp $09 : bcs ++
    jmp .skip
++  lda $09 : clc : adc #$20 : cmp $0B : bcs ++
    jmp .skip
+   lda $0B : cmp $09 : bcs ++
    lda $09 : clc : adc #$20 : and #$3F : cmp $0B : bcs ++
    jmp .skip
++  rep #$20

    ; Layer 2: $3000 -> $3800
    lda $03 : and #$07FF : ora #$3800
    jmp vram_change

.not_layer2:
    ; Everything else: don't change
    lda $03
    jmp vram_change

    ; We have to delete this entry from the stripe table
    ; This fixes VRAM updates that happen offscreen vertically, which seems to happen with Mushroom Scales and Growing Pipes, for example
    ; Solution: copy the table from the next entry to this one, and change $7F837B
    ; It can be very time consuming, but this scenario should only happen once or twice per frame in the worst case
    ; The code here also looks kinda bad and you can blame me this time
.skip:
    rep #$20
    phb

    ; Compute next data index in $03 and current data size in $07
    lda $05 : beq +
    lda #$0006
    bra ++
+   lda [$00],y
    xba : and #$03FF : clc : adc #$0005
++  sta $07
    dey #2
    tya : clc : adc $07 : sta $03

    ; Setup source address in X
    clc : adc.w #!stripe_table : tax

    ; Setup size-1 in A
    lda.l !stripe_index : sec : sbc $03 : pha

    ; Update stripe index
    lda.l !stripe_index : sec : sbc $07 : sta.l !stripe_index

    ; Setup destination address in Y
    sty $03
    tya : clc : adc.w #!stripe_table : tay

    ; Transfer bytes -> effectively deletes the current entry
    pla
    mvn !stripe_table>>16,!stripe_table>>16

    plb

    ; Return with the new current index in Y
    ldy $03
    jmp vram_loop
