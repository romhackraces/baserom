; Block that is solid to sprites, passable by Mario

print "Block that is solid to sprites, passable by Mario"

db $42
JMP Mario : JMP Mario : JMP Mario : JMP Sprite : JMP Sprite : JMP End : JMP End
JMP End : JMP End : JMP End

Sprite:
	LDA #$30  ;\
	STA $1693 ;| Act like a cement block
	LDY #$01  ;/
Mario:
End:
	RTL 