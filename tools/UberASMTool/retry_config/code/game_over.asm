; Gamemode 16

init:
    jsl level_transition_init
    
    ; Skip if it's not the "GAME OVER" screen.
    lda $143B|!addr : cmp #$14 : bne .return

if !sram_feature
    ; Reload the save file.
    jsl sram_load_game_over
endif ; !sram_feature
    
    ; Call the extra routine.
    php : phb
    jsl extra_game_over
    plb : plp

    ; If applicable, save the game.
if !save_after_game_over
    jsr shared_save_game
endif ; !save_after_game_over

.return:
    rtl
