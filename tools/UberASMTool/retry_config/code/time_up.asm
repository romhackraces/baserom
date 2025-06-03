; Gamemode 15

init:
if !time_up_fix
    ; Skip if it's not the "TIME UP!" screen.
    lda $143B|!addr : cmp #$1D : bne .return

    ; Check if the level timer was set to 0.
    lda !ram_timer+0 : ora !ram_timer+1 : ora !ram_timer+2
    and #$0F : bne .return

    ; If so, go to the Overworld directly.
    lda #$0B : sta $0100|!addr
endif

.return:
    rtl
