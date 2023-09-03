; Routine used for spawning extended sprites with initial speed at the position (+offset)
; of the calling sprite and returns the sprite index in Y
; For a list of extended sprites see here: 
; https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=d22e80035676
;
; Input:
;   A   = number
;   $00 = x offset
;   $01 = y offset
;   $02 = x speed
;   $03 = y speed
;   $04 = origin x pos  ; since this is a generic routine it can be called from any other sprite
;   $06 = origin y pos  ; type, so i opted for adding macros in _header.asm that helps to setup this

; Output:
;   Y = index to extended sprite ($FF means no sprite spawned)
;   C = Spawn status
;       Set = Spawn failed
;       Clear = Spawn successful

?main:
    ldy.b #!ExtendedSize-1
?.loop
    lda !extended_num,y
    beq ?.found
    dey 
    bpl ?.loop
?.ret
    sec 
    rtl

?.found
    xba 
    sta !extended_num,y
    
    lda $00
    clc 
    adc $04
    sta !extended_x_low,y
    lda #$00
    bit $00
    bpl $01
    dec 
    adc $05
    sta !extended_x_high,y

    lda $01
    clc 
    adc $06
    sta !extended_y_low,y
    lda #$00
    bit $01
    bpl $01
    dec 
    adc $07
    sta !extended_y_high,y

    lda $02
    sta !extended_x_speed,y
    lda $03
    sta !extended_y_speed,y

    clc
    rtl
    
