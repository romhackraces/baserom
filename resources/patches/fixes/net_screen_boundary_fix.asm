;=======================================================================
; Climbing Net Door on Subscreen Boundary Fix by Kevin
;
; This patch fixes the issue where net doors won't work properly when
; placed on a screen/subscreen boundary (some tiles won't be erased and
; restored when the door revolves).
;
; Note that when a net is placed on a boundary, it will be more likely to
; cause blank overflows (for example, black bars on top of the screen).
; If this happens, try patching my "Lunar Magic VRAM Optimization" patch.
;
; Since the original routine is completely rewritten, some ROM space is
; left unused (48 bytes at $00C39F) and it can be used by other patches.
;=======================================================================

if read1($00FFD5) == $23
    sa1rom
else
    lorom
endif

org $00C35D
net_door_stripe_upload:
    lda $06 : xba : sta $06
    ldy #$000B
    and #$001F : sec : sbc #$001B : bmi .normal
.boundary:
    asl : tax
    lda.l .upload_num,x : tay
.normal:
    sty $0E

    lda $7F837B : tax
    ldy #$0000
    lda #$0005 : sta $00

    autoclean jsl net_rows_loop

    lda #$FFFF : sta $7F837D,x
    txa : sta $7F837B
    rts

; How many bytes to upload in each half row (when crossing a boundary)
.upload_num:
    db $09,$01
    db $07,$03
    db $05,$05
    db $03,$07
    db $01,$09

warnpc $00C3D1

freecode

; Similar to the original loop (except we always stay in 16-bit mode
; and copy the tiles together with the header) but we do two separate
; stripe uploads if the row crosses a horizontal boundary. Also, vertical
; boundaries are taken into account when going to the next row.
net_rows_loop:
    lda $06 : xba : sta $7F837D,x
    inx #2
    lda $0E : and #$00FF : sta $0C
    xba : sta $7F837D,x
    inx #2
    jsr copy_tiles
    lda $0E : cmp #$000B : beq .next
.boundary:
    and #$FF00 : sta $7F837F,x
    xba : sta $0C
    lda $06 : and #$FFE0 : eor #$0400 : xba : sta $7F837D,x
    inx #4
    jsr copy_tiles
.next:
    lda $06 : clc : adc #$0020
    bit #$03E0 : bne +
    sec : sbc #$0020
    and #$FC1F : eor #$0800
+   sta $06
    dec $00 : bpl net_rows_loop
.end:
    rtl

; Small routines that copies tiles (number + properties)
; into the stripe image table.
;
; Inputs:
; - $0C-$0D: amount of bytes to copy - 1
; - [$02],y: where to copy from
; - $7F837D,x: where to copy to
copy_tiles:
    lsr $0C
.loop:
    lda [$02],y : sta $7F837D,x
    inx #2
    iny #2
    dec $0C : bpl .loop
    rts
