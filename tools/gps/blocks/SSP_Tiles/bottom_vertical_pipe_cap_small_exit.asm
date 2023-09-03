;~@sa1
;This is the bottom cap of a vertical 1-way pipe that
;is exit only for small mario.
;behaves $25 or $130

incsrc "../../../../shared/defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
	LDA !Freeram_SSP_PipeDir	;\do nothing if outside
	AND.b #%00001111		;|
	BEQ return			;/when not in pipe
	CMP #$03			;\exit of going down
	BEQ exit			;|
	CMP #$07			;|
	BEQ exit			;/
within_pipe:
	JSR passable
	RTL
exit:
	REP #$20		;\Don't snap from very far away.
	LDA $98			;|
	AND #$FFF0		;|
	SEC : SBC #$00010	;|
	CMP $96			;|
	SEP #$20		;|
	BCS within_pipe		;/

	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02
	BEQ within_pipe		;/
	LDA #$02		;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR passable		;>become passable while exiting
	LDA.b #!SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario	;\Set timer.
	STA !Freeram_SSP_PipeTmr					;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	JSR center_horiz	;>center the player horizontally

	REP #$20		;\center vertically
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	SEC : SBC #$0010	;|
	STA $96			;|
	SEP #$20		;/
return:
	RTL
center_horiz:
	REP #$20		;\center player to pipe horizontally.
	LDA $9A			;|
	AND #$FFF0		;|
	STA $94			;|
	SEP #$20		;/
	RTS
passable:
	LDY #$00		;\mario passes through the block
	LDA #$25		;|
	STA $1693|!addr		;/
	RTS
print "Bottom exit cap of a pipe for small mario."
