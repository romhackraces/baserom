ORG $00804E
	autoclean JML clear_pointers

ORG $00806B
	autoclean JML _global_main
	
ORG $008176
	autoclean JML nmi_hijack
	NOP #2
	
ORG $05808C
	JML load
	NOP
	
freecode
	
; Do not edit nor move that.
; That's a special prot table for cleaning external data and codes.
db "uber"
prot_table:
dl $97FF14
dl $908118
dl $9986A9
dl $97FF72

db "tool"
	
clear_pointers:
	STA $7F8182
	LDA #$00
	LDX #!sprite_slots*3-1
	-
		STA !sprite_RAM,x
		DEX
	BPL -
	
	LDA #$00
	STA !previous_mode+1
	DEC
	STA !previous_mode
		
	if !sa1
		LDA #$60
		STA $1E93 ; edit SA-1 main loop to allow simple usage of it
	endif
	
	JSR global_init
	JML $008052|!bank

_global_main:
	if !sa1
		JSR $1E8F
	else
		LDA $10
		BEQ _global_main
	endif
	JSR global_main
	
	LDA $0100|!addr
	CMP #$14
	BNE +
		JSR sprite_code
+
	
	JML $00806F|!bank

load:
	PHB
	SEP #$30
	JSR global_load
	REP #$30
	LDA !level
	ASL
	ADC !level
	TAX
	LDA.l level_load_table,x
	STA $00
	LDA.l level_load_table+1,x
	JSL run_code
	PLB
	REP #$10
	PHK
	PEA.w .return-1
	PEA.w $058125-1
	JML $0583AC|!bank
.return
	SEP #$30
	JML $058091|!bank

	
nmi_hijack:
	LDA $4210	; This is SNES hardware stuff, so don't remove it please.
	
	PHB
	
	; Include various probabilities for optimal performance.
	if !global_nmi == 1
		JSR global_nmi
	endif
	
	; I guess I could have done this better, like pre-storing the tables into RAM during INIT or like,
	; however I wanted to all hacks have minimum safetly to this run properly, so I decided to use
	; temporary memory instead.
	if !gamemode_nmi == 1 || !level_nmi == 1 || !overworld_nmi == 1
		PEI ($6E)
		PEI ($70)
	endif

	if !gamemode_nmi == 1
		REP #$20
		LDA $0100|!addr
		AND #$00FF
		STA $6E
		ASL
		ADC $6E
		TAX
		LDA gamemode_nmi_table,x
		STA $6E
		LDA gamemode_nmi_table+1,x
		JSL nmi_run_code
	endif
	
	if !level_nmi == 1 && !overworld_nmi == 0	
		; LevelNMI only.
		LDA $0100|!addr
		CMP #$13
		BEQ ++
		CMP #$14
		BNE +
	++	REP #$30
		LDA !level
		ASL
		ADC !level
		TAX
		LDA.l level_nmi_table,x
		STA $6E
		LDA.l level_nmi_table+1,x
		JSL nmi_run_code
	+
	endif
	
	if !level_nmi == 1 && !overworld_nmi == 1
		; Level NMI + Overworld NMI
		LDA $0100|!addr
		CMP #$13
		BEQ ++
		CMP #$14
		BNE +
	++	REP #$30
		LDA !level
		ASL
		ADC !level
		TAX
		LDA.l level_nmi_table,x
		STA $6E
		LDA.l level_nmi_table+1,x
		JSL nmi_run_code
		
		LDA $1DFB|!addr	; return
		JML $00817C
	
	+	CMP #$0D
		BEQ ++
		CMP #$0E
		BNE +
		
	++	LDX $0DB3|!addr
		LDA $1F11|!addr,x
		ASL
		ADC $1F11|!addr,x
		TAX				
		REP #$20		
		LDA.l OW_nmi_table,x
		STA $6E
		LDA.l OW_nmi_table+1,x
		JSL nmi_run_code
	+
	endif
	
	if !level_nmi == 0 && !overworld_nmi == 1
		; Overworld NMI only.
		LDA $0100|!addr
		CMP #$0D
		BEQ ++
		CMP #$0E
		BNE +
		
	++	LDX $0DB3|!addr
		LDA $1F11|!addr,x
		ASL
		ADC $1F11|!addr,x
		TAX				
		REP #$20		
		LDA.l OW_nmi_table,x
		STA $6E
		LDA.l OW_nmi_table+1,x
		JSL nmi_run_code
	+
	endif
	
	if !gamemode_nmi == 1 || !level_nmi == 1 || !overworld_nmi == 1
		REP #$20
		PLA
		STA $70
		PLA
		STA $6E
		SEP #$20
	endif
	
	PLB
	LDA $1DFB|!addr
	JML $00817C
	
nmi_run_code:
	STA $6F
	PHA
	PLB
	PLB
	SEP #$30
	JML [$006E|!dp]


namespace global
; Note that since global code is a single file, all code below should return with RTS.

load:
	rts
init:
	rts
main:
	rts
;nmi:
;	rts

namespace off
