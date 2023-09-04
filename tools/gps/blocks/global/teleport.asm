; act as 25
db $37

JMP Mario : JMP Mario : JMP Mario
JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario
JMP Mario : JMP Mario

Mario:
	%teleport_direct()
Return:
	RTL

print "A block that will teleport Mario to the current screen exit."