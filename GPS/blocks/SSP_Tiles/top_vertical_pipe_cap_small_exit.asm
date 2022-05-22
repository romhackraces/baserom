;~@sa1
;This is the top cap of a vertical 1-way pipe that
;is exit only for small mario.
;behaves $25 or $130

incsrc "../../../SSP_Defines.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioAbove:
TopCorner:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\do nothing if outside
	AND.b #%00001111
	BEQ return		;/when not in pipe
	CMP #$01		;\exit if going up
	BEQ exit		;|
	CMP #$05		;|
	BEQ exit		;/
within_pipe:
	JSR passable
	RTL
exit:
	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02
	BEQ within_pipe		;/
	LDA #$02		;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR center_horiz	;>center the player horizontally
	JSR passable		;>be passable while exiting
	LDA.b #!SSP_PipeTimer_Exit_Upwards_OffYoshi	;\Set timer.
	STA !Freeram_SSP_PipeTmr			;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	REP #$20		;\center vertically (for small/yoshi)
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
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
if !Setting_SSP_Description != 0
print "Top exit cap of a pipe for small mario."
endif