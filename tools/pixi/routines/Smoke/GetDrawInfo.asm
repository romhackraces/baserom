; Routine for smoke sprites that fetches information to draw a single oam tile on screen.
;
; Input:
;   N/A
; 
; Output:
;   $00 = X position within the screen
;   $01 = Y position within the screen
;   Y   = OAM index
;   C   = Draw status
;       Set     = Ready to be drawn on screen
;       Clear   = Not possible to draw on screen

?main:
?.check_x
    lda !smoke_x_low,x
    sec 
    sbc $1A
    cmp #$F0
    bcs ?.nope
    sta $00
?.check_y
    lda !smoke_y_low,x
    sec 
    sbc $1C
    sta $01
    lda.l $0296B8|!BankB,x
    tay
    sec 
    rtl
?.nope
    clc 
    rtl 
