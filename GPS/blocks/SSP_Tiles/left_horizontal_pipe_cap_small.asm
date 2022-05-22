;~@sa1
;this is the left cap of a horizontal 2-way pipe that is only
;enterable as small mario (yoshi always not allowed).
;behaves $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"
incsrc "cap_defines.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside


MarioSide:
	LDA !Freeram_SSP_PipeDir	;\If mario isn't in a pipe, the run the enter routine
	AND.b #%00001111		;|
	BEQ enter			;/
	CMP #$04			;\If mario is going outwards from the cap heading left,
	BEQ exit			;|then exit
	CMP #$08			;|
	BEQ exit			;/
	BRA within_pipe			;>Other directions, allow player to pass through without exiting.
enter:
	REP #$20		;\Prevent triggering the block from the right side (if you press right away from block)
	LDA $9A			;|
	AND #$FFF0		;|
	CMP $94			;|
	SEP #$20		;|
	BMI +			;/
	LDA $187A|!addr		;>no yoshi.
	ORA $19			;>no powerup
;	ORA $1471|!addr		;>so vertical centering code works
	BEQ .SmallNoYoshi
	+
	RTL			;>otherwise return
.SmallNoYoshi
	LDA !Freeram_BlockedStatBkp		;\If you are not on ground, return
	AND.b #%00000100		;|
	BNE +
	RTL			;/
	+
if !Setting_SSP_CarryAllowed == 0
	LDA $1470|!addr			;\no carrying item
	ORA $148F|!addr			;|
	BNE Return0			;/
endif
	LDA $15				;\must press right
	AND #$01			;|
	BEQ Return0			;/
	LDA $76				;\must face right
	BEQ Return0			;/
	if !Setting_SSP_CarryAllowed != 0
		LDA $1470|!addr			;\if mario not carrying anything
		ORA $148F|!addr			;|then skip
		BEQ not_carry			;/
		LDA #$01			;\set flag
		STA !Freeram_SSP_CarrySpr	;/
	endif
not_carry:
	LDA.b #!SSP_PipeTimer_Enter_Rightwards	;\Set timer.
	STA !Freeram_SSP_PipeTmr		;/
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 6)
	AND.b #%11110000		;|
	ORA.b #%00000110		;|
	STA !Freeram_SSP_PipeDir	;/
	LDA #$01		;\set flag to "entering"
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR center_vert
TopCorner:
MarioAbove:
HeadInside:
BodyInside:
MarioBelow:
within_pipe:
	JSR passable
Return0:
	RTL
exit:
	REP #$20
	LDA $9A			;\If mario is touching only the
	AND #$FFF0		;|right side of cap, then don't do...
	CLC			;\(this moves the boundary leftwards, due
	ADC #$0004		;/to a bug with $9A doesn't update as fast as $94)
	CMP $94			;|...anything except become passable.
	SEP #$20		;|(So it doesn't snap mario about #$10 pixels)
	BMI within_pipe		;/
	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02			;|
	BEQ within_pipe			;/
	LDA #$02			;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 8)
	AND.b #%11110000		;|>Force low nibble clear
	ORA.b #%00001000		;|>Force low nibble set
	STA !Freeram_SSP_PipeDir	;/
	REP #$20			;\center horizontally so if left and right
	LDA $9A				;|caps are touching each other won't exit
	AND #$FFF0			;|incorrectly.
	STA $94				;|
	SEP #$20			;/
	JSR center_vert			;>Center vertically as exiting horizontal pipe cap
	LDA.b #!SSP_PipeTimer_Exit_Leftwards	;\set exit the pipe timer (same as smw's $7E0088)
	STA !Freeram_SSP_PipeTmr		;/
	JSR passable		;>become passable
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	STZ $76			;>don't exit backwards.
return:
	RTL
passable:
	LDA !Freeram_SSP_PipeDir	;\not in pipe = solid
	AND.b #%00001111		;|
	BEQ solid_out			;/
	LDY #$00		;\mario passes through the block
	LDA #$25		;|
	STA $1693|!addr		;/
solid_out:
	RTS
center_vert:
	LDA $187A|!addr
	BNE yoshi_center
	REP #$20
	LDA $98
	AND #$FFF0
	SEC : SBC #$0011
	STA $96
	SEP #$20
	RTS
yoshi_center:
	REP #$20
	LDA $98
	AND #$FFF0
	SEC : SBC #$0021
	STA $96
	SEP #$20
	RTS
if !Setting_SSP_Description != 0
print "Left cap piece of horizontal 2-way pipe for small mario."
endif