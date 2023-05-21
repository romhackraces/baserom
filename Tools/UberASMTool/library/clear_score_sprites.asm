; A simple code to clear score sprites when a flag is set.
;
; This is run during the retry system's extra death routine
; to free up tiles for prompt display

!freeram = $0F5E|!addr

main:
    lda !freeram : cmp #$01
    bne .return

    ; Clear score sprites
    stz $16E1|!addr
    stz $16E2|!addr
    stz $16E3|!addr
    stz $16E4|!addr
    stz $16E5|!addr
    stz $16E6|!addr

.return:
    rtl
