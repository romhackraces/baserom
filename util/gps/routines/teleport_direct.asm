; A teleport routine which ACTUALLY teleports Mario.
; Unlike the method used on SMWC (which uses the pipe animation set to animation
; timer to 0 to prevent to play the animation an teleport Mario instantly),
; this teleports Mario directly.

; Input:
; A should be set to be 8-bit (except if X < 0)
; X = 0: Uses Mario's position to determine the teleport destination (vanilla behaviour)
; X > 0: Uses the block's position to determine the teleport destination
; X < 0: Hardcoded destination, uses A (16-bit) as the input (same format as the exit table)
; Clobbers:
; A (also set to 8-bit mode if X < 0), X

	CPX #$00			; Failsafe
	BEQ .TeleportMario
	BPL .BlockPosition
	
.FixedTeleport:
	SEP #$20			; A = 8-bit
	PHA					;\
	LDX $95				; |
	LDA $5B				; |
	LSR					; | Get the screen position
	PLA					; |
	BCC +				; |
	LDX $97				;/

+	STA $19B8|!addr,x	;\
	XBA					; | Set the teleport destination (in A)
	STA $19D8|!addr,x	;/
BRA .TeleportMario

.BlockPosition:
	PHA					;\
	LDX $95				; |
	LDY $9B				; |
	LDA $5B				; |
	LSR					; | Get the screen position
	PLA					; |
	BCC +				; |
	LDX $97				; |
	LDX $99				;/

+	LDA $19B8|!addr,y	;\
	STA $19B8|!addr,x	; | Copy the block's teleport destination
	LDA $19D8|!addr,y	; | to Mario's screen.
	STA $19D8|!addr,x	;/
.TeleportMario:
	STZ $15				;\
	STZ $16				; | Disable Mario's controls
	STZ $17				; |
	STZ $18				;/
	LDA #$0D			;\ Enter door animation
	STA $71				;/ (actually do nothing)
	INC $141A|!addr		; Increment the level counter
	LDA #$0F			; 
	STA $0100|!addr		;
RTL
