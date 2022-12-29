; Gamemode 03

init:
    ; Set the DBR to the freeram's bank for faster stores.
    %set_dbr(!retry_freeram)

    ; Initialize the retry ram to 0.
    rep #$30
    ldx #$0024
-   stz.w !retry_freeram,x
    dex #2 : bpl -

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

    ; Initialize "No exit" flag.
    lda.b #!no_exit_option : sta.w !ram_disable_exit

    ; Initialize "No prompt box" flag.
    lda.b #!no_prompt_box : sta.w !ram_disable_box

    ; Initialize prompt position.
    lda.b #!text_x_pos : sta.w !ram_prompt_x_pos
    lda.b #!text_y_pos : sta.w !ram_prompt_y_pos

    ; Initialize "midway powerup" flag.
    lda.b #!midway_powerup : sta.w !ram_midway_powerup

    ; Call the custom load title routine.
    php : phk : plb
    jsr extra_load_title
    plp

    plb
    rtl
