;; Extended Sprite cape clipping routine
;; input:
;; $00 = X clipping offsets
;; $01 = Width
;; $02 = Y clipping offsets
;; $03 = Height
;; returns: carry set if contact, clear if not
.ExtendedCapeClipping
JSR .ClippingExt
JSR .MarioInteractVal
JSL $03B72B|!BankB
RTL



.ClippingExt					;-----------| Subroutine to get clipping values (B) for an extended sprite.
	LDA $171F|!addr,X			;$02A51C	|
	CLC							;$02A51F	|
	ADC	$00					    ;$02A520	|
	STA $04						;$02A523	|
	LDA $1733|!addr,X			;$02A525	|
	ADC #$00					;$02A528	|
	STA $0A						;$02A52A	|
	LDA $01					    ;$02A52C	|
	STA $06						;$02A52F	|
	LDA $1715|!addr,X			;$02A531	|
	CLC							;$02A534	|
	ADC $02					    ;$02A535	|
	STA $05						;$02A538	|
	LDA $1729|!addr,X			;$02A53A	|
	ADC #$00					;$02A53D	|
	STA $0B						;$02A53F	|
	LDA	$03					    ;$02A541	|
	STA $07						;$02A544	|
	RTS							;$02A546	|

.MarioInteractVal				;-----------| Routine to get interaction values for Mario's cape and net punches. Takes the place of "sprite B".
	LDA.w $13E9|!addr			;$029696	|\ 
	SEC							;$029699	||
	SBC.b #$02					;$02969A	||
	STA $00						;$02969C	|| Get X displacement.
	LDA.w $13EA|!addr			;$02969E	||
	SBC.b #$00					;$0296A1	||
	STA $08						;$0296A3	|/
	LDA.b #$14					;$0296A5	|\\ Width for Mario's capesin and net punch.
	STA $02						;$0296A7	|/
	LDA.w $13EB|!addr			;$0296A9	|\ 
	STA $01						;$0296AC	|| Get Y displacement.
	LDA.w $13EC|!addr			;$0296AE	||
	STA $09						;$0296B1	|/
	LDA.b #$10					;$0296B3	|\\ Height for Mario's capesin and net punch.
	STA $03						;$0296B5	|/
	RTS							;$0296B7	|