db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
	LDA #$01 : STA $1412|!addr
Return:
	RTL

print "Enable vertical camera scroll. (Remove graphics in Map16 when finished.)"