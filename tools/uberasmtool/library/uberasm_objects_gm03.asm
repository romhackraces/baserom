incsrc "../../../shared/freeram.asm"

; Bytes to clear
!Bytes = 13

init:
    ; Clear out ram needed for all object flags
    ldx #!Bytes-1
    lda #$00
    -
    sta !objectool_level_flags_freeram,x
    dex
    bpl -
    rtl
