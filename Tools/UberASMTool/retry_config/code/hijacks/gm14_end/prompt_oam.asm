; Check if palette values make sense.
assert !letter_palette >= $08 && !letter_palette <= $0F, "Error: \!letter_palette should be between $08 and $0F."
assert !cursor_palette >= $08 && !cursor_palette <= $0F, "Error: \!cursor_palette should be between $08 and $0F."

; Convert palettes from row number to YXPPCCCT format.
!l_props #= ($30|((!letter_palette-8)<<1))
!c_props #= ($30|((!cursor_palette-8)<<1))

;=====================================
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
;=====================================
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
endif
    ldx $1B92|!addr
    lda.w .hide_cursor_mask,x
++  sta $00

    ; Draw "RETRY"
    ldy #$00 : sty $01
    ldx.b #letters_retry-letters
    jsr oam_draw
    jsr handle_cursor

    ; Draw "EXIT" if exit is enabled
    lda !ram_disable_exit : bne .no_exit
    sty $01
    ldx.b #letters_exit-letters
    jsr oam_draw
    lsr $00
    jsr handle_cursor

.no_exit:
    ; Draw filler tiles if the box is enabled
    lda !ram_disable_box : bne .no_box
    ldx.b #letters_box-letters
    lda !ram_disable_exit : beq +
    ldx.b #letters_box_no_exit-letters
+   jsr oam_draw

.no_box:
    rts

.hide_cursor_mask:
    db $02,$01

if !cursor_setting == 2
.cursor_x_offset:
    db $FF,$00,$01,$02,$03,$02,$01,$00
endif

;=====================================
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
;=====================================
handle_cursor:
    ; Set the OAM size.
    lda $01 : lsr #2 : tax
    lda !ram_disable_box : beq +
    lda #$00
    bra ++
+   lda #$02
++  sta $0420|!addr,x
    
    ; Hide and offset the cursor.
    ldx $01
    lda $00 : and #$01 : bne .hide

if !cursor_setting == 2
    ; If the box is enabled...
    lda !ram_disable_box : bne +

    ; Draw an additional black tile under the cursor.
    rep #$20
    lda $0200|!addr,x : sta $0200|!addr,y
    lda.w #(!l_props<<8)|(!tile_blk) : sta $0202|!addr,y
    sep #$20

    ; Make the black tile 16x16 and increase the OAM index.
    phy
    tya : lsr #2 : tay
    lda #$02 : sta $0420|!addr,y
    ply
    iny #4
+   
    ; Apply the X offset to the cursor
    lda $0200|!addr,x : clc : adc $02 : sta $0200|!addr,x

    ; Make the cursor 8x8.
    txa : lsr #2 : tax
    stz $0420|!addr,x
endif
    rts

.hide:
    lda !ram_disable_box : beq +
    lda #$F0 : sta $0201|!addr,x
    rts
+   lda.b #!tile_blk : sta $0202|!addr,x
.return:
    rts

;=====================================
; erase_tiles routine
;
; This routine hides the Retry prompt tiles.
;=====================================
erase_tiles:
    ; Erase the prompt's OAM tiles when in Reznor/Morton/Roy/Ludwig's rooms.
    ; This avoids the BG from glitching out when the prompt disappears.
    lda $0D9B|!addr : cmp #$C0 : bne .return

    ; Find how many tiles we need to erase.
    lda.b #(letters_retry_end-letters_retry)/5 : sta $00
    
    lda !ram_disable_exit : bne +
    lda $00 : clc : adc.b #(letters_exit_end-letters_exit)/5 : sta $00
+   
    lda !ram_disable_box : bne +
    lda $00 : clc : adc.b #(letters_box_end-letters_box)/5
if !cursor_setting == 2
    inc
endif
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

;=====================================
; oam_draw routine
;
; This routine draws one part of the Retry prompt on the screen.
; Inputs:
;  X = index in the letters table
;  Y = OAM index
;=====================================
oam_draw:
    ; Return if we reached the $FF terminator.
    lda.w letters,x : cmp #$FF : beq .return

    ; Store the X,Y positions and tile OAM properties.
    clc : adc !ram_prompt_x_pos : sta $0200|!addr,y
    lda.w letters+1,x : clc : adc !ram_prompt_y_pos : sta $0201|!addr,y
    rep #$20
    lda.w letters+2,x : sta $0202|!addr,y
    sep #$20

    ; Store the OAM size.
    phy
    tya : lsr #2 : tay
    lda.w letters+4,x : sta $0420|!addr,y
    ply

    ; Go to the next tile.
    inx #5
    iny #4
    bra oam_draw
.return:
    rts

;=====================================
; OAM info for each tile (X,Y,T,P,S)
;=====================================
letters:
.retry:
    db $00,$00,!tile_curs,!c_props,$00 ; Black/Cursor
    db $10,$00,!tile_r,   !l_props,$00 ; R
    db $18,$00,!tile_e,   !l_props,$00 ; E
    db $20,$00,!tile_t,   !l_props,$00 ; T
    db $28,$00,!tile_r,   !l_props,$00 ; R
    db $30,$00,!tile_y,   !l_props,$00 ; Y
..end:
    db $FF

.exit:
    db $00,$10,!tile_curs,!c_props,$00 ; Black/Cursor
    db $10,$10,!tile_e,   !l_props,$00 ; E
    db $18,$10,!tile_x,   !l_props,$00 ; X
    db $20,$10,!tile_i,   !l_props,$00 ; I
    db $28,$10,!tile_t,   !l_props,$00 ; T
..end:
    db $FF

.box:
    db $E0,$10,!tile_blk, !l_props,$02 ; Black
    db $F0,$10,!tile_blk, !l_props,$02 ; Black
..no_exit:
    db $E0,$00,!tile_blk, !l_props,$02 ; Black
    db $F0,$00,!tile_blk, !l_props,$02 ; Black
..end:
    db $FF

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

    ; First we find the first free slot from the end of the table.
    ; This prevents the main loop from hiding tiles when the end of the OAM table is filled.
.setup_loop:
    lda $0201|!addr,y : cmp #$F0 : beq .main_loop
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
    dey #4 : bpl .main_loop

.end:
    sep #$10
    rts
