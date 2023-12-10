incsrc "../retry_config/ram.asm"

; Safety button combo to clear saved checkpoints (set to 1 to use in the combo)

!b = 0		; B
!y = 0		; Y
!e = 1		; Select
!t = 1		; Start
!U = 0		; Up
!D = 1		; Down
!L = 0		; Left
!R = 0		; Right

; interpret the above
!Combo = (!b<<7)+(!y<<6)+(!e<<5)+(!t<<4)+(!U<<3)+(!D<<2)+(!L<<1)+!R

main:
    lda $9D
    ora $13D4|!addr
    bne .return

    ; Check for button combo
    ldy $0DB3|!addr
    lda $0DA2|!addr,y
    ora $0DA6|!addr,y
    and #!Combo
    cmp #!Combo
    beq clear_saved_checkpoints
.return
    rtl

clear_saved_checkpoints:

    ; Taken from the retry's API file
    ; A/X/Y 8 bits
    phx : phy : php
    sep #$30

    ; Initialize the checkpoint ram table.
    ldx #$BE
    ldy #$5F
-   tya : cmp #$25 : bcc +
    clc : adc #$DC
+   sta !ram_checkpoint,x
    lda #$00 : adc #$00 : sta !ram_checkpoint+1,x
    lda $1EA2|!addr,y : and #~$40 : sta $1EA2|!addr,y
    dex #2
    dey : bpl -

    ; Initialize respawn RAM in case it's called inside a level.
    lda $13BF|!addr : asl : tax
    rep #$20
    lda !ram_checkpoint,x : sta !ram_respawn

    ; Initialize "set checkpoint" handle to $FFFF.
    lda #$FFFF : sta !ram_set_checkpoint

    ; Restore X/Y/P
    plp : ply : plx

; save the game to replace a bad save
.save_game
    ; Set up vanilla SRAM buffer.
    phb
    rep #$30
    ldx.w #$1EA2|!addr
    ldy.w #$1F49|!addr
    lda.w #$008C
    mvn $00,$00
    sep #$30
    plb

    ; Save to SRAM/BW-RAM.
    jsl $009BC9|!bank

; play sound effect
.play_sfx
    lda #$0F : sta $1DF9|!addr

.return
    rtl
