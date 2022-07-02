;~@sa1
;Input: A = sprite number, CLC = CLear Custom, SEC = SEt Custom
;Output: Carry clear = spawned, carry set = not spawned, A = slot used
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
		SEC
		BRA ?no_slot
	?+
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
?no_slot:
	TXA
	RTL
