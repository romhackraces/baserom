;~@sa1
;This is the bottom cap of a vertical two-way pipe that is only
;enterable as small mario (note that yoshi always not allowed).
;behaves $130

incsrc "../../../SSP_Defines.asm"
incsrc "cap_defines.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\if not in pipe
	AND.b #%00001111		;|
	BEQ enter			;/then enter
	CMP #$03			;\if going down..
	BEQ exit			;|then exit
	CMP #$07			;|
	BEQ exit			;/
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
	LDA $15			;\must press up
	AND #$08		;|
	BEQ return		;/
	if !Setting_SSP_CarryAllowed != 0
		LDA $1470|!addr			;\if mario not carrying anything
		ORA $148F|!addr			;|then skip
		BEQ .not_carry			;/
		LDA #$01			;\set carry flag
		STA !Freeram_SSP_CarrySpr	;/
	endif
.not_carry
	LDA.b #!SSP_PipeTimer_Enter_Upwards_OffYoshi	;\set timer
	STA !Freeram_SSP_PipeTmr			;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 5)
	AND.b #%11110000		;|>Force low nibble clear
	ORA.b #%00000101		;|>Force low nibble set
	STA !Freeram_SSP_PipeDir	;/
	LDA #$01		;\set flag to "entering"
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR center_horiz	;>center the player to pipe horizontally
within_pipe:
	JSR passable
return:
	RTL
TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
	LDA !Freeram_SSP_PipeDir	;\return for other offset
	AND.b #%00001111		;|
	BEQ return			;/when not in pipe
	CMP #$03			;\exit of going down
	BEQ exit			;|
	CMP #$07			;|
	BEQ exit			;/
	BRA within_pipe
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
print "Bottom cap of 2-way pipe for small mario."
endif