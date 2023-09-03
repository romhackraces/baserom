;~@sa1
	LDX #$03		; disassembled from original smb3.bin
?C_8213:
	LDA $16CD|!addr,x
	BEQ ?C_821C
	DEX 
	BPL ?C_8213
	INX 
?C_821C:
	LDA $9A
	STA $16D1|!addr,x
	LDA $9B
	STA $16D5|!addr,x
	LDA $98
	STA $16D9|!addr,x
	LDA $99
	STA $16DD|!addr,x
	LDA $1933|!addr
	BEQ ?C_8253
	LDA $9A
	SEC 
	SBC $26
	STA $16D1|!addr,x
	LDA $9B
	SBC $27
	STA $16D5|!addr,x
	LDA $98
	SEC 
	SBC $28
	STA $16D9|!addr,x
	LDA $99
	SBC $29
	STA $16DD|!addr,x
?C_8253:
	LDA #$01
	STA $16CD|!addr,x
	LDA #$06
	STA $18F8|!addr,x
	RTL
