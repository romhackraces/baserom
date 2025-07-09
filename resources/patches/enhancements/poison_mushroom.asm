;=======================================================================
; Poison Mushroom by mikeyk
; modifications by JackTheSpades and AmperSam
;=======================================================================

;Applying this patch will specify that an existing sprite number will be a
;Poison Mushroom instead (ideally an unused one). Available unused sprite
;numbers: 12, 69, 85 (Default), 96.
;
;Don't reapply this patch to the same ROM after specifying a sprite
;number as it will NOT remove the previous insertion.
;
;Setting the Extra Bit of the sprite in Lunar Magic will make this
;sprite a kill variant Mushroom. This requires PIXI to be applied
;to your project.


;=======================================================================
; DEFINES
;=======================================================================

!NUM ?= $85         ; NORMAL sprite number to insert as
!Tile = $E6         ; sprite tile to use for graphics
!PalHurt = $A       ; palette row number to use (not YXPPCCCT)
!PalKill = $B       ; palette row for the kill version
!GFXPage = 0		; 0 = first graphics page, 1 = second page


;=======================================================================
; CODE
;=======================================================================

assert !NUM < $C9

if read1($00FFD5) == $23
    sa1rom
    !dp = $3000
    !addr = $6000
    !bank = $000000
    !extra_bits = $400040
    !sa1 = 1
    !14C8 = $3242
    !9E = $3200
else
    lorom
    !dp = $0000
    !addr = $0000
    !bank = $800000
    !extra_bits = $7FAB10
    !sa1 = 0
    !14C8 = $14C8
    !9E = $9E
endif

org ($01817D+(!NUM*2))|!bank    ;sprite init pointer
    dw $858B                    ;power up init
org ($0185CC+(!NUM*2))|!bank    ;main pointer
    dw $C353                    ;power up routine

org ($07F26C+!NUM)|!bank        ;tweaker 1656
    db $00
org ($07F335+!NUM)|!bank        ;tweaker 1662
    db $00
org ($07F3FE+!NUM)|!bank        ;tweaker 166E
    db (!PalHurt-8)<<1|!GFXPage
org ($07F4C7+!NUM)|!bank        ;tweaker 167A
    db $C2
org ($07F590+!NUM)|!bank        ;tweaker 1686
    db $28
org ($07F659+!NUM)|!bank        ;tweaker 190F
    db $40

; hijack power up routine
org $01C4C6|!bank
    autoclean JML PoisonMushroom

; handle GFX routine
org $01C6D6|!bank
    autoclean JSL PoisonMushroomGFX

freecode

PoisonMushroom:
    LDA !9E,x				;\
    CMP #$21                ;| check if moving coin
    BNE .not_coin           ;/

    JML $01C4CF|!bank       ; jump to give coin routine

.not_coin
    CMP #!NUM               ;\ check if sprite is poison mushroom
    BNE .erase              ;/ ..otherwise erase sprite

    LDA !extra_bits,x       ;\ check extra bits for kill variant
    AND #$04                ;|
    BNE .kill               ;/

    JSL $00F5B7|!bank       ; run hurt routine
    BRA .rts

.kill
    JSL $00F606|!bank       ; run kill routine

.rts
    JML $01C57F|!bank       ; jump to end of routine RTS

.erase
    STZ !14C8,x             ; erase sprite if not poison mushroom

.return
    JML $01C538|!bank       ; return to normal power-up code


;input:  A = sprite number
;output: A = tile number
PoisonMushroomGFX:
    CMP.b #!NUM-$74         ;\ check if sprite is poison mushroom and skip
    BNE +                   ;/ if not.

    LDA !extra_bits,x       ; we still have the sprite index in x
    AND #$04                ;\
    BEQ ++                  ;/ ignore this if the extra bit isn't set

    LDA $0303|!addr,y       ;\
    EOR #$04                ;|zero out current palette setting
    ORA #(!PalKill-8)<<1    ;|and replace it with the kill shroom setting
    STA $0303|!addr,y       ;/

++  LDA #!Tile              ;\ if, set tile to !Tile
    RTL                     ;/ and return
+   TAX                     ;\ restore code
    LDA $C609,x             ;/ ROMMAP $01C609 (Tilemap powerups)
    RTL                     ; return