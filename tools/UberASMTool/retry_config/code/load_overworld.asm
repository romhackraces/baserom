; Gamemode 0C

init:

; Reset various counters.
.counterbreak:
if !counterbreak_yoshi == 1 || !counterbreak_yoshi == 3
    ; Reset Yoshi
    stz $13C7|!addr
    stz $187A|!addr
endif

if !counterbreak_powerup == 1 || !counterbreak_powerup == 3
    ; Reset powerup.
    stz $19
endif

if !counterbreak_item_box == 1 || !counterbreak_powerup == 3
    ; Reset item box.
    stz $0DC2|!addr
endif

if !counterbreak_coins == 1 || !counterbreak_coins == 3
    ; Reset coin counter.
    stz $0DBF|!addr
endif

if !counterbreak_bonus_stars == 1 || !counterbreak_bonus_stars == 3
    ; Reset bonus stars counter.
    stz $0F48|!addr
    stz $0F49|!addr
endif

if !counterbreak_score == 1 || !counterbreak_score == 3
    ; Reset score counter.
    rep #$20
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
    sep #$20
endif

if !counterbreak_lives == 1 || !counterbreak_lives == 3
    ; Reset lives.
    lda.b #!initial_lives-1 : sta $0DBE|!addr
endif

; Reset the current level's checkpoint if the level was beaten.
.reset_checkpoint:
    ; Skip if the level wasn't just beaten.
    lda $0DD5|!addr : beq ..skip
                      bmi ..skip

    ; Remove the checkpoint for the current level.
    jsr shared_reset_checkpoint

..skip:
    rtl
