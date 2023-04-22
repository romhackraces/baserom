;~@sa1
;this is the left bottom-half cap of a horizontal 2-way pipe.
;behaves $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside


MarioSide:
BodyInside:
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
	BMI return		;/
	if !Setting_SSP_CarryAllowed == 0
		LDA $1470|!addr		;\no carrying item
		ORA $148F|!addr		;|
		BNE return		;/
	endif
	LDA $187A|!addr		;\do not enter pipe when turning
	CMP #$02		;|around on yoshi.
	BEQ return		;/
;	LDA $1471|!addr		;>so vertical centering code works
;	BNE return
	LDA !Freeram_BlockedStatBkp	;\If you are not on ground, return
	AND.b #%00000100		;|
	BEQ return			;/
	LDA $15				;\must press right
	AND #$01			;|
	BEQ return			;/
	LDA $76				;\must face right
	BEQ return			;/
	if !Setting_SSP_YoshiAllowed == 0
		LDA $187A|!addr
		BEQ +
		LDA $16						;\Use 1-frame controller to prevent sound replaying each frame.
		AND #$01					;|(you have to let go the button and tap to trigger this though)
		BEQ return					;/
		LDA #$20
		STA $1DF9|!addr
		RTL
		+
	endif
	if !Setting_SSP_CarryAllowed != 0
		LDA $1470|!addr			;\if mario not carrying anything
		ORA $148F|!addr			;|then skip
		BEQ .not_carry			;/
		LDA #$01			;\set flag
		STA !Freeram_SSP_CarrySpr	;/
	endif
.not_carry
	LDA.b #!SSP_PipeTimer_Enter_Rightwards	;\Set timer.
	STA !Freeram_SSP_PipeTmr		;/
	LDA #$04			;\pipe sound
	STA $1DF9|!addr			;/
	STZ $7B				;\Prevent centering, and then displaced by xy speeds.
	STZ $7D				;/
	LDA !Freeram_SSP_PipeDir	;\Set his direction (Will only force the low nibble (bits 0-3) to have the value 6)
	AND.b #%11110000		;|
	ORA.b #%00000110		;|
	STA !Freeram_SSP_PipeDir	;/
	LDA #$01			;\set flag to "entering"
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR center_vert
within_pipe:
	JSR passable
return:
	RTL
TopCorner:
MarioAbove:
MarioBelow:
HeadInside:
	LDA !Freeram_SSP_PipeDir	;\for other offsets if mario
	AND.b #%00001111		;/
	BEQ return			;/not in pipe
	BRA within_pipe
exit:
	REP #$20
	LDA $9A			;\If mario is touching only the
	AND #$FFF0		;|right side of cap, then don't do
	CLC			;\(this moves the boundary leftwards, due
	ADC #$0004		;/to a bug with $9A doesn't update as fast as $94)
	CMP $94			;|anything except become passable.
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
	STZ $76			;>mario faces left.

	%FaceYoshi()
return1:
	RTL
passable:
	LDY #$00		;\mario passes through the block
	LDA #$25		;|
	STA $1693|!addr		;/
	RTS
center_vert:
	if !Setting_SSP_YoshiAllowed != 0
		LDA $187A|!addr
		BNE yoshi_center
	endif
	REP #$20
	LDA $98
	AND #$FFF0
	SEC : SBC #$0011
	STA $96
	SEP #$20
	RTS
	if !Setting_SSP_YoshiAllowed != 0
		yoshi_center:
		REP #$20
		LDA $98
		AND #$FFF0
		SEC : SBC #$0021
		STA $96
		SEP #$20
		RTS
	endif

print "Bottom-left cap piece of horizontal 2-way pipe."
