;~@sa1
;This block will be solid if mario isn't in a pipe, if he is, will let him go
;through this block (mainly use as parts of a pipe that never changes his
;direction).
;Behaves $25 or $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside



TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\be a solid block if mario isn't pipe status.
	AND.b #%00001111		;|
	BEQ return			;/
	LDY #$00	;\become passable
	LDA #$25	;|
	STA $1693|!addr	;/
return:
	RTL

print "Part of pipe that is passable."
