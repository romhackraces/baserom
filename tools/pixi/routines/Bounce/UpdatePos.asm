; Updates the X and Y positions of a bounce sprite based on its speed values
;
; Input:
;   N/A
; 
; Output:
;   N/A

?main:
    lda !bounce_y_speed,x
    asl #4
    clc
    adc !bounce_y_bits,x
    sta !bounce_y_bits,x
    php
    lda !bounce_y_speed,x
    lsr #4
    cmp #$08
    ldy #$00
    bcc ?+
    ora #$F0
    dey
?+
    plp
    adc !bounce_y_low,x
    sta !bounce_y_low,x
    tya
    adc !bounce_y_high,x
    sta !bounce_y_high,x

    lda !bounce_x_speed,x
    asl #4
    clc
    adc !bounce_x_bits,x
    sta !bounce_x_bits,x
    php
    lda !bounce_x_speed,x
    lsr #4
    cmp #$08
    ldy #$00
    bcc ?+
    ora #$F0
    dey
?+
    plp
    adc !bounce_x_low,x
    sta !bounce_x_low,x
    tya
    adc !bounce_x_high,x
    sta !bounce_x_high,x
    rtl 