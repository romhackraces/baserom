if not(!no_prompt_draw)

; Check if palette values make sense.
assert !prompt_pal_letter >= $08 && !prompt_pal_letter <= $0F, "Error: \!prompt_pal_letter should be between $08 and $0F."
assert !prompt_pal_cursor >= $08 && !prompt_pal_cursor <= $0F, "Error: \!prompt_pal_cursor should be between $08 and $0F."

; Convert palettes from row number to YXPPCCCT format.
!l_props #= ($30|((!prompt_pal_letter-8)<<1))
!c_props #= ($30|((!prompt_pal_cursor-8)<<1))

; Function to add the T bit in the YXPPCCCT properties for tiles in page 1
function props(prop,tile) = ((prop)|((tile>>8)&1))

; The bg tiles are always uploaded next to the cursor
!prompt_tile_black #= !prompt_tile_cursor+1

; Set the cursor/black tile size depending on the prompt type.
; This is only needed for bg enabled (otherwise it's always 8x8).
if !prompt_type == 0
    !bg_tile_size #= $02
else ; if not(!prompt_type == 0)
    !bg_tile_size #= $00
endif ; !prompt_type == 0

;===============================================================================
; prompt_oam routine
;
; This routine draws the Retry prompt tiles on the screen.
; The prompt will be drawn using as few OAM slots as possible:
; - If box and exit are enabled, 15 slots will be used (16 if using the oscillating cursor).
; - If box is disabled but exit is enabled, 11 slots will be used.
; - If box is enabled but exit is disabled, 8 slots will be used (9 if using the oscillating cursor).
; - If box and exit are disabled, 6 slots will be used.
; Before drawing, all the currently used OAM slots are moved at the end of the OAM table, then the new tiles are written from the start.
; This ensures that in most cases Retry won't overwrite other sprites, and that it will always have max priority w.r.t. other sprite tiles
; (so that other sprites will always go behind the prompt).
;===============================================================================
prompt_oam:
    ; Get as many free slots as possible at the start of $0200.
    ; Skip this in Reznor/Morton/Roy's rooms to avoid glitching their BGs.
    lda $0D9B|!addr : cmp #$C0 : beq +
    jsr defrag_oam
+   
    ; Store the "hide cursor" mask in $00.
if !cursor_setting == 1
    lda $1B91|!addr : eor #$1F : and #$18 : bne +
    lda #$03
    bra ++
+
elseif !cursor_setting == 2
    lda $1B91|!addr : lsr #!cursor_oscillate_speed : and #$07 : tax
    lda.w .cursor_x_offset,x : sta $02
endif ; !cursor_setting
    ldx $1B92|!addr
    lda.w .hide_cursor_mask,x
++  sta $00

    ; Draw "RETRY"
    ldy #$00 : sty $01
    ldx.b #letters_retry-letters
if !prompt_wave
    stz $03
    lda $1B92|!addr : bne +
    inc $03
+
endif ; !prompt_wave
    jsr oam_draw
    jsr handle_cursor

    ; Draw "EXIT" if exit is enabled
    lda !ram_disable_prompt_exit : bne .no_exit
    sty $01
    ldx.b #letters_exit-letters
if !prompt_wave
    stz $03
    lda $1B92|!addr : beq +
    inc $03
+
endif ; !prompt_wave
    jsr oam_draw
    lsr $00
    jsr handle_cursor

.no_exit:
    ; Draw filler tiles if the box is enabled
    lda !ram_disable_prompt_bg : bne .no_box
    ldx.b #letters_box-letters
    lda !ram_disable_prompt_exit : beq +
    ldx.b #letters_box_no_exit-letters
+   jsr oam_draw

.no_box:    
    ; Make sure $0400 is up to date
    jsr shared_update_0400
    rts

.hide_cursor_mask:
    db $02,$01

if !cursor_setting == 2
.cursor_x_offset:
    db -1,0,1,2,3,2,1,0
endif ; !cursor_setting == 2

;===============================================================================
; handle_cursor routine
;
; This routine handles hiding the cursor when applicable, as well as setting its OAM size
; and offsetting its X position when !cursor_setting == 2.
; If the box is enabled, the cursor will be 16x16, and hidden by replacing it with a black tile.
; Otherwise, the cursor will be 8x8, and hidden by moving it offscreen.
;
; Inputs:
;  $00 = LSB set if the cursor should be hidden
;  $01 = OAM index of the cursor
;  $02 = X offset of the cursor (when !cursor_setting == 2)
;===============================================================================
handle_cursor:
    ; Set the OAM size.
    lda $01 : lsr #2 : tax
    lda !ram_disable_prompt_bg : beq +
    lda #$00
    bra ++
+   lda.b #!bg_tile_size
++  sta $0420|!addr,x
    
    ; Hide and offset the cursor.
    ldx $01
    lda $00 : and #$01 : bne .hide

if !cursor_setting == 2
    ; If the box is enabled...
    lda !ram_disable_prompt_bg : bne +

    ; Draw an additional black tile under the cursor (to avoid cutoff).
    rep #$20
    lda $0200|!addr,x : sta $0200|!addr,y
    lda.w #(!l_props<<8)|(!prompt_tile_black) : sta $0202|!addr,y
    sep #$20

    ; Make the black tile 16x16 for box or 8x8 for bar and increase the OAM index.
    phy
    tya : lsr #2 : tay
    lda.b #!bg_tile_size : sta $0420|!addr,y
    ply
    iny #4
+   
    ; Apply the X offset to the cursor
    lda $0200|!addr,x : clc : adc $02 : sta $0200|!addr,x

    ; Make the cursor 8x8.
    txa : lsr #2 : tax
    stz $0420|!addr,x
endif ; !cursor_setting == 2
    rts

.hide:
    lda !ram_disable_prompt_bg : beq +
    lda #$F0 : sta $0201|!addr,x
    rts
+   lda.b #!prompt_tile_black : sta $0202|!addr,x
.return:
    rts

;===============================================================================
; This routine hides the Retry prompt tiles if necessary in mode 7 boss rooms.
;===============================================================================
prompt_maybe_erase_tiles:
    ; Erase the prompt's OAM tiles when in Reznor/Morton/Roy/Ludwig's rooms.
    ; This avoids the BG from glitching out when the prompt disappears.
    lda $0D9B|!addr : cmp #$C0 : bne .return

    ; If the prompt is enabled and it was activated, erase the tiles.
    jsr shared_is_prompt_deployed : bcc .return

    ; Find how many tiles we need to erase.
    lda.b #(letters_retry_end-letters_retry)/5 : sta $00
    
    lda !ram_disable_prompt_exit : bne +
    lda $00 : clc : adc.b #(letters_exit_end-letters_exit)/5 : sta $00
+   
    lda !ram_disable_prompt_bg : bne +
    lda $00 : clc : adc.b #(letters_box_end-letters_box)/5
if !cursor_setting == 2
    inc
endif ; !cursor_setting == 2
    sta $00
+   
    ; Put all the tiles offscreen.
    lda $00 : dec : asl #2 : tay
    lda #$F0
.loop:
    sta $0201|!addr,y
    dey #4 : bpl .loop
.return:
    rts

;===============================================================================
; oam_draw routine
;
; This routine draws one part of the Retry prompt on the screen.
; Inputs:
;  X = index in the letters table
;  Y = OAM index
;===============================================================================
oam_draw:
if !prompt_wave
    stz $0F
endif ; !prompt_wave
    
    lda !ram_disable_prompt_bg : sta $0C
    lda !ram_prompt_x_pos : sta $0D
    lda !ram_prompt_y_pos : sta $0E

.loop:
    ; Return if we reached the $FF terminator.
    lda.w letters,x : cmp #$FF : beq .return

    ; Store the X position.
    clc : adc $0D : sta $0200|!addr,y

    ; If the prompt box is disabled, don't draw the empty tiles.
    lda $0C : beq +
    lda.w letters+2,x : cmp.b #!prompt_tile_black : beq ..skip_tile
    cmp.b #!prompt_tile_black+1 : beq ..skip_tile
+
    ; Store the Y position.
    lda.w letters+1,x : clc : adc $0E : sta $0201|!addr,y

if !prompt_wave
    ; Make the letters wave
    lda $03 : beq +
    lda.w letters+2,x : cmp.b #!prompt_tile_cursor : beq +
    phx
    lda $1B91|!addr : lsr #!prompt_wave_speed
    clc : adc $0F : and #$07 : tax
    lda.w .y_offset,x : clc : adc $0201|!addr,y : sta $0201|!addr,y
    plx
    inc $0F
+
endif ; !prompt_wave
    
    ; Store tile and properties.
    rep #$20
    lda.w letters+2,x : sta $0202|!addr,y
    sep #$20

    ; Store the OAM size.
    phy
    tya : lsr #2 : tay
    lda.w letters+4,x : sta $0420|!addr,y
    ply

    ; Go to the next tile.
    iny #4
..skip_tile:
    inx #5
    bra .loop
.return:
    rts

if !prompt_wave
.y_offset:
    db -3,-2,-1,0,1,0,-1,-2
endif ; !prompt_wave

; Get value in the variadic list at the specified index
macro _arg_get(idx, ...)
    !__idx #= <idx>
    !__arg #= <...[!__idx]>
    undef "__idx"
endmacro

; Build OAM entries for all tiles indexed by the variadic argument
; The entries start at the <x,y> specified and then shift 8 pixels to the right each time
macro _prompt_oam(x, y, ...)
    !__x #= <x>
    for i = 0..sizeof(...)
        if <...[!i]> == -1
            !__arg #= !prompt_tile_black
        elseif defined("prompt_tiles_line2") ; && not(<...[!i]> == -1)
            %_arg_get(<...[!i]>,!prompt_tiles_line1,!prompt_tiles_line2)
        else ; if not(<...[!i]> == -1 || defined("prompt_tiles_line2"))
            %_arg_get(<...[!i]>,!prompt_tiles_line1)
        endif ; <...[!i]> == -1
        db !__x                   ; X
        db <y>                    ; Y
        db !__arg                 ; Tile
        db props(!l_props,!__arg) ; Properties
        db $00                    ; Size
        !__x #= !__x+$08
    endfor
    undef "__x"
    undef "__arg"
endmacro

;===============================================================================
; OAM info for each tile (X,Y,T,P,S)
;
; For the letters on the two lines, a variadic macro is used to build the table
; based on two lists of tile numbers.
;===============================================================================
letters:
.retry:
    db $00,$00,!prompt_tile_cursor,props(!c_props,!prompt_tile_cursor),$00
if !prompt_type != 0
    db $08,$00,!prompt_tile_black,props(!c_props,!prompt_tile_cursor),$00
endif ; !prompt_type != 0
    %_prompt_oam($10,$00,!prompt_tile_index_line1)
..end:
    db $FF

.exit:
if defined("prompt_tile_index_line2")
if !prompt_type == 0
    db $00,!prompt_box_exit_y_offset,!prompt_tile_cursor,props(!c_props,!prompt_tile_cursor),$00
    %_prompt_oam($10,!prompt_box_exit_y_offset,!prompt_tile_index_line2)
else ; if not(!prompt_type == 0)
    db !prompt_bar_exit_x_offset,$00,!prompt_tile_cursor,props(!c_props,!prompt_tile_cursor),$00
    db !prompt_bar_exit_x_offset+$08,$00,!prompt_tile_black,props(!c_props,!prompt_tile_cursor),$00
    %_prompt_oam(!prompt_bar_exit_x_offset+$10,$00,!prompt_tile_index_line2)
endif ; !prompt_type == 0
endif ; defined("prompt_tile_index_line2")
..end:
    db $FF

; These are the tiles used to hide the window holes to the left.
; We calculate how many tiles are needed based on the text x position.
.box:
if !prompt_type == 0
    for i = 0..(!prompt_box_text_x_pos-!box_window_x_pos)/$10
        db -(!i+1)*$10,$10,!prompt_tile_black,props(!l_props,!prompt_tile_black),$02
    endfor
    if (!prompt_box_text_x_pos-!box_window_x_pos)%$10 != 0
        db !box_window_x_pos-!prompt_box_text_x_pos,$10,!prompt_tile_black,props(!l_props,!prompt_tile_black),$02
    endif ; (!prompt_box_text_x_pos-!box_window_x_pos)%$10 != 0
..no_exit:
    for i = 0..(!prompt_box_text_x_pos-!box_window_x_pos)/$10
        db -(!i+1)*$10,$00,!prompt_tile_black,props(!l_props,!prompt_tile_black),$02
    endfor
    if (!prompt_box_text_x_pos-!box_window_x_pos)%$10 != 0
        db !box_window_x_pos-!prompt_box_text_x_pos,$00,!prompt_tile_black,props(!l_props,!prompt_tile_black),$02
    endif ; (!prompt_box_text_x_pos-!box_window_x_pos)%$10 != 0
else ; if not(if !prompt_type == 0)
    for i = 0..(!prompt_bar_exit_x_offset/$08)-!prompt_line1_length-2
        db !prompt_bar_exit_x_offset-((!i+1)*$08),$00,!prompt_tile_black,props(!l_props,!prompt_tile_black),$00
    endfor
    if !prompt_bar_exit_x_offset%$08 != 0
        db (2+!prompt_line1_length)*$08,$00,!prompt_tile_black,props(!l_props,!prompt_tile_black),$00
    endif ; !prompt_bar_exit_x_offset%$08 != 0
..no_exit:
    ; No additional tiles to draw when the exit option is enabled
endif ; !prompt_type == 0
..end:
    db $FF

;===============================================================================
; defrag_oam routine
;
; This routine puts all used slots in OAM at the end of the table in contiguous spots.
; The result is that all free slots will be at the beginning of the table.
; This allows the letters to be drawn with max priority w.r.t. everything else, and to not overwrite other tiles.
; Clobbers $00-$03.
;===============================================================================
defrag_oam:
    ; Since we scan both $0200 and $0300, we need 16 bit indexes.
    rep #$10
    ; Y: index in the original OAM table.
    ldy #$01FC
    ; X: index in the rearranged table.
    ldx #$01FC

    ; First we find the first free slot from the end of the table.
    ; This prevents the main loop from hiding tiles when the end of the OAM table is filled.
    lda #$F0
    
.setup_loop:
    cmp $0201|!addr,y : beq .main_loop
    dex #4
    dey #4
    bpl .setup_loop

..end:
    ; If we get here it means that the entire OAM table is full, so just return.
    sep #$10
    rts

    ; Now we move all the used slots in adjacent spots at the end of the OAM table.
.main_loop:
    ; If the slot is free, go to the next one.
    cmp $0201|!addr,y : beq ..next

    ; Otherwise, copy the Y slot in the X slot.
    rep #$20
    lda $0200|!addr,y : sta $0200|!addr,x
    lda $0202|!addr,y : sta $0202|!addr,x

    ; Backup X and Y.
    stx $00
    sty $02

    ; Compute the indexes in $0420.
    tya : lsr #2 : tay
    txa : lsr #2 : tax

    ; Copy the entry in $0420 as well.
    sep #$20
    lda $0420|!addr,y : sta $0420|!addr,x

    ; Restore X and Y.
    ldx $00
    ldy $02

    ; Go to the next slot in the rearranged table.
    dex #4

    ; Mark the Y slot as free
    ; (also load A with value to compare $0201 to in the next iteration).
    lda #$F0 : sta $0201|!addr,y

..next:
    ; Go to the next slot in the original table, and loop back if not the end.
    dey #4 : bpl .main_loop

.end:
    sep #$10
    rts

endif ; not(!no_prompt_draw)
