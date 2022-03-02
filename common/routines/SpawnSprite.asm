;Routine that spawns a normal or custom sprite with initial speed at the position (+offset)
;of the calling sprite and returns the sprite index in Y

;Input:  A   = number of sprite to spawn
;        C   = Carry/Custom (CLC = CLear Custom, SEC = SEt Custom :P)
;        $00 = x offset  \
;        $01 = y offset  | you could also just ignore these and set them later
;        $02 = x speed   | using the returned Y.
;        $03 = y speed   /
;
;		 if x and y are negative, those will be subtracted instead of added
;
;Output: Y   = index to spawned sprite (#$FF means no sprite spawned)
;        C   = Carry Set = spawn failed, Carry Clear = spawn successful.

	PHX
	XBA
	LDX #!SprSize-1
	?-
		LDA !14C8,x
		BEQ ?+
			DEX
		BPL ?-
		SEC
		BRA .no_slot
	?+
	XBA
	STA !9E,x
	JSL $07F7D2|!BankB
	
	BCC ?+
		LDA !9E,x
		STA !7FAB9E,x
		
		REP #$20
		LDA $00 : PHA
		LDA $02 : PHA
		SEP #$20
		
		JSL $0187A7|!BankB			; this sucker kills $00-$02
				
		REP #$20
		PLA : STA $02
		PLA : STA $00
		SEP #$20
		
		LDA #$08
		STA !7FAB10,x
	?+
	
	LDA #$01
	STA !14C8,x
	
	TXY
	PLX

	LDA $00					; \
	CLC : ADC !E4,x		; |
	STA.w !E4,y				; | store x position + x offset (low byte)
	LDA #$00					; |
	BIT $00					; | create high byte based on $00 in A and add
	BPL ?+						; | to x position
	DEC						; |
?+	ADC !14E0,x				; |
	STA !14E0,y				; /
		
	LDA $01					; \ 
 	CLC : ADC !D8,x		; |
	STA.w !D8,y				; | store y position + y offset	
	LDA #$00					; |
	BIT $01					; | create high byte based on $01 in A and add
	BPL ?+						; | to y position
	DEC						; |
?+	ADC !14D4,x				; |
	STA !14D4,y				; /
	
	LDA $02					; \ store x speed
	STA.w !B6,y				; /
	LDA $03					; \ store y speed
	STA.w !AA,y				; /	
	
	CLC
	RTL	
	
.no_slot:
	TXY
	PLX
	RTL
