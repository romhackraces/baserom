
; Gets the OAM index to be used, deletes when off screen, etc.


	LDA.l .OAMPtr,x
	TAY
   
.noIndex
	LDA $1747|!Base2,x
	AND #$80
	EOR #$80
	LSR
	STA $00
	LDA $171F|!Base2,x
	SEC
	SBC $1A
	STA $01
	LDA $1733|!Base2,x
	SBC $1B
	BNE .erasespr
	LDA $1715|!Base2,x
	SEC
	SBC $1C
	STA $02
	LDA $1729|!Base2,x
	ADC $1D
	BEQ .neg
	LDA $02
	CMP #$F0
	BCS .erasespr
	RTL
.neg
	LDA $02
	CMP #$C0
	BCC .erasespr
	CMP #$E0
	BCC .hidespr
	RTL
.erasespr
	STZ $170B|!Base2,x	; delete sprite.
.hidespr
	LDA #$F0	; prevent OAM flicker
	STA $02
+	RTL

.OAMPtr
   db $90,$94,$98,$9C,$A0,$A4,$A8,$AC
