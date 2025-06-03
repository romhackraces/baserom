db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
	LDA #$01 : STA $1411|!addr
Return:
	RTL

print "Enable horizontal camera scroll. (Remove graphics in Map16 when finished.)"