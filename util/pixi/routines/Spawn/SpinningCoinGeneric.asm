; Routine used for spawning spinning coin sprites with initial speed at the position (+offset)
; of the calling sprite and returns the sprite index in Y
;
; Input:
;   A   = number
;   $00 = x offset
;   $01 = y offset
;   $03 = y speed
;   $04 = origin x pos  ; since this is a generic routine it can be called from any other sprite
;   $06 = origin y pos  ; type, so i opted for adding macros in _header.asm that helps to setup this

; Output:
;   Y = index to spinning coin sprite ($FF means no sprite spawned)
;   C = Spawn status
;       Set = Spawn failed
;       Clear = Spawn successful

?main:
    ldy.b #!SpinningCoinSize-1
?.loop
    lda !spinning_coin_num,y
    beq ?.found
    dey 
    bpl ?.loop
?.ret
    sec 
    rtl

?.found
    xba 
    sta !spinning_coin_num,y
    
    lda $00
    clc 
    adc $04
    sta !spinning_coin_x_low,y
    lda #$00
    bit $00
    bpl $01
    dec 
    adc $05
    sta !spinning_coin_x_high,y

    lda $01
    clc 
    adc $06
    sta !spinning_coin_y_low,y
    lda #$00
    bit $01
    bpl $01
    dec 
    adc $07
    sta !spinning_coin_y_high,y

    lda $03
    sta !spinning_coin_y_speed,y

    clc
    rtl
    
