;~@sa1
;This is the top left-half cap of a vertical 1-way pipe.
;(this cap is exit only)
;behaves $25 or $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioAbove:
TopCorner:
MarioSide:
HeadInside:
BodyInside:
MarioBelow:
	LDA !Freeram_SSP_PipeDir	;\return for other offsets
	AND.b #%00001111		;/
	BEQ return		;/when not in pipe
	CMP #$01		;\exit if going up
	BEQ exit		;|
	CMP #$05		;|
	BEQ exit		;/
within_pipe:
	JSR passable
	RTL
exit:
	LDA $19			;\If you're small, don't need to check
	BEQ .Small		;/to avoid snapping y position
	REP #$20		;\When big mario, this prevents snapping
	LDA $98			;|the player upwards to the cap.
	AND #$FFF0		;|
	CLC			;|
	ADC #$0004		;|
	CMP $96			;|
	SEP #$20		;|
	BMI within_pipe		;|
.Small				;/
	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02
	BEQ within_pipe		;/
	LDA #$02		;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR center_horiz	;>center the player horizontally
	JSR passable		;>be passable while exiting

	PHY
	LDY $187A|!addr
	LDA YoshiTimersExit,y
	STA !Freeram_SSP_PipeTmr
	PLY

	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	LDA $187A|!addr		;\+1 block up for yoshi
	BNE .VCenter2		;/
	REP #$20		;\center vertically
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	STA $96			;|
	SEP #$20		;/
	RTL
.VCenter2
	REP #$20		;\center vertically + 1 block up
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	SEC : SBC #$000C	;|
	STA $96			;|
	SEP #$20		;/
return:
	RTL

center_horiz:
	REP #$20		;\center player to pipe horizontally.
	LDA $9A			;|
	AND #$FFF0		;|
	CLC : ADC #$0008	;|
	STA $94			;|
	SEP #$20		;/
	RTS
center_vert:
	REP #$20		;\center vertically (for small/yoshi)
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	STA $96			;|
	SEP #$20		;/
	RTS
passable:
	LDY #$00		;\mario passes through the block
	LDA #$25		;|
	STA $1693|!addr		;/
	RTS

YoshiTimersExit:
	db !SSP_PipeTimer_Exit_Upwards_OffYoshi,!SSP_PipeTimer_Exit_Upwards_OnYoshi,!SSP_PipeTimer_Exit_Upwards_OnYoshi		;>Timers: 1st one = on foot, 2nd and 3rd one = on yoshi

print "Top-left exit cap piece of a vertical pipe."