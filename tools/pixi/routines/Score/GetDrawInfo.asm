; Routine for score sprites that fetches information to draw a it on screen.
; 
; Input:
;   N/A
; 
; Output: 
;   $00 = X position within the screen
;   $01 = Y position within the screen
;   Y   = OAM Index
;   C   = Draw status
;       Set     = Ready to be drawn on screen
;       Clear   = Not possible to draw on screen

?main:
    lda !score_layer,x
    asl #2
    tay 
    rep #$20
    lda.w $1C|!dp,y
    sta $02
    lda.w $1A|!dp,y
    sta $04
    sep #$20

    lda !score_x_low,x
    clc 
    adc #$0C
    php 
    sec 
    sbc $04
    lda !score_x_high,x
    sbc $05
    plp 
    adc #$00
    bne ?.return
    lda !score_x_low,x
    cmp $04
    lda !score_x_high,x
    sbc $05
    bne ?.return

    lda !score_y_low,x
    cmp $02
    lda !score_y_high,x
    sbc $03
    bne ?.return

?.valid
    lda !score_x_low,x
    sec 
    sbc $04
    sta $00
    lda !score_y_low,x
    sec 
    sbc $02
    sta $01
    lda.l $02AD9E|!BankB,x
    tay 
    sec 
    rtl 

?.return
    clc 
    rtl