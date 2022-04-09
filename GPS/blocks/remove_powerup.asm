; Block that removes any powerup from Mario

print "Block that removes any powerup from Mario"

db $42
JMP Mario : JMP Mario : JMP Mario : JMP End : JMP End : JMP End : JMP End
JMP Mario : JMP Mario : JMP Mario

Mario:
	STZ $19		;\ Steal that power
	STZ $0DC2	;/ 
	RTL
End:
	RTL
