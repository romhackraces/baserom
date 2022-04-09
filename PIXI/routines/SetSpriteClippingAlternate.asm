;; SetSpriteClippingAlternate:
;;    Routine from imamelia
;;    Custom sprite clipping routine. Sets up a sprite's interaction field with
;;    16-bit values as custom clipping 2.
;;
;; Input:
;;    X: Sprite index
;;    $08-$09: X displacement
;;    $0A-$0B: Y displacement
;;    $0C-$0D: Width
;;    $0E-$0F: Height
;;
;; Output:
;;    $08-0F: Clipping values
;;
;; Clobbers: A
;;

.SetSpriteClippingAlternate
    LDA !sprite_x_high,x
    XBA : LDA !sprite_x_low,x
    REP #$20
    CLC : ADC $08
    STA $08
    SEP #$20
    LDA !sprite_y_high,x
    XBA : LDA !sprite_y_low,x
    REP #$20
    CLC : ADC $0A
    STA $0A
    SEP #$20
    RTL