;Input: A = sprite number, CLC = CLear Custom, SEC = SEt Custom
;Output: Carry clear = spawned, carry set = not spawned, A = slot used
	PHX
	XBA
	if !sa1
		LDX #$15
	else
		LDX #$0B
	endif
	?-
		LDA !14C8,x
		BEQ ?+
			DEX
		BPL ?-
		DEC $1861|!addr
		BPL ?++
		LDA #$01
		STA $1861|!addr
	?++
		LDA $1861|!addr
		PHP
		if !sa1
			CLC : ADC #$14
		else
			CLC : ADC #$0A
		endif
		PLP
		TAX
	?+
	STX $185E|!addr
	XBA
	STA !9E,x
	JSL $07F7D2|!bank
	
	BCC ?+
		LDA !9E,x
		STA !7FAB9E,x
		JSL $0187A7|!bank
		LDA #$08
		STA !7FAB10,x
	?+
	
	LDA #$01
	STA !14C8,x
	CLC
	TXA
	PLX
	RTL
