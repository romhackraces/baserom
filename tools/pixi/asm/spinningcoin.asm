; implementation made by lx5

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $0299D4|!BankB
    autoclean JML Main
    dl Ptr
    warnpc $0299DC|!BankB

org $028A7D|!BankB
    autoclean JML Fix

freecode

Fix: 
    JSL $05B34A|!BankB
    LDA #$01
    STA !spinning_coin_num,x
    JML $028A84|!BankB

Main:
    LDA !spinning_coin_num,x
    BEQ .return                     ; original code
    STX $15E9|!addr

    CMP.b #!SpinningCoinOffset      ; check if custom
    BCC .original

.custom
    SEC 
    SBC.b #!SpinningCoinOffset      ; substract
    AND #$1F                        ; self imposed limit
    %CallSprite(Ptr)
.return
    JML $0299DF|!BankB

.original
    JML $0299DC|!BankB

   
;tool generated pointer table
Ptr:
    incbin "_spinningcoinptr.bin"