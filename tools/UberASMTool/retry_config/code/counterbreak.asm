from_ow:
    rep #$20

if !counterbreak_bonus_stars == 1 || !counterbreak_bonus_stars == 3
    ; Reset bonus stars counter.
    stz $0F48|!addr
endif ; !counterbreak_bonus_stars == 1 || !counterbreak_bonus_stars == 3

if !counterbreak_score == 1 || !counterbreak_score == 3
    ; Reset score counter.
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
    sep #$20
endif ; !counterbreak_score == 1 || !counterbreak_score == 3
    
    sep #$20

if !counterbreak_yoshi == 1 || !counterbreak_yoshi == 3
    ; Reset Yoshi
    stz $13C7|!addr
    stz $187A|!addr
endif ; !counterbreak_yoshi == 1 || !counterbreak_yoshi == 3

if !counterbreak_powerup == 1 || !counterbreak_powerup == 3
    ; Reset powerup.
    stz $19
endif ; !counterbreak_powerup == 1 || !counterbreak_powerup == 3

if !counterbreak_item_box == 1 || !counterbreak_powerup == 3
    ; Reset item box.
    stz $0DC2|!addr
endif ; !counterbreak_item_box == 1 || !counterbreak_powerup == 3

if !counterbreak_coins == 1 || !counterbreak_coins == 3
    ; Reset coin counter.
    stz $0DBF|!addr
endif ; !counterbreak_coins == 1 || !counterbreak_coins == 3

if !counterbreak_lives == 1 || !counterbreak_lives == 3
    ; Reset lives.
    lda.b #!initial_lives-1 : sta $0DBE|!addr
endif ; !counterbreak_lives == 1 || !counterbreak_lives == 3

    rts

from_reset:
    rep #$20

if !counterbreak_bonus_stars == 1 || !counterbreak_bonus_stars == 2
    ; Reset bonus stars counter.
    stz $0F48|!addr
endif ; !counterbreak_bonus_stars == 1 || !counterbreak_bonus_stars == 2

if !counterbreak_score == 1 || !counterbreak_score == 2
    ; Reset score counter.
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
endif ; !counterbreak_score == 1 || !counterbreak_score == 2
    
    sep #$20

if !counterbreak_powerup == 1 || !counterbreak_powerup == 2
    ; Reset powerup.
    stz $19
endif ; !counterbreak_powerup == 1 || !counterbreak_powerup == 2

if !counterbreak_item_box == 1 || !counterbreak_item_box == 2
    ; Reset item box.
    stz $0DC2|!addr
endif ; !counterbreak_item_box == 1 || !counterbreak_item_box == 2

if !counterbreak_coins == 1 || !counterbreak_coins == 2
    ; Reset coin counter.
    stz $0DBF|!addr
endif ; !counterbreak_coins == 1 || !counterbreak_coins == 2

if !counterbreak_lives == 1 || !counterbreak_lives == 2
    ; Reset lives.
    lda.b #!initial_lives-1 : sta $0DBE|!addr
endif ; !counterbreak_lives == 1 || !counterbreak_lives == 2

    rts
