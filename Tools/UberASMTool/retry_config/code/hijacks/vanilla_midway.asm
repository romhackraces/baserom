;=====================================
; Hijack to the midway interaction routine to correctly handle checkpoints.
; Also handles skipping the midway powerup if applicable.
;=====================================

pushpc

org $00F2D8
    jml midway_main

org $0DA691
    jml midway_spawn

pullpc

;=====================================
; midway_main routine
;
; Handles giving the correct checkpoint when touching a midway.
;=====================================
midway_main:
    ; Get the index of this tile in the map16 table.
    phx
    rep #$20
    lda $04 : pha
    jsr get_tile_index
    sep #$20
    
    ; If there's no custom midways in this sublevel, skip.
    lda !ram_cust_obj_num : dec : bmi .not_custom

    ; Loop through all custom midways IDs to see if this one is custom.
    asl : tax
    rep #$20
.find_custom_midway_loop:
    lda !ram_cust_obj_data,x : cmp $04 : bne ..next
    jmp .custom
..next:
    dex #2 : bpl .find_custom_midway_loop
    sep #$20

.not_custom:
    ; Signal that we have to set a normal midway.
    lda #$00 : sta !ram_set_checkpoint
    bra .return

.custom:
    ; Set the respawn entrance value.
    lda !ram_cust_obj_entr,x : sta !ram_set_checkpoint

.return:
    ; Restore $04.
    rep #$20
    pla : sta $04
    sep #$20

    ; Call the custom midway routine.
    ; (we already did PHX earlier).
    phy : php : phb : phk : plb
    jsr extra_midway
    plb : plp : ply : plx
    
    ; Only run the powerup code if applicable.
    ; If using the "SMB2-Styled" Health Bar patch, this should prevent healing
    ; at midways unless the flag is set.
    lda !ram_midway_powerup : beq +
    jml $00F2E0|!bank
+   jml $00F2E8|!bank

;=====================================
; Routine to get a block's $7EC800 index in $04 (16 bit).
; It should be run during the block interaction process.
;=====================================
get_tile_index:
    phy : phx : php
    sep #$30
    lda $5B : lsr : bcs .vert

.horz:
    lda $1933|!addr : beq +
    lda $9B : ora #$10
    bra ++
+   lda $9B
++  tax
    
    lda.l lm_version : cmp #$33
    rep #$20
    bcc +
    lda $13D7|!addr
    bra ++
+   lda #$01B0
++  sta $04
    
    jsr .multiply

    lda $9A : and #$00F0 : lsr #4
    clc : adc $04 : sta $04
    lda $98 : and #$FFF0
    clc : adc $04 : sta $04

    plp : plx : ply
    rts

.vert:
    lda $1933|!addr : beq +
    lda $9B : clc : adc #$0E
    bra ++
+   lda $9B
++  asl : ora $99 : sta $05

    lda $9A : lsr #4 : sta $04
    lda $98 : and #$F0 : tsb $04

    plp : plx : ply
    rts

;=====================================
; Input:
;     X: a, 8bit, unsigned.
;   $04: b, 16bit, unsigned.
; output:
;   $04: a*b, 16bit (least significant), unsigned.
;=====================================
.multiply
    lda $00 : pha
    lda $02 : pha
    sep #$20

    stz $02

if !sa1 == 0
    stx $4202
    lda $04 : sta $4203
    nop #3
    rep #$20
    lda $4216 : sta $00
    sep #$20

    ;stx $4202
    lda $05 : sta $4203
    rep #$20
    lda $01 : clc : adc $4216 : sta $01
else
    stz $2250

    rep #$20
    txa : and #$00FF : sta $2251
    lda $04 : and #$00FF : sta $2253
    bra $00
    lda $2306 : sta $00

    stz $2250
    txa : and #$00FF : sta $2251
    lda $05 : and #$00FF : sta $2253
    lda $01 : clc : adc $2306 : sta $01
endif

    lda $00 : sta $04
    pla : sta $02
    pla : sta $00
    rts

;=====================================
; midway_spawn routine
;
; Handles spawning the midway if the current checkpoint wasn't from itself.
;=====================================
midway_spawn:
    ; If midways are overridden, don't spawn it.
    lda !ram_midways_override : and #$7F : bne .no_spawn

    ; Filter title screen, etc.
    lda $0109|!addr : beq .no_intro
    cmp.b #!intro_level+$24 : bne .spawn

.no_intro:
    lda $1EA2|!addr,x : and #$40 : bne .checkpoint
    lda $13CE|!addr : bne .checkpoint

.spawn:
    jml $0DA69E|!bank

.checkpoint:
    ; Check if the checkpoint is for the main or sublevel.
    jsr shared_get_checkpoint_value
    cmp #$01 : bcs ..sublevel

..main:
    %lda_13BF() : bne ...no_intro
    jsr shared_get_intro_sublevel
    bra +

...no_intro:
    rep #$20
    and #$00FF : cmp #$0025 : bcc +
    clc : adc #$00DC
    bra +

..sublevel:
    rep #$20
    lda $010B|!addr
+   ora #$0C00 : eor !ram_respawn : and #$FBFF
    sep #$20
    bne .spawn

.no_spawn:
    jml $0DA6B0|!bank
