; Gamemode 0C

init:

; Reset various counters.
.counterbreak:
if !counterbreak_yoshi
    stz $13C7|!addr
    stz $187A|!addr
endif

if !counterbreak_powerup
    ; Reset powerup.
    stz $19
endif

if !counterbreak_item_box
    ; Reset item box.
    stz $0DC2|!addr
endif

if !counterbreak_coins
    ; Reset coin counter.
    stz $0DBF|!addr
endif

if !counterbreak_bonus_stars
    ; Reset bonus stars counter.
    stz $0F48|!addr
    stz $0F49|!addr
endif

if !counterbreak_score
    ; Reset score counter.
    rep #$20
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
    sep #$20
endif

; Reset the current level's checkpoint if the level was beaten.
.reset_checkpoint:
    ; Skip if the level wasn't just beaten.
    lda $0DD5|!addr : beq ..skip
                      bmi ..skip

    ; Remove the checkpoint for the current level.
    jsr shared_reset_checkpoint

..skip:

    ; Reset some settings on return to overworld

    ; Initialize default prompt type
    lda.b #!default_prompt_type+1 : sta !ram_prompt_override

    ; Initialize prompt position.
    lda.b #!text_x_pos : sta.w !ram_prompt_x_pos
    lda.b #!text_y_pos : sta.w !ram_prompt_y_pos

    ; Initialize "midway powerup" flag.
    lda #$01 : sta !ram_midway_powerup

    rtl
