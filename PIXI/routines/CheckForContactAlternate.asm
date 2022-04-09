;; CheckForContactAlternate:
;; Routine from imamelia
;;    Custom contact check routine. Checks for contact between whatever two
;;    things were set up previously.
;;
;; Input:
;;    $00-$07: Clipping 1
;;    $08-$0F: Clipping 2
;;
;; Output:
;;    Carry: Contact flag
;;
;; Clobbers: A

.CheckForContactAlternate
    REP #$20
.checkX
    LDA $00
    CMP $08
    BCC .checkXSub2
.checkXSub1
    SEC : SBC $08
    CMP $0C
    BCS .returnNoContact
    BRA .checkY

.checkXSub2
    LDA $08
    SEC : SBC $00
    CMP $04
    BCS .returnNoContact
.checkY
    LDA $02
    CMP $0A
    BCC .checkYSub2
.checkYSub1
    SEC : SBC $0A
    CMP $0E
    BCS .returnNoContact
.returnContact
    SEP #$21
    RTL

.checkYSub2
    LDA $0A
    SEC : SBC $02
    CMP $06
    BCC .returnContact
.returnNoContact
    CLC
    SEP #$20
    RTL