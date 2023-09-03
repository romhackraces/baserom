; Routine used for spawning score sprites with initial speed at the position (+offset)
; of the calling sprite and returns the sprite index in Y
; For a list of score sprites see here: 
; https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=befc37dd6e48
;
; Input:
;   A   = number
;   $00 = x offset
;   $01 = y offset
;   $04 = origin x pos  ; since this is a generic routine it can be called from any other sprite
;   $06 = origin y pos  ; type, so i opted for adding macros in _header.asm that helps to setup this

; Output:
;   Y = index to score sprite

?main:
    ldy.b #!ScoreSize-1
?.loop
    lda !score_num,y
    beq ?.found
    dey 
    bpl ?.loop
    dec $18F7|!addr
    bpl ?.force
    lda.b #!ScoreSize-1
    sta $18F7|!addr
?.force
    ldy $18F7|!addr

?.found
    xba 
    sta !score_num,y
    
    lda $00
    clc 
    adc $04
    sta !score_x_low,y
    lda #$00
    bit $00
    bpl $01
    dec 
    adc $05
    sta !score_x_high,y

    lda $01
    clc 
    adc $06
    sta !score_y_low,y
    lda #$00
    bit $01
    bpl $01
    dec 
    adc $07
    sta !score_y_high,y

    lda #$30
    sta !score_y_speed,y

    rtl
    
