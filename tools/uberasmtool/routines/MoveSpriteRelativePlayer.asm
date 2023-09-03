; MoveSpriteRelativePlayer
;
; Sets the sprite's position relative to that of the player
;
; Input:
;     X  : index of sprite
;     $00: signed x offset to the player for the sprite
;     $02: signed y offset to the player for the sprite
;     carry bit clear - offsets are signed 8-bit values
;     carry bit set   - offsets are signed 16-bit values

?main:
    bcc ?.EightBit

    lda $00
    clc : adc $94
    sta !sprite_x_low,x
    lda $01
    adc $95
    sta !sprite_x_high,x

    lda $02
    clc : adc $96
    sta !sprite_y_low,x
    lda $03
    adc $97
    sta !sprite_y_high,x

    rtl

?.EightBit:
    lda $00
    clc : adc $94
    sta !sprite_x_low,x
    lda #$00
    bit $00
    bpl ?+
    dec
?+
    adc $95
    sta !sprite_x_high,x

    lda $02
    clc : adc $96
    sta !sprite_y_low,x
    lda #$00
    bit $02
    bpl ?+
    dec
?+
    adc $97
    sta !sprite_y_high,x

    rtl
