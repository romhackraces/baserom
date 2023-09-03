;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $B829 - vertical mario/sprite position check - shared
; Y = 1 if mario below sprite??
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                    ;org $03B829 

?main:
    LDY #$00
    LDA $96
    SEC
    SBC !D8,x
    STA $0F
    LDA $97
    SBC !14D4,x
    BPL ?+
    INY
?+
    RTL



