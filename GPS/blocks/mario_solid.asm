; Block that is solid to Mario, passable by sprites

print "Block that is solid to Mario, passable by sprites"

db $42
JMP Mario : JMP Mario : JMP Mario : JMP End : JMP End : JMP End : JMP End
JMP Mario : JMP Mario : JMP Mario

Mario:
	LDY #$01	;\
	LDA #$30	;| Act like a cement block
	STA $1693	;/
	RTL
End:
	RTL