;~@sa1
;This block will be solid if mario isn't in a pipe, if he is, will let him go
;through this block (mainly use as parts of a pipe that never changes his
;direction).
;Behaves $25 or $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP Return
JMP Return : JMP TopCorner : JMP BodyInside : JMP HeadInside


SpriteV:
SpriteH:
	LDA !Freeram_SSP_PipeDir	;\be a solid block if mario isn't pipe status.
	AND.b #%00001111			;|
	BEQ Return					;/
	LDA !9E,x 		;\
	CMP #$2F 		;| Check for springboard as it's in state 08
	BEQ .Remove		;/

	LDA !14C8,x		;\ Check for carryable state
	CMP #$09 		;/
	BCC Return

.Remove
	STZ !14C8,x		;remove
	RTL

TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\be a solid block if mario isn't pipe status.
	AND.b #%00001111		;|
	BEQ Return			;/
	LDY #$00	;\become passable
	LDA #$25	;|
	STA $1693|!addr	;/
Return:
	RTL

print "Part of pipe that is passable but it but clears held item."