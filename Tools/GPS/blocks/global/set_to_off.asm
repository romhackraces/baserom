; act as 25
db $42

JMP Switch : JMP Switch : JMP Switch : JMP Switch : JMP Switch
JMP Return : JMP Switch : JMP Switch : JMP Switch : JMP Switch

Switch:
	LDA $14AF|!addr					;> Check if switch already pressed
	BNE Return
	INC $14AF|!addr					;> set switch to off
	LDA #$0B : STA $1DF9|!addr		;> play switch sound
Return:
	RTL

print "Sets the ON/OFF status to OFF when anything (incl. dead sprites) passes through it."