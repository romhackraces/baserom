;~@sa1
;Note that ram address $7FAB10 ($400040 SA-1) are uninitialized when not using a custom sprite.
;Thus certain emulators may fail on running this code.
	LDA $187A|!addr	;\If not riding yoshi, return
	BEQ +		;/
	PHX		;\Push stack
	PHA		;|
	PHY		;/

	if !sa1 == 0
		LDX.b #22-1	;>Number of sprite slots
	else
		LDX.b #12-1	;>Number of sprite slots
	endif

	-
	LDA !7FAB10,x	;\If custom sprite, next slot
	AND #$08	;|
	BNE ++		;/
	LDA !9E,x	;\If other than yoshi, next slot
	CMP #$35	;|
	BNE ++		;/

	STZ !157C,x		;>default facing direction right
;	LDA $007B+!dp		;\If going foward in the direction yoshi facing,
;	BPL ++			;/don't alter facing
	LDA !Freeram_SSP_PipeDir	;>Direction
	CMP #$02		;\Rightwards
	BEQ +++			;|
	CMP #$06		;|
	BEQ +++			;/
	CMP #$04		;\Leftwards
	BEQ ++++		;|
	CMP #$08		;|
	BEQ ++++		;/
	BRA ++			;>Other directions

	+++
	STZ !157C,x		;>Face right
	BRA ++

	++++
	LDA #$01		;\Face left
	STA !157C,x		;/

;(still checks all slots in case if a double yoshi glitch...)
	++
	DEX		;>Next slot/index
	BPL -		;>If zero or positive, loop back

	PLY		;\Pull stack
	PLA		;|
	PLX		;/

	+
	RTL