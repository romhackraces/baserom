;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; change_map16 - Optimized version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Usage:
; REP #$10
; LDX #!block_number
; %change_map16()
; SEP #$10
;;;
; Note: This routine swaps the x and y bytes in vertical levels, if you
;   use the position later on make sure to call swap_xy to correct them
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDA $0F : PHA
	PHP
	PHY
	PHX
	LDY $98
	STY $0E
	LDY $9A
	STY $0C
	SEP #$30
	LDA $5B
	LDX $1933|!addr
	BEQ ?Layer1
	LSR A
?Layer1:
	STA $0A
	LSR A
	BCC ?Horz
	LDA $9B
	LDY $99
	STY $9B
	STA $99
?Horz:
if !EXLEVEL
	BCS ?vertical
	REP #$20
		LDA $98
		CMP $13D7|!addr
	SEP #$20
	BRA ?check
?vertical:
endif
	LDA $99
	CMP #$02
?check:
	BCS ?End
	LDA $9B
	CMP $5D
	BCC ?NoEnd
?End:
	REP #$10
	PLX
	PLY
	PLP
	JMP ?returnasdf

?NoEnd:
	STA $0B
	ASL
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
	ASL
	TAX

	LDA $0D
	LSR
	LDA $0F
	AND #$01		; 0000 000y
	ROL				; 0000 00yx
	ASL #2			; 0000 yx00
	ORA.l ?LayerData,x	; 001l yx00
	TSB $06			; $06 : 001l yxYY
	LDA $9A			; X LowByte
	AND #$F0		; XXXX 0000
	LSR #3			; 000X XXX0
	TSB $07			; $07 : YY0X XXX0
	LSR
	TSB $08

	LDA $1925|!addr
	ASL
	REP #$31
	ADC $00BEA8|!bank,x
	TAX
	TYA
	if !sa1
		ADC $000000,x
		TAX
		LDA $08
		ADC $000000,x
	else
		ADC $00,x
		TAX
		LDA $08
		ADC $00,x
	endif
	TAX
	PLA
	ASL
	TAY
	LSR
	SEP #$20
	if !sa1
		STA $400000,x
		XBA
		STA $410000,x
	else
		STA $7E0000,x
		XBA
		STA $7F0000,x
	endif
	LSR $0A
	LDA $1933|!addr
	REP #$20
	BCS ?Vert
	BNE ?HorzL2
?HorzL1:
	LDA $1A			;\
	SBC #$007F		; |$08 : Layer1X - 0x80
	STA $08			;/
	LDA $1C			;  $0A : Layer1Y
	BRA ?Common
?HorzL2:
	LDA $1E			;\ $08 : Layer2X
	STA $08			;/
	LDA $20			;\ $0A : Layer2Y - 0x80
	SBC #$007F		;/
	BRA ?Common

?Vert:
	BNE ?VertL2
	LDA $1A			;\ $08 : Layer1X
	STA $08			;/
	LDA $1C			;\ $0A : Layer1Y - 0x80
	SBC #$0080		;/
	BRA ?Common
?VertL2:
	LDA $1E			;\
	SBC #$0080		; |$08 : Layer2X - 0x80
	STA $08			;/
	LDA $20			;  $0A : Layer2Y
?Common:
	STA $0A
	PHB
	PHK
;	PER $0006
	PEA ?return-1
	PEA $804C
	JML $00C0FB|!bank
?return:
	PLB
	PLY
	PLP
?returnasdf:
	PLA : STA $0F
	RTL

?LayerData:	db $20,$00,$30
