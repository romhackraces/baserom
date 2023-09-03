; Routine that updates score's sprites Y position based on its speed.
; It also handles how high the score sprite can go.
; You'd be better using %UpdateYPos() for default SMW behavior or
; %UpdateYPosAlt() for easy handling of the upper limit of the score sprite
;
; Input:
;   C = Use SMW's highest position value
;   A = If carry set, highest position relative to the camera the score sprite can reach
; 
; Output:
;   N/A

?main:
    bcs ?.already_set
    lda #$04
?.already_set
    sta $00
    phb
    phk
    plb
    lda !score_y_speed,x
    lsr #4
    tay 
    lda $13
    and ?.point_speed_y,y
    bne ?.return
    lda !score_y_low,x
    tay 
    sec 
    sbc $1C 
    cmp $00
    bcc ?.return
    dec !score_y_low,x
    tya 
    bne ?.return
    dec !score_y_high,x
?.return
    plb
    rtl

?.point_speed_y 
    db $03,$01,$00,$00