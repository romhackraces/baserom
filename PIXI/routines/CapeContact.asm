;; CapeContact:
;;    Checks for contact between the current sprite and the player's cape.
;;	  Taken from GIEPY's routines.
;; Input:
;;    X: Sprite index
;;
;; Output:
;;    Carry: Set if there is contact
;;
;; Clobbers: A, $00-$0C, $0F
;;

.CapeContact
    LDA $13E8|!addr                ; If the cape is not spinning, return.
    BEQ .noContact
    LDA !sprite_being_eaten,x       ; If the sprite can't contact the cape,
    ORA !sprite_misc_154c,x         ; return.
    ORA !sprite_cape_disable_time,x
    BNE .noContact
    LDA !sprite_behind_scenery,x    ; If the player and the sprite are on
    PHY                             ; different sides of the net, return.
    LDY $74
    BEQ ?+
        EOR #$01
?+   PLY
    EOR $13F9|!addr
    BNE .noContact
    JSL $03B69F|!bank              ; Get the clipping of the sprite.
    LDA $13E9|!addr                ; Get the clipping of the cape.
    SEC : SBC #$02
    STA $00
    LDA $13EA|!addr
    SBC #$00
    STA $08
    LDA #$14
    STA $02
    LDA $13EB|!addr
    STA $01
    LDA $13EC|!addr
    STA $09
    LDA #$10
    STA $03
    JML $03B72B|!bank              ; Check for contact with the cape.

.noContact
    CLC
    RTL