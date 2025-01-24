; include common freeram
incsrc "callisto.asm"
%import_library("freeram.asm")
incsrc "../retry_config/ram.asm"

; UberASM Objects system
;
; run the init in gamemode 12 (level load) and the main in gamemode 14 (in level)
;
; This system requires ObjecTool and reserves Extended objects 98-CF
; see patches/objectool/custom_object_code.asm for details

macro ObjectRoutine(object_number, routine)
    db <object_number>-$98 : dw <routine>
endmacro

routines:
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
..end

.main
    ; basic uberasm
    %ObjectRoutine($98, enable_free_vertical_scroll)
    %ObjectRoutine($9A, invisible_mario)
    %ObjectRoutine($9B, no_powerup_collection)
    %ObjectRoutine($9C, cape_eight_frame_float)
    %ObjectRoutine($9D, cape_zero_float_delay)
    %ObjectRoutine($9E, disable_cape_flight)
    %ObjectRoutine($9F, death_on_power_up_loss)
    %ObjectRoutine($A0, press_lr_to_die)
    %ObjectRoutine($A1, disable_screen_shake)
..end

init:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl
.not_castle_entrance

    phb
    phk
    plb
    lda.b #routines_init&$FF
    sta $00
    lda.b #routines_init>>8
    sta $01
    rep #$10
    ldy.w #routines_init_end-routines_init-3
    jsr run_routines
    plb

.return
    rtl

main:
    lda $71
    cmp #$0A
    bne .not_castle_entrance
    rtl
.not_castle_entrance

    phb
    phk
    plb
    lda.b #routines_main&$FF
    sta $00
    lda.b #routines_main>>8
    sta $01
    rep #$10
    ldy.w #routines_main_end-routines_main-3
    jsr run_routines
    plb

.return
    rtl


; word routine table pointer in $00-$01
; table size - 3 (in bytes) in 16-bit Y (16-bit needed since 3 * 0x68 > 0xFF)
; clobbers: $02, $03, $04
run_routines:
    lda #$00
    xba             ; zero out high byte of A so we can transfer to 16-bit X later
.loop
    lda ($00),y     ; load current custom object number
    sta $02         ; cache in $02
    lsr #3          ; divide custom object number by 8 to get byte index into FreeRAM
    sta $03         ; cache in $03
    stz $04         ; zero out $04 so 16-bit X can load index later
    lda $02         ; restore custom object number from $02
    and #$07        ; modulo 8 to get bit index
    tax
    lda ..masks,x   ; load correct mask for the bit
    ldx $03         ; load byte index from $03-$04
    and !objectool_level_flags_bank,x
    beq ..next      ; if bit not set skip the routine

    iny
    lda ($00),y
    sta $02
    iny
    lda ($00),y
    sta $03         ; otherwise, load word routine address into $02-$03

    phy             ; pushing current table index rather than caching in scratch so routines can use scratch
    sep #$10        ; ensuring routines get 8-bit everything
    ldx #$00
    jsr ($0002|!dp,x)   ; jump to object routine in $02-$03
    rep #$10        ; restore 16-bit X/Y
    ply             ; restore current table index

    dey #2          ; need to undo the two iny's from earlier

..next
    dey #3          ; move to next table entry
    bpl .loop
    sep #$10
    rts

..masks
    db 1,2,4,8,16,32,64,128


;---------------------------------------------------------------------
; Code to run for each extended object
; IDs correspond to patches/objectool/custom_object_code.asm
;---------------------------------------------------------------------


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

; Invisible
invisible_mario:
    lda #$7F : sta $78 ; hide the player graphics
    rts

; Cannot collect power-ups in the level
no_powerup_collection:
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
    stz $149F|!addr ; store zero to the flight timer to prevent take off
    rts

; Disable screen shake
disable_screen_shake:
    stz $1887|!addr ; store zero to the layer 1 shake timer
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

; Draw sprite item box
retry_display_item_box:
    rep #$30
    lda #$301D  ; Item box: palette B, tile 0x80
    sta !retry_ram_status_bar_item_box_tile
    sep #$30
    rts

retry_display_timer:
    rep #$30
    lda #$0020 ; Timer: palette 8, tile 0x20
    sta !retry_ram_status_bar_timer_tile
    sep #$30
    rts

retry_display_coins:
    rep #$30
    lda #$0022 ; Coin counter: palette 8, tile 0x22
    sta !retry_ram_status_bar_coins_tile
    sep #$30
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
