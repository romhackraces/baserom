; Updates the minor extended sprite's position based on its speed
; Depending on A, it will have behave differently
;   A = Update type
;       00 = Slow, X position
;       01 = Fast, X position
;       02 = Slow, Y position
;       03 = Fast, Y position
; The slow version is accurater as it uses fractional speed values, but has higher cycle usage.
;   0x01 unit = 1/16th of a pixel
;   0x10 units = 1 pixel
; The fast version is less accurate as it doesn't use fractional speed values, but it has lower cycle usage.
;   0x01 unit = 0x01 pixel
;   0x10 units = 0x10 pixels

?main:
    lsr
    bcc ?.slow

; use faster, inaccurate, method of updating position

?.fast
    lsr 
    bcs ?..y
?..x
    ldy #$00
    lda !minor_extended_x_speed,x
    bpl $01
    dey 
    clc 
    adc !minor_extended_x_low,x
    sta !minor_extended_x_low,x
    tya 
    adc !minor_extended_x_high,x
    sta !minor_extended_x_high,x
    rtl
    
?..y
    ldy #$00
    lda !minor_extended_y_speed,x
    bpl $01
    dey 
    clc 
    adc !minor_extended_y_low,x
    sta !minor_extended_y_low,x
    tya 
    adc !minor_extended_y_high,x
    sta !minor_extended_y_high,x
    rtl

; slower but accurater method of updating position

?.slow
    lsr 
    bcs ?..y
?..x
    lda !minor_extended_x_speed,x
    asl #4
    clc 
    adc !minor_extended_x_fraction,x
    sta !minor_extended_x_fraction,x
    php
    ldy #$00
    lda !minor_extended_x_speed,x
    lsr #4
    cmp #$08
    bcc $03
    ora #$F0
    dey
    plp 
    adc !minor_extended_x_low,x
    sta !minor_extended_x_low,x
    tya 
    adc !minor_extended_x_high,x
    sta !minor_extended_x_high,x
    rtl
?..y
    lda !minor_extended_y_speed,x
    asl #4
    clc 
    adc !minor_extended_y_fraction,x
    sta !minor_extended_y_fraction,x
    php
    ldy #$00
    lda !minor_extended_y_speed,x
    lsr #4
    cmp #$08
    bcc $03
    ora #$F0
    dey
    plp 
    adc !minor_extended_y_low,x
    sta !minor_extended_y_low,x
    tya 
    adc !minor_extended_y_high,x
    sta !minor_extended_y_high,x
    rtl
