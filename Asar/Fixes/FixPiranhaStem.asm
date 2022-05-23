;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Piranha Plant Stems by Ice Man
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SA-1 Check
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if read1($00FFD5) == $23
    ; SA-1 base addresses
    sa1rom
    !SA1  = 1
    !dp   = $3000
    !addr = $6000
    !bank = $000000
    !9E = $3200
else
    ; Non SA-1 base addresses
    lorom
    !SA1  = 0
    !dp   = $0000
    !addr = $0000
    !bank = $800000
    !9E   = $9E
endif

org $018E8D|!bank
    autoclean JSL FixPiranhaStem        ;Classic Piranha Plant Stem Fix
    NOP #6


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Classic Piranha Stem Fix
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
freecode

FixPiranhaStem:
    LDA !9E,x
    CMP #$1A
    BEQ +

    LDA $030B|!addr,y
    AND #$F1
    ORA #$0A
    STA $030B|!addr,y
    RTL

+   LDA $0307|!addr,y
    AND #$F1
    ORA #$0A
    STA $0307|!addr,y
    RTL
