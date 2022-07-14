;; FireballContact:
;;    Checks for contact between the current sprite and a player fireball.
;;	  Taken from GIEPY's routines.
;;    The index returned by this routine is an index to the last two extended
;;    sprites. You can add 8 to it and use it to index the extended sprite
;;    tables normally. Alternatively, you can add 8 to the tables when using
;;    them.
;;
;; Input:
;;    X: Sprite index
;;
;; Output:
;;    Y: Index of the fireball or $FF if there is no contact.
;;    Carry: Set if there is contact with any fireball.
;;
;; Clobbers: A

.FireballContact
    PHX                             ; Preserve X.
    LDY #$00                        ; Set initial fireball index.
?-   LDA !extended_num+8,y           ; If there is no fireball in this slot,
    BEQ .nothing                    ; check the next one.
    LDA !extended_x_low+8,y         ; Store clipping B of fireball.
    SEC : SBC #$02
    STA $00
    LDA !extended_x_high+8,y
    SBC #$00
    STA $08
    LDA #$0C
    STA $02
    LDA !extended_y_low+8,y
    SEC : SBC #$04
    STA $01
    LDA !extended_y_high+8,y
    SBC #$00
    STA $09
    LDA #$13
    STA $03
    PHY                             ; Preserve fireball index.
    JSL $03B69F|!bank              ; Get sprite A clipping.
    JSL $03B72B|!bank              ; Check for contact.
    BCS .foundFireball              ; Return if fireball found.
    PLY                             ; Pull fireball index.
.nothing
    CPY #$00
    BNE .noFire                     ; If second fireball failed, end.
    INY
    BRA ?-

.foundFireball
    PLY                             ; Pull fireball index.
    PLX                             ; Restore X.
    SEC
    RTL

.noFire
    LDY #$FF
    PLX                             ; Restore X.
    CLC
    RTL

