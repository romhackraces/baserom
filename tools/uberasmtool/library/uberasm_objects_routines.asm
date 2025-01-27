incsrc "callisto.asm"
%import_library("freeram.asm")
incsrc "../retry_config/ram.asm"

;=================================================================
; UberASM Object System - Routines
;=================================================================
; Each extended uberasm object, follows the format:
;
;       %ObjectRoutine(<num>, <routine_name>)
;
;=================================================================
; Objects under .init are loaded during game mode 12 init so they
; are active when the object data loads. Those under .main are
; loaded during GM14 main.
;=================================================================

; macro to run an object
macro ObjectRoutine(object_number, routine)
    db <object_number>-$98 : dw <routine>
endmacro

routines:
; Game Mode 12 init
.init
    ; basic uberasm
    %ObjectRoutine($99, disable_horizontal_scroll)
    %ObjectRoutine($9A, invisible_mario)
    ; retry objects
    %ObjectRoutine($B0, retry_type_instant)
    %ObjectRoutine($B1, retry_type_prompt)
    %ObjectRoutine($B2, retry_type_vanilla)
    %ObjectRoutine($B3, retry_config_bottom_left_prompt)
    %ObjectRoutine($B4, retry_config_no_powerup_from_midway)
    %ObjectRoutine($BA, retry_display_timer)
    %ObjectRoutine($BB, retry_display_coins)
    %ObjectRoutine($BC, retry_display_item_box)
    %ObjectRoutine($BD, retry_display_lives)
    %ObjectRoutine($BE, retry_display_bonus_stars)
    ; initialization objects
    %ObjectRoutine($C0, start_with_mushroom)
    %ObjectRoutine($C1, start_with_cape)
    %ObjectRoutine($C2, start_with_fire_flower)
    %ObjectRoutine($C3, start_with_star_power)
    %ObjectRoutine($C4, start_on_green_yoshi)
    %ObjectRoutine($C5, start_on_yellow_yoshi)
    %ObjectRoutine($C6, start_on_blue_yoshi)
    %ObjectRoutine($C7, start_on_red_yoshi)
    %ObjectRoutine($C8, start_in_spin_jump)
    %ObjectRoutine($C9, start_with_switch_off)
    %ObjectRoutine($CA, start_with_switch_on)
    ; toggle objects
    %ObjectRoutine($D0, toggle_status_bar)
    %ObjectRoutine($D1, toggle_lr_scroll)
    %ObjectRoutine($D2, toggle_spinjump_fireballs)
    %ObjectRoutine($D3, toggle_block_duplication)
    %ObjectRoutine($D4, toggle_capespin_direction)
    %ObjectRoutine($D5, toggle_springboard_fixes)
    %ObjectRoutine($D6, toggle_rope_glitch)
..done

; Game Mode 14 main
.main
    ; basic uberasm
    %ObjectRoutine($98, enable_free_vertical_scroll)
    %ObjectRoutine($9A, invisible_mario)
    %ObjectRoutine($9B, no_powerups)
    %ObjectRoutine($9C, cape_eight_frame_float)
    %ObjectRoutine($9D, cape_zero_float_delay)
    %ObjectRoutine($9E, disable_cape_flight)
    %ObjectRoutine($9F, death_on_power_up_loss)
    %ObjectRoutine($A0, press_lr_to_die)
    %ObjectRoutine($A1, disable_screen_shake)
    %ObjectRoutine($A2, disable_spin_jump)
..done

; Game Mode 14 end
.end
    ; end code here
..done

;=================================================================
; Code to run for each extended object. It's recommended to keep
; it simple and use level ASM for more complex code.
;=================================================================
; IDs correspond to those in patches/objectool/custom_object_code.asm
;=================================================================

;;
;; Extended Objects 98 - AF
;;

; Free vertical scrolling
enable_free_vertical_scroll:
    lda #$01 : sta $1404|!addr
    rts

; Lock horizontal scroll
disable_horizontal_scroll:
    stz $1411|!addr
    rts

; Invisible Mario (hides the player graphics)
invisible_mario:
    lda #$7F : sta $78 ;
    rts

; Resets power-up state and cannot collect power-ups
no_powerups:
    stz $19             ; Reset powerup.
    stz $0DC2|!addr     ; Reset item box.
    rts

; Enable eight frame float with cape
cape_eight_frame_float:
    lda $15             ;\ Check if A or B button is being held
    and #$80            ;/
    beq +
    lda #$08            ;\ Store 8 frames to cape float
    sta $14A5|!addr     ;/
+   rts

; Zero float delay with cape
cape_zero_float_delay:
    lda $187A|!addr     ;\ Check if Mario is riding Yoshi with wings...
    and $141E|!addr     ;/
    bne +
    stz $14A5|!addr     ; Disable the float timer
+   rts

; Death on power up loss
death_on_power_up_loss:
    lda $71             ;\ Check if mario is in hurt state
    cmp #$01            ;/
    bne +
    jsl $00F606|!bank   ; Kill the player
+   rts

; Press L & R to Die
press_lr_to_die:
    lda $17             ;\ Check if L & R are pressed
    and #%00110000      ;|
    cmp #$30            ;/
    bne +
    jsl $00F606|!bank   ; Kill the player
+   rts

; Disable cape flight
disable_cape_flight:
    stz $149F|!addr     ; store zero to the flight timer to prevent take off
    rts

; Disable screen shake
disable_screen_shake:
    stz $1887|!addr     ; store zero to the layer 1 shake timer
    rts

; Disable spin jump
disable_spin_jump:
    lda #$80 : trb $18  ; Disable pressing A
    rts

;;
;; Extended Objects B0 - BF
;; Retry Config Objects
;;

; Use instant retry
retry_type_instant:
    lda #$03 : sta !retry_ram_prompt_override
    rts

; Use prompt retry
retry_type_prompt:
    lda #$02 : sta !retry_ram_prompt_override
    rts

; Use Vanilla death sequence (useful to override a global setting)
retry_type_vanilla:
    lda #$04 : sta !retry_ram_prompt_override
    rts

; Display retry prompt in bottom left
retry_config_bottom_left_prompt:
    lda #$08 : sta !retry_ram_prompt_x_pos
    lda #$D0 : sta !retry_ram_prompt_y_pos
    rts

; No powerup from midways
retry_config_no_powerup_from_midway:
    lda #$00 : sta !retry_ram_midway_powerup
    rts

; Display sprite item box
retry_display_item_box:
    rep #$20
    lda #$301D  ; palette B, tile 0x1D
    sta !retry_ram_status_bar_item_box_tile
    sep #$20
    rts

; Display sprite timer
retry_display_timer:
    rep #$20
    lda #$0020 ; palette 8, tile 0x20
    sta !retry_ram_status_bar_timer_tile
    sep #$20
    rts

; Display sprite coin counters
retry_display_coins:
    rep #$20
    lda #$0022 ; palette 8, tile 0x22
    sta !retry_ram_status_bar_coins_tile
    sep #$20
    rts

; Display sprite life counter
retry_display_lives:
    rep #$20
    lda #$10CE ; palette 9, tile 0xCE
    sta !retry_ram_status_bar_lives_tile
    sep #$20
    rts

; Display sprite bonus stars counter
retry_display_bonus_stars:
    rep #$20
    lda #$104E ; palette 9, tile 0x4E
    sta !retry_ram_status_bar_bonus_stars_tile
    sep #$20
    rts


;;
;; Extended Objects C0-CF
;; Initial Player or level states
;;

; Start Mario in with a Mushroom
start_with_mushroom:
    lda #$01 : sta $19 ; set player power-up status to big
    rts

; Start Mario in with a Cape
start_with_cape:
    lda #$02 : sta $19 ; set player power-up status to cape
    rts

; Start Mario in with Flower
start_with_fire_flower:
    lda #$03 : sta $19 ; set player power-up status to fire
    rts

; Start with Star Power
start_with_star_power:
    lda #$FF : sta $1490|!addr ; start the player with default star power timer
    rts

; Start Mario on Green Yoshi
start_on_green_yoshi:
    lda #$0A            ;\ #$04=yellow; #$06=blue; #$08=red; #$0A=green
    sta $13C7|!addr     ;/ store yoshi color
    jsl $00FC7A|!bank   ;> run routine to initialize yoshi
    rts

; Start Mario on Yellow Yoshi
start_on_yellow_yoshi:
    lda #$04            ;\ #$04=yellow; #$06=blue; #$08=red; #$0A=green
    sta $13C7|!addr     ;/ store yoshi color
    jsl $00FC7A|!bank   ;> run routine to initialize yoshi
    rts

; Start Mario on Blue Yoshi
start_on_blue_yoshi:
    lda #$06            ;\ #$04=yellow; #$06=blue; #$08=red; #$0A=green
    sta $13C7|!addr     ;/ store yoshi color
    jsl $00FC7A|!bank   ;> run routine to initialize yoshi
    rts

; Start Mario on Red Yoshi
start_on_red_yoshi:
    lda #$08            ;\ #$04=yellow; #$06=blue; #$08=red; #$0A=green
    sta $13C7|!addr     ;/ store yoshi color
    jsl $00FC7A|!bank   ;> run routine to initialize yoshi
    rts

; Start in Spinning State
start_in_spin_jump:
    lda #$01 : sta $140D|!addr ; set spin jump flag
    rts

; Start with Switch OFF
start_with_switch_off:
    lda #$01 : sta $14AF|!addr ; set switch state to OFF
    rts

; Start with Switch ON
start_with_switch_on:
    stz $14AF|!addr ; set switch state to ON
    rts


;;
;; Extended Objects D0 - DF
;; Feature toggle Objects
;;

; Toggle status bar
toggle_status_bar:
    lda #$01 : sta !toggle_statusbar_freeram
    rts

; Toggle l/r scroll
toggle_lr_scroll:
    lda #$01 : sta !toggle_lr_scroll_freeram
    rts

; Toggle vanilla cape spin in air
toggle_capespin_direction:
    lda #$01 : sta !toggle_capespin_direction_freeram
    rts

; Toggle spin jump fireballs
toggle_spinjump_fireballs:
    lda #$01 : sta !toggle_spinjump_fireball_freeram
    rts

; Toggle springboard fixes
toggle_springboard_fixes:
    lda #$01 : sta !toggle_springboard_fixes_freeram
    rts

; Toggle rope glitch
toggle_rope_glitch:
    lda #$01 : sta !toggle_rope_glitch_freeram
    rts

;  Toggle block duplication
toggle_block_duplication:
    lda #$01 : sta !toggle_block_duplication_freeram
    rts
