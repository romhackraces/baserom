; Gamemode 7, 14

; Calculate the time to check for prompt starting
; !prompt_show_delay/4 is done because $1496 decrements every 4th frame
!show_prompt_time #= !death_time-(!prompt_show_delay/4)

; If the death animation should show, set the times to the minimum possible
if !retry_death_animation&1
    !show_prompt_time #= 2
endif
if !retry_death_animation&2
    !death_time #= 2
endif

main:
    ; Enable SFX echo if applicable.
    lda !ram_play_sfx : bpl +
    lda $1DFA|!addr : bne +
    ; Don't play every frame or AMK will ignore it
    ; when changing music in the middle of a level
    lda $13 : lsr : bcs +
    lda #$06 : sta $1DFA|!addr
+
    ; Update the window HDMA when the flag is set.
    lda !ram_update_window : bpl +
    jsr prompt_update_window
+
    ; If the game is paused, skip.
    lda $13D4|!addr : bne .paused

    ; If a message is running, skip.
    lda $1426|!addr : bne .return

    ; If Mario is dying, handle it.
    lda $71 : cmp #$09 : beq .dying

.not_dying:
    ; Otherwise, reset the dying flag...
    lda #$00 : sta !ram_is_dying
    
    ; ...and backup $0DDA for later.
    lda $0DDA|!addr : sta !ram_music_backup

    ; If Mario is not dead but the prompt is displayed for some reason
    ; (for example, revive glitch with Yoshi)...
    lda !ram_prompt_phase : beq .return

    ; ...reset the prompt box and prevent drawing tiles
    lda #$00 : sta !ram_prompt_phase
    jsr prompt_handle_box_finished_shrinking

.return:
    rtl

.paused:
if not(!always_start_select)
    ; Check if the prompt type requires Start+Select always active.
    jsr shared_get_prompt_type
    cmp.b #!retry_type_vanilla : bcs .not_dying
    tay
    lda !ram_disable_exit : bne +
    cpy.b #!retry_type_prompt_max+1 : bcc .not_dying
+
endif
    
    ; If we're in the intro level, don't Start+Select.
    lda $0109|!addr : bne .not_dying

    ; If we're in the title screen, don't Start+Select.
    lda $0100|!addr : cmp #$07 : beq .not_dying

    ; Check if the correct button was pressed.
    lda.b !exit_level_buttons_addr : and.b #!exit_level_buttons_bits : beq .not_dying

..start_select_exit:
    ; Call the Start+Select routine.
    ; This should make this compatible with custom resources like Start+Select Advanced, AMK 1.0.8 Start+Select SFX, etc.
    %jsl_to_rts($00A269,$0084CF)
    rtl

.dying:
    ; Show the death pose just to be sure.
    lda.l !rom_death_pose : sta $13E0|!addr

    ; Disable camera Y scroll if applicable.
if !death_camera_lock
    stz $1412|!addr
endif
    
    ; Freeze the screen.
    jsr screen_freeze

    ; Don't respawn if not infinite lives and we're about to game over.
if not(!infinite_lives)
    jsr shared_get_bitwise_mask
    and.l tables_lose_lives,x : beq +
    lda $0DBE|!addr : bpl +
    rtl
+
endif

    ; See what retry we have to use.
    jsr shared_get_prompt_type
    cmp.b #!retry_type_prompt_max+1 : bcc ..prompt
    cmp.b #!retry_type_vanilla : beq ..vanilla
    jmp ..instant

..vanilla:
if !title_death_behavior != 0
    ; If on the title screen...
    lda $0100|!addr : cmp #$07 : bne ...return

    ; ...prevent opening the file select menu.
    stz $15 : stz $16 : stz $17 : stz $18

    ; If the death animation is almost over...
    lda $1496|!addr : cmp #$01 : bne ...return

    ; ... reset stuff for reloading...
    jsr reset_addresses
    jsr reset_music

    ; ...and set the flag to reload the title screen.
    jmp ..reload_title_screen
endif

...return:
    rtl

..prompt:
    ; If Mario is not dying because of selecting "Exit", skip.
    lda !ram_prompt_phase : cmp #$06 : bne ...no_exit

...exit:
    ; If not supposed to run the Exit animation, end it immediately.
if !exit_animation < 2
    stz $1496|!addr
    stz $76
    stz $7D
endif

    ; If the game isn't locked, prevent death timer from running out.
if !prompt_freeze == 0
    lda $1496|!addr : bpl +
    stz $1496|!addr
+   inc $1496|!addr
endif

    rtl

...no_exit:
    ; Keep Mario locked in place, but only after he fully ascended during the animation
    ; (unless the full death animation should be shown).
if !show_prompt_time > 2
    lda $7D : bmi +
    stz $7D
    stz $76
+
endif

    ; If the prompt hasn't begun yet, check if it should.
    lda !ram_prompt_phase : beq ...check_box

    ; Keep Mario locked in the death animation.
    stz $7D
    stz $76

    ; Handle the box shrinking.
    cmp #$05 : bne ...no_shrink

    ; This overcomes vanilla DECing $1496 twice since $9D is 0
if !prompt_freeze == 0
    inc $1496|!addr
endif
    bra ...handle_box

...no_shrink:
    ; Keep death timer constant during prompt activity (except shrinking).
    ldx.b #!show_prompt_time : stx $1496|!addr

    ; Handle the box expanding.
    cmp #$04 : beq ..respawn
    cmp #$02 : bne ...handle_box

...handle_menu:
    ; Handle the menu cursor and options.
    jsr prompt_handle_menu
    rtl

...handle_box:
    ; Expand/shrink the prompt.
    jsr prompt_handle_box
    rtl

...check_box:
if not(!fast_prompt)
if not(!retry_death_animation&1)
    ; If fallen in a pit, show immediately.
    lda $81 : dec : bpl +
endif

    ; Check if it's time to show the prompt.
    lda $16 : ora $18 : bmi +
    lda $1496|!addr : cmp.b #!show_prompt_time : bcs ..return
+
endif

    ; Set letter transfer flag and change prompt phase.
    lda #$01 : sta !ram_update_request
               sta !ram_prompt_phase

    ; Reset message box stuff just to be sure.
    stz $1B88|!addr
    stz $1B89|!addr

    ; If in a special level mode (mode 7 boss), change BG color to black.
    lda $0D9B|!addr : bpl ..return
    stz $0701|!addr
    stz $0702|!addr

..return:
    rtl

..instant:
if not(!retry_death_animation&2)
    ; If fallen offscreen, respawn immediately.
    lda $81 : dec : bpl ..respawn
endif
    
    ; Respawn after 4 frames so it shows the death pose.
    lda $1496|!addr : cmp.b #!death_time : bcs ..return

..respawn:
    ; Set the respawning flag.
    lda #$01 : sta !ram_is_respawning

    ; Reset some addresses.
    jsr reset_addresses

    ; Reset level music.
    jsr reset_music

    ; Reset the prompt phase.
    lda #$00 : sta !ram_prompt_phase

    ; Reset the hurry up flag.
    sta !ram_hurry_up

    ; Set the destination to send Mario to.
    jsr shared_get_screen_number
    lda !ram_respawn+0 : sta $19B8|!addr,x
    lda !ram_respawn+1 : ora #$04 : sta $19D8|!addr,x

    ; If the Yoshi Wings checkpoint flag is set and the destination is the
    ; level's main entrance, also set the normal Yoshi Wings and "Carry Yoshi" flags.
    ; Also clear the flag in the checkpoint ram to avoid a game crash.
    bpl ...remove_yoshi
    bit #$0A : bne ...remove_yoshi
    and #$7F : sta $19D8|!addr,x
    lda #$02 : sta $1B95|!addr
    dec : sta $0DC1|!addr
    bra +

    ; Remove Yoshi, but only if not set to go to the Yoshi Wings level.
...remove_yoshi:
    stz $0DC1|!addr
    stz $187A|!addr
    lda #$03 : sta $1DFA|!addr
+

    ; Mark as sublevel so we skip the "Mario Start!" message.
    ; (don't do "inc $141A" so we avoid the 256 entrance glitch)
    lda #$01 : sta $141A|!addr

    ; Skip No Yoshi intros.
    stz $141D|!addr

if !title_death_behavior != 0
    ; Check if we need to reload a level or the title screen.
    lda $0100|!addr : cmp #$0F : bcs ..reload_level

..reload_title_screen:
    ; Make sure everything is reloaded
    stz $0109|!addr

    ; Set the flag to reload the title screen.
    lda #$60 : sta !ram_is_dying
    rtl

..reload_level:
endif

    ; Set the flag to reload the level.
    lda #$40 : sta !ram_is_dying
    rtl

;=====================================
; screen_freeze routine
;
; Routine to freeze sprites, animations, timer etc. while the prompt is displayed.
; If !prompt_freeze == 0, most stuff is kept running except for timer, autoscrollers, message boxes and some Yoshi stuff.
; If !prompt_freeze == 1, stuff that doesn't obey to the $9D flag will still run.
; If !prompt_freeze == 2, everything should freeze (although I might have missed some).
;=====================================
screen_freeze:
if !prompt_freeze
    ; Force sprites and animations to lock.
    lda #$01 : sta $9D

if !prompt_freeze == 2
    ; Freeze animations that use $13.
    lda !ram_prompt_phase : beq +
    cmp #$05 : bcs +
    dec $13
+   
    ; Freeze vanilla layer 3 tides.
    lda $1403|!addr : beq +
    lda $145E|!addr : lsr : bcs +
    dec $22
+   
    ; Freeze Shell-less Koopas and Sumo Bro's Lightning.
    ldx.b #!sprite_slots-1
-   lda !14C8,x : cmp #$08 : bne ++
    lda !extra_bits,x : and #$08 : bne ++
    lda !9E,x : cmp #$04 : bcc +
    cmp #$2B : bne ++
    ; Sumo Bro's Lightning
    lda.l !rom_sumo_bro_lightning_y_speed : eor #$FF : inc : sta !AA,x
    jsl $01801A|!bank
    bra ++
+   ; Shell-less Koopas
    stz !sprite_speed_y,x
++  dex : bpl -
    
    ; Stop earthquake.
    stz $1887|!addr

    ; Stop lightning effect.
    stz $1FFC|!addr : stz $1FFD|!addr

    ; Stop Reappearing Boos timer.
    inc $190A|!addr

    ; Freeze bonus game 1UPs
    lda $18B8|!addr : beq +
    ldx.b #20-1
    lda #$01
-   cmp $1892|!addr,x : bne ++
    stz $1E52|!addr,x
    stz $1E66|!addr,x
++  dex : bpl -
+
    ; Prevent swallow timer from decrementing
    lda $18AC|!addr : beq +
    cmp #$FF : beq +
    lda $14 : and #$03 : bne +
    inc $18AC|!addr
+
endif
else
    ; Force sprites and animations to run.
    stz $9D

    ; Prevent timer from ticking down.
    inc $0F30|!addr

    ; Prevent messages from activating.
    stz $1426|!addr

    ; Disable autoscrollers.
    lda $143E|!addr : beq ++
    cmp #$01 : beq +
    cmp #$0C : bne ++
+   stz $143E|!addr
++
endif

    ; Skip Yoshi's hatch animation.
    stz $18E8|!addr

    ; Reset Yoshi's swallow timer.
    ldx $18E2|!addr : beq +
    stz !1564-1,x

    ; Prevent Yoshi's tongue from extending.
    lda !1594-1,x : cmp #$01 : bne ++
    lda !151C-1,x : sec : sbc.l !rom_yoshi_tongue_extend_speed : bmi +
    sta !151C-1,x
    bra +
++  
    ; Prevent Yoshi's tongue from retracting.
    cmp #$02 : bne +
    sta !1558-1,x
+   
    rts

;=====================================
; reset_addresses routine
;
; Routine to reset a bunch of addresses that are usually reset when loading a level from the overworld.
;=====================================
reset_addresses:
    ; Call the custom reset routine.
    ; Call this first so the values can be used in the routine before being reset.
    php : phb : phk : plb
    jsr extra_reset
    plb : plp

    ; Reset collected Yoshi coins.
    stz $1420|!addr
    stz $1422|!addr

    ; Reset individual dcsave buffers.
    jsr shared_dcsave_init

    rep #$20

    ; Reset item memory.
    ldx #$7E
-   stz $19F8|!addr,x
    stz $1A78|!addr,x
    stz $1AF8|!addr,x
    dex #2 : bpl -

    ; Reset the sprite load index table.
    ; If SA-1 or PIXI's 255 sprite per level are used, the reset loop
    ; will use the remapped address and reset 256 entries instead of 128.
    ldx #$7E
    lda.l !rom_sprite_load_orig : cmp #$1938 : beq .sprite_load_orig
.sprite_load_remap:
    %set_dbr(!sprite_load_table)
-   stz.w !sprite_load_table,x
    stz.w !sprite_load_table+$80,x
    dex #2 : bpl -
    plb
    bra +
.sprite_load_orig:
    stz.w $1938,x
    dex #2 : bpl .sprite_load_orig
+    
    ; Reset scroll sprites ($1446-$1455).
    ldx #$0E
-   stz $1446|!addr,x
    dex #2 : bpl -

    ; Reset various timers and end-level addresses ($1492-$14AB).
    ldx #$18
-   stz $1492|!addr,x
    dex #2 : bpl -

    ; Reset various addresses used by Bowser ($14B0-$14B9).
    ldx #$08
-   stz $14B0|!addr,x
    dex #2 : bpl -

if !reset_boo_rings
    ; Reset vanilla Boo rings.
    stz $0FAE|!addr
    stz $0FB0|!addr
endif

if !counterbreak_bonus_stars == 1 || !counterbreak_bonus_stars == 2
    ; Reset bonus stars counter.
    stz $0F48|!addr
endif

if !counterbreak_score == 1 || !counterbreak_score == 2
    ; Reset score counter.
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
endif

    ; Reset timer to the original value.
    lda !ram_timer+0 : and #$0F0F : sta $0F31|!addr
    sep #$20
    lda !ram_timer+2 : and #$0F : sta $0F33|!addr

if !counterbreak_powerup == 1 || !counterbreak_powerup == 2
    ; Reset powerup.
    stz $19
endif

if !counterbreak_item_box == 1 || !counterbreak_item_box == 2
    ; Reset item box.
    stz $0DC2|!addr
endif

if !counterbreak_coins == 1 || !counterbreak_coins == 2
    ; Reset coin counter.
    stz $0DBF|!addr
endif

if !counterbreak_lives == 1 || !counterbreak_lives == 2
    ; Reset lives.
    lda.b #!initial_lives-1 : sta $0DBE|!addr
endif

    ; Reset green star block counter.
    lda.l !rom_green_star_block_count : sta $0DC0|!addr

    ; Reset collected invisible 1-UPs.
    stz $1421|!addr

    ; Reset directional coin flag.
    stz $1432|!addr

    ; Reset ON/OFF status.
    stz $14AF|!addr

    ; Reset Yoshi wings flag.
    stz $1B95|!addr

    ; Reset side exit flag.
    stz $1B96|!addr

    ; Reset peace image flag.
    stz $1B99|!addr

    ; Reset background scroll flag.
    stz $1B9A|!addr

    ; Reset layer 3 tides timer.
    stz $1B9D|!addr

    ; Reset Reznor bridge counter.
    stz $1B9F|!addr

    ; Don't go to the bonus game after a Kaizo trap to prevent it glitching out.
    ; Don't reset it if currently in the bonus itself to prevent a softlock.
    lda $1B94|!addr : bne +
    stz $1425|!addr
+   
    ; Reset bonus game sprite flag.
    stz $1B94|!addr

    ; Reset RNG addresses if the current sublevel is set to do so.
    jsr shared_get_bitwise_mask
    and.l tables_reset_rng,x : beq +
    rep #$20
    stz $148B|!addr
    stz $148D|!addr
    sep #$20
+   
    rts

;=====================================
; reset_music routine
;
; Routine to reset music to make it play properly after respawning.
;=====================================
reset_music:
    lda.l !rom_amk_byte : cmp #$5C : beq .amk

.no_amk:
    lda $0DDA|!addr : bpl .return
    stz $0DDA|!addr
    rts

.amk:
    lda $13C6|!addr : bne .force_reset
    lda $0DDA|!addr : cmp #$FF : beq .spec
    lda !ram_music_to_play : cmp $0DDA|!addr : bne .return
    bra .bypass

.spec:
    lda.l !rom_death_song : beq .force_reset
    cmp $1DFB|!addr : beq .no_reset

.force_reset:
    lda #$00 : sta !amk_freeram : sta $1DFB|!addr
    bra .return

.no_reset:
    lda !ram_music_to_play : cmp !ram_music_backup : bne .return

.bypass:
    lda !ram_music_to_play : cmp #$FF : beq .return
    jsr shared_get_prompt_type
    cmp.b #!retry_type_prompt_death_song : beq ..reload_samples
    cmp.b #!retry_type_instant_death_song : bne .return

..reload_samples:
    ; Make AMK reload the samples.
    lda #$01 : sta !amk_freeram+1

.return:
    rts

;================================================================================
; This routine handles some processes that need to run at the very end of the main game loop:
; - Death routine: if the player died on this frame, it needs to prevent the
;   death song from playing when applicable, before the music engine is aware
;   of it. It also handles incrementing the death counter-
; - Prompt OAM: if the prompt is being show, it needs to draw it on the
;   screen. You can't draw sprite tiles in gamemode 14 codes, as $7F8000
;   is called shortly after their main code, so we do it here. Being at
;   the end of the loop also allows it to not overwrite sprite tiles used
;   by other elements in the level.
; - Set checkpoint: if a checkpoint has been gotten on this frame (signaled
;   by the !ram_set_checkpoint handle), it needs to actually set it in Retry's
;   RAM. This could be done in gm14 as well, at the start of the next frame,
;   but better to do it as early as possible just to be safe :P
;================================================================================
end:
    ; Set DBR.
    phb : phk : plb

    ; Cap lives at 99, unless they're negative (about to game over).
    lda $0DBE|!addr : bmi +
    cmp #$62 : bcc +
    lda #$62 : sta $0DBE|!addr
+

if !sprite_status_bar
    ; Draw the sprite status bar.
    jsr sprite_status_bar_main
endif

    ; If Mario is dying, call the death routine.
    lda $71 : cmp #$09 : bne .no_death
    jsr death_routine

.no_death:
    ; Check if we have to set the checkpoint.
    rep #$20
    lda !ram_set_checkpoint : cmp #$FFFF
    sep #$20
    beq .no_checkpoint
    jsr set_checkpoint

.no_checkpoint:
if not(!no_prompt_draw)
    ; Check if it's time to draw the tiles.
    lda !ram_prompt_phase : cmp #$02 : beq .draw_prompt
                                       bcc .return

    ; In some cases it's needed to remove the prompt tiles from OAM after the option is chosen.
    jsr erase_tiles
    bra .return

.draw_prompt:
    jsr prompt_oam
endif

.return:
    ; Restore DBR.
    plb
    rtl

; Import all auxiliary routines called by this file.
incsrc "gm14_end/death_routine.asm"
incsrc "gm14_end/prompt_oam.asm"
incsrc "gm14_end/set_checkpoint.asm"
