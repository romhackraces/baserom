org $009322
	autoclean JML gamemode_main

freecode

	db "uber" ; Don't touch or move these tables.
	gamemode_main_table:
	gamemode_init_table:
	gamemode_nmi_table:
	db "tool"
	

	gamemode_main:
		LDA $0100|!addr
		CMP #$2A		
		BCS new_mode	
		PHK
		PEA.w return-1
		BRA do_game_mode
				
	new_mode:  
		LDA #$00
		PHA  
		PEA $9311
				
	do_game_mode:
		PHB
		PHK
		PLB
		LDA $0100|!addr
		CMP !previous_mode
		STA !previous_mode
		REP #$30
		PHP
		AND #$00FF
		ASL
		ADC !previous_mode
		TAX
		PLP
		BNE +
			LDA gamemode_main_table,x
			STA $00
			LDA gamemode_main_table+1,x
		BRA ++
	+
			LDA gamemode_init_table,x
			STA $00
			LDA gamemode_init_table+1,x
	++
		JSL run_code
		PLB
		RTL
		
	return:
		LDA $0100|!addr
		ASL			
		TAX			
		LDA $9329,x		
		STA $00			
		LDA $932A,x		
		STA $01			
		STZ $02						
		JML [!dp]
		