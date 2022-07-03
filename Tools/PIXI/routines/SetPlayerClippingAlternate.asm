;; SetPlayerClippingAlternate:
;;    Routine from imamelia
;;    Custom player clipping routine. Sets up the player's interaction field
;;    with 16-bit values as custom clipping 1.
;;
;; Output:
;;    $00-$07: Clipping values
;;
;; Clobbers: A

.SetPlayerClippingAlternate
    PHX
    REP #$20
    LDA $94
    CLC : ADC #$0002
    STA $00
    LDA #$000C
    STA $04
    SEP #$20
    LDX #$00
    LDA $73
    BNE .inc1
    LDA $19
    BNE .next1
.inc1
    INX
.next1
    LDA $187A|!addr
    BEQ .next2
    INX #2
.next2
    LDA.l $03B660|!bank,x
    STA $06
    STZ $07
    LDA.l $03B65C|!bank,x
    REP #$20
    AND #$00FF
    CLC : ADC $96
    STA $02
    SEP #$20
    PLX
    RTL
