;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; change_map16 - Optimized version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; input:
; $98-$99 block position Y
; $9A-$9B block position X
; $1933   layer
;
; Usage:
; REP #$20
; LDA #!block_number
; %change_map16()
;
; by Akaginite
;
; For compatibility reasons, input was changed from X to A.
; Return SEC = didn't work, CLC = did work

; Slightly modified by Tattletale
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PHX
	PHP
	REP #$10
	TAX
	SEP #$20
	PHB
	PHY
	PHX
	LDY $98
	STY $0E
	LDY $9A
	STY $0C
	SEP #$30
	LDA $5B
	LDX $1933|!Base2
	BEQ .layer1
	LSR A
.layer1
	STA $0A
	LSR A
	BCC .horz
	LDA $9B
	LDY $99
	STY $9B
	STA $99
.horz
if !EXLEVEL
	BCS .verticalCheck
	REP #$20
	LDA $98
	CMP $13D7|!Base2
	SEP #$20
	BRA .check
endif
.verticalCheck
	LDA $99
	CMP #$02
.check
	BCC .noEnd
	REP #$10
	PLX
	PLY
	PLB
	PLP
	PLX
	SEC
	RTL
	
.noEnd
	LDA $9B
	STA $0B
	ASL A
	ADC $0B
	TAY
	REP #$20
	LDA $98
	AND.w #$FFF0
	STA $08
	AND.w #$00F0
	ASL #2			; 0000 00YY YY00 0000
	XBA			; YY00 0000 0000 00YY
	STA $06
	TXA
	SEP #$20
	ASL A
	TAX
	
	LDA $0D
	LSR A
	LDA $0F
	AND #$01		; 0000 000y
	ROL A			; 0000 00yx
	ASL #2			; 0000 yx00
	ORA #$20		; 0010 yx00
	CPX #$00
	BEQ .noAdd
	ORA #$10		; 001l yx00
.noAdd
	TSB $06			; $06 : 001l yxYY
	LDA $9A			; X LowByte
	AND #$F0		; XXXX 0000
	LSR #3			; 000X XXX0
	TSB $07			; $07 : YY0X XXX0
	LSR A
	TSB $08

	LDA $1925|!Base2
	ASL A
	REP #$31
	ADC $00BEA8|!BankB,x
	TAX
	TYA
if !SA1
    ADC.l $00,x
    TAX
    LDA $08
    ADC.l $00,x
else
    ADC $00,x
    TAX
    LDA $08
    ADC $00,x
endif
	TAX
	PLA
	ASL A
	TAY
	LSR A
	SEP #$20
if !SA1
	STA $400000,x
	XBA
	STA $410000,x
else
	STA $7E0000,x
	XBA
	STA $7F0000,x
endif
	LSR $0A
	LDA $1933|!Base2
	REP #$20
	BCS .vert
	BNE .horzL2
.horzL1
	LDA $1A			;\
	SBC #$007F		; |$08 : Layer1X - 0x80
	STA $08			;/
	LDA $1C			;  $0A : Layer1Y
	BRA ?+
.horzL2
	LDA $1E			;\ $08 : Layer2X
	STA $08			;/
	LDA $20			;\ $0A : Layer2Y - 0x80
	SBC #$007F		;/
	BRA ?+
	
.vert
	BNE .vertL2
	LDA $1A			;\ $08 : Layer1X
	STA $08			;/
	LDA $1C			;\ $0A : Layer1Y - 0x80
	SBC #$0080		;/
	BRA ?+
.vertL2
	LDA $1E			;\
	SBC #$0080		; |$08 : Layer2X - 0x80
	STA $08			;/
	LDA $20			;  $0A : Layer2Y
?+
	STA $0A
	PHK
?-	PEA.w (?-)+9
	PEA $804C
	JML $00C0FB|!BankB
	PLY
	PLB
	PLP
	PLX
	CLC
	RTL
