db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead

Return:
MarioAbove:
MarioSide:
Fireball:
MarioCorner:
MarioInside:
MarioHead:
RTL

SpriteH:
	%check_sprite_kicked_horizontal()
	BCS SpriteShared
RTL

SpriteV:
	LDA !14C8,x
	CMP #$09
	BCC Return
	LDA !AA,x
	BPL Return
	LDA #$10
	STA !AA,x

SpriteShared:
	%sprite_block_position()

Cape:
MarioBelow:
SpawnItem:
	PHX
	PHY
	LDA #$03
	LDX #$0D
	LDY #$00
	%spawn_bounce_sprite()
	LDA #$00
	STA $1901|!addr,y
	LDA #$02
	STA $1DFC|!addr

	LDA #$85 ; sprite number of the poison mushroom
	CLC

	%spawn_sprite_block()
	TAX
	STZ $00
	STZ $01
	TXA
	%move_spawn_relative()

	LDA #$08
	STA !14C8,x
	LDA #$3E
	STA !1540,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x

	LDA !190F,x
	BPL Return2
	LDA #$10
	STA !15AC,x
Return2:
	PLY
	PLX
RTL

print "Question block that spawns a poison mushroom."