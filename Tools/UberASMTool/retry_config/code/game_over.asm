; Gamemode 16

init:
    ; Skip if it's not the "GAME OVER" screen.
    lda $143B|!addr : cmp #$14 : bne .return

if !sram_feature
    ; Reload the save file.
    jsl sram_load_game_over
endif
    
    ; Call the extra routine.
    phb : phk : plb
    php
    jsr extra_game_over
    plp
    plb

    ; If applicable, save the game.
if !save_after_game_over
    jsr shared_save_game
endif

.return:
    rtl
