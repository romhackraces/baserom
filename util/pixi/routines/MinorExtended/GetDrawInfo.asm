; Routine for minor extended sprites that fetches information to draw a single oam tile on screen.
; It handles offscreen situations, including X position's high bit.
; If a minor extended sprite is way too offscreen, the sprite will be erased from memory.
;
; Input:
;   N/A
; 
; Output:
;   $00 = X position within the screen
;   $01 = Y position within the screen
;   $02 = X position's high bit
;   Y   = OAM index
;   C   = Draw status
;       Set     = Ready to be drawn on screen
;       Clear   = Not possible to draw on screen

?main:
?.check_y
    lda !minor_extended_y_low,x
    sec 
    sbc $1C 
    sta $01
    cmp #$E0
    bcc ?.check_x
    clc 
    adc #$10
    bpl ?.check_x
?.kill
    stz !minor_extended_num,x
?.invalid
    clc 
    rtl

?.check_x
    stz $02
    lda !minor_extended_x_low,x
    sec 
    sbc $1A
    sta $00
    lda !minor_extended_x_high,x
    sbc $1B
    beq ?.on_screen_x
    lda $00
    clc 
    adc #$38            ; range for despawn
    cmp #$70
    bcs ?.kill
    inc $02
?.on_screen_x
    lda.l $028B77|!BankB,x
    tay
    sec 
    rtl
