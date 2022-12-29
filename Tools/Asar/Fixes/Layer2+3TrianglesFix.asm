;Layer 2+3 Triangles
;Fixes wall run triangles so they work with layer 2/3 interaction enabled
;And also work when placed on Layer 2
;By dtothefourth

if read1($00FFD5) == $23	;sa-1 compatibility
  sa1rom
  !BankB = $000000
  !addr = $6000
else
  !BankB = $800000
  !addr = $0000
endif

!FreeRAM = $14BE|!addr


org $00F048|!BankB
	autoclean JSL NoteLayer

org $00EAE1|!BankB
	autoclean JML Layer1Only

org $00EE35|!BankB
	autoclean JSL Layer1OnlyFly

freecode

NoteLayer:
	LDA $1933|!addr
	STA !FreeRAM
	INX
	STX.W $13E3|!addr
	RTL

Layer1Only:
	LDA $1933|!addr
	CMP.L !FreeRAM
	BEQ +
	JML $00EB77|!BankB
	+
	LDA $13E3|!addr
	BNE +
	JML $00EB77|!BankB
	+
	JML $00EAE9|!BankB
	
Layer1OnlyFly:
	LDA $1933|!addr
	CMP.L !FreeRAM
	BEQ +

	LDA $13E3|!addr
	BEQ +
	RTL
	+
	LDA #$24
	STA $72
	RTL