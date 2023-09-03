; Generic routine to draw a score sprite with two 8x8 tiles
; and priority over every layer, similar to SMW's score sprites.
; 
; Input:
;   $07 = Left tile number
;   $08 = Right tile number
;   $09 = Left tile properties
;   $0A = Right tile properties
; 
; Output: 
;   C   = Draw status
;       Set     = Score sprite drawn on screen
;       Clear   = Score sprite not drawn on screen


?main:
    %ScoreGetDrawInfo()
    bcc ?.return
    lda $00
    sta $0200|!addr,y
    clc 
    adc #$08
    sta $0204|!addr,y 
    lda $01
    sta $0201|!addr,y
    sta $0205|!addr,y
    lda $07
    sta $0202|!addr,y
    lda $08
    sta $0206|!addr,y
    lda $09
    ora #$30
    sta $0203|!addr,y
    lda $0A
    ora #$30
    sta $0207|!addr,y
    tya 
    lsr #2
    tay 
    lda #$00
    sta $0420|!addr,y
    sta $0421|!addr,y
    sec 
?.return
    rtl