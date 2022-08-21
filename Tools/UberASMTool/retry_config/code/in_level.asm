; Gamemode 14

!show_prompt_time #= !death_time-$10

main:
    ; Update the window HDMA when the flag is set.
    lda !ram_update_window : beq +
    jsr prompt_update_window
+
    ; If the game is paused, skip.
    lda $13D4|!addr : bne .paused

    ; If Mario is dying, handle it.
    lda $71 : cmp #$09 : beq .dying

.not_dying:
    ; Otherwise, reset the dying flag...
    lda #$00 : sta !ram_is_dying
    
    ; ...and backup $0DDA for later.
    lda $0DDA|!addr : sta !ram_music_backup
    rtl

.paused:
if not(!always_start_select)
    ; Check if the prompt type requires start+select always active.
    jsr shared_get_prompt_type
    cmp #$04 : bcs .not_dying
    tay
    lda !ram_disable_exit : bne +
    cpy #$03 : bcc .not_dying
+
endif

    ; Check if the correct button was pressed.
    lda.b !exit_level_buttons_addr
    and.b #!exit_level_buttons_bits
    beq .not_dying

..start_select_exit:
    ; Call the start+select routine.
    ; This should make this compatible with custom resources like Start+Select Advanced, AMK 1.0.8 Start+Select SFX, etc.
    %jsl_to_rts($00A269, $0084CF)
    rtl

.dying:
    ; Show the death pose just to be sure.
    lda.b #!death_pose : sta $13E0|!addr
    
if !prompt_freeze
    ; Force sprites and animations to lock.
    lda #$01 : sta $9D

if !prompt_freeze == 2
    ; Freeze animations that use $13.
    lda !ram_prompt_phase : beq +
    cmp #$06 : beq +
    dec $13
+
endif
else
    ; Force sprites and animations to run.
    stz $9D

    ; Prevent timer from ticking down.
    inc $0F30|!addr
endif

    ; Skip Yoshi's hatch animation.
    stz $18E8|!addr

    ; Reset Yoshi's swallow timer.
    ldx $18E2|!addr : beq +
    stz !1564-1,x
+
    ; Don't respawn if not infinite lives and we're about to game over.
    jsr shared_get_bitwise_mask
    and.l tables_lose_lives,x : beq +
    lda $0DBE|!addr : bne +
    rtl
+
    ; See what retry we have to use.
    jsr shared_get_prompt_type
    cmp #$03 : bcc ..prompt
               beq ..instant
    rtl

..prompt:
    ; If Mario is dying because of selecting "exit", skip.
    lda !ram_prompt_phase : cmp #$06 : beq ..return

    ; Keep Mario locked in place, but only after he fully ascended during the animation.
    lda $7D : bmi +
    stz $7D
    stz $76
+
    ; If the prompt hasn't begun yet, check if it should.
    lda !ram_prompt_phase : beq ...check_box

    ; Keep Mario locked in the death animation.
    ldx.b #!show_prompt_time : stx $1496|!addr
    stz $7D
    stz $76

    ; Handle the box expanding/shrinking.
    cmp #$04 : beq ..respawn
    cmp #$02 : bne ...handle_box

...handle_menu:
    jsr prompt_handle_menu
    rtl

    ; Otherwise, expand/shrink the prompt.
...handle_box:
    jsr prompt_handle_box
    rtl

...check_box:
if not(!fast_prompt)
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
    ; Respawn after 4 frames so it shows the death pose.
    lda $1496|!addr : cmp.b #!death_time : bcs ..return

..respawn:
    ; Set the respawning flag.
    lda #$01 : sta !ram_is_respawning

    ; Reset some addresses.
    jsr reset_addresses

    ; Reset the prompt phase.
    lda #$00 : sta !ram_prompt_phase

    ; Reset the hurry up flag.
    sta !ram_hurry_up

    ; Set the destination to send Mario to.
    jsr shared_get_screen_number
    lda !ram_respawn : sta $19B8|!addr,x
    lda !ram_respawn+1 : ora #$04 : sta $19D8|!addr,x

    ; If applicable, decrement lives (if 0, we can't get here so we're safe).
    jsr shared_get_bitwise_mask
    and.l tables_lose_lives,x : beq +
    dec $0DBE|!addr
+    
    ; If Mario died on Yoshi, remove Yoshi.
    stz $0DC1|!addr

    ; Reset the death timer.
    stz $1496|!addr

    ; Mark as sublevel so we skip the "Mario Start!" message.
    ; (don't do "inc $141A" so we avoid the 256 entrance glitch)
    lda #$01 : sta $141A|!addr

    ; Skip No Yoshi intros.
    stz $141D|!addr

    ; Change to "Fade to level" game mode
    ; (or "Fade to overworld" when on the intro level to avoid going to level 0)
    ldy #$0F
    lda $0109|!addr : beq +
    ldy #$0B
+   sty $0100|!addr
    rtl

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

    ; Reset green star block counter.
    lda.b #read1($0091AC) : sta $0DC0|!addr

    ; Reset individual dcsave buffers.
if !dcsave
    jsr shared_dcsave_init
endif

    ; Reset item memory.
    ldx #$7E
    rep #$20
-   stz $19F8|!addr,x
    stz $1A78|!addr,x
    stz $1AF8|!addr,x
    dex #2
    bpl -

    ; Reset the sprite load index table.
    ; Change DBR to use absolute addressing (saves 512 cycles in the best case).
    %set_dbr(!sprite_load_table)
    ldx #$7E
-   stz.w !sprite_load_table,x
if !255_sprites_per_level
    stz.w !sprite_load_table+$80,x
endif
    dex #2
    bpl -
    plb

    ; Reset vanilla Boo rings.
if !reset_boo_rings
    stz $0FAE|!addr
    stz $0FB0|!addr
endif

    ; Reset various timers.
    stz $1497|!addr
    stz $1499|!addr
    stz $149B|!addr
    stz $149D|!addr
    stz $149F|!addr
    stz $14A1|!addr
    stz $14A3|!addr
    stz $14A5|!addr
    stz $14A7|!addr
    stz $14A9|!addr
    sep #$20
    stz $14AB|!addr

    ; Reset directional coin flag.
    stz $1432|!addr

    ; Reset ON/OFF status.
    stz $14AF|!addr

    ; Reset Yoshi wings flag.
    stz $1B95|!addr

    ; Reset side exit flag.
    stz $1B96|!addr

    ; Reset background scroll flag.
    stz $1B9A|!addr

    ; Reset Reznor bridge counter.
    stz $1B9F|!addr

    ; Reset Yoshi drums.
    lda #$03 : sta $1DFA|!addr

    ; Reset some level end addresses (for Kaizo traps).
    rep #$20
    stz $1492|!addr
    stz $1494|!addr
    sep #$20
    stz $1B99|!addr

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

if !counterbreak_powerup
    ; Reset powerup.
    stz $19
endif

if !counterbreak_item_box
    ; Reset item box.
    stz $0DC2|!addr
endif

if !counterbreak_coins
    ; Reset coin counter.
    stz $0DBF|!addr
endif

if !counterbreak_bonus_stars
    ; Reset bonus stars counter.
    stz $0F48|!addr
    stz $0F49|!addr
endif

if !counterbreak_score
    ; Reset score counter.
    rep #$20
    stz $0F34|!addr
    stz $0F36|!addr
    stz $0F38|!addr
    sep #$20
endif

    ; Reset timer to the original value.
    lda !ram_timer+0 : sta $0F31|!addr
    lda !ram_timer+1 : sta $0F32|!addr
    lda !ram_timer+2 : sta $0F33|!addr

    ; Reset timer frame counter
    lda.b #!timer_ticks : sta $0F30|!addr

    ; Music related stuff. I don't understand most of it.
if !amk
    lda $13C6|!addr : bne .force_reset
    lda $0DDA|!addr : cmp #$FF : beq .spec
    lda !ram_music_to_play : cmp $0DDA|!addr : bne .music_end
    bra .bypass

.spec:
if !death_song != $00
    lda $1DFB|!addr : cmp.b #!death_song : beq +
endif

.force_reset:
    lda #$00 : sta !amk_freeram : sta $1DFB|!addr
    bra .music_end
+   
    lda !ram_music_to_play : cmp !ram_music_backup : bne .music_end

.bypass:
    lda !ram_music_to_play : cmp #$FF : beq .music_end
    jsr shared_get_prompt_type
    cmp #$02 : bcs .music_end

    ; Force AMK to reload the samples.
    lda #$01 : sta !amk_freeram+1
else
    lda $0DDA|!addr : bpl .music_end
    stz $0DDA|!addr
endif
.music_end:
    rts
