math pri on
math round off
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
    %incsrc("",misc)
    %incsrc("",settings)
    %incsrc("",ram)
    %incsrc("",rom)

;=====================================
; Check incompatibilities.
;=====================================
    %incsrc(code,check_incompatibilities)

;=====================================
; Load the Retry tables.
;=====================================
    %incsrc("",tables)
if !sram_feature
    %incsrc("",sram_tables)
endif
if !sprite_status_bar
    %incsrc("",sprite_status_bar_tables)
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
.coin:
    %incbin(gfx,coin)
.timer:
    %incbin(gfx,timer)
.item_box:
    %incbin(gfx,item_box)
endif

;=====================================
; Load the ASM files.
;=====================================
    %incsrc(code,shared)
    %incsrc("",extra)
    %incsrc("",level_end_frame)
    %incsrc(code,load_title)
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

;=====================================
; Load the hijacks.
;=====================================
    %incsrc(code/hijacks,hex_edits)
    %incsrc(code/hijacks,gm14_end)
    %incsrc(code/hijacks,multiple_midways)
    %incsrc(code/hijacks,vanilla_midway)
    %incsrc(code/hijacks,custom_midway)
    %incsrc(code/hijacks,sram)
    %incsrc(code/hijacks,hurry_up)
    %incsrc(code/hijacks,death_counter)
    %incsrc(code/hijacks,lose_lives)
    %incsrc(code/hijacks,initial_facing_fix)
    %incsrc(code/hijacks,item_box_fix)
    %incsrc(code/hijacks,remove_status_bar)
