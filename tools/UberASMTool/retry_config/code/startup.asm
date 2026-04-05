; Gamemode 00

init:
    ; Set the DBR to the freeram's bank for faster stores.
    %set_dbr(!retry_freeram)

    ; Initialize the retry ram to 0.
    rep #$30
    ldx.w #!ram_checkpoint-!retry_freeram-2
-   stz.w !retry_freeram,x
    dex #2 : bpl -

    ; Initialize the canary
    lda.w #!canary_value : sta.w !ram_canary

    ; Initialize "set checkpoint" handle to $FFFF.
    lda #$FFFF : sta.w !ram_set_checkpoint

    ; Initialize the checkpoint ram table.
    ldx #$00BE
    ldy #$005F
-   tya : cmp #$0025 : bcc +
    clc : adc #$00DC
+   sta.w !ram_checkpoint,x
    dex #2
    dey : bpl -

    ; Set the intro level checkpoint (level 0 = intro).
    jsr shared_get_intro_sublevel
    sta.w !ram_checkpoint
    
    sep #$30

    ; If the SRAM feature is not installed, align checkpoints here
    ; (no save file init hijack).
if not(!sram_feature)
    ; Load the initial OW flags from ROM into $1F49
    %jsl_to_rts_db($009F06)
    ; Align checkpoint table with the initial OW flags
    jsr shared_set_checkpoints_from_initial_ow_flags
endif ; not(!sram_feature)

    ; Initialize "No exit" flag.
    lda.b #!no_exit_option : sta.w !ram_disable_prompt_exit

    ; Initialize "No prompt box" flag.
    lda.b #!no_prompt_bg : sta.w !ram_disable_prompt_bg

    ; Initialize prompt position.
if !prompt_type == 0
    lda.b #!prompt_box_text_x_pos : sta.w !ram_prompt_x_pos
    lda.b #!prompt_box_text_y_pos : sta.w !ram_prompt_y_pos
else ; if not(!prompt_type == 0)
    lda.b #!prompt_bar_text_x_pos : sta.w !ram_prompt_x_pos
    lda.b #!prompt_bar_text_y_pos : sta.w !ram_prompt_y_pos
endif ; !prompt_type == 0

    ; Initialize "midway powerup" flag.
    lda.b #!midway_powerup : sta.w !ram_midway_powerup

if !sram_feature
    ; Initialize the SRAM global variables
    jsr sram_load_global
endif ; !sram_feature

    plb
    rtl
