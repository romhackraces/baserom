db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
	LDA #$02 : STA $13FE|!addr
Return:
	RTL

print "Scroll camera right. (Remove graphics in Map16 when finished.)"