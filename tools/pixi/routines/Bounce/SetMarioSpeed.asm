; Updates the player's speed based on the direction of the bounce sprite.
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
    lda.l ?.mario_y_speed,x
    cmp #$80
    beq ?.no_mario_y_speed
    sta $7D
?.no_mario_y_speed
    lda.l ?.mario_x_speed,x
    cmp #$80
    beq ?.no_mario_x_speed
    sta $7B
?.no_mario_x_speed
    tyx 
    rtl

?.mario_x_speed
    db $80,$E0,$20,$80
?.mario_y_speed
    db $80,$80,$80,$00