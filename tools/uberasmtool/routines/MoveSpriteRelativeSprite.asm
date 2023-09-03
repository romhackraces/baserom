; MoveSpriteRelativeSprite
;
; Sets a sprite's position relative to that of another sprite
;
; Input:
;     X  : index of sprite to move
;     Y  : index of sprite whose position is used as a base
;     $00: signed x offset
;     $02: signed y offset
;     carry bit clear - offsets are signed 8-bit values
;     carry bit set   - offsets are signed 16-bit values

?main:
    bcc ?.EightBit

    lda $00
    clc : adc !sprite_x_low,y
    sta !sprite_x_low,x
    lda $01
    adc !sprite_x_high,y
    sta !sprite_x_high,x

    lda $02
    clc : adc !sprite_y_low,y
    sta !sprite_y_low,x
    lda $03
    adc !sprite_y_high,y
    sta !sprite_y_high,x

    rtl

?.EightBit:
    lda $00
    clc : adc !sprite_x_low,y
    sta !sprite_x_low,x
    lda #$00
    bit $00
    bpl ?+
    dec
?+
    adc !sprite_x_high,y
    sta !sprite_x_high,x

    lda $02
    clc : adc !sprite_y_low,y
    sta !sprite_y_low,x
    lda #$00
    bit $02
    bpl ?+
    dec
?+
    adc !sprite_y_high,y
    sta !sprite_y_high,x

    rtl
