; implementation made by lx5

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $0296C0|!BankB
    autoclean JML Main
    dl Ptr
    warnpc $0296C7|!BankB

freecode

Main:
    LDA !smoke_num,x
    BEQ .return                     ; original code
    AND #$7F

    CMP.b #!SmokeOffset             ; check if custom
    BCC .original

.custom
    SEC 
    SBC.b #!SmokeOffset             ; substract
    AND #$1F                        ; self imposed limit
    %CallSprite(Ptr)
.return
    JML $0296D7|!BankB              ; both routines return
                                    ; to the same place
 
.original
    JML $0296C7|!BankB

   
;tool generated pointer table
Ptr:
    incbin "_smokeptr.bin"