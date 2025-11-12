;========================================================================;
; Settings used by Retry. Feel free to change these.                     ;
;========================================================================;

;======================== Default Retry behavior ========================;

; 0 = retry prompt & play the death song when players die (music restarts on every death).
; 1 = retry prompt & play only the death sfx when players die (music won't be interrupted).
; 2 = instant retry & play only the death sfx when players die (no prompt & music won't be interrupted)
; 3 = instant retry & play the death song when players die (no prompt & music restarts on every death)
; 4 = no retry prompt/respawn (vanilla death).
; Note: you can override this per sublevel (see "settings_local.asm") and also at any point by setting a certain RAM address (see "docs/ram_map.html").
    !default_prompt_type = 1

;======================== QoL and Anti-Break ============================;

; How many lives to start a new save file with.
    !initial_lives = 99

; If 1, lives won't decrement when dying.
; Note: if 0, you can choose to have infinite lives in specific sublevels using the "no_lose_lives" option in "settings_local.asm".
    !infinite_lives = 1

; 0 = midways won't give Mario a mushroom.
; 1 = vanilla midway powerup behavior.
; Note: you can also change this on the fly (see "docs/ram_map.html").
    !midway_powerup = 0

; Counterbreak options reset the corresponding counters/items when the player dies and/or when going to the Overworld.
; Useful for Kaizo and collab hacks. For lives, they will be reset to !initial_lives
; 0 = disabled, 1 = enabled for both respawning and going to the Overworld
; 2 = enabled just for respawning, 3 = enabled just for going to the Overworld
    !counterbreak_yoshi = 1
    !counterbreak_powerup = 1
    !counterbreak_item_box = 1
    !counterbreak_coins = 0
    !counterbreak_bonus_stars = 0
    !counterbreak_score = 0
    !counterbreak_lives = 0

;======================== QoL fixes =====================================;

; If 1, level transitions will be much faster than usual.
    !fast_transitions = 0

; If 1, it fixes the issue where some sprites don't face Mario when entering a level for the first time.
; It's suggested to enable the fix to make sprite behavior consistent between the first and all the next level reloads.
    !initial_facing_fix = 1

; If 1, it fixes the issue where dying in a level with the timer set to 0
; shows the "TIME UP!" message when exiting the level.
    !time_up_fix = 1

; If 1, it fixes the issue where you can drop the reserve item in the item box
; by pressing Select while Mario is dying or while the Retry prompt is shown.
    !item_box_fix = 1

; If 1, it fixes the weird behavior where levels 12E-13B always use the "No Yoshi Sign 2" intro
; regardless of the tileset / custom "No Yoshi Intro" patches.
    !no_yoshi_intro_fix = 1

; If 1, it removes the "Hurry up!" SFX and tempo hike effect that happens when reaching 100 seconds on the timer.
; If not disabled, the death song will be played when dying during the tempo hike effect (regardless of the settings), to reset the tempo of the song after respawning.
    !disable_hurry_up = 0

; This controls whether to freeze sprites during a level's pipe entrance (it doesn't affect other entrance types).
; 0 = don't freeze
; 1 = freeze (recommended)
; 2 = vanilla: freeze only if sprites were frozen when exiting the previous room (e.g. if you entered a pipe, but not if you entered a door).
;     This can be inconsistent if exiting and re-entering the level.
    !pipe_entrance_freeze = 1

; If 1, Start+Select out of a level is always possible.
; Otherwise, it's only possible with the instant Retry option, or with the Retry prompt with the "Exit" option disabled, or if the level is already beaten like vanilla.
    !always_start_select = 0

; If 1, the camera won't scroll vertically during Mario's death animation.
    !death_camera_lock = 0

; If 1, DSX (dynamic) sprites status is reset on level load.
    !reset_dsx = 1

; 0 = vanilla (Boo Rings will retain the previous positions, not recommended for Kaizo).
; 1 = reset Boo Rings positions on death.
; 2 = reset Boo Rings positions on death and on level load.
    !reset_boo_rings = 1

; This determines what happens when you die on the title screen.
; 0 = vanilla (after dying a glitched version of the title screen will load, causing a softlock).
;     Use this if you either don't care or want to do something custom with it.)
; 1 = play vanilla death animation and reload title screen (note: death music only works with AddmusicK!).
; 2 = instantly reload the title screen.
; 3 = instantly reload the title screen and play the death music (title screen music will restart)
    !title_death_behavior = 1

;======================== SFX ===========================================;

; SFX to play when dying (!death_sfx = $00 -> no SFX).
; Only played if the death song is skipped (for example, it's not played if the level uses vanilla death).
; You can find a suitable death sfx inside "resources/amk/sfx".
    !death_sfx = $20
    !death_sfx_addr = $1DF9

; The alternative death jingle which will be played after the !death_sfx when "Exit" is chosen in the prompt.
; $01-$FE: custom song number, $FF = do not use this feature.
; You can find a suitable alt death jingle inside "resources/amk/music" (to be paired with the custom sfx).
    !death_jingle_alt = $FF

; SFX to play when selecting an option in the prompt (!option_sfx = $00 -> no SFX).
    !option_sfx = $01
    !option_sfx_addr = $1DFC

; SFX to play when the prompt cursor moves (!cursor_sfx = $00 -> no SFX).
    !cursor_sfx = $06
    !cursor_sfx_addr = $1DFC

; SFX to play when getting a checkpoint through a room transition (!room_cp_sfx = $00 -> no SFX).
; This is meant as a way to inform the player that they just got a room checkpoint.
; If enabled, you can disable it in specific sublevels using the "no_room_cp_sfx" option in "settings_local.asm".
    !room_cp_sfx = $05
    !room_cp_sfx_addr = $1DF9

; SFX to play when entering a level from the Overworld (!enter_level_sfx = $00 -> no SFX)
; similarly to what SMB3 does. If the SFX gets cut out, increase !enter_level_delay.
    !enter_level_sfx = $00
    !enter_level_sfx_addr = $1DFC
    !enter_level_delay = $02

; Default option for SFX echo. This is irrelevant if AddmusicK is not used.
; This controls the default SFX echo option for all levels and what the %sfx_echo(<level>) does in "settings_local.asm":
; 0 = disabled in all levels except those toggled by %sfx_echo
; 1 = enabled in all levels except those toggled by %sfx_echo (note: this only works if !use_legacy_tables = 0)
    !default_sfx_echo = 0

;======================== Save and SRAM =================================;

; If 1, a custom SRAM expansion patch will be inserted as well.
; By default, it will save the custom checkpoint status and death counter to SRAM.
; To make your own stuff saved as well, check out the "save" table in "sram_tables.asm".
    !sram_feature = 1

; If 1, the game will automatically save everytime a new checkpoint is obtained (when touching a midway or getting a cp on a room transition).
; If using this, make sure there's no softlocks (for example, a level is unbeatable from one of the checkpoints).
    !save_on_checkpoint = 0

; If 1, the game will automatically save after getting a game over.
; This can be useful when paired with the option of not reloading some data from SRAM after a game over (see "sram_tables.asm"),
; if you want some things to retain even if the player got a game over before saving them (for example, the death counter).
; This ensures that they will be saved to SRAM when this happens.
    !save_after_game_over = 1

;======================== Custom Midways ================================;

; If 1, Retry will install a custom midway object in the ROM, insertable in levels by using object 2D.
; These objects allow you to have multiple midways in the same level, each with a different entrance.
; For more info on how to use them, check out "docs/midway_instruction.html".
; Note: this can be used alongside ObjecTool, but you'll need to modify that patch a bit (see the "docs/objectool_info.html" file).
    !use_custom_midway_bar = 1

; If !use_custom_midway_bar = 1, it determines how many custom midways you can have in the same sublevel.
; The more you set, the more free ram is needed (4 bytes for each).
    !max_custom_midway_num = 8

;======================== Retry Prompt ==================================;

; If 1, the prompt will show up immediately after dying.
; Otherwise, it will show up halfway through (or right after, depending on !retry_death_animation)
; the death animation, but pressing A/B during it will skip the animation.
    !fast_prompt = 0

; 0 = don't play the death animation when using instant Retry or prompt
;     Note: for Retry prompt, part of the death animation still plays if not using !fast_prompt
; 1 = play the full death animation before showing the Retry prompt (note: make sure !fast_prompt = 0)
; 2 = play the full death animation before reloading the level with instant Retry
; 3 = play the full death animation in both cases (effects 1 and 2)
    !retry_death_animation = 0

; How many frames after dying the prompt shows up when using !fast_prompt = 0 and !retry_death_animation = 0
    !prompt_show_delay = $30

; How fast the prompt expands/shrinks. It must evenly divide 72.
    !prompt_speed = 6

; 0 = sprites and animations won't freeze when the prompt is shown.
; 1 = sprites and most animations will freeze, but some animations will still play (for example, Magikoopa Magic's flashing).
; 2 = sprites and all animations will freeze.
    !prompt_freeze = 2

; Cooldown (max $7F) for disabling up/down when the prompt shows up, which prevents
; selecting the "Exit" option for a few frames. Can be useful to prevent accidentally
; pressing "Exit" when dying while pressing up/down. Set to $00 to disable this.
    !prompt_cooldown = $10

; This controls what happens when hitting "Exit" on the Retry prompt:
; 0 = exit the level immediately and don't play the death music (except when the level music is sped up).
; 1 = exit the level immediately and play the death music (note that the vanilla song will be cut short).
; 2 = play the death animation and music, then exit the level.
; Note: when dying before going to Game Over, the vanilla animation will be always played regardless.
    !exit_animation = 2

; Set to 1 if you don't want the "Exit" option in the prompt.
; This will also allow the player to Start+Select when having the prompt.
; Note: you can also change this on the fly (see "docs/ram_map.html").
    !no_exit_option = 0

; Set to 1 to remove the black box, but leave the options on screen.
; Note: you can also change this on the fly (see "docs/ram_map.html").
    !no_prompt_box = 0

; Set to 1 to dim the screen while the prompt is shown.
    !dim_screen = 0

; Only used if !dim_screen = 1. Can go from 0 to 15, 15 = max brightness, 0 = black.
    !brightness = 8

; This defines a button that will count as hitting "Exit" on the menu while the prompt is shown.
; It could be handy if you disabled the exit option, but still want a quick way of exiting the level.
; By default it's "Select", set !exit_button = $00 to disable this.
; For more information on these values, see $7E0016 on the SMWCentral RAM Map.
    !exit_button = %00100000
    !exit_button_address = $16

; If 1, the Retry prompt won't be drawn to the screen (but still function normally).
; Use this for a minimalistic Retry, without having to use the instant option.
; You should also use !no_prompt_box = 1 or the black box will still appear (also you probably want !no_exit_option = 1).
; Note that this renders all the prompt options below useless (and no sprite GFX space needs to be reserved).
    !no_prompt_draw = 0

; X/Y position of the first tile in the prompt (the cursor on the first line).
; Changing this only works if the black box is disabled (if enabled,
; default values will be used instead).
; Note: you can also change these on the fly (see "docs/ram_map.html").
    !text_x_pos = $58
    !text_y_pos = $6F

; 0 = the cursor is static
; 1 = the cursor blinks like in vanilla menus
; 2 = the cursor oscillates slowly right and left
    !cursor_setting = 1

; How fast the cursor oscillates (only used when !cursor_setting = 2)
; Higher = slower. Possible values: 0 to 5.
    !cursor_oscillate_speed = 2

; 1 = the letters in the option selected on the Retry prompt will wave up and down.
; Note: this is incompatible with the black box (use !no_prompt_box = 1)
    !prompt_wave = 0

; How fast the letters wave (only used when !prompt_wave = 1)
; Higher = slower. Possible values: 0 to 5.
    !prompt_wave_speed = 2

; Palette row used by the letters and cursor (note: they use sprite palettes).
    !letter_palette = $08
    !cursor_palette = $08

; If 1, score sprites (points, 1-Up) will be removed when dying, if Retry prompt is enabled in the level.
; This can be used to replace their graphics ($29, $38-$39, $44-$47, $54-$57)
; with the Retry prompt tiles instead of having to reserve sprite tiles for the prompt.
    !no_score_sprites_on_death = 0

; Sprite tile number for the tiles used by the prompt ($00-$FF = SP1/SP2, $100-$1FF = SP3/SP4).
; These will be overwritten dynamically when the prompt needs to show up.
; The default values should be fine in most cases, unless you're using some other patch that reserves tiles in SP1,
; for example: Sprite Status Bar, 32x32 Player Tilemap, lx5's Custom Powerups, lx5's Dynamic Spriteset System.
; In this case you may need to change some of them to avoid other tiles being overwritten.
; You can see the tile number in LM's 8x8 Tile Editor, by taking the value you see in the bottom left - $400
; (e.g., "Tile 0x442" -> $42, "Tile 0x542" -> $142).
; Note: when the prompt box is enabled, !tile_curs and !tile_blk actually use 2 adjacent 8x8 tiles.
; For example, !tile_curs = $24 means both $24 and $25 will be overwritten.
; Also, obviously these aren't used if you don't use the Retry prompt or !no_prompt_draw = 1.
    !tile_curs = $20
    !tile_blk  = $22
    !tile_r    = $30
    !tile_e    = $31
    !tile_t    = $32
    !tile_y    = $33
    !tile_x    = $4A
    !tile_i    = $5A

;======================== Sprite Status Bar =============================;

; If 1, a sprite status bar will be installed allowing you to display the item box, coins, Yoshi coins,
; timer, lives and bonus stars using sprite tiles, which keeps layer 3 working properly.
    !sprite_status_bar = 0

; If 1, it disables the original game's status bar (including the IRQ) which prevents layer 3 from messing up.
; Differently than the normal remove status bar patch, this keeps the status bar functions (lives, coins,
; bonus stars, score, timer, reserve item) running in the background.
; Suggested to use if you're using !sprite_status_bar = 1.
; Don't use this if you're using similar patches such as "RAM Toggled Status Bar".
    !remove_vanilla_status_bar = 0

; Default sprite tile and palette to use for each element in the status bar.
; These settings can be overridden per-level by using the "configure_sprite_status_bar" API routine (see "docs/api.html").
; If !default_xxx_tile or !default_xxx_palette is $00, the item will be hidden by default.
; These are only relevant if !sprite_status_bar = 1.
    !default_item_box_tile         = $80
    !default_item_box_palette      = $0B
    !default_timer_tile            = $88
    !default_timer_palette         = $08
    !default_coin_counter_tile     = $C2
    !default_coin_counter_palette  = $08
    !default_lives_counter_tile    = $00
    !default_lives_counter_palette = $09
    !default_bonus_stars_tile      = $00
    !default_bonus_stars_palette   = $09

; General properties for sprite status bar elements.
; These are only relevant if !sprite_status_bar = 1.
    !item_box_x_pos      = $70
    !item_box_y_pos      = $07
    !timer_x_pos         = $D0
    !timer_y_pos         = $0F
    !coin_counter_x_pos  = $D0
    !coin_counter_y_pos  = $17
    !dc_counter_x_pos    = $9A
    !dc_counter_y_pos    = $0F
    !lives_counter_x_pos = $10
    !lives_counter_y_pos = $0F
    !bonus_stars_x_pos   = $10
    !bonus_stars_y_pos   = $17

; If 1, the item box will always be drawn (if set to be drawn for the specific level).
; Otherwise, it will only be drawn when having an item in reserve.
; This is only relevant if !sprite_status_bar = 1.
    !always_draw_box = 1

; If 1, the item box will use an 8x8 tile instead of a 16x16 tile.
; This is only relevant if !sprite_status_bar = 1.
    !8x8_item_box_tile = 0

; If 1, when collecting all DCs in a level they'll be displayed in the status bar.
; If 0, they won't be displayed (like in vanilla).
; This is only relevant if !sprite_status_bar = 1.
    !draw_all_dc_collected = 0

; 0 = draw both coins and dragon coins by default (if _tile and _palette are valid)
; 1 = don't draw coins by default (only dragon coins)
; 2 = don't draw dragon coins by default (only coins)
    !default_coin_counter_behavior = 0

; If !draw_retry_indicator = 1, an 8x8 indicator will be drawn on the sprite status bar
; in levels where Retry prompt or instant Retry is enabled. This could be useful for collabs.
; The other settings control how and where it is drawn. The tile you choose will be
; overwritten at runtime by the indicator tile when needed.
; This is only relevant if !sprite_status_bar = 1.
    !draw_retry_indicator    = 0
    !retry_indicator_tile    = $1D
    !retry_indicator_palette = $09
    !retry_indicator_x_pos   = $50
    !retry_indicator_y_pos   = $0F

;======================== Death Counter =================================;

; If 1, a death counter will replace the lives on the (vanilla) status bar.
    !status_death_counter = 0

; If 1, the "DEATHS" word will replace Mario's name on the status bar.
; If you want to customize the text or its palette, look in "retry_config/code/hijacks/death_counter.asm".
    !status_death_word = 0

; If 1, a death counter will be written to the Overworld border.
; Note: this only handles the counter, if you want other stuff like "DEATHS" appear, use LM's layer 3 editor.
    !ow_death_counter = 0

; Position of the death counter on the Overworld.
    !ow_death_counter_x_pos = $19
    !ow_death_counter_y_pos = $02

; YXPCCCTT properties of the death counter on the Overworld.
; The first digit is the palette, the second is the GFX page number (0 or 1).
    !ow_death_counter_props = l3_prop(6,1)

; Tile number of the digit "0" on the Overworld.
; (it's assumed that the digits are stored in order from 0 to 9 in the GFX file).
    !ow_digit_0 = $22

;======================== Misc settings =================================;

; If 1, the level-specific Retry settings will be loaded from the "legacy/tables.asm"
; file instead of the "settings_local.asm" file. Use this if you prefer the old table-based
; approach rather than the new macro-based approach.
    !use_legacy_tables = 0
