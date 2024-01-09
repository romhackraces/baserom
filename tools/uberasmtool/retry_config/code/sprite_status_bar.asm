if !sprite_status_bar

; Calculates the VRAM address based on the sprite tile number.
; Also ensures the carry is clear.
macro calc_vram()
    and #$01FF : asl #4 : adc.w #!sprite_vram
endmacro

; Store the ROM address for the digit in A to the DMA source register.
macro store_digit_addr()
    xba : lsr #3 : adc.w #retry_gfx_digits : sta.w prompt_dma($4302)
endmacro

nmi:
    ; Get the index for the current sublevel.
    rep #$30
    lda $010B|!addr : asl : tax

    ; Check if we need to upload the timer digits.
    lda.l tables_timer,x : bne +
    jmp .no_timer
+
    ; Compute the VRAM address for later.
    phx
    %calc_vram() : pha

    ; Only upload if the timer changed, unless Mario died
    ; (ensuring the timer updates when dying for a timeout).
    sep #$20
    lda $71 : cmp #$09 : beq +
    lda $0F30|!addr : cmp.l !rom_timer_ticks : beq +
    rep #$20
    pla
    plx
    jmp .no_timer
+   
    ; Setup the constant DMA parameters.
    sep #$10
    rep #$20
    ldy #$80 : sty $2115
    lda #$1801 : sta.w prompt_dma($4300)
    ldy.b #retry_gfx>>16 : sty.w prompt_dma($4304)
    ldy #$04

    ; Upload the first digit, unless it's 0.
    lda $0F31|!addr : and #$00FF : beq +
    %store_digit_addr()
    lda $01,s : adc #$0010 : sta $2116
    lda.w #gfx_size(1) : sta.w prompt_dma($4305)
    sty $420B

    ; In this case we need to upload the second digit even if 0.
    lda $0F32|!addr : and #$00FF : bra ++
+   
    ; Upload the second digit, unless it's 0.
    lda $0F32|!addr : and #$00FF : beq +
++  %store_digit_addr()
    lda $01,s : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w prompt_dma($4305)
    sty $420B
+
    ; Upload the third digit.
    lda $0F33|!addr : and #$00FF
    %store_digit_addr()
    pla : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w prompt_dma($4305)
    sty $420B

    ; Restore X and processor state.
    rep #$10 : plx

.no_timer:
    ; Check if we need to upload the coin counter digits.
    lda.l tables_coins,x : beq .no_coins

    ; Compute the VRAM address for later.
    %calc_vram() : pha

    ; Only upload if the coin counter changed.
    sep #$20
    lda $0DBF|!addr : cmp !ram_coin_backup : bne +
    rep #$20 : pla
    bra .no_coins
+   
    ; Update the coin counter backup.
    sta !ram_coin_backup

    ; Compute the coin counter digits.
    sta $4204 : stz $4205
    lda #10 : sta $4206

    ; Setup the constant DMA parameters (also waste time for division).
    rep #$20
    sep #$10
    ldy #$80 : sty $2115
    lda #$1801 : sta.w prompt_dma($4300)
    ldy.b #retry_gfx>>16 : sty.w prompt_dma($4304)
    ldy #$04

    ; Upload the first digit (unless it's 0).
    lda $4214 : beq +
    %store_digit_addr()
    lda $01,s : adc #$0100 : sta $2116
    lda.w #gfx_size(1) : sta.w prompt_dma($4305)
    sty $420B
+   
    ; Upload the second digit.
    lda $4216 : %store_digit_addr()
    pla : adc #$0110 : sta $2116
    lda.w #gfx_size(1) : sta.w prompt_dma($4305)
    sty $420B

.no_coins:
    sep #$30
    rts

init:
    ; Initialize the coin backup value to invalid.
    lda #$FF : sta !ram_coin_backup

    ; Upload the static tiles.
    jsr .nmi

    ; Upload the digits.
    jmp nmi

.nmi:
    ; Setup the constant DMA parameters.
    rep #$20
    ldy #$80 : sty $2115
    lda #$1801 : sta.w prompt_dma($4300)
    ldy.b #retry_gfx>>16 : sty.w prompt_dma($4304)
    ldy #$04

    ; Get the index for the current sublevel.
    rep #$10
    lda $010B|!addr : asl : tax

    ; Check if we need to upload the item box tile.
    lda.l tables_item_box,x : beq ..no_item_box

    ; Upload the first row.
    phx : sep #$10
    %calc_vram() : sta $2116 : pha
    lda.w #retry_gfx_item_box : sta.w prompt_dma($4302)
    lda.w #gfx_size(2) : sta.w prompt_dma($4305)
    sty $420B

    ; Upload the second row.
    pla : adc #$0100 : sta $2116
    lda.w #retry_gfx_item_box+$40 : sta.w prompt_dma($4302)
    lda.w #gfx_size(2) : sta.w prompt_dma($4305)
    sty $420B

    ; Restore X and processor state.
    rep #$10 : plx
..no_item_box:

    ; Check if we need to upload the clock tile.
    lda.l tables_timer,x : beq ..no_timer

    ; Upload the clock tile.
    phx : sep #$10
    %calc_vram() : sta $2116
    lda.w #retry_gfx_timer : sta.w prompt_dma($4302)
    lda.w #gfx_size(1) : sta.w prompt_dma($4305)
    sty $420B

    ; Restore X and processor state.
    rep #$10 : plx
..no_timer:

    ; Check if we need to upload the coin tile.
    lda.l tables_coins,x : beq ..no_coins

    ; Upload the coin tiles.
    sep #$10
    %calc_vram() : sta $2116
    lda.w #retry_gfx_coin : sta.w prompt_dma($4302)
    lda.w #gfx_size(2) : sta.w prompt_dma($4305)
    sty $420B

..no_coins:
    sep #$30
    rts

main:
    ; Don't draw if the game is paused.
    lda $13D4|!addr : bne .return

    ; Get the index for the current sublevel.
    rep #$30
    lda $010B|!addr : asl : tay

    phb : phk : plb
if not(!maxtile)
    ldx #$0000
endif

    ; Draw the item box if applicable.
    lda.w tables_item_box,y : beq .no_item_box
    phy : php
    jsr convert_tile_props
    jsr draw_item_box
    plp : ply

.no_item_box:
    
    ; Draw the timer if applicable.
    lda.w tables_timer,y : beq .no_timer
    phy : php
    jsr convert_tile_props
    jsr draw_timer
    plp : ply

.no_timer:

    ; Draw the coins if applicable.
    lda.w tables_coins,y : beq .no_coins
    phy : php
    jsr convert_tile_props
    jsr draw_coins
    jsr draw_yoshi_coins
    plp : ply

.no_coins:
    sep #$30
    plb

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

if not(!maxtile)

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

endif

draw_item_box:
if not(!always_draw_box)
    lda $0DC2|!addr : beq .return
endif
    ldy.w #.props-.pos-2
.loop:
if !maxtile
    ldx !maxtile_buffer_max+0 : cpx !maxtile_buffer_max+8 : beq .return
    rep #$20
    lda.w .pos,y : sta $400000,x
    lda $00 : ora.w .props,y : sta $400002,x
    sep #$20
    dex #4 : stx !maxtile_buffer_max+0
    ldx !maxtile_buffer_max+2
    lda #$02 : sta $400000,x
    dex : stx !maxtile_buffer_max+2
else
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : ora.w .props,y : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    lda #$02 : sta $0420|!addr,x
    plx
    inx #4
endif
    dey #2 : bpl .loop
.return:
    rts

.pos:
    db $00+!item_box_x_pos,$00+!item_box_y_pos
    db $10+!item_box_x_pos,$00+!item_box_y_pos
    db $00+!item_box_x_pos,$10+!item_box_y_pos
    db $10+!item_box_x_pos,$10+!item_box_y_pos

.props:
    dw $0000,$4000,$8000,$C000

draw_timer:
    ; Draw the clock tile.
    ldy #$0000
    jsr .draw
    
    ; Draw the first digit, unless it's 0.
    lda $0F31|!addr : bne +
    lda #$80 : ora !ram_timer+0 : sta !ram_timer+0
    iny #2
    bra ++
+   lda !ram_is_respawning : beq +
    lda !ram_timer+0 : bpl +
    iny #2
    bra ++
+   jsr .draw
    ; In this case we always need to draw the second digit.
    bra +
++
    ; Draw the second digit, unless it's 0.
    lda $0F32|!addr : bne +
    lda #$80 : ora !ram_timer+1 : sta !ram_timer+1
    iny #2
    bra ++
+   lda !ram_is_respawning : beq +
    lda !ram_timer+1 : bpl +
    iny #2
    bra ++
+   jsr .draw
++
    ; Draw the third digit.
    ;jsr .draw
    ;rts

.draw:
if !maxtile
    ldx !maxtile_buffer_max+0 : cpx !maxtile_buffer_max+8 : beq .return
    rep #$20
    lda.w .pos,y : sta $400000,x
    lda $00 : ora.w .tile,y : sta $400002,x
    sep #$20
    dex #4 : stx !maxtile_buffer_max+0
    ldx !maxtile_buffer_max+2
    lda #$00 : sta $400000,x
    dex : stx !maxtile_buffer_max+2
else
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : ora.w .tile,y : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
endif
    iny #2
.return:
    rts

.pos:
    db $00+!timer_x_pos-1,!timer_y_pos+1
    db $08+!timer_x_pos,!timer_y_pos
    db $10+!timer_x_pos,!timer_y_pos
    db $18+!timer_x_pos,!timer_y_pos

.tile:
    dw $0000,$0001,$0010,$0011

draw_coins:
    ; Draw the coin tile.
    ldy #$0000
    jsr .draw

    ; Draw the first digit, unless it's 0.
    lda $0DBF|!addr : cmp #10 : bcs +
    iny #2
    bra ++
+   jsr .draw
++
    ; Draw the second digit.
    ;jsr .draw
    ;rts

.draw:
if !maxtile
    ldx !maxtile_buffer_max+0 : cpx !maxtile_buffer_max+8 : beq .return
    rep #$20
    lda.w .pos,y : sta $400000,x
    lda $00 : ora.w .tile,y : sta $400002,x
    sep #$20
    dex #4 : stx !maxtile_buffer_max+0
    ldx !maxtile_buffer_max+2
    lda #$00 : sta $400000,x
    dex : stx !maxtile_buffer_max+2
else
    jsr get_free_slot
    rep #$20
    lda.w .pos,y : sta $0200|!addr,x
    lda $00 : ora.w .tile,y : sta $0202|!addr,x
    phx
    txa : lsr #2 : tax
    sep #$20
    stz $0420|!addr,x
    plx
    inx #4
endif
    iny #2
.return:
    rts

.pos:
    db $00+!coin_counter_x_pos-1,!coin_counter_y_pos
    db $10+!coin_counter_x_pos,!coin_counter_y_pos
    db $18+!coin_counter_x_pos,!coin_counter_y_pos

.tile:
    dw $0000,$0010,$0011

draw_yoshi_coins:
    ; Check if we need to draw the Yoshi Coins.
    sep #$10
    lda $13BF|!addr : and #$07 : tay
    lda.w .mask,y : sta $02
    lda $13BF|!addr : lsr #3 : tay
    lda $1F2F|!addr,y : and $02 : beq .not_all

if !draw_all_dc_collected
    ; If all DCs collected, calculate how many they were.
    jsr get_total_dc_amount
    bne .shared
endif

    rts

.not_all:
    ; If not all DCs collected, get their amount from $1422.
    lda $1422|!addr : beq .return

.shared:
    rep #$10

    ; $0F = amount of tiles to draw
    dec : sta $0F

    ; $0D = starting XY position
    lda.b #!dc_counter_x_pos : sta $0D
    lda.b #!dc_counter_y_pos : sta $0E

    ; Yoshi Coin tile is one tile to the right.
    inc $00

.loop:
if !maxtile
    ldx !maxtile_buffer_max+0 : cpx !maxtile_buffer_max+8 : beq .return
    rep #$20
    lda $0D : sta $400000,x
    clc : adc.w #$0008 : sta $0D
    lda $00 : sta $400002,x
    sep #$20
    dex #4 : stx !maxtile_buffer_max+0
    ldx !maxtile_buffer_max+2
    lda #$00 : sta $400000,x
    dex : stx !maxtile_buffer_max+2
else
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
endif
    dec $0F : bpl .loop

.return:
    rts

.mask:
    db $80,$40,$20,$10,$08,$04,$02,$01

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
endif

endif
