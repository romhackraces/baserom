org $01A087
	autoclean JSL throwDirection
	NOP

freecode
throwDirection:
	LDA $15					; \ 
	AND #$01				; | Check to see if "right" is pressed.
	BNE .throwRight			; / 
	LDA $15					; \ 
	AND #$02				; | Check to see if "left" is pressed.
	BNE .throwLeft			; / 
	LDY $76					; \ Restore the original code.
	LDA $187A				; / 
	RTL;
		.throwRight
			LDY #$01		; \ Throw the sprite right.
			LDA $187A
			RTL				; / 
		.throwLeft
			LDY #$00		; \ Throw the sprite left.
			LDA $187A
			RTL				; / 