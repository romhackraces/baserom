db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return

Mario:
	STZ $1412|!addr
Return:
	RTL

print "Disable vertical camera scroll. (Remove graphics in Map16 when finished.)"