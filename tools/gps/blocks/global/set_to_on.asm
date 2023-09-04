; act as 25
db $42

JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch
JMP Return : JMP Switch : JMP Switch : JMP Switch : JMP Switch

Switch:
    LDA $14AF|!addr                 ;> check switch state
    BEQ Return
    DEC $14AF|!addr                 ;> set switch to on
    LDA #$0B :  STA $1DF9|!addr     ;> play switch sound
Return:
    RTL

print "Sets the ON/OFF status to ON when anything (incl. dead sprites) passes through it."