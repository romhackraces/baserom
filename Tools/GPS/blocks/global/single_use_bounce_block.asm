db $42

JMP Return : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Return : JMP Return

Mario:
	LDA #$A0 : STA $7D			;> bounce Mario
	;STZ $140D|!addr				;> negate spin jump
	LDA #$08 : STA $1DFC|!addr	;> play bounce noise

	%erase_block()
	%create_smoke()

Return:
	RTL

print "A single-use bounce block."