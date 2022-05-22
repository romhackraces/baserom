;~@sa1
;this is the right bottom-half cap of a horizontal 1-way pipe, can
;be used as a small pipe and normal-sized pipe cap.
;behaves $25 or $130

incsrc "../../../SSP_Defines.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside


MarioSide:
	LDA !Freeram_SSP_PipeDir	;\for other offsets if mario
	AND.b #%00001111		;|not in pipe
	BEQ return			;/
	CMP #$02			;\if going right
	BEQ exit			;|then exit
	CMP #$06			;|
	BEQ exit			;/
TopCorner:
MarioAbove:
HeadInside:
BodyInside:
MarioBelow:
within_pipe:
	JSR passable
	RTL
exit:
	REP #$20
	LDA $9A			;\If mario is touching only the
	AND #$FFF0		;|right side of cap, then don't do...
	SEC			;\(this moves the boundary leftwards, due
	SBC #$0004		;/to a bug with $9A doesn't update as fast as $94)
	CMP $94			;|...anything except becomme passable.
	SEP #$20		;|(So it doesn't snap mario about #$10 pixels)
	BPL within_pipe		;/
	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02			;|
	BEQ within_pipe			;/
	LDA #$02		;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 6)
	AND.b #%11110000		;|
	ORA.b #%00000110		;|
	STA !Freeram_SSP_PipeDir	;/
	REP #$20			;\center horizontally so if left and right
	LDA $9A				;|caps are touching each other won't exit
	AND #$FFF0			;|incorrectly.
	STA $94				;|
	SEP #$20			;/
	JSR center_vert			;>Center vertically as exiting horizontal pipe cap
	LDA.b #!SSP_PipeTimer_Exit_Rightwards	;\set exit the pipe timer (same as smw's $7E0088)
	STA !Freeram_SSP_PipeTmr		;/
	JSR passable		;>become passable
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	LDA #$01		;\don't exit backwards.
	STA $76			;/
	%FaceYoshi()
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
print "Bottom-right/right cap exit piece of horizontal pipe."
endif