if read1($00FFD5) == $23		; check if the rom is sa-1
	sa1rom
	!Base2 = $6000
	!BankB = $000000
else
	lorom
	!Base2 = $0000
	!BankB = $800000
endif

ORG $00C4F8
	autoclean JML hack
	NOP

freecode

hack:
	LDA $71
	BEQ +
		STZ.w $13FB|!Base2
	+
	LDA.w $13FB|!Base2
	BEQ +
		JML $00C58F|!BankB
	+
	JML $00C500|!BankB