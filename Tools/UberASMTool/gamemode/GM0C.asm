init:
    ; Reset some retry settings on return to overworld
    incsrc "../retry_config/ram.asm"
    incsrc "../retry_config/settings.asm"

    ; Initialize default prompt type
    lda.b #!default_prompt_type+1 : sta !ram_prompt_override

    ; Initialize prompt position.
    lda.b #!text_x_pos : sta !ram_prompt_x_pos
    lda.b #!text_y_pos : sta !ram_prompt_y_pos

    ; Initialize "midway powerup" flag.
    lda #$01 : sta !ram_midway_powerup

    jsl retry_load_overworld_init
    rtl
