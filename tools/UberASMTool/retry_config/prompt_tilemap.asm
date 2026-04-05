; In this file you can customize the Retry prompt text relatively easily.
; If you're opening this just to change which areas of VRAM (SP1/SP2/SP3/SP4)
; are used by the Retry prompt tiles, then look at the "Basic settings".
; To also change the prompt text, open "docs/prompt_tilemap.html" and go to the
; "Tilemap Generation Tool", which will calculate the values needed for the defines
; in the "Advanced settings" section (it also explains what they do if you're interested).

;============================== Basic settings =================================

; Sprite tile numbers for the tiles used by the prompt ($00-$FF = SP1/SP2, $100-$1FF = SP3/SP4).
; !prompt_tile_cursor is the cursor and space tile, !prompt_tiles_line1 are the unique letters for the
; first line, !prompt_tiles_line2 are the unique letters for the second line.
; Note: When the prompt black bg is disabled, !prompt_tile_cursor uses one 8x8 tile.
;       When the prompt black bg is enabled, !prompt_tile_cursor uses more than one 8x8 tile
;         (3 if using the prompt box, 2 if using the prompt bar).
; Note: When the exit option is disabled, or the line2 list has all letters from the line1, the line2 list is unused.
    !prompt_tile_cursor = $46
    !prompt_tiles_line1 = $44,$45,$54,$55 ; RETY
    !prompt_tiles_line2 = $29,$39         ; XI

; Palette rows used by the letters and cursor (note: they use sprite palettes).
    !prompt_pal_letter = $08
    !prompt_pal_cursor = $08

;============================== Advanced settings ==============================

; These settings specify the index of the prompt tiles in the GFX bin file.
    !prompt_gfx_index_cursor = 0
    !prompt_gfx_index_line1  = 3,4,5,6 ; RETY
    !prompt_gfx_index_line2  = 7,8     ; XI

; These settings specify which tiles are drawn on the two lines of the Retry prompt, and in which order.
    !prompt_tile_index_line1 = 0,1,2,0,3 ; RETRY
    !prompt_tile_index_line2 = 1,4,5,2   ; EXIT
