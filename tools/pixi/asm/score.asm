; implementation made by lx5

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $02ADBA|!BankB
    autoclean JML Main
    dl Ptr
    warnpc $02ADC2|!BankB

freecode

Main:
    LDA !score_num,x
    BEQ .return
    STX $15E9|!addr

    CMP.b #!ScoreOffset
    BCC .original

.custom
    SEC 
    SBC.b #!ScoreOffset
    AND #$1F
    %CallSprite(Ptr)
.return
    JML $02ADC5|!BankB

.original
    JML $02ADC2|!BankB


   
;tool generated pointer table
Ptr:
    incbin "_scoreptr.bin"