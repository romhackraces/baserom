db $42

JMP trigger : JMP trigger : JMP trigger : JMP trigger : JMP trigger
JMP return : JMP trigger : JMP trigger : JMP trigger : JMP trigger

trigger:
	LDA $14AF|!addr
	BEQ return

	DEC $14AF|!addr	;set switch to on
	LDA #$0B
	STA $1DF9|!addr	;sound number
return:
	RTL

print "A button that sets the on/off status to on."