; Reset some retry settings on return to overworld
; Used to re-sync settings with globals that may have been overridden by UberASM Objects
incsrc "../retry_config/settings_global.asm"
incsrc "../retry_config/ram.asm"

init:
    ; Initialize default prompt type
    lda #!default_prompt_type+1 : sta !ram_prompt_override

    ; Initialize prompt position.
    lda #!prompt_box_text_x_pos : sta !ram_prompt_x_pos
    lda #!prompt_box_text_y_pos : sta !ram_prompt_y_pos

    ; Initialize "midway powerup" flag.
    lda #!midway_powerup : sta !ram_midway_powerup
    rtl
