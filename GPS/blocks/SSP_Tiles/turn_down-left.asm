;~@sa1
;This is the corner piece of the pipe that changes mario's
;direction from down to left or right to up.
;Behaves $25 or $130

incsrc "../../../SSP_Defines.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP Return : JMP Return : JMP Return
JMP Return : JMP TopCorner : JMP BodyInside : JMP HeadInside

TopCorner:
MarioAbove:
MarioSide:
HeadInside:
MarioBelow:
BodyInside:
	;Check pipe state
		LDA !Freeram_SSP_PipeDir	;\If not in pipe mode, Return as being a solid block
		AND.b #%00001111		;|
		BEQ Return			;/
	;Render passable
		LDY #$00			;\Become passable when in pipe.
		LDX #$25			;|
		STX $1693|!addr			;/
	;Check if the block should be merely passable.
		CMP #$09			;\If traveling in any direction, do nothing except be passable.
		BCS Return			;/
	;Adjust player pipe travel direction and centering
		JSR DistanceFromTurnCornerCheck
		BCC Return
		
		LDA !Freeram_SSP_PipeDir	;\Get current direction
		AND.b #%00001111		;/
		CMP #$03			;\If going down, translate to left
		BEQ down_to_left		;|
		CMP #$07			;|
		BEQ down_to_left		;/
		CMP #$02			;\If going right, translate to up
		BEQ right_to_up			;|
		CMP #$06			;|
		BEQ right_to_up			;/
Return:
	RTL
down_to_left:
	LDA $187A|!addr		;\Only snap the player should the player's feet or yoshi touches the bottom of the turning left part.
	ASL			;|
	TAX			;|
	REP #$20		;|
	LDA $98			;|
	AND #$FFF0		;|
	SEC			;|
	SBC YoshiPositioning,x	;|
	CMP $96			;|
	SEP #$20		;|
	BMI +			;|
	RTL			;/
	+
	LDA !Freeram_SSP_PipeDir	;\Set direction
	AND.b #%11110000		;|
	ORA.b #%00000100		;|
	STA !Freeram_SSP_PipeDir	;/
	JSR corner_center		;>and snap player
	RTL
right_to_up:
	REP #$20		;\Don't center and change direction until the player is centered close enough (about to go past it).
	LDA $9A			;|
	AND #$FFF0		;|
	SEC			;|
	SBC #$0008		;|
	CMP $94			;|
	SEP #$20		;|
	BMI +			;|
	RTL			;/
	+
	LDA !Freeram_SSP_PipeDir	;\Set direction
	AND.b #%11110000		;|
	ORA.b #%00000001		;|
	STA !Freeram_SSP_PipeDir	;/
	JSR corner_center		;>and snap player
	RTL
corner_center:
	REP #$20		;\center player to pipe horizontally.
	LDA $9A			;|
	AND #$FFF0		;|
	SEC : SBC #$0008	;|
	STA $94			;|
	SEP #$20		;/
	LDA $187A|!addr		;\center differently if on yoshi
	BNE yoshi_center	;/
	REP #$20		;\center vertically as no yoshi
	LDA $98			;|
	AND #$FFF0		;|
	SEC : SBC #$0011	;|
	STA $96			;|
	SEP #$20		;/
	RTS
yoshi_center:
	REP #$20		;\center vertically as on yoshi
	LDA $98			;|
	AND #$FFF0		;|
	SEC : SBC #$0021	;|
	STA $96			;|
	SEP #$20		;/
	RTS
solid_out:
	RTS
	
YoshiPositioning:
	dw $0010,$0028,$0028
	;^You might've noticed that this is different compared to all other turn pipes.
	; this is because there is a problem with yoshi's collision points when big
	; mario is on yoshi traveling downwards on this block when there is a solid
	; platform below it to not  trigger this block (which causes the player to get
	; stuck trying to head downwards before turning).

	DistanceFromTurnCornerCheck:
	;Prevents such glitches where as the player leaves a special turn corner
	;and activates a special direction block while touching the previous corner
	;would cause the player to travel in the wrong direction.
	;
	;$00-$03 holds the position "point" on Mario/yoshi's feet:
	;$00-$01 is the X position in units of block
	;$02-$03 is Y position in units of block
	;
	;AND #$FFF0 rounds DOWN to the nearest #$0010 value
	;Carry is set if the player's position point is inside the block and clear if outside.
	
	LDA $187A|!addr		;\Yoshi Y positioning
	ASL			;|
	TAX			;/
	
	REP #$20
	LDA $94				;\Get X position (due to some positioning lag a frame behind, this is 2 pixels to the right from center)
	CLC				;|
	ADC #$0008			;|
	AND #$FFF0			;|
	STA $00				;/
	LDA $96				;\Get Y position
	CLC				;|
	ADC FootDistanceYpos,x		;|
	AND #$FFF0			;|
	STA $02				;/
	
	LDA $9A				;\if X position point is within this block
	AND #$FFF0			;|
	CMP $00				;|
	BNE +				;/
	LDA $98				;\if Y position point is within this block
	AND #$FFF0			;|
	CMP $02				;|
	BNE +				;/
	SEC
	SEP #$20
	RTS
	+
	CLC
	SEP #$20
	RTS
	FootDistanceYpos:
	dw $0018, $0028, $0028
if !Setting_SSP_Description != 0
print "Changes the pipe direction from down to left or right to up."
endif