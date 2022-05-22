;~@sa1
;This is the bottom right-half cap of a vertical two-way pipe.
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
	if !Setting_SSP_CarryAllowed != 0
		CMP #$03			;\if going down..
		BEQ exit			;|then exit
		CMP #$07			;|
		BEQ exit			;/
		BRA within_pipe			;>other directions = pass
	else
		;Branch out of bounds with "BEQ exit"
		CMP #$03			;\if going down..
		BNE +
		JMP exit			;|then exit
		+
		CMP #$07			;|
		BNE +
		BEQ exit			;/
		+
		JMP within_pipe			;>other directions = pass
	endif
enter:
	if !Setting_SSP_CarryAllowed == 0
		LDA $1470|!addr		;\no carrying item
		ORA $148F|!addr		;|
		BEQ +
		RTL			;/
		+
	endif
	REP #$20		;\Must be on the correct side to enter.
	LDA $9A			;|
	AND #$FFF0		;|
	if !Setting_SSP_VerticalCapsEnterableWidth != $0008
		CLC
		ADC.w #!Setting_SSP_VerticalCapsEnterableWidth-($0008+1)
	endif
	CMP $94			;|
	SEP #$20		;|
	BCS .MarioOnLeft	;/\Branch out of range.
	RTL			; /
.MarioOnLeft
	LDA $15			;\must press up
	AND #$08		;|\
	BNE .PressUp		;/|Branch out of range
	RTL			; /
.PressUp
	if !Setting_SSP_YoshiAllowed == 0
		LDA $187A|!addr
		BEQ .AllowEnter
		if !Setting_SSP_YoshiProhibitSFXNum != 0
			LDA.b #!Setting_SSP_YoshiProhibitSFXNum
			STA !Setting_SSP_YoshiProhibitSFXPort|!addr
			LDA #$20					;\Prevent SFX playing multiple times.
			STA $7D						;/
		endif
		RTL
		.AllowEnter
	endif
	if !Setting_SSP_CarryAllowed != 0
		LDA $1470|!addr			;\if mario not carrying anything
		ORA $148F|!addr			;|then skip
		BEQ .not_carry			;/
		LDA #$01			;\set carrying flag
		STA !Freeram_SSP_CarrySpr	;/
	endif
	.not_carry
	
	if !Setting_SSP_YoshiAllowed != 0
		PHY			;\
		LDY $187A|!addr		;|Set timer.
		LDA YoshiTimersEnter,y	;|
	else
		LDA.b #!SSP_PipeTimer_Enter_Upwards_OffYoshi
	endif
	STA !Freeram_SSP_PipeTmr	;|
	if !Setting_SSP_YoshiAllowed != 0
		PLY			;/
	endif
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
	RTL
TopCorner:
MarioAbove:
MarioSide:
HeadInside:
BodyInside:
	LDA !Freeram_SSP_PipeDir	;\return for other offset
	AND.b #%00001111		;|
	BNE +
	RTL				;/when not in pipe
	+
	CMP #$03			;\exit of going down
	BEQ exit			;|
	CMP #$07			;|
	BEQ exit			;/
	BRA within_pipe
exit:
	if !Setting_SSP_YoshiAllowed != 0
		LDA $187A|!addr		;\If riding yoshi, do further snap
		BNE .FurtherSnap 	;/
	endif
	REP #$20		;\Don't snap from very far away.
	LDA $98			;|
	AND #$FFF0		;|
	SEC : SBC #$00010	;|
	CMP $96			;|
	SEP #$20		;|
	BCS within_pipe		;/
	
	if !Setting_SSP_YoshiAllowed != 0
		BRA .SkipFurtherSnap
		.FurtherSnap
		REP #$20		;\Don't snap from very far away, yoshi edition.
		LDA $98			;|
		AND #$FFF0		;|
		SEC : SBC #$0020	;|
		CMP $96			;|
		SEP #$20		;|
		BCS within_pipe		;/
	endif
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

	if !Setting_SSP_YoshiAllowed != 0
		LDA $187A|!addr		;\Riding yoshi
		BNE .YoshiExit		;/
	endif

	LDA $19			;\Powerup
	BNE .BigMario		;/

	LDA.b #!SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario		;\Small mario's timer
	BRA .StoreTimer							;/
.BigMario
	LDA.b #!SSP_PipeTimer_Exit_Downwards_OffYoshi_BigMario		;\Big mario's timer
	if !Setting_SSP_YoshiAllowed != 0
		BRA .StoreTimer							;/
		
		.YoshiExit
		LDA $19			;\powerup
		BNE .BigMarioYoshi	;/

		LDA.b #!SSP_PipeTimer_Exit_Downwards_OnYoshi_SmallMario		;\Small on yoshi's timer
		BRA .StoreTimer							;/
		
		.BigMarioYoshi
		LDA.b #!SSP_PipeTimer_Exit_Downwards_OnYoshi_BigMario		;>big on yoshi's timer
	endif
.StoreTimer
	STA !Freeram_SSP_PipeTmr	;>set timer
	LDA #$04		;\pipe sound
	STA $1DF9|!addr		;/
	STZ $7B			;\Prevent centering, and then displaced by xy speeds.
	STZ $7D			;/
	JSR center_horiz	;>center the player horizontally
	if !Setting_SSP_YoshiAllowed != 0
		LDA $187A|!addr
		BNE yoshi_exit
	endif
	REP #$20		;\center vertically
	LDA $98			;|so it doesn't glitch if the bottom
	AND #$FFF0		;|and top caps are touching each other.
	SEC : SBC #$0010	;|
	STA $96			;|
	SEP #$20		;/
return:
	RTL
	if !Setting_SSP_YoshiAllowed != 0
		yoshi_exit:
		REP #$20
		LDA $98
		AND #$FFF0
		SEC : SBC #$0020
		STA $96
		SEP #$20
		RTL
	endif
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

if !Setting_SSP_YoshiAllowed != 0
	YoshiTimersEnter:
	db !SSP_PipeTimer_Enter_Upwards_OffYoshi,!SSP_PipeTimer_Enter_Upwards_OnYoshi,!SSP_PipeTimer_Enter_Upwards_OnYoshi	;>Timers: 1st one = on foot, 2nd and 3rd one = on yoshi
endif
if !Setting_SSP_Description != 0
print "Bottom-right cap piece of vertical 2-way pipe."
endif