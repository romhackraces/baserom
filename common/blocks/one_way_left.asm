;If anything tries to go through the block going right, it will block it,
;otherwise it will let them pass.
;behaves $25

!using_boost	= 0		;>if you are using boost blocks, set this to 1
				;so mario cannot glitch through them in the opposite
				;direction

print "Solid if anything goes right"
db $37
JMP return : JMP return : JMP Check : JMP return : JMP SpriteH : JMP return
JMP MarioFireBall : JMP return : JMP Check : JMP Check : JMP wall : JMP Check

wall:
	LDA $13E3|!addr
	CMP #$07
	BEQ solid
	RTL
Check:			;>so mario wouldn't "vibrate" should there be a boost next to it.
if !using_boost > 0		;>if this statement is true, then include this:
	LDA $7B			;\if the player is going to the right
	CMP #$35		;|very fast..
	BCC playeroneway	;|
	CMP #$80		;|
	BCS playeroneway	;/
	REP #$20		;\..prevent the boosted player from going through
	LDA $9A			;|this block in the opposite direction.
	AND #$FFF0		;|
	SEC : SBC #$000E	;|
	STA $94			;|
	SEP #$20		;|
	STZ $7B			;/
	RTL
playeroneway:
endif
	REP #$20		;\compare mario's position and the block
	LDA $9A			;|(so it won't solid if mario moves
	AND #$FFF0		;|right while directly *inside* the block)
	SEC : SBC #$0009	;|
	CMP $94			;|
	SEP #$20		;|
	BCC return		;/
	BRA solid
MarioFireBall:
	LDA $1747|!addr,x		;\solid to right-moving fireballs
	BPL solid		;/
	RTL
SpriteH:
	LDA !B6,x		;\if going left, then return
	BMI return		;/
	LDA !14C8,x		;\If sprite not carryable, ignore code below
	CMP #$09		;|
	BNE +			;/
	;Prevent pulling dropped sprites in the direction opposite of 1-way:
	;
	;$0A-$0B = sprite X pos the block is touching (Much like $9A-$9B)
	;$0C-$0D = Sprite Y pos the block is touching (Much like $98-$99)
	LDA !E4,x		;\Sprite X position
	STA $00			;|
	LDA !14E0,x		;|
	STA $01			;/
	REP #$20
	LDA $0A			;
	AND #$FFF0		;>round down to nearest 16th pixel (divide by 16, round down, then multiply by 16), this is the grid block position
	CMP $00			;>Compare with sprite's x position
	SEP #$20
	BMI return		;>If block is too far to the left (sprite to the right) far enough, don't push sprite.
	
	LDA $0A			;\Teleport sprite to the front of the block.
	AND #$F0		;|
	SEC			;|
	SBC #$0A		;|
	STA !E4,x		;|
	LDA $0B			;|
	SBC #$00		;|
	STA !14E0,x		;/
	+
solid:
	LDY #$01		;\become solid
	LDA #$30		;|
	STA $1693|!addr		;/
return:
	RTL