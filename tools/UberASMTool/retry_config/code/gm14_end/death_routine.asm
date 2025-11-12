;=====================================
; death_sfx routine
;
; Handles death music/sfx when dying, death counter and other stuff.
; This runs just before AMK, so we can kill the death song before it starts.
;=====================================
death_routine:
if not(!infinite_lives)
    ; Check if all lives were lost.
    lda $0DBE|!addr : bpl .no_game_over

    ; Check if the death sequence has finished.
    lda $1496|!addr : bne .game_over_return

.game_over:
    ; If yes, go to game over
    %jsl_to_rts_db($00D0DD,$0084CF)

..return:
    rts

.no_game_over:
endif

    ; If the reload level flag is set...
    lda !ram_is_dying : bit #$40 : beq .no_reload

    ; Make sure Mario's animation timer is 0.
    stz $1496|!addr

.reload:
if !title_death_behavior != 0
    ; (Check if we need to reload a level or the title screen)
    bit #$20 : beq ..level

..title:
    ; ...reload the title screen!
    lda #$02 : sta $0100|!addr
    rts

..level:
endif
    ; ...reload the level!
    lda #$0F : sta $0100|!addr
    rts

.no_reload:
    ; Only update death counter and call the death routine once
    ; but handle the death song every frame to avoid issues with custom codes that call $00F606 every frame.
    cmp #$00 : bne .handle_song

.first_frame:
    ; Set the dying flag.
    inc : sta !ram_is_dying

    ; Update the death counter.
    ldx #$04
-   lda !ram_death_counter,x : inc : sta !ram_death_counter,x
    cmp #10 : bcc +
    lda #$00 : sta !ram_death_counter,x
    dex : bpl -
    
    ; If we got here, it means the counter overflowed back to 0, so set it to 99999.
    ldx #$04
    lda #$09
-   sta !ram_death_counter,x
    dex : bpl -
+   
    ; Call the custom death routine.
    php : phb
    jsr extra_death
    plb : plp

    ; Kill score sprites if the option is enabled and Retry prompt is enabled.
if !no_score_sprites_on_death
    jsr shared_get_prompt_type
    cmp.b #!retry_type_enabled_max : bcs +

    ldx.b #$06-1
-   stz $16E1|!addr,x
    dex : bpl -
+
endif

    ; Reset some stuff related to lx5's Custom Powerups.
if !custom_powerups == 1
    stz.w ($170B|!addr)+$08
    stz.w ($170B|!addr)+$09
    lda #$00 : sta !projectile_do_dma

    ldx #$07
-   lda $170B|!addr,x : cmp #$12 : bne +
    stz $170B|!addr,x
+   dex : bpl -
    
    lda !item_box_disable : ora #$02 : sta !item_box_disable
endif

if not(!infinite_lives)
    ; Don't decrement lives on the title screen.
    lda $0100|!addr : cmp #$0B : bcc .no_lose_lives

    ; Check if we need to decrement lives.
    jsr shared_get_bitwise_mask
    and.l tables_lose_lives,x : beq .no_lose_lives

    ; If yes, decrement them and don't reset music if about to game over.
    dec $0DBE|!addr : bmi .return

.no_lose_lives:
endif

.handle_song:
    ; If the music is sped up, play the death song to make it normal again.
    lda !ram_hurry_up : bne .return

    ; If "Exit" was selected, don't disable the death music.
    lda !ram_prompt_phase : cmp #$05 : bcs .return

    ; Check if we have to disable the death music.
    jsr shared_get_prompt_type
    cmp.b #!retry_type_prompt_death_sfx : beq .no_death_song
    cmp.b #!retry_type_instant_death_sfx : bne .return

.no_death_song:
    ; Don't play the death song.
    stz $1DFB|!addr

    ; Undo the $0DDA change.
    ; This ensures the song won't be reloaded if it's the same after respawning.
    lda !ram_music_backup : sta $0DDA|!addr

    ; Only play the death SFX once per death.
    lda !ram_is_dying : bmi .return
    ora #$80 : sta !ram_is_dying

    ; Play the death SFX.
if !death_sfx != $00
    lda.b #!death_sfx : sta !death_sfx_addr|!addr
endif

.return:
    rts
