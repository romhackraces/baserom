incsrc "../Defines/ScreenScrollingPipes.asm"
;Reverses the player's pipe direction (for example, if going up, would set his direction to down, right to left, and so on).
	LDA !Freeram_SSP_PipeDir
	AND.b #%00001111		
	BEQ ?Return			;>Failsafe in case if the player somehow make the game execute this routine outside the pipe.
	CMP #$05			;\If Mario was in his cap transitioning, treat as if he is in a stem transitioning.
	BCC ?Already1To4		;|
	SEC				;|
	SBC #$04			;/

	?Already1To4
	DEC				;>Convert possible numbers 1-8 to 0-7.
	TAX				;>Index it
	LDA !Freeram_SSP_PipeDir
	AND.b #%11110000		;>Clear out the low nybble.
	ORA ?SSPFlipTable,x
	
	?Return:
	RTL
	
	?SSPFlipTable
	db $03 ;>Change from up to down
	db $04 ;>From right to left
	db $01 ;>From down to up
	db $02 ;>From left to right
	?.End