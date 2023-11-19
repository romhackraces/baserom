incsrc "../retry_config/ram.asm"
incsrc "../retry_config/settings.asm"

; Safety button combo to clear saved checkpoints (set to 1 to use in the combo)

!b = 1		; B
!y = 0		; Y
!e = 1		; Select
!t = 0		; Start
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
    beq clear_saved_cp
.return
    rtl

clear_saved_cp:

; do nothing if retry isn't configured for cp saving
if !save_on_checkpoint

; reset the checkpoint state (all CPs)
.reset_checkpoint
    phx
    phy
    lda $13BF|!addr : tay
    rep #$30
    and #$00FF : asl : tax
    lsr : cmp #$0025 : bcc +
    clc : adc #$00DC
+   sta !ram_checkpoint,x
    sta !ram_respawn
    sep #$30
    lda $1EA2|!addr,y : and #~$40 : sta $1EA2|!addr,y

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

    ply
    plx

    ; play sound effect
    lda #$0F : sta $1DF9|!addr
endif
.return
    rtl
