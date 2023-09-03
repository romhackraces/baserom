; Adapted from Pixi 1.4
;
; SpawnExtended: spawns an extended sprite.  Sets speed to 0; does not set position.
; You must either set position manually or use MoveExtendedRelativePlayer/Sprite
;
; Input:
;     A: number of sprite to spawn (see https://www.smwcentral.net/?p=memorymap&a=detail&game=smw&region=ram&detail=d22e80035676 for a list)
;
; Output:
;     X: index to spawned sprite (#$FF means no sprite spawned)
;     Carry bit set = spawn failed, Carry bit clear = spawn successful.

?main:
    xba

    ldx #$07              ; top slot to begin searching, skips the top 2 fireball-only slots
?-
    lda !extended_num,x
    beq ?.found
    dex
    bpl ?-
    sec 
    rtl

?.found:
    xba 
    sta !extended_num,x
    stz !extended_x_speed,x
    stz !extended_y_speed,x
    clc
    rtl
    
