;~@sa1
;This is the top cap of a vertical two-way pipe that is only
;enterable as small mario (note that yoshi isn't allowed).
;behaves $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioAbove:			;>mario above only so he cannot enter edge and warp all the way to middle.
	LDA !Freeram_SSP_PipeDir	;\if not in pipe
	AND.b #%00001111		;|then enter
	BEQ enter			;/
	CMP #$01		;\exit if going up
	BEQ exit		;|
	CMP #$05		;|
	BEQ exit		;/
	BRA within_pipe		;>other directions = pass
enter:
	LDA $187A|!addr		;>no yoshi.
	ORA $19			;>no powerup
	BNE return		;>otherwise return
	if !Setting_SSP_CarryAllowed == 0
		LDA $1470|!addr		;\no carrying item
		ORA $148F|!addr		;|
		BNE return		;/
	endif
	LDA $15			;\must press down
	AND #$04		;|
	BEQ return		;/
	if !Setting_SSP_CarryAllowed != 0
		LDA $1470|!addr			;\if mario not carrying anything
		ORA $148F|!addr			;|then skip
		BEQ .NotCarry			;/
		LDA #$01			;\set flag
		STA !Freeram_SSP_CarrySpr	;/
	endif
.NotCarry
	LDA.b #!SSP_PipeTimer_Enter_Downwards_SmallPipe	;\set timer
	STA !Freeram_SSP_PipeTmr			;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 7)
	AND.b #%11110000		;|>Force low nibble clear
	ORA.b #%00000111		;|>Force low nibble set
	STA !Freeram_SSP_PipeDir	;/
	LDA #$01		;\set flag to "entering"
	STA !Freeram_SSP_EntrExtFlg		;/
	JSR center_horiz	;>center the player to pipe
within_pipe:
	JSR passable
return:
	RTL
TopCorner:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\return for other offsets
	AND.b #%00001111		;|when not in pipe
	BEQ return			;/
	CMP #$01			;\exit if going up
	BEQ exit			;|
	CMP #$05			;|
	BEQ exit			;/
	BRA within_pipe
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

print "Top cap of 2-way pipe for small mario."