if !sprite_status_bar

; Calculates the VRAM address based on the sprite tile number.
; Also ensures the carry is clear.
macro calc_vram()
    and #$01FF : asl #4 : adc.w #!sprite_vram
endmacro

; Store the ROM address for the digit in A to the DMA source register.
macro store_digit_addr()
    xba : lsr #3 : adc.w #gfx_digits : sta.w upload_dma($4302)
endmacro

init:
    ; Skip if on the title screen.
    lda $0100|!addr : cmp #$0F : bcs +
    rts
+
    ; Initialize the coin, lives and bonus stars backup values to invalid.
    lda #$FF
    sta !ram_coin_backup
    sta !ram_lives_backup
    sta !ram_bonus_stars_backup

    ; Force to upload during level load
    lda #$01 : sta !ram_status_bar_force_upload

    ; Upload the status bar.
    ;jmp nmi

nmi:
    ; $02 = flag to force upload (for direct addressing)
    lda !retry_ram_status_bar_force_upload : sta $02

    ; $04 = flag to upload the "X" tile
    rep #$20
    stz $04

    ; Setup the constant DMA parameters.
    ldy #$80 : sty $2115
    lda #$1801 : sta.w upload_dma($4300)
    ldy.b #!gfx_bank : sty.w upload_dma($4304)
    ldy.b #1<<!upload_channel

    ; If forced upload, also upload the icons
    ; For now we're uploading every icon when the status bar visibility changes,
    ; which could be wasteful in most cases, but it's the simpler way and this
    ; case only happens in rare cases. If necessary, in the future it could be
    ; changed to use a force upload flag for every item separately (maybe a bit
    ; in their ram).
    ldx $02 : bne .icons
    jmp .counters

.icons:
    ; Check if we need to upload the item box tile.
    lda !ram_status_bar_item_box_tile : beq ..no_item_box
..item_box:
if !8x8_item_box_tile
    ; Upload the item box tile.
    %calc_vram() : sta $2116
    lda.w #gfx_item_box : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
else ; if not(!8x8_item_box_tile)
    ; Upload the first row.
    %calc_vram() : sta $00 : sta $2116
    lda.w #gfx_item_box : sta.w upload_dma($4302)
    lda.w #gfx_size(2) : sta.w upload_dma($4305)
    sty $420B

    ; Upload the second row.
    lda $00 : adc #$0100 : sta $2116
    lda.w #gfx_item_box+$40 : sta.w upload_dma($4302)
    lda.w #gfx_size(2) : sta.w upload_dma($4305)
    sty $420B
endif ; !8x8_item_box_tile
..no_item_box:

    ; Check if we need to upload the clock tile.
    lda !ram_status_bar_timer_tile : beq ..no_timer
..timer:
    ; Signal "X" tile upload
if !timer_X_enabled
    inc $04
endif ; !timer_X_enabled
    ; Upload the clock tile.
    %calc_vram() : sta $2116
    lda.w #gfx_timer : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_timer:

    ; Check if we need to upload the coin tiles.
    lda !ram_status_bar_coins_tile : beq ..no_coins
..coins:
    ; Signal "X" tile upload
if !coin_X_enabled
    inc $04
endif ; !coin_X_enabled
    ; Upload the coin tiles.
    %calc_vram() : sta $2116
    lda.w #gfx_coins : sta.w upload_dma($4302)
    lda.w #gfx_size(2) : sta.w upload_dma($4305)
    sty $420B
..no_coins:

    ; Check if we need to upload the lives tile.
    lda !ram_status_bar_lives_tile : beq ..no_lives
..lives:
    ; Signal "X" tile upload
if !lives_X_enabled
    inc $04
endif ; !lives_X_enabled
    ; Upload the lives tile based on the current player.
    %calc_vram() : sta $2116
    lda.w #gfx_lives
    ldx $0DB3|!addr : beq +
    lda.w #gfx_lives+gfx_size(1)
+   sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_lives:

    ; Check if we need to upload the bonus stars tile.
    lda !ram_status_bar_bonus_stars_tile : beq ..no_bonus_stars
..bonus_stars:
    ; Signal "X" tile upload
if !bonus_stars_X_enabled
    inc $04
endif ; !bonus_stars_X_enabled
    ; Upload the bonus stars tile.
    %calc_vram() : sta $2116
    lda.w #gfx_bonus_stars : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_bonus_stars:

    ; Check if we need to upload the death tile.
    lda !ram_status_bar_death_tile : beq ..no_death
..death:
    ; Signal "X" tile upload
if !death_X_enabled
    inc $04
endif ; !death_X_enabled
    ; Upload the death tile.
    %calc_vram() : sta $2116
    lda.w #gfx_death : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_death:
    
    ; Check if we need to upload the "X" tile.
    lda $04 : beq ..no_X
..X:
    ; Upload the "X" tile.
    rep #$20
    lda.w #vram_addr(!X_tile) : sta $2116
    lda.w #gfx_x : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_X:

if !draw_retry_indicator
    ; Check if we need to upload the indicator tile.
    sep #$20
    lda $0100|!addr : cmp #$0B : bcc ..no_indicator
    jsr shared_get_prompt_type
    cmp.b #!retry_type_vanilla : bcs ..no_indicator
..indicator:
    ; Upload the indicator tile.
    rep #$20
    lda.w #vram_addr(!retry_indicator_tile) : sta $2116
    lda.w #gfx_indicator : sta.w upload_dma($4302)
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_indicator:
endif ; !draw_retry_indicator

.counters:
    ; Check if we need to upload the timer digits.
    lda !ram_status_bar_timer_tile : bne ..timer
    jmp ..no_timer

..timer:
    ; Compute the VRAM address for later.
    %calc_vram() : sta $00

    ; Only upload if forced, or if the timer changed, unless Mario died
    ; (ensuring the timer updates when dying for a timeout).
    ldx $02 : bne +
    ldx $71 : cpx #$09 : beq +
    sep #$20
    lda $0F30|!addr : cmp.l !rom_timer_ticks
    rep #$20
    beq +
    jmp ..no_timer
+
    ; Upload the first digit, unless it's 0.
    lda $0F31|!addr : and #$00FF
if not(!draw_leading_zeroes)
    beq +
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0010 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B

if not(!draw_leading_zeroes)
    ; In this case we need to upload the second digit even if 0.
    lda $0F32|!addr : and #$00FF : bra ++
+   
endif ; not(!draw_leading_zeroes)

    ; Upload the second digit, unless it's 0.
    lda $0F32|!addr : and #$00FF
if not(!draw_leading_zeroes)
    beq +
endif ; not(!draw_leading_zeroes)
++  %store_digit_addr()
    lda $00 : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
+
    ; Upload the third digit.
    lda $0F33|!addr : and #$00FF
    %store_digit_addr()
    lda $00 : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_timer:

    ; Check if we need to upload the coin counter digits.
    lda !ram_status_bar_coins_tile : beq ..no_coins
..coins:
    ; Compute the VRAM address for later.
    %calc_vram() : sta $00

    ; Only upload if forced or if the coin counter changed.
    sep #$20
    lda $0DBF|!addr : cmp !ram_coin_backup : bne +
    ldx $02 : bne +
    rep #$20
    bra ..no_coins
+   
    ; Update the coin counter backup.
    sta !ram_coin_backup

    ; Compute the coin counter digits.
    sta $4204 : stz $4205
    lda #10 : sta $4206

    jsr .rep20_and_waste_time_for_division

    ; Upload the first digit (unless it's 0).
    lda $4214
if not(!draw_leading_zeroes)
    beq +
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
+   
    ; Upload the second digit.
    lda $4216 : %store_digit_addr()
    lda $00 : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_coins:

    ; Check if we need to upload the lives counter digits.
    lda !ram_status_bar_lives_tile : beq ..no_lives
..lives:
    ; Compute the VRAM address for later.
    %calc_vram() : sta $00

    ; Only upload if forced or if the lives counter changed.
    sep #$20
    lda $0DBE|!addr : cmp !ram_lives_backup : bne +
    ldx $02 : bne +
    rep #$20
    bra ..no_lives
+   
    ; Update the lives counter backup.
    sta !ram_lives_backup

    ; Compute the lives counter digits.
    inc : sta $4204 : stz $4205
    lda #10 : sta $4206

    jsr .rep20_and_waste_time_for_division

    ; Upload the first digit (unless it's 0).
    lda $4214
if not(!draw_leading_zeroes)
    beq +
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
+   
    ; Upload the second digit.
    lda $4216 : %store_digit_addr()
    lda $00 : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_lives:

    ; Check if we need to upload the bonus stars digits.
    lda !ram_status_bar_bonus_stars_tile : beq ..no_bonus_stars
..bonus_stars:
    ; Compute the VRAM address for later.
    %calc_vram() : sta $00

    ; Only upload if forced or if the bonus stars changed.
    sep #$20
    ldx $0DB3|!addr
    lda $0F48|!addr,x : cmp !ram_bonus_stars_backup : bne +
    ldx $02 : bne +
    rep #$20
    bra ..no_bonus_stars
+   
    ; Update the bonus stars backup.
    sta !ram_bonus_stars_backup

    ; Compute the bonus stars digits.
    sta $4204 : stz $4205
    lda #10 : sta $4206

    jsr .rep20_and_waste_time_for_division

    ; Upload the first digit (unless it's 0).
    lda $4214
if not(!draw_leading_zeroes)
    beq +
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
+   
    ; Upload the second digit.
    lda $4216 : %store_digit_addr()
    lda $00 : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_bonus_stars:

    ; Check if we need to upload the death counter digits.
    lda !ram_status_bar_death_tile : bne ..death
    jmp ..no_death

..death:
    ; Compute the VRAM address for later.
    %calc_vram() : sta $00

    ; Only upload if forced or if Mario is dead or if loading the level.
    ; We upload every frame even if wasteful, because I'd rather not add another
    ; flag (!ram_is_dying does not work because it is already changed by the
    ; time we get here). On death most things are stopped so it should be fine.
    ldx $02 : bne +
    ldx $0100|!addr : cpx #$14 : bcc +
    ldx $71 : cpx #$09 : beq +
    jmp ..no_death
+

if not(!draw_leading_zeroes)
    ; X = indicator that something was uploaded previously
    ldx #$00
endif ; not(!draw_leading_zeroes)

    ; Upload the first digit (unless it's 0).
    lda !ram_death_counter+0 : and #$00FF
if not(!draw_leading_zeroes)
    beq +
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0010 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
if not(!draw_leading_zeroes)
    inx
+
endif ; not(!draw_leading_zeroes)

    ; Upload the second digit (unless it's 0 and didn't upload the first).
    lda !ram_death_counter+1 : and #$00FF
if not(!draw_leading_zeroes)
    bne +
    cpx #$00 : beq ++
+   
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0020 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
if not(!draw_leading_zeroes)
    inx
++
endif ; not(!draw_leading_zeroes)

    ; Upload the third digit (unless it's 0 and didn't upload the first 2).
    lda !ram_death_counter+2 : and #$00FF
if not(!draw_leading_zeroes)
    bne +
    cpx #$00 : beq ++
+
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
if not(!draw_leading_zeroes)
    inx
++
endif ; not(!draw_leading_zeroes)

    ; Upload the fourth digit (unless it's 0 and didn't upload the first 3).
    lda !ram_death_counter+3 : and #$00FF
if not(!draw_leading_zeroes)
    bne +
    cpx #$00 : beq ++
+
endif ; not(!draw_leading_zeroes)
    %store_digit_addr()
    lda $00 : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
++
    ; Upload the fifth digit.
    lda !ram_death_counter+4 : and #$00FF
    %store_digit_addr()
    lda $00 : adc #$0120 : sta $2116
    lda.w #gfx_size(1) : sta.w upload_dma($4305)
    sty $420B
..no_death:

    sep #$20
    ; Force upload only lasts for 1 frame
    lda #$00 : sta !retry_ram_status_bar_force_upload
    rts

; Routine to set A to 16 bits and waste time for division.
; JSR to this routine will result in 17 cycles, so the division result will be
; ready.
.rep20_and_waste_time_for_division:
    rep #$20
    nop
    rts

main:
    ; Don't draw if the game is paused.
    lda $13D4|!addr : beq .not_paused
    rts

.not_paused:
    ; Don't draw if on not in a level.
    lda $0100|!addr : cmp #$0B : bcc +
    cmp #$15 : bcc .run
+   rts

.run:
    phb : phk : plb

    ; Get start OAM index to search at
    ; Normally it's 0, but it's higher if in a mode 7 boss room and prompt is deployed
    ; The value is calculated kinda arbitrarily but I can't be arsed to make it
    ; better for these shit bosses
    lda $0D9B|!addr : cmp #$C0 : bne +
    jsr shared_is_prompt_deployed : bcc +
    rep #$30
    ldx.w #(!prompt_line1_length+!prompt_line2_length+20)*4
    bra ++
+   rep #$30
    ldx #$0000
++
    stz $02

    ; Draw the item box if applicable.
    lda !ram_status_bar_item_box_tile : beq .no_item_box
.item_box:
    php
    jsr convert_tile_props
    jsr draw_item_box
    plp
    inc $02
.no_item_box:

    ; Draw the timer if applicable.
    lda !ram_status_bar_timer_tile : beq .no_timer
.timer:
    php
    jsr convert_tile_props
    jsr draw_timer
    plp
    inc $02
.no_timer:

    ; Draw the coins if applicable.
    lda !ram_status_bar_coins_tile : beq .no_coins
.coins:
    php
    jsr convert_tile_props
    lda !ram_status_bar_coins_tile+1 : and #$02 : bne +
    jsr draw_coins
+   lda !ram_status_bar_coins_tile+1 : and #$04 : bne +
    jsr draw_yoshi_coins
+   plp
    inc $02
.no_coins:

    ; Draw the lives if applicable.
    lda !ram_status_bar_lives_tile : beq .no_lives
.lives:
    php
    jsr convert_tile_props
    jsr draw_lives
    plp
    inc $02
.no_lives:

    ; Draw the bonus stars if applicable.
    lda !ram_status_bar_bonus_stars_tile : beq .no_bonus_stars
.bonus_stars:
    php
    jsr convert_tile_props
    jsr draw_bonus_stars
    plp
    inc $02
.no_bonus_stars:

    ; Draw the death counter if applicable.
    lda !ram_status_bar_death_tile : beq .no_death
.death:
    php
    jsr convert_tile_props
    jsr draw_death
    plp
    inc $02
.no_death:

if !draw_retry_indicator
    ; Draw the indicator if applicable
    sep #$20
    lda $0100|!addr : cmp #$0B : bcc .no_indicator
    jsr shared_get_prompt_type
    cmp.b #!retry_type_vanilla : bcs .no_indicator
.indicator:
    jsr draw_indicator
    inc $02
.no_indicator:
endif ; !draw_retry_indicator
    
    sep #$30
    plb

    ; Check if a tile was drawn
    lda $02 : beq .return

    ; If yes, always update $0400 during gamemode 14
    lda $0100|!addr : cmp #$14 : beq .0400_update

    ; Skip updating the $0400 table during mode 7 boss
    ; initialization to avoid a game crash (???)
    lda $0D9B|!addr : bmi .return

.0400_update:
    ; Make sure $0400 is up to date
    jsr shared_update_0400

.return:
    rts

; Converts an entry from the table into a tile number, YXPPCCCT properties
; pair and stores it into $00. Also sets A to 8-bit.
convert_tile_props:
    sta $00
    sep #$20
    ; Save T bit...
    lda $01 : lsr : php
    ; ...align CCC bits...
    lsr #2
    ; ...set T bit...
    plp : adc #$00
    ; ...set PP bits...
    ora #$30
    ; ...finally store the result.
    sta $01
    rts

; Routine that scans the OAM table until a free slot is found.
get_free_slot:
    lda #$F0
.loop:
    ; Loop until an empty slot is found
    cmp $0201|!addr,x : beq .found
    inx #4
    cpx #$0200 : bcc .loop
.not_found:
    ; Destroy the JSR: exit from drawing routine.
    plx
.found:
    rts

draw_item_box:
if not(!always_draw_box)
    lda $0DC2|!addr : beq .return
endif ; not(!always_draw_box)
    ldy.w #.props-.pos-2
.loop:
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : ora.w .props,y : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
if !8x8_item_box_tile
    stz $0420|!addr,x
else ; if not(!8x8_item_box_tile)
    lda #$02 : sta $0420|!addr,x
endif ; !8x8_item_box_tile
    plx
    inx #4
    dey #2 : bpl .loop
.return:
    rts

.pos:
if !8x8_item_box_tile
    db $00+!item_box_x_pos,$08+!item_box_y_pos-1
    db $18+!item_box_x_pos,$08+!item_box_y_pos-1
    db $00+!item_box_x_pos,$10+!item_box_y_pos-1
    db $18+!item_box_x_pos,$10+!item_box_y_pos-1
else ; if not(!8x8_item_box_tile)
    db $00+!item_box_x_pos,$00+!item_box_y_pos-1
    db $10+!item_box_x_pos,$00+!item_box_y_pos-1
    db $00+!item_box_x_pos,$10+!item_box_y_pos-1
    db $10+!item_box_x_pos,$10+!item_box_y_pos-1
endif ; !8x8_item_box_tile

.props:
    dw $0000,$4000,$8000,$C000

assert !X_palette >= $08 && !X_palette <= $0F, "Error: \!X_palette should be between $08 and $0F."

!X_tp #= (!X_tile&$1FF)|$3000|((!X_palette-8)<<9)

!timer_X_index       #= 2*0
!coin_X_index        #= 2*1
!lives_X_index       #= 2*2
!bonus_stars_X_index #= 2*3
!death_X_index       #= 2*4

; Shared routine to draw an element's "X" tile
; Should be called with Y = index specific for each element, defined above
draw_X:
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda.w #!X_tp : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    rts

.pos:
    db !timer_X_x_pos,!timer_X_y_pos-1
    db !coin_X_x_pos,!coin_X_y_pos-1
    db !lives_X_x_pos,!lives_X_y_pos-1
    db !bonus_stars_X_x_pos,!bonus_stars_X_y_pos-1
    db !death_X_x_pos,!death_X_y_pos-1

; Tiles offset from the timer tile in VRAM
!timer_icon_offset   = $00
!timer_digit1_offset = $01
!timer_digit2_offset = $10
!timer_digit3_offset = $11

draw_timer:
    ; Draw the "X" tile if applicable
if !timer_X_enabled
    ldy.w #!timer_X_index
    jsr draw_X
endif ; !timer_X_enabled

    ; Draw the clock tile.
    ldy #$0000
    sty $0E ;lda.b #!timer_icon_offset : sta $0E
    jsr .draw
    
if not(!draw_leading_zeroes)
    ; Draw the first digit, unless it's 0.
    lda $0F31|!addr : bne +
    lda #$80 : ora !ram_timer+0 : sta !ram_timer+0
if !timer_counter_align_right
    iny #2
endif ; !timer_counter_align_right
    bra ++
+   lda !ram_is_respawning : beq +
    lda !ram_timer+0 : bpl +
if !timer_counter_align_right
    iny #2
endif ; !timer_counter_align_right
    bra ++
+   
endif ; not(!draw_leading_zeroes)

    lda.b #!timer_digit1_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
    ; In this case we always need to draw the second digit.
    bra +
++
    ; Draw the second digit, unless it's 0.
    lda $0F32|!addr : bne +
    lda #$80 : ora !ram_timer+1 : sta !ram_timer+1
if !timer_counter_align_right
    iny #2
endif ; !timer_counter_align_right
    bra ++
+   lda !ram_is_respawning : beq +
    lda !ram_timer+1 : bpl +
if !timer_counter_align_right
    iny #2
endif ; !timer_counter_align_right
    bra ++
+   
endif ; not(!draw_leading_zeroes)

    lda.b #!timer_digit2_offset : sta $0E
    jsr .draw
++
    ; Draw the third digit.
    lda.b #!timer_digit3_offset : sta $0E
    ;jsr .draw
    ;rts

.draw:
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : clc : adc $0E : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    iny #2
    rts

.pos:
    db $00+!timer_icon_x_pos-1,!timer_icon_y_pos-1
    db $00+!timer_counter_x_pos,!timer_counter_y_pos-1
    db $08+!timer_counter_x_pos,!timer_counter_y_pos-1
    db $10+!timer_counter_x_pos,!timer_counter_y_pos-1

; Tiles offset from the coin tile in VRAM
!coin_icon_offset   = $00
!coin_digit1_offset = $10
!coin_digit2_offset = $11

draw_coins:
    ; Draw the "X" tile if applicable
if !coin_X_enabled
    ldy.w #!coin_X_index
    jsr draw_X
endif ; !coin_X_enabled

    ; Draw the coin tile.
    ldy #$0000
    sty $0E ;lda.b #!coin_icon_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
    ; Draw the first digit, unless it's 0.
    lda $0DBF|!addr : cmp #10 : bcs +
if !coin_counter_align_right
    iny #2
endif ; !coin_counter_align_right
    bra ++
+
endif ; not(!draw_leading_zeroes)

    lda.b #!coin_digit1_offset : sta $0E
    jsr .draw
++
    ; Draw the second digit.
    lda.b #!coin_digit2_offset : sta $0E
    ;jsr .draw
    ;rts

.draw:
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : clc : adc $0E : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    iny #2
    rts

.pos:
    db $00+!coin_icon_x_pos-1,!coin_icon_y_pos-1
    db $00+!coin_counter_x_pos,!coin_counter_y_pos-1
    db $08+!coin_counter_x_pos,!coin_counter_y_pos-1

draw_yoshi_coins:
    phx
    sep #$10

    ; Check if we need to draw the Yoshi Coins
    lda $13BF|!addr : and #$07 : tay
    lda.w .mask,y : sta $02
    lda $13BF|!addr : lsr #3 : tay
    lda $1F2F|!addr,y : and $02 : beq .not_all

if !draw_all_dc_collected
    ; If all DCs collected, calculate how many they were.
    jsr get_total_dc_amount
    bne .shared
endif ; !draw_all_dc_collected

.no_draw:
    rep #$10
    plx
    rts

.not_all:
    ; If not all DCs collected, get their amount from $1422.
    lda $1422|!addr : beq .no_draw

.shared:
    rep #$10
    plx

    ; $0F = amount of tiles to draw
    dec : sta $0F

    ; $0D = starting XY position
    lda.b #!dc_counter_x_pos : sta $0D
    lda.b #!dc_counter_y_pos : sta $0E

    ; Yoshi Coin tile is one tile to the right.
    inc $00

.loop:
    jsr get_free_slot
    rep #$20
    lda $0D : sta $0200|!addr,x
    clc : adc.w #$0008 : sta $0D
    lda $00 : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    dec $0F : bpl .loop
    rts

.mask:
    db $80,$40,$20,$10,$08,$04,$02,$01

; Tiles offset from the lives tile in VRAM
!lives_icon_offset   = $00
!lives_digit1_offset = $10
!lives_digit2_offset = $11

draw_lives:
    ; Draw the "X" tile if applicable
if !lives_X_enabled
    ldy.w #!lives_X_index
    jsr draw_X
endif ; !lives_X_enabled

    ; Draw the lives tile.
    ldy #$0000
    sty $0E ;lda.b #!lives_icon_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
    ; Draw the first digit, unless it's 0.
    lda $0DBE|!addr : inc : cmp #10 : bcs +
if !lives_counter_align_right
    iny #2
endif ; !lives_counter_align_right
    bra ++
+   
endif ; not(!draw_leading_zeroes)

    lda.b #!lives_digit1_offset : sta $0E
    jsr .draw
++
    ; Draw the second digit.
    lda.b #!lives_digit2_offset : sta $0E
    ;jsr .draw
    ;rts

.draw:
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : clc : adc $0E : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    iny #2
    rts

.pos:
    db $00+!lives_icon_x_pos-1,!lives_icon_y_pos-1
    db $00+!lives_counter_x_pos,!lives_counter_y_pos-1
    db $08+!lives_counter_x_pos,!lives_counter_y_pos-1

; Tiles offset from the bonus stars tile in VRAM
!bonus_stars_icon_offset   = $00
!bonus_stars_digit1_offset = $10
!bonus_stars_digit2_offset = $11

draw_bonus_stars:
    ; Draw the "X" tile if applicable
if !bonus_stars_X_enabled
    ldy.w #!bonus_stars_X_index
    jsr draw_X
endif ; !bonus_stars_X_enabled

    ; Draw the bonus stars tile.
    ldy #$0000
    sty $0E ;lda.b #!bonus_stars_icon_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
    ; Draw the first digit, unless it's 0.
    phx : php
    sep #$30
    ldx $0DB3|!addr
    lda $0F48|!addr,x : cmp #10 : bcs +
    plp : plx
if !bonus_stars_counter_align_right
    iny #2
endif ; !bonus_stars_counter_align_right
    bra ++
+   plp : plx
endif ; not(!draw_leading_zeroes)

    lda.b #!bonus_stars_digit1_offset : sta $0E
    jsr .draw
++
    ; Draw the second digit.
    lda.b #!bonus_stars_digit2_offset : sta $0E
    ;jsr .draw
    ;rts

.draw:
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : clc : adc $0E : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    iny #2
    rts

.pos:
    db $00+!bonus_stars_icon_x_pos-1,!bonus_stars_icon_y_pos-1
    db $00+!bonus_stars_counter_x_pos,!bonus_stars_counter_y_pos-1
    db $08+!bonus_stars_counter_x_pos,!bonus_stars_counter_y_pos-1

; Tiles offset from the death tile in VRAM
!death_icon_offset   = $00
!death_digit1_offset = $01
!death_digit2_offset = $02
!death_digit3_offset = $10
!death_digit4_offset = $11
!death_digit5_offset = $12

draw_death:
    ; Draw the "X" tile if applicable
if !death_X_enabled
    ldy.w #!death_X_index
    jsr draw_X
endif ; !death_X_enabled

    ; Draw the death tile.
    ldy #$0000
    sty $0E ;lda.b #!death_icon_offset : sta $0E
    jsr .draw

    ; $04 = indicator that something was uploaded previously
    stz $04

if not(!draw_leading_zeroes)
    ; Draw the first digit, unless it's 0.
    lda !ram_death_counter+0 : bne +
if !death_counter_align_right
    iny #2
endif ; !death_counter_align_right
    bra ++
+   
endif ; not(!draw_leading_zeroes)

    lda.b #!death_digit1_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
++
    ; Draw the second digit, unless it's 0 and didn't draw the first.
    lda !ram_death_counter+1 : ora $04 : bne +
if !death_counter_align_right
    iny #2
endif ; !death_counter_align_right
    bra ++
+
endif ; not(!draw_leading_zeroes)

    lda.b #!death_digit2_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
++
    ; Draw the third digit, unless it's 0 and didn't draw the first 2.
    lda !ram_death_counter+2 : ora $04 : bne +
if !death_counter_align_right
    iny #2
endif ; !death_counter_align_right
    bra ++
+   
endif ; not(!draw_leading_zeroes)

    lda.b #!death_digit3_offset : sta $0E
    jsr .draw

if not(!draw_leading_zeroes)
++
    ; Draw the fourth digit, unless it's 0 and didn't draw the first 3.
    lda !ram_death_counter+3 : ora $04 : bne +
if !death_counter_align_right
    iny #2
endif ; !death_counter_align_right
    bra ++
+
endif ; not(!draw_leading_zeroes)

    lda.b #!death_digit4_offset : sta $0E
    jsr .draw
++
    ; Draw the fifth digit.
    lda.b #!death_digit5_offset : sta $0E
    ;jsr .draw
    ;rts

.draw:
    inc $04
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : clc : adc $0E : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    iny #2
    rts

.pos:
    db $00+!death_icon_x_pos-1,!death_icon_y_pos-1
    db $00+!death_counter_x_pos,!death_counter_y_pos-1
    db $08+!death_counter_x_pos,!death_counter_y_pos-1
    db $10+!death_counter_x_pos,!death_counter_y_pos-1
    db $18+!death_counter_x_pos,!death_counter_y_pos-1
    db $20+!death_counter_x_pos,!death_counter_y_pos-1

if !draw_retry_indicator

assert !retry_indicator_palette >= $08 && !retry_indicator_palette <= $0F, "Error: \!retry_indicator_palette should be between $08 and $0F."

!retry_indicator_xy #= (!retry_indicator_x_pos)|((!retry_indicator_y_pos-1)<<8)
!retry_indicator_tp #= (!retry_indicator_tile&$1FF)|$3000|((!retry_indicator_palette-8)<<9)

draw_indicator:
    jsr get_free_slot
    rep #$20
    lda.w #!retry_indicator_xy : sta $0200|!addr,x
    lda.w #!retry_indicator_tp : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
    rts

endif ; !draw_retry_indicator

if !draw_all_dc_collected
get_total_dc_amount:
    ; If CMP #$XX, return $XX
    lda.l !rom_dc_amount_cmp_byte : cmp #$C9 : bne .hijack
    lda.l !rom_dc_amount_cmp_byte+1
    rts

.hijack:
    ; If detecting the "Per Level Yoshi Coins" patch,
    ; use it to load the DC amount for this level.
    lda.l !rom_dc_perlevel_patch_byte : cmp #$22 : bne .default

    ; We get the DC per-level amount table address from the patch address + 8
    ; (assuming people don't edit the patch...)
    lda.l !rom_dc_perlevel_patch_byte+3 : sta $0F
    rep #$20
    lda.l !rom_dc_perlevel_patch_byte+1 : clc : adc.w #$0008 : sta $0D
    lda [$0D] : sta $0D
    sep #$20
    ldy $13BF|!addr
    lda [$0D],y
    rts

.default:
    ; If detection failed, load the default amount.
    lda.b #!default_dc_amount
    rts
endif ; !draw_all_dc_collected

endif ; !sprite_status_bar
