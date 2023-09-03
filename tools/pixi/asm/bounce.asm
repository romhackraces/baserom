; implementation made by lx5

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $029054|!BankB
    autoclean JML Main
    dl Ptr
    warnpc $02905E|!BankB

freecode

Main:
    BNE .execute
    LDY !bounce_timer,x
    BEQ .execute
    DEC !bounce_timer,x
.execute
    CMP.b #!BounceOffset
    BCC .original

.custom
    SEC 
    SBC.b #!BounceOffset
    AND #$3F
    %CallSprite(Ptr)
.return
    JML $02904C|!BankB

.original
    JML $02905E|!BankB

   
;tool generated pointer table
Ptr:
    incbin "_bounceptr.bin"