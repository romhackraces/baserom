
;; Gets the OAM index to be used, deletes when off screen, etc.
;; ExtGetDraw_NoIndex variation to be used if handling OAM through alternate methods.
OAMPtr:	db $90,$94,$98,$9C,$A0,$A4,$A8,$AC

ExtGetDrawInfo2:
	LDY.w OAMPtr,x
ExtGetDraw2_NoIndex:
	LDA $1747|!addr,x
	AND #$80
	EOR #$80
	LSR
	STA $00
	LDA $171F|!addr,x
	SEC
	SBC $1A
	STA $01
	LDA $1733|!addr,x
	SBC $1B
	BNE .erasespr
+	LDA $1715|!addr,x
	SEC
	SBC $1C
	STA $02
	LDA $1729|!addr,x
	ADC $1D
	BEQ .neg
	LDA $02
	CMP #$F0
	BCS .erasespr
	RTS
.neg	LDA $02
	CMP #$C0
	BCC .erasespr
	CMP #$E0
	BCC .hidespr
	RTS
.erasespr
	STZ $170B|!addr,x	; delete sprite.
.hidespr
	LDA #$F0	; prevent OAM flicker
	STA $02
+	RTS

;; sprite x + y speed handler; has gravity.
SpriteSpd:
	LDA $173D|!base2,x
	CMP #$40
	BPL SpriteSpdNoGravity
	CLC
	ADC #$03
	STA $173D|!base2,x

;; sprite x + y speed handler; no gravity.
SpriteSpdNoGravity:
	JSR SpriteYSpd

;; original sprite x speed handler.
SpriteXSpd:
	PHK
	PEA.w .donex-1
	PEA.w $B889-1
	JML $02B554|!base3
.donex	RTS

;; original sprite y speed handler.
SpriteYSpd:
	PHK
	PEA.w .doney-1
	PEA.w $B889-1
	JML $02B560|!base3
.doney	RTS

;; extended sprite -> mario interaction.
Hit_Mario:
	LDA $171F|!addr,x
	CLC
	ADC #$03
	STA $04
	LDA $1733|!addr,x
	ADC #$00
	STA $0A
	LDA #$0A
	STA $06
	STA $07
	LDA $1715|!addr,x
	CLC
	ADC #$03
	STA $05
	LDA $1729|!addr,x
	ADC #$00
	STA $0B
	JSL $03B664|!bank
	JSL $03B72B|!bank
	BCC .hitmar
	PHB
	LDA.b #($02|!bank>>16)
	PHA
	PLB
	PHK
	PEA.w .retur-1
	PEA.w $B889-1
	JML $02A469|!base3
.retur	PLB 
.hitmar	RTS