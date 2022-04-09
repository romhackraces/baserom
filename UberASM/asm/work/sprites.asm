sprite_code:
	LDX.b #!sprite_slots
	-
		DEX
		LDA !sprite_RAM,x
		ORA !sprite_RAM+(!sprite_slots),x
		ORA !sprite_RAM+(!sprite_slots*2),x
	BNE +
		CPX #$00
		BNE -
		BRA .return
	+
		if !sa1
			LDA $3242,x 
		else
			LDA $14C8,x
		endif
		BEQ .clear
		LDA !sprite_RAM,x
		STA $00
		LDA !sprite_RAM+(!sprite_slots),x
		STA $01
		LDA !sprite_RAM+(!sprite_slots*2),x
		STA $02
		PHK
		PEA.w .next
		JMP [!dp]
	.next
		CPX #$00
		BNE -
	.return
		RTS
	.clear
		LDA #$00
		STA !sprite_RAM,x
		STA !sprite_RAM+(!sprite_slots),x
		STA !sprite_RAM+(!sprite_slots*2),x
		BRA -
