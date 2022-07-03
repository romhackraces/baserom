db $37
JMP main : JMP main : JMP main : JMP main : JMP main : JMP main : JMP main
JMP main : JMP main : JMP main : JMP main : JMP main

main:
	LDA $14AF|!addr	;\ check ON/OFF switch state
	BEQ .return 	;/
	LDY.b #$0025>>8	;\
	LDA.b #$0025	;| make tile act as air (25)
	STA $1693|!addr	;/
.return
	RTL

print "Inverted ON/OFF Switch block."