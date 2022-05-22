db $37

JMP Return : JMP Return : JMP Return : JMP Sprite
JMP Sprite : JMP Return : JMP Return : JMP Return
JMP Return : JMP Return : JMP Return : JMP Return
Sprite:
	STZ !14C8,x
Return:
	RTL

print "Block that silently kills any sprite."