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
if !EXLEVEL
	PHA
	SEP #$30
	JSL $03BCDC|!bank
	PLA
	STA $19B8|!addr,x
	PLA
	ORA #$04
	STA $19D8|!addr,x
else
	SEP #$20			; A = 8-bit
	PHA					;\
	LDX $95				; |
	LDA $5B				; |
	LSR					; | Get the screen position
	PLA					; |
	BCC +				; |
	LDX $97				;/
+
	STA $19B8|!addr,x	;\
	XBA					; | Set the teleport destination (in A)
	ORA #$04
	STA $19D8|!addr,x	;/
endif

BRA .TeleportMario

.BlockPosition:
if !EXLEVEL
	REP #$20
	LDA $96
	PHA
	LDA $94
	PHA
	LDA $98
	STA $96
	LDA $9A
	STA $94
	SEP #$20
	JSL $03BCDC|!bank
	REP #$20
	PLA
	STA $94
	PLA
	STA $96
	PHX
	JSL $03BCDC|!bank
	PLY
else
	PHA					;\
	LDX $95				; |
	LDY $9B				; |
	LDA $5B				; |
	LSR					; | Get the screen position
	PLA					; |
	BCC +				; |
	LDX $97				; |
	LDX $99				;/

+
endif
	LDA $19B8|!addr,y	;\
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
