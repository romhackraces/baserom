db $37

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Fireball
JMP MarioCorner : JMP MarioInside : JMP MarioHead
JMP WallRun : JMP WallFeet

MarioCorner:
MarioAbove:
Return:
MarioSide:
Fireball:
MarioInside:
MarioHead:
WallRun:
WallFeet:
RTL

SpriteV:
	LDA !14C8,x
	SEC : SBC #$09
	CMP #$02
	BCS Return
	LDA !AA,x
	BPL Return
	LDA !1588,x
	AND #$03
	BNE Return
	LDA #$08
    BRA SpriteShared

SpriteH:
	LDA !15A0,x
	BNE Return
	LDA !E4,x
	SEC : SBC $1A
	CLC : ADC #$14
	CMP #$1C
	BCC Return
	%check_sprite_kicked_horiz_alt()
	BCC Return
	LDA #$05

SpriteShared:
	STA !1FE2,x
	%sprite_block_position()

MarioBelow:
Cape:
BlockMain:
	PHX
	PHY
if !bounce_num
	if !bounce_block == $FF
		LDA #!bounce_tile
		STA $02
		LDA.b #!bounce_Map16
		STA $03
		LDA.b #!bounce_Map16>>8
		STA $04
	endif
	LDA #!bounce_num
	LDX #!bounce_block
	LDY #!bounce_direction
	%spawn_bounce_sprite()
	LDA #!bounce_properties
	STA $1901|!addr,y
else
	REP #$10
	LDX #!bounce_Map16
	%change_map16()
	SEP #$10
endif

if !item_memory_dependent
	%set_item_memory()
endif

if !SoundEffect
	LDA #!SoundEffect
	STA !APUPort
endif

	JSR SpawnThing

	PLY
	PLX
RTL
