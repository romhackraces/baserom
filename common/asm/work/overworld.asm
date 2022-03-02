ORG $00A1C3
	autoclean JML main_ow
	
ORG $00A18F
	autoclean JML init_ow
	NOP #2

freecode

; Do not touch, nor move that.
db "uber"
OW_asm_table:
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer

OW_init_table:
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer
dl null_pointer

OW_nmi_table:
db "tool"

main_ow:
	PHB
	JSL $7F8000
	
	LDX $0DB3|!addr
	LDA $1F11|!addr,x
	ASL
	ADC $1F11|!addr,x
	TAX				
	REP #$20		
	LDA.l OW_asm_table,x
	STA $00
	LDA.l OW_asm_table+1,x
	JSL run_code
	PLB
	JML $00A1C7|!bank		

init_ow:
	PHK
	PEA.w .return-1
	PEA.w $84CE
	JML $0092A0|!bank
.return
	PHB
	LDX $0DB3|!addr
	LDA $1F11|!addr,x
	ASL
	ADC $1F11|!addr,x
	TAX				
	REP #$20		
	LDA.l OW_init_table,x
	STA $00
	LDA.l OW_init_table+1,x
	JSL run_code
	PLB
	JML $0093F4|!bank
