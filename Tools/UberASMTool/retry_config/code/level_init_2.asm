; Gamemode 12

init:
    ; Reset the "play CP sfx" flag.
    lda #$00 : sta !ram_play_sfx
    
    ; Set layer 2 interaction offsets
    ; (prevents layer 2 interaction from glitching on level load)
    jsl $05BC72|!bank

    ; Check if we entered from the overworld.
    lda $141A|!addr : beq .return

    ; Check if it's a normal room transition.
    lda !ram_is_respawning : bne .return

.room_transition:
    ; Otherwise, check if we should count this entrance as a checkpoint.
    jsr shared_get_checkpoint_value
    cmp #$02 : bcc .return

    ; If entrance checkpoints are overridden, skip it.
    lda !ram_midways_override : bmi .return

..set_checkpoint:
    ; Set the checkpoint to the current entrance.
    rep #$20
    lda !ram_door_dest : sta !ram_respawn
    sep #$20

    ; Update the checkpoint value.
    jsr shared_hard_save

    ; Call the custom checkpoint routine.
    php : phb : phk : plb
    jsr extra_room_checkpoint
    plb : plp

    ; Set the "play CP sfx" flag if applicable.
if !room_cp_sfx != $00
    jsr shared_get_bitwise_mask
    and.l tables_disable_room_cp_sfx,x : bne +
    lda #$01 : sta !ram_play_sfx
+
endif

    ; Save individual dcsave buffers.
    jsr shared_dcsave_midpoint

.return:
    rtl
