; Safety button combo to clear saved checkpoints (set to 1 to use in the combo)

!b = 0		; B
!y = 0		; Y
!e = 1		; Select
!t = 0		; Start
!U = 0		; Up
!D = 0		; Down
!L = 0		; Left
!R = 0		; Right

!a = 0		; A
!x = 0		; X
!l = 1		; L
!r = 1		; R

; interpret the above
!Combo1 = (!b<<7)+(!y<<6)+(!e<<5)+(!t<<4)+(!U<<3)+(!D<<2)+(!L<<1)+!R
!Combo2 = (!a<<7)+(!x<<6)+(!l<<5)+(!r<<4)

main:
	lda $9D
	ora $13D4|!addr
	bne .return
	ldy $0DB3|!addr
	; byetUDLR check
    lda $0DA2|!addr,y
    ora $0DA6|!addr,y
    and #!Combo1
    cmp #!Combo1
    bne .return
	; axlr check
    lda $0DA4|!addr,y
    ora $0DA8|!addr,y
    and #!Combo2
    cmp #!Combo2
    beq clear_saved_checkpoints
.return
    rtl

clear_saved_checkpoints:

    ; use retry api to reset all CP
    JSL retry_api_reset_all_checkpoints

    ; play clear sound effect
    lda #$0F : sta $1DF9|!addr

    ; use retry api to save game
    JSL retry_api_save_game

    ; play save sound effect
    lda #$22 : sta $1DFC|!addr

.return
    rtl
