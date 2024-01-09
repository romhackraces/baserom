incsrc "../../../shared/freeram.asm"

; Bytes to clear
!Bytes = 16

init:
    ; Clear out ram needed for all object flags
    ldx #!Bytes-1
    lda #$00
    -
    sta !toggles_freeram_bank,x
    dex
    bpl -
    rtl
