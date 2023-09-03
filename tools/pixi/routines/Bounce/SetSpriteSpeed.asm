; Updates the sprite's speed based on the direction of the bounce sprite.
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
    lda.l $0290D6|!bank,x
    cmp #$80
    beq ?.no_sprite_y_speed
    phx
    ldx $0F
    sta !AA,x
    plx
?.no_sprite_y_speed
    lda.l $0290DA|!bank,x
    cmp #$80
    beq ?.no_sprite_x_speed
    ldx $0F
    sta !B6,x
?.no_sprite_x_speed
    tyx 
    rtl
