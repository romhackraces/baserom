;=====================================
; prompt_oam routine
;
; Handles drawing the prompt tiles when necessary.
; It's setup to only draw in empty OAM slots, so unless the OAM table is full, it won't overwrite tiles.
; The tiles will also have highest priority over every other sprite.
;=====================================

; Check if palette values make sense.
assert !letter_palette >= $08 && !letter_palette <= $0F, "Error: \!letter_palette should be between $08 and $0F."
assert !cursor_palette >= $08 && !cursor_palette <= $0F, "Error: \!cursor_palette should be between $08 and $0F."

; Convert palettes from row number to YXPPCCCT format.
!letter_props #= ($30|((!letter_palette-8)<<1))
!cursor_props #= ($30|((!cursor_palette-8)<<1))

erase_tiles:
    ; Erase the prompt's OAM tiles when in Reznor/Morton/Roy/Ludwig's rooms.
    ; This avoids the BG from glitching out when the prompt disappears.
    lda $0D9B|!addr : cmp #$C0 : bne .return
    lda !ram_disable_box : tay
    lda.w prompt_oam_start_index,y : asl #2 : tay
    lda #$F0
.loop:
    sta $0201|!addr,y
    dey #4 : bpl .loop
.return:
    rts

prompt_oam:
    ; Get as many free slots as possible at the start of $0200.
    ; Skip this in Reznor/Morton/Roy's rooms to avoid glitching their BGs.
    lda $0D9B|!addr : cmp #$C0 : beq +
    jsr defrag_oam
+
    ; Load starting index depending on the box being enabled/disabled.
    lda !ram_disable_box : sta $00 : tay
    lda.w .start_index,y : tax
    asl #2 : tay

    ; Draw the letters.
.oam_draw_loop:
    ; Store OAM values.
    lda !ram_prompt_x_pos : clc : adc.w .letters_x_pos,x : sta $0200|!addr,y
    lda !ram_prompt_y_pos : clc : adc.w .letters_y_pos,x : sta $0201|!addr,y
    lda.w .letters_tile,x : sta $0202|!addr,y
    lda.b #!letter_props : sta $0203|!addr,y
    
    ; Store OAM size. X is always Y/4 so we can use that directly.
    ; The size of the first two tiles (cursor/black) depends on the prompt box being enabled/disabled.
    lda.w .letters_size,x
    cpx #$02 : bcs +
    cmp $00 : bne +
    lda #$02
+   sta $0420|!addr,x

    ; Go to the next slot.
    dey #4

    ; Go to the next tile.
    dex : bpl .oam_draw_loop

    ; Now handle the exit option.
.handle_exit:
    ; If exit is enabled, skip.
    lda !ram_disable_exit : beq .handle_cursor

    ; If the box is disabled, put the "exit" tiles offscreen.
    lda !ram_disable_box : beq +
    lda #$F0
    sta $0209|!addr : sta $020D|!addr : sta $0211|!addr : sta $0215|!addr
    bra .handle_cursor
+
    ; Otherwise, turn them all into black tiles.
    lda.b #!tile_blk
    sta $020A|!addr : sta $020E|!addr : sta $0212|!addr : sta $0216|!addr

    ; Now handle the cursor.
.handle_cursor:
    ; Hide it on both lines if it's on a blinking frame.
    lda $1B91|!addr : eor #$1F : and #$18 : beq ..hide_both

..hide_one:
    ; Otherwise, only hide the one that's not on the selected option's line.
    lda $1B92|!addr : eor #$01 : asl #2 : tay

    ; If the box is disabled, just put the tile offscreen.
    lda !ram_disable_box : beq +
    lda #$F0 : sta $0201|!addr,y
+
    ; Otherwise, turn into a black tile.
    lda.b #!tile_blk : sta $0202|!addr,y
    bra ..end

..hide_both:
    ; If the box is disabled, put both tiles offscreen.
    lda !ram_disable_box : beq +
    lda #$F0
    sta $0201|!addr : sta $0205|!addr
+
    ; Otherwise, turn them into black tiles.
    lda.b #!tile_blk
    sta $0202|!addr : sta $0206|!addr

..end:
    rts

;=====================================
; These tables control what's drawn in the prompt box.
; In all cases, the letters are just 8x8 tiles (original retry uses 16x16 tiles to use less
; OAM tiles, I chose 8x8 so I use less space in SP1, it's easier to manage which tiles in the
; GFX are overwritten and it's easier to optimize the space used when not having the box).
;  - If it's a regular prompt, we need to draw 6 16x16 black tiles to hide the
;    "window cutoff" (one of these is the cursor).
;  - If the box was disabled, we don't need 4 of the black tiles, and the other 2
;    (used for the cursor) are 8x8 instead (since we don't need to cover cutoff).
;  - If the exit option is disabled, the "EXIT" tiles are drawn as black tiles instead, if the
;    box is on (to cover the cutoff). Otherwise, they're moved offscreen. Either way they use
;    4 slots to have an easier drawing routine in any case.
; In summary, if !no_promp_box = 1, 11 slots are used, otherwise 15.
;=====================================

; Index to start from in the below tables when the prompt box is enabled/disabled.
.start_index:
    db .letters_x_pos_end-.letters_x_pos-1
    db .letters_x_pos_box-.letters_x_pos-1

; X position offset of each letter on the screen.
.letters_x_pos:
    db $00 ; Black / Cursor
    db $00 ; Black / Cursor
    db $10 ; E
    db $18 ; X
    db $20 ; I
    db $28 ; T
    db $10 ; R
    db $18 ; E
    db $20 ; T
    db $28 ; R
    db $30 ; Y
..box:
    db $E0 ; Black
    db $F0 ; Black
    db $E0 ; Black
    db $F0 ; Black
..end:

; Y position offset of each letter on the screen.
.letters_y_pos:
    db $00 ; Black / Cursor
    db $10 ; Black / Cursor
    db $10 ; E
    db $10 ; X
    db $10 ; I
    db $10 ; T
    db $00 ; R
    db $00 ; E
    db $00 ; T
    db $00 ; R
    db $00 ; Y
..box:
    db $00 ; Black
    db $00 ; Black
    db $10 ; Black
    db $10 ; Black
..end:

; Tile number for each letter.
.letters_tile:
    db !tile_curs,!tile_curs
    db !tile_e,!tile_x,!tile_i,!tile_t
    db !tile_r,!tile_e,!tile_t,!tile_r,!tile_y
..box:
    db !tile_blk,!tile_blk,!tile_blk,!tile_blk
..end:

; Size (8x8 or 16x16) for each letter.
.letters_size:
    db $00,$00
    db $00,$00,$00,$00
    db $00,$00,$00,$00,$00
..box:
    db $02,$02,$02,$02
..end:

;=====================================
; defrag_oam routine
;
; This routine puts all used slots in OAM at the end of the table in contiguous spots.
; The result is that all free slots will be at the beginning of the table.
; This allows the letters to be drawn with max priority w.r.t. everything else, and to not overwrite other tiles.
;=====================================
defrag_oam:
    ; Since we scan both $0200 and $0300, we need 16 bit indexes.
    rep #$10
    ; Y: index in the original OAM table.
    ldy #$01FC
    ; X: index in the rearranged table.
    ldx #$01FC
.loop:
    ; If the slot is free, go to the next one.
    lda $0201|!addr,y : cmp #$F0 : beq ..next

    ; Otherwise, copy the Y slot in the X slot...
    rep #$20
    lda $0200|!addr,y : sta $0200|!addr,x
    lda $0202|!addr,y : sta $0202|!addr,x

    ; ...and mark the Y slot as free.
    lda #$F0F0 : sta $0200|!addr,y

    phx : phy

    ; Compute the indexes in $0420.
    tya : lsr #2 : tay
    txa : lsr #2 : tax

    ; Copy the entry in $0420 as well.
    sep #$20
    lda $0420|!addr,y : sta $0420|!addr,x

    ply : plx

    ; Go to the next slot in the rearranged table.
    dex #4

..next:
    ; Go to the next slot in the original table, and loop back if not the end.
    dey #4 : bpl .loop

.end:
    sep #$10
    rts
