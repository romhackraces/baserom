;# Setups the required information for spawning a Map16 tile from a bounce sprite.

?main:
    lda !bounce_y_low,x
    clc
    adc #$08
    and #$F0
    sta $98
    lda !bounce_y_high,x
    adc #$00
    sta $99
    lda !bounce_x_low,x
    clc
    adc #$08
    and #$F0
    sta $9A
    lda !bounce_x_high,x
    adc #$00
    sta $9B
    lda !bounce_properties,x
    asl
    rol
    and #$01
    sta $1933|!addr
    rtl