; Gamemode 6, 13

init:
if !pipe_entrance_freeze < 2
    ; If in the pipe entrance animation, lock/unlock sprites.
    lda $71 : cmp #$05 : bcc +
    cmp #$07 : bcs +
    lda.b #!pipe_entrance_freeze : sta $9D
+
endif ; !pipe_entrance_freeze < 2

    ; If goal walk is in progress, reset the music to play.
    ; This ensures the song will be reloaded if dying and respawning in the same sublevel.
    lda $1493|!addr : beq +
    lda #$FF : sta $0DDA|!addr
+   
    ; Play the silent checkpoint SFX if applicable.
if !room_cp_sfx != $00
    lda !ram_play_sfx : beq +
    lda.b #!room_cp_sfx : sta !room_cp_sfx_addr|!addr
+
endif ; !room_cp_sfx != $00

    ; If AMK is inserted, send the disable/enable SFX echo command
    ; depending on the current sublevel's sfx_echo setting.
    ; Also set a flag in RAM if SFX echo is enabled.
    lda.l !rom_amk_byte : cmp #$5C : bne +
    ldy #$05
    jsr shared_get_bitwise_mask
    and.l tables_sfx_echo,x : beq ++
    iny
    lda !ram_play_sfx : ora #$80 : sta !ram_play_sfx
++  sty $1DFA|!addr
+
    ; Reset DSX sprites.
if !reset_dsx
    stz $06FE|!addr
endif ; !reset_dsx

    ; Reset vanilla Boo rings.
if !reset_boo_rings == 2
    rep #$20
    stz $0FAE|!addr
    stz $0FB0|!addr
    sep #$20
endif ; !reset_boo_rings == 2

    ; Reset timer frame counter
    lda.l !rom_timer_ticks : sta $0F30|!addr

    ; If not entering from the overworld, skip.
    lda $141A|!addr : bne .room_transition

    ; Backup the timer value.
    rep #$20
    lda $0F31|!addr : sta !ram_timer+0
    sep #$20
    lda $0F33|!addr : sta !ram_timer+2

.room_transition:
    ; If we're respawning, reset some stuff.
    lda !ram_is_respawning : bne ..respawning

    ; If this just transition just triggered a room checkpoint, reset some stuff.
    lda !ram_respawn+1
    jsr shared_is_destination_a_checkpoint : bcc .normal

..respawning:
    ; Fix issues with the "level ender" sprite.
    stz $1493|!addr
    stz $13C6|!addr

    ; Reset mode 7 values.
    rep #$20
    stz $36
    stz $38
    stz $3A
    stz $3C
    sep #$20
    
    ; Backup the music that should play.
    lda $0DDA|!addr : sta !ram_music_to_play

.normal:
    ; Reset the respawning flag.
    lda #$00 : sta !ram_is_respawning

if !sprite_status_bar
    ; Initialize and draw the status bar during the fadein
    jsr sprite_status_bar_init
    jsr sprite_status_bar_main
endif ; !sprite_status_bar

main:
if !fast_transitions
    ; Reset the mosaic timer.
    stz $0DB1|!addr
endif ; !fast_transitions

    rtl
