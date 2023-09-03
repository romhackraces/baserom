; implementation made by lx5

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $028B6C|!BankB
    autoclean JML Main
    dl Ptr
    warnpc $028B74|!BankB

freecode

Main:
    BEQ .return                     ; original code

    STX $1698|!addr                 ; store index if valid
    CMP.b #!MinorExtendedOffset     ; check if custom
    BCC .original

.custom
    SEC 
    SBC.b #!MinorExtendedOffset     ; substract
    AND #$3F                        ; self imposed limit
    %CallSprite(Ptr)
    JML $028B74|!BankB

.original
    PHK
    PEA.w .return-1
    PEA.w $B888                     ; call original code
    JML $028B94|!BankB              ; jslrts because it calls ExecutePtr

.return
    JML $028B74|!BankB              ; both routines return
                                    ; to the same place
    
;tool generated pointer table
Ptr:
    incbin "_minorextendedptr.bin"