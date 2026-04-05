; Bank where all gfx files are stored, used externally
!gfx_bank = bank(gfx_prompt)

macro incgfx(file)
    incbin "../../gfx/<file>.bin"
endmacro

macro incgfx_size(file, size)
    incbin "../../gfx/<file>.bin":0..<size>
endmacro

; Calculate prompt file size to insert based on the indexes defined by the user
macro _prompt_file_size(...)
    !__size #= 0
    for i = 0..sizeof(...)
        if <...[!i]> > !__size
            !__size = <...[!i]>
        endif ; <...[!i]> > !__size
    endfor
    ; Each tile is 32 bytes (+1 because the index starts from 0)
    !__size #= (!__size+1)*32
endmacro

if defined("prompt_gfx_index_line2")
    %_prompt_file_size(!prompt_gfx_index_line1,!prompt_gfx_index_line2)
else ; if not(defined("prompt_gfx_index_line2"))
    %_prompt_file_size(!prompt_gfx_index_line1)
endif ; defined("prompt_gfx_index_line2")

prompt:
.box:
    %incgfx_size(prompt1,!__size)

.no_box:
    %incgfx_size(prompt2,!__size)

undef "__size"

if !sprite_status_bar

digits:
    %incgfx(digits)

x:
    %incgfx(x)

coins:
    %incgfx(coins)

timer:
    %incgfx(timer)

lives:
    %incgfx(lives)

bonus_stars:
    %incgfx(bonus_stars)

death:
    %incgfx(death)

item_box:
if !8x8_item_box_tile
    %incgfx(item_box_8x8)
else ; if not(!8x8_item_box_tile)
    %incgfx(item_box_16x16)
endif ; !8x8_item_box_tile

if !draw_retry_indicator
indicator:
    %incgfx(indicator)
endif ; !draw_retry_indicator

endif ; !sprite_status_bar
