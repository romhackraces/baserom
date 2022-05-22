;~@sa1
;This is the bottom right-half cap of a vertical 1-way pipe.
;(this cap is exit only).
;behaves $25 or $130

incsrc "../../../Defines/ScreenScrollingPipes.asm"

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP return : JMP return : JMP return
JMP return : JMP TopCorner : JMP BodyInside : JMP HeadInside

ReturnShort:
	RTL

MarioBelow:
TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
	LDA !Freeram_SSP_PipeDir	;\do nothing if outside
	AND.b #%00001111		;|
	BEQ ReturnShort			;/when not in pipe
	CMP #$03		;\exit of going down
	BEQ exit		;|
	CMP #$07		;|
	BEQ exit		;/
within_pipe:
	JSR passable
	RTL
exit:
	LDA $187A|!addr		;\If riding yoshi, do further snap
	BNE .FurtherSnap 	;/
	REP #$20		;\Don't snap from very far away.
	LDA $98			;|
	AND #$FFF0		;|
	SEC : SBC #$0010	;|
	CMP $96			;|
	SEP #$20		;|
	BCS within_pipe		;/
	BRA .SkipFurtherSnap
.FurtherSnap
	REP #$20		;\Don't snap from very far away, yoshi edition.
	LDA $98			;|
	AND #$FFF0		;|
	SEC : SBC #$0020	;|
	CMP $96			;|
	SEP #$20		;|
	BCS within_pipe		;/
.SkipFurtherSnap
	LDA !Freeram_SSP_EntrExtFlg	;\do nothing if already exiting pipe
	CMP #$02
	BEQ within_pipe		;/
	LDA #$02		;\set exiting flag
	STA !Freeram_SSP_EntrExtFlg	;/
	JSR passable		;>become passable while exiting

;offset notes:
;timer = 0E if small mario
;timer = 1B if super
;timer = 18 if small on yoshi 
;timer = 25 if super on yoshi

	LDA $187A|!addr		;\Riding yoshi
	BNE .YoshiExit		;/

	LDA $19			;\Powerup
	BNE .BigMario		;/

	LDA.b #!SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario		;\Small mario's timer
	BRA .StoreTimer							;/
.BigMario
	LDA.b #!SSP_PipeTimer_Exit_Downwards_OffYoshi_BigMario		;\Big mario's timer
	BRA .StoreTimer							;/
.YoshiExit
	LDA $19			;\powerup
	BNE .BigMarioYoshi	;/

	LDA.b #!SSP_PipeTimer_Exit_Downwards_OnYoshi_SmallMario		;\Small on yoshi's timer
	BRA .StoreTimer							;/
.BigMarioYoshi
	LDA.b #!SSP_PipeTimer_Exit_Downwards_OnYoshi_BigMario		;>big on yoshi's timer
.StoreTimer
	STA !Freeram_SSP_PipeTmr	;>set timer
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	JSR center_horiz	;>center the player horizontally

	LDA $187A|!addr
	BNE yoshi_exit

	REP #$20		;\center vertically
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	SEC : SBC #$0010	;|
	STA $96			;|
	SEP #$20		;/
return:
	RTL
yoshi_exit:
	REP #$20
	LDA $98
	AND #$FFF0
	SEC : SBC #$0020
	STA $96
	SEP #$20
	RTL
center_horiz:
	REP #$20		;\center player to pipe horizontally.
	LDA $9A			;|
	AND #$FFF0		;|
	SEC : SBC #$0008	;|
	STA $94			;|
	SEP #$20		;/
	RTS
passable:
	LDY #$00		;\mario passes through the block
	LDA #$25		;|
	STA $1693|!addr		;/
	RTS

if !Setting_SSP_Description != 0
print "Bottom-right exit cap piece of a vertical pipe."
endif