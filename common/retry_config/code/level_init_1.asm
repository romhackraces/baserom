; Gamemode 11

init:
    ; Better safe than sorry.
    stz $13 : stz $14

    ; Reset the custom midway object counter.
    lda #$00 : sta !ram_cust_obj_num

    ; Don't trigger the prompt by accident, and reset the death flag.
    sta !ram_prompt_phase
    sta !ram_is_dying

    ; Check if we entered from the overworld.
    lda $141A|!addr : bne .skip

    ; The game sets $13BF a bit later so we need to do it ourselves
    ; Don't do it if in the intro level, or right after a "No Yoshi" cutscene.
    lda $0109|!addr : bne +
    lda $71 : cmp #$0A : beq +
    jsr shared_get_translevel
+
    ; Don't trigger Yoshi init.
    lda #$00 : sta !ram_is_respawning

    ; Reset hurry up flag.
    sta !ram_hurry_up

    ; Call the custom reset routine.
    php : phb : phk : plb
    jsr extra_reset
    plb : plp

    ; Set the destination from the level's checkpoint value.
    lda $13BF|!addr : asl : tax
    rep #$20
    lda !ram_checkpoint,x : sta !ram_respawn
    sep #$20

.skip:
    ; Reset Yoshi, but only if respawning and not parked outside of a Castle/Ghost House.
    lda !ram_is_respawning : beq +
if not(!counterbreak_yoshi)
    lda $1B9B|!addr : bne +
endif
    stz $0DC1|!addr
+
    rtl
