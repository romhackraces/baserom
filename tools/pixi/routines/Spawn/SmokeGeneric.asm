; Routine used for spawning smoke sprites with initial speed at the position (+offset)
; of the calling sprite and returns the sprite index in Y
; For a list of smoke sprites see here: 
; https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=884f711d6fb3
;
; Input:
;   A   = number
;   $00 = x offset
;   $01 = y offset
;    $02 = timer
;   $04 = origin x pos  ; since this is a generic routine it can be called from any other sprite
;   $06 = origin y pos  ; type, so i opted for adding macros in _header.asm that helps to setup this

; Output:
;   Y = index to smoke sprite ($FF means no sprite spawned)
;   C = Spawn status
;       Set = Spawn failed
;       Clear = Spawn successful

?main:
    ldy.b #!SmokeSize-1
?.loop
    lda !smoke_num,y
    beq ?.found
    dey 
    bpl ?.loop
?.ret
    sec 
    rtl

?.found
    xba 
    sta !smoke_num,y
    
    lda $00
    clc 
    adc $04
    sta !smoke_x_low,y

    lda $01
    clc 
    adc $06
    sta !smoke_y_low,y

    lda $02
    sta !smoke_timer,y

    clc
    rtl
    

