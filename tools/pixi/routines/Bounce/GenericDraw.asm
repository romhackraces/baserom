; Draws a single 16x16 tile for a bounce sprite, it also handles the offscreen behavior (X pos high bit)
; 
; Input:
;   A = Tile number to use
; 
; Output:
;   N/A

?main:
    sta $02
    %BounceGetDrawInfo()
    bcc ?.skip
    
    lda $00
    sta $0200|!addr,y
    lda $01
    sta $0201|!addr,y
    lda $02
    sta $0202|!addr,y
    lda !bounce_properties,x
    ora $64
    sta $0203|!addr,y

    tya 
    lsr #2
    tay
    lda $03
    sta $0420|!addr,y

?.skip
    rtl