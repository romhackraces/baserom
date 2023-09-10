db $42

print "Question block that always spawns a Blue P-Switch/POW."
;print "Spawns sprite $",hex(!Sprite),"."

!Sprite = $3E	; sprite number
!State = $09	; $08 for normal, $09 for carryable sprites
!1540_val = $00	; If you use powerups, this should be $3E
				; Carryable sprites uses it as the stun timer

!Placement = %move_spawn_above_block()
		; Use %move_spawn_above_block() if the sprite should appear above the block, otherwise %move_spawn_into_block()

SwitchPalette: db $06,$02

JMP MarioBelow : JMP Return : JMP Return
JMP SpriteV : JMP SpriteH
JMP Cape : JMP Return
JMP Return : JMP Return : JMP Return

Return:
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
	STA $1901,y

	LDA #$02
	STA $1DFC|!addr

	LDA #!Sprite
	CLC

	%spawn_sprite_block()
	TAX
	!Placement

	; P-Switch specific things
	LDA #$00 ; 00 for blue, 01 for silver
	STA !151C,x
	PHY
	LDY #$00 ; 00 for blue, 01 for silver
	LDA SwitchPalette,y
	STA !15F6,x
	PLY

	LDA #!State
	STA !14C8,x
	LDA #!1540_val
	STA !1540,x
	LDA #$D0
	STA !AA,x
	LDA #$2C
	STA !154C,x

	LDA !190F,x
	BPL +
	LDA #$10
	STA !15AC,x
+
	PLY
	PLX
	RTL