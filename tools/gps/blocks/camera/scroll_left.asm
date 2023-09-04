db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
	LDA #$04 : STA $13FE|!addr
Return:
	RTL

print "Scroll camera left. (Remove graphics in Map16 when finished.)"