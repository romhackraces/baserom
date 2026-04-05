; Gamemode 12

init:
if !sprite_status_bar
    jsr ssb_tables_load
endif ; !sprite_status_bar

    ; Reset the "play CP sfx" flag.
    lda #$00 : sta !ram_play_sfx
    
    ; Set layer 2 interaction offsets
    ; (prevents layer 2 interaction from glitching on level load)
    jsl $05BC72|!bank

    ; Check if we entered from the overworld.
    lda $141A|!addr : beq .from_ow

    ; Check if it's a normal room transition.
    lda !ram_is_respawning : bne .return

.room_transition:
    ; Reset RNG if the current sublevel is set to do so on room transitions.
    jsr shared_get_reset_rng_value
    cmp.b #!reset_rng_type_always : bne +
    jsr shared_reset_rng
+   
    ; If the destination should trigger a checkpoint, do it.
    lda !ram_door_dest+1
    jsr shared_is_destination_a_checkpoint : bcc .return

if !room_cp_sfx != $00
    ; If this is the same checkpoint we already have, don't play the sfx.
    rep #$20
    lda !ram_door_dest : cmp !ram_respawn
    sep #$20
    beq ..no_sfx

    ; If the SFX should play in this sublevel, set the play sfx flag.
    jsr shared_get_bitwise_mask
    and.l tables_disable_room_cp_sfx,x : bne ..no_sfx
    lda #$01 : sta !ram_play_sfx
..no_sfx:
endif ; !room_cp_sfx != $00

    ; Set the checkpoint to the current entrance.
    rep #$20
    lda !ram_door_dest : sta !ram_respawn
    sep #$20

    ; Update the checkpoint value.
    jsr shared_hard_save

    ; Call the custom checkpoint routine.
    php : phb
    jsl extra_room_checkpoint
    plb : plp

    ; Save individual dcsave buffers.
    jsr shared_dcsave_midpoint

.return:
    rtl

.from_ow:
    ; Reset RNG addresses if the current sublevel is set to do so on OW entrance.
    jsr shared_get_reset_rng_value
    cmp.b #!reset_rng_type_never : beq +
    jsr shared_reset_rng
+   rtl
