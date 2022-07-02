!frames = $04

!freeram1 = $1DFD|!addr
!freeram2 = $1DFE|!addr
!switch   = $14AF|!addr

init:
	LDA !switch
	STA !freeram1
	STZ !freeram2
	RTL

main:
	LDA $9D			;\ If the game is frozen, return.
	ORA $13D4|!addr		;|
	BNE .Return		;/
	LDA !freeram2		;\ If the timer isn't ticking, check the switch state.
	BEQ .CheckSwitched	;/
	DEC !freeram2		; Otherwise, tick the timer...
	LDA !freeram1		;\ ...and keep the switch state constant.
	STA !switch		;/
	RTL
.CheckSwitched
	LDA !switch		;\ If the switch state wasn't changed, return.
	CMP !freeram1		;|
	BEQ .Return		;/
.SetTimer
	LDA #!frames		;\ Otherwise, initialize the timer...
	STA !freeram2		;/
	LDA !switch		;\ ...and backup the switch state.
	STA !freeram1		;/
.Return
	RTL
