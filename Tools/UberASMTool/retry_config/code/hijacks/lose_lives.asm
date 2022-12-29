pushpc

; Enable/disable life loss on death depending on the setting and table.
org $00D0D8
    jml lose_lives
    nop

pullpc

lose_lives:
if not(!infinite_lives)
    ; Decrement lives if applicable, and go to Game Over if they're over.
    jsr shared_get_bitwise_mask
    and.l tables_lose_lives,x : beq .normal
    dec $0DBE|!addr
    bpl .normal
.game_over:
    jml $00D0DD|!bank
.normal:
endif
    jml $00D0E6|!bank
