namespace nested off

; Macros to load files easily.
macro incsrc(folder,file)
    namespace <file>
        incsrc "../retry_config/<folder>/<file>.asm"
    namespace off
endmacro

macro incbin(folder,file)
    incbin "../retry_config/<folder>/<file>.bin"
endmacro

;=====================================
; Load shared settings and defines.
;=====================================
    %incsrc(code/include,defines)
    %incsrc(code/include,misc)
    %incsrc(code/include,rom)
    %incsrc("",ram)
    %incsrc("",settings_global)
    
;=====================================
; Check incompatibilities.
;=====================================
    %incsrc(code,check_incompatibilities)

;=====================================
; Load the Retry tables.
;=====================================
if !use_legacy_tables
    %incsrc(legacy,tables)
else
    %incsrc(code/include,tables)
    %incsrc("",settings_local)
endif
if !sram_feature
    %incsrc("",sram_tables)
endif

;=====================================
; Load the letters gfx.
;=====================================
retry_gfx:
.box:
    %incbin(gfx,letters1)
.no_box:
    %incbin(gfx,letters2)
if !sprite_status_bar
.digits:
    %incbin(gfx,digits)
.coins:
    %incbin(gfx,coins)
.timer:
    %incbin(gfx,timer)
.lives:
    %incbin(gfx,lives)
.bonus_stars:
    %incbin(gfx,bonus_stars)
.item_box:
if !8x8_item_box_tile
    %incbin(gfx,item_box_8x8)
else
    %incbin(gfx,item_box_16x16)
endif
if !draw_retry_indicator
.indicator:
    %incbin(gfx,indicator)
endif
endif

;=====================================
; Load the ASM files.
;=====================================
    %incsrc(code,shared)
    %incsrc("",extra)
    %incsrc(code,startup)
    %incsrc(code,fade_to_level)
    %incsrc(code,level_init_1)
    %incsrc(code,level_init_2)
    %incsrc(code,level_init_3)
    %incsrc(code,level_transition)
    %incsrc(code,in_level)
    %incsrc(code,prompt)
    %incsrc(code,nmi)
    %incsrc(code,load_overworld)
    %incsrc(code,fade_to_overworld)
    %incsrc(code,game_over)
    %incsrc(code,time_up)
    %incsrc(code,sprite_status_bar)
    %incsrc(code,api)

;=====================================
; Load the hijacks.
;=====================================
    %incsrc(code/hijacks,hex_edits)
    %incsrc(code/hijacks,multiple_midways)
    %incsrc(code/hijacks,vanilla_midway)
    %incsrc(code/hijacks,custom_midway)
    %incsrc(code/hijacks,sram)
    %incsrc(code/hijacks,hurry_up)
    %incsrc(code/hijacks,death_counter)
    %incsrc(code/hijacks,initial_facing_fix)
    %incsrc(code/hijacks,item_box_fix)
    %incsrc(code/hijacks,remove_status_bar)
    %incsrc(code/hijacks,vanilla_boss_gm13)
    %incsrc(code/hijacks,switch_palace_message_fix)
