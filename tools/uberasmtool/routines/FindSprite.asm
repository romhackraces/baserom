; FindSprite - tries to find the sprite slot occupied by the given sprite number
;
; Input:
;     X  : sprite slot to begin searching in, plus 1 (searches downwards, safe to pass $00, which will always result in no match)
;     A  : if carry bit clear, sprite number/acts like
;          if carry bit set, custom sprite number
;
; Output:
;     X : sprite slot containing the sprite (which might be in a dead state), or $FF is not found
;     Carry bit clear if found, carry bit set if not found

?main:
    bcs ?.custom

?-
    dex
    bmi ?.not_found
    bit !sprite_status,x
    beq ?-
    cmp !sprite_num,x
    bne ?-
    clc
    rtl

?.custom:
?-
    dex
    bmi ?.not_found
    bit !sprite_status,x
    beq ?-
    cmp !new_sprite_num,x
    bne ?-
    clc
    rtl

?.not_found:
    sec
    rtl
