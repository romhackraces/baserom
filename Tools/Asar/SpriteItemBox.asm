; 0 = only draw the box if there's an item.
; 1 = always draw the box.
!always_draw = 0

; You should disable this if the method you used to remove the status bar didn't also disable the item drawing routine.
; For example, with the "Remove Status Bar" patch you need this at 1, but for something that disables it per-level you probably want this at 0.
!draw_item = 0

; If set to an address, the item box/item will only be drawn when this address holds a non-zero value.
; (it can be used to only draw in specific levels, for example if you have a patch that only removes the status bar in specific levels).
; Keep this at 0 to draw it in every level.
!freeram = $79 ; Same as RAMToggledStatusbar so they both activate.

; Box GFX properties.
!box_tile = $22
!box_prop = $36 ; YXPPCCCT
!box_xpos = $70
!box_ypos = $07
!box_size = $02 ; $00 = 8x8, $02 = 16x16

; Shared item GFX properties.
; (for item specific, look at the tables at the bottom of the file).
!item_xpos = $78
!item_ypos = $0F
!item_size = $02 ; $00 = 8x8, $02 = 16x16

if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !dp = $3000
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1 = 0
    !dp = $0000
    !addr = $0000
    !bank = $800000
endif

org $028B20
    autoclean jml main

freecode

main:
    ; Don't draw it on the title screen level.
    lda $0100|!addr : cmp #$0B : bcc .return

if !freeram
    ; Don't draw if the flag is not set.
    lda !freeram : beq .return
endif

if not(!always_draw)
    ; If there's no item, return.
    lda $0DC2|!addr : beq .return
endif

    ; Draw it!
    phb : phk : plb
    jsr draw_item_box
    plb

.return:
    ; Restore original code.
    lda $18C0|!addr : beq +
    jml $028B25|!bank
+   jml $028B65|!bank

; Draw the tiles in the first free OAM slots we find.
draw_item_box:
    rep #$10

    ; If we're in the Bowser fight, we only need to draw the item.
    ldx #$0000
    lda $0D9B|!addr : cmp #$C1 : bne +
    ldx #$0004
+
    ; We start from index $20, because previous ones are cleared by the message box.
    ldy #$0020

    ; If we're in Reznor/Morton/Roy's room, start from $190 (previous slots aren't refreshed).
    cmp #$C0 : bne +
    ldy #$0190
+
.oam_loop:
    ; If the tile is offscreen, write to it.
    lda $0201|!addr,y : cmp #$F0 : beq ..found
..next:
    iny #4 : cpy #$0200 : bne .oam_loop
    bra .return
..found:
    ; If it's the 5th tile, it's the item.
    cpx #$0004 : beq .draw_item
.draw_box:
    lda.w box_xpos,x : sta $0200|!addr,y
    lda.w box_ypos,x : sta $0201|!addr,y
    lda.b #!box_tile : sta $0202|!addr,y
    lda.w box_prop,x : ora.b #!box_prop : sta $0203|!addr,y
    phy
    rep #$20
    tya : lsr #2 : tay
    sep #$20
    lda.b #!box_size : sta $0420|!addr,y
    ply
    inx
    bra .oam_loop_next
.draw_item:
if !draw_item
    ; Taken from $009079.
    lda #$00 : xba
    lda $0DC2|!addr : beq .return
    tax
    lda.b #!item_xpos : sta $0200|!addr,y
    lda.b #!item_ypos : sta $0201|!addr,y
    lda.w item_tiles-1,x : sta $0202|!addr,y
    lda.w item_props-1,x
    cpx #$0003 : bne +
    lda $13 : lsr : and #$03 : tax
    lda.w star_props,x
+   sta $0203|!addr,y
    rep #$20
    tya : lsr #2 : tay
    sep #$20
    lda.b #!item_size : sta $0420|!addr,y
endif
.return:
    sep #$10
    rts

; Specific properties of the 4 item box tiles.
box_xpos:
    db !box_xpos+$00,!box_xpos+$10,!box_xpos+$00,!box_xpos+$10

box_ypos:
    db !box_ypos+$00,!box_ypos+$00,!box_ypos+$10,!box_ypos+$10

box_prop:
    db $00,$40,$80,$C0

if !draw_item

; These are indexed by item value: Mushroom, Flower, Star, Cape.
; You can add more entries if you have custom powerups.
item_tiles:
    db $24,$26,$48,$0E

item_props:
    db $38,$3A,$30,$34

; Properties the star item cycles through.
star_props:
    db $30,$32,$34,$32

endif
