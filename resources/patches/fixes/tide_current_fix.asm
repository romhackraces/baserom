;patch by Koopster.

;sa-1

!bank = $800000

if read1($00FFD5) == $23
	sa1rom
	!bank = $000000
endif

;hijacks

org $00DA58
	autoclean JML WalkSpeed		;\this controls player walking speed
	NOP							;/when under a tide
End1:

org $00DA71
	JML AccLeft		;this controls the auto speed given to the player
End2:

org $00DA79
End3:

;patch

freedata

WalkSpeed:
	BEQ Return		;original check
	TAY				;preserve accumulator
	JSR TideCheck	;run extra check
	BMI NoWalkSpeed	;skip if not below the tide
	TYA				;restore it
	CLC				;\
	ADC #$04		;/original code
	JML End1|!bank

NoWalkSpeed:
	TYA
Return:
	JML End1|!bank

AccLeft:
	JSR TideCheck	;run our check here too
	BMI NoAccLeft	;skip if not below the tide
	LDX #$1E		;\
	LDA $72			;/original code
	JML End2|!bank

NoAccLeft:
	JML End3|!bank

TideCheck:		;above tides = negative, below tides = positive
	REP #$21
	LDA $80			;player y position within the screen
	ADC $24			;tide height within the screen
	CMP #$00E8		;where the tide starts taking effect. not a smw value, I tuned this myself!
	SEP #$20
	RTS 