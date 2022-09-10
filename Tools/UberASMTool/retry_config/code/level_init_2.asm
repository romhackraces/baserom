; Gamemode 12

init:
    ; Reset the "play CP sfx" flag.
if !room_cp_sfx != $00
    lda #$00 : sta !ram_play_sfx
endif

    ; Check if we entered from the overworld.
    lda $141A|!addr : beq .return

.room_transition:
    ; If respawning from Retry, backup the L2 interaction bit and disable it.
    lda !ram_is_respawning : beq +
    lda $5B : and #$80 : sta !ram_l2_backup
    lda #$80 : trb $5B
    rtl
+    
    ; Otherwise, check if we should count this entrance as a checkpoint.
    jsr shared_get_checkpoint_value
    cmp #$02 : bcc .return

    ; If entrance checkpoints are overridden, skip it.
    lda !ram_midways_override : bmi .return

..set_checkpoint:
    ; Set the checkpoint to the current entrance.
    lda !ram_door_dest : sta !ram_respawn
    lda !ram_door_dest+1 : sta !ram_respawn+1

    ; Update the checkpoint value.
    jsr shared_hard_save

    ; Call the custom checkpoint routine.
    php : phb : phk : plb
    jsr extra_room_checkpoint
    plb : plp

    ; Set the "play CP sfx" flag.
if !room_cp_sfx != $00
    lda #$01 : sta !ram_play_sfx
endif

    ; Save individual dcsave buffers.
if !dcsave
    jsr shared_dcsave_midpoint
endif

.return:
    rtl
