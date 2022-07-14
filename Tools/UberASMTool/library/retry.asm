math pri on
math round off

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
; Check incompatibilities.
;=====================================
    %incsrc(code,check_incompatibilities)

;=====================================
; Load shared settings and defines.
;=====================================
    %incsrc("",misc)
    %incsrc("",settings)
    %incsrc("",ram)

;=====================================
; Load the retry stables.
;=====================================
    %incsrc("",tables)

;=====================================
; Load the letters gfx.
;=====================================
retry_gfx:
.box:
    %incbin(gfx,letters1)
.no_box:
    %incbin(gfx,letters2)

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
