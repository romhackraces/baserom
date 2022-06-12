db $37

print "Block with infinite supply of throwblocks."

!Sprite = $53
!State = $0B

JMP Mario : JMP Mario : JMP Mario : JMP Return
JMP Return : JMP Return : JMP Return : JMP Mario
JMP Mario : JMP Mario : JMP Return : JMP Return

Mario:
	LDA $1470|!addr		; is player carrying an item
	ORA $148F|!addr		; or is player carrying an item
	ORA $187A|!addr		; or is player on yoshi
	ORA $74				; or is player climbing
	BNE Return
checkInput:
	LDA $15
	BIT #$40
	BEQ Return
spawnSprite:
	LDA #!Sprite
	CLC
	%spawn_sprite()
	BCS Return
	%move_spawn_into_block()
	LDA #!State
	STA !14C8,x
	LDA #$FF
	STA !1540,x
Return:
	RTL