; Routine for bounce sprites that fetches information to draw a it on screen.
; It handles the offscreen bit and layer 2 offsets.
; 
; Input:
;   N/A
; 
; Output: 
;   $00 = X position within the screen
;   $01 = Y position within the screen
;   $03 = OAM size and offscreen bit
;   Y   = OAM Index
;   C   = Draw status
;       Set     = Ready to be drawn on screen
;       Clear   = Not possible to draw on screen

?main:
    lda #$02
    sta $03
    ldy #$00
    lda !bounce_properties,x
    bpl ?.layer_1
?.layer_2
    ldy #$04
?.layer_1
    lda !bounce_x_low,x
    sec 
    sbc.w $1A,y
    sta $00
    lda !bounce_x_high,x
    sbc.w $1B,y
    beq ?.on_screen_x
    inc $03
?.on_screen_x
    lda !bounce_y_low,x
    sec 
    sbc.w $1C,y
    sta $01
    lda !bounce_y_high,x
    sbc.w $1D,y
    beq ?.on_screen_y
    clc
    rtl 
?.on_screen_y
    lda.l $0291ED|!BankB,x
    tay
    sec
    rtl