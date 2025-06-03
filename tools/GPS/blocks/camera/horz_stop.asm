db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
	STZ $1411|!addr
Return:
	RTL

print "Disable horizontal camera scroll. (Remove graphics in Map16 when finished.)"