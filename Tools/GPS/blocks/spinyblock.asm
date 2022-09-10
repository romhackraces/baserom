; Spiny block by TheBourgyman. Don't forget to make it act as 25 in Lunar Magic's 16x16 Tile Map Editor.

print "A block that acts like a mid-air suspended Spiny."

db $42

JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

!fireballcoin = 0		; Set to 1 to have the block spawn a coin when killed by a fireball.

Bounce:
	LDA $14A8|!addr		; Check unused timer to see if Mario should bounce off the block.
	BEQ +				; If it's still going, skip interaction entirely.
	RTL
+	LDA $140D|!addr		; Check if Mario is spin jumping.
	ORA $187A|!addr		; Check if Mario is riding Yoshi.
	BNE +				; If he does one of those things, skip ahead.
	JML $00F5B7|!bank	; Hurt Mario if he does neither.
+	LDA #$D0			; Give low vertical up speed to player.
	BIT $15				; Test controller bits.
	BPL +				; Skip ahead if the player is not holding A or B.
	LDA #$A8			; Give high vertical up speed to player.
+	STA $7D
	LDA #$02			; Play sound "Enemy defeated by a spin jump".
	STA $1DF9|!addr
	LDA #$08			; Make Mario not interact with the spiny again for 8 frames.
	STA $14A8|!addr
	JML $01AB99|!bank	; Write the contact graphics for the spin jump.
	
MarioSide:				; Make the block's hitbox one pixel narrower (like Munchers).
	REP #$20			; Make A 16 bit.
	LDA $9A				; Check the collision X position currently being processed.
	AND #$FFF0			; Remove the four lowest bits (00-0F).
	SEC
	SBC #$000E			; Subtract 000E.
	CMP $94				; Compare with the value in $94 (Player's X position within the level)
	BCS Return			; If the carry is still set, Return.
	CLC					; Clear carry.
	ADC #$001A			; Add 1A.
	CMP $94
	BCC Return			; If the carry is still set, Return.
	SEP #$20
	
	LDA $1490|!addr		; Check if Mario has a star.
	ORA $13ED|!addr		; Check if Mario is landing with a cape, or sliding.
	BNE Star			; If he does, ignore the modified hitbox below.
	

TopCorner:
MarioAbove:
	LDA $1490|!addr		; Check if Mario has a star.
	ORA $13ED|!addr		; Check if Mario is landing with a cape, or sliding.
	BNE Star			; If he does, destroy block.
	BRA Bounce			; If not, go to bounce.

SpriteV:
SpriteH:
	LDA !9E,x			; Load the sprite's number.
	CMP #$53			; Check for throw block.
	BEQ +				; Skip ahead if it is.
	CMP #$11			; Check for Koopa, Goomba and Bob-Omb (also keyhole, but that won't have any effect)
	BCS Return			; If not any of them, return.
	LDA !14C8,x			; Check the state of the sprite.
	CMP #$09			; Is it stationary/carryable?
	BCC Return			; If not, return.
+	%sprite_block_position()	; Run routine to check which block to destroy.
	%row_points()		; Give points to the player.
	%erase_block()		; Erase block.
	%create_smoke()		; Create smoke effect.
	LDA !14C8,x			; Check the state of the sprite again.
	CMP #$0B			; Is the sprite currently being carried?
	BNE Return			; If not, return.
	LDA #$02
	STA !14C8,x			; KIll the sprite.
	LDA #$D0
	STA !AA,x			; Give some upward speed to make the sprite bounce after dying.
	LDA $7B
	STA !B6,x			; Give it Mario's X speed after dying.
	RTL

MarioFireball:
	STZ $170B|!addr,x	; Remove fireball making contact.
if !fireballcoin
	LDA #$21
	CLC
	%spawn_sprite()
	BCS +
	%move_spawn_into_block()
	LDA #$D0
	STA !AA,x
+
endif

	
MarioCape:
	%hundred_points()	; Give points to the player.
	BRA Poof
Star:
	%star_points()		; Give points to the player.
Poof:
	%erase_block()		; Erase block.
	%create_smoke()		; Create smoke effect.

Return:
	SEP #$20			; Make A 8 bit.
	RTL

MarioBelow:
	LDA $1490|!addr		; Check if Mario has a star.
	ORA $13ED|!addr		; Check if Mario is landing with a cape, or sliding.
	BNE Star			; If he does, destroy block.
	LDA $187A|!addr		; Check if Mario is riding Yoshi.
	BNE Return			; Return if he does.
	PHY
	JSL $00F5B7|!bank	; Hurt subroutine.
	PLY
	RTL
	
HeadInside:
	REP #$20			; Make A 16 bit.
	LDA $9A				; Check the collision X position currently being processed.
	AND #$FFF0			; Remove the four lowest bits (00-0F).
	SEC
	SBC #$000E			; Subtract 000E.
	CMP $94				; Compare with the value in $94 (Player's X position within the level)
	BCS Return			; If the carry is still set, Return.
	CLC	
	ADC #$001A			; Add 1A with carry.
	CMP $94				; Compare with $94.
	BCC Return			; If the carry is clear, Return.
	SEP #$20			; Make A 8 bit.
	
BodyInside:
	LDA $1490|!addr		; Check if Mario has a star.
	ORA $13ED|!addr		; Check if Mario is landing with a cape, or sliding.
	BNE Star			; If he does, destroy block.
	LDA $1497|!addr		; Check if Mario has i-frames.
	BNE Return			; If he does, skip interaction entirely.
	LDA $187A|!addr		; Check if Mario is riding Yoshi.
	BEQ Damage			; Go to Damage if not the case.
	LDX $18DF|!addr		; Get Yoshi's sprite slot plus 1.
	DEX					; Decrement to get the actual slot.
	BEQ Damage			; Return if for some reason, Yoshi is not found.

if !sa1					; Code stolen from Koopster. If Mario rides Yoshi, lose him when touching the block, instead of just dying.
	REP #$20
	TXA					; Koopster: "sa-1 uses pointers in certain sprites rather than the addresses themselves
	CLC					; due to spacing issues. this code stores the y position address to the
	ADC #$3216			; pointer that the code we'll jslrts to uses. due to using jslrts rather
	STA $CC				; than rewriting the routine, this workaround is needed".
	SEP #$20
endif
	
	PEA $01|(PushReturn>>16<<8)	; Push current bank then bank $01.
	PLB					; Pull $01 to data bank register.
	
	PHK
	PEA PushReturn-1
	PEA $80CA-1			; Koopster: "jslrts to yoshi runs away routine to force it to happen".
	JML $01F70E|!bank
	
PushReturn:				; Restore our data bank register.
	PLB
	
Damage:
	LDA $14A8|!addr		; Check unused timer to see if Mario should take damage.
	BNE Return			; If it's still going, return.
	PHY
	JSL $00F5B7|!bank	; Hurt subroutine.
	PLY
	RTL