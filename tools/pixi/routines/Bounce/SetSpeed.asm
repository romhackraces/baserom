; Routine that updates the speeds of a bounce sprite like the original bounce sprites.
; 
; Input:
;   N/A
;
; Output:
;   N/A

?main:
    txy
    lda !bounce_table,y
    and #$03
    tax 
    lda !bounce_y_speed,y
    clc 
    adc.l ?.bounce_y_accel,x
    sta !bounce_y_speed,y
    lda !bounce_x_speed,y
    clc 
    adc.l ?.bounce_x_accel,x
    sta !bounce_x_speed,y
    tyx
    rtl 

?.bounce_x_accel
    db $00,$F0,$10,$00
?.bounce_y_accel
    db $10,$00,$00,$F0