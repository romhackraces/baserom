;Aiming Routine by MarioE. 

;Input:  A   = 8 bit projectile speed
;        $00 = 16 bit (shooter x pos - target x pos)
;        $02 = 16 bit (shooter y pos - target y pos)
;
;Output: $00 = 8 bit X speed of projectile
;        $02 = 8 bit Y speed of projectile

.aiming
		PHX
		PHP
		SEP #$30
		STA $0F
		if !SA1
			STZ $2250
		endif
		LDX #$00
		REP #$30
		LDA $00
		BPL ..pos_dx
		EOR #$FFFF
		INC A
		STA $00
		LDX #$0002
		
..pos_dx	LDA $02
		BPL ..pos_dy
		EOR #$FFFF
		INC A
		STA $02
		INX
		
..pos_dy	STX $06
		ORA $00
		AND #$FF00
		BEQ ?+
		XBA
	?-	LSR $00
		LSR $02
		LSR A
		BNE ?-
	?+
		if !SA1
			LDA $00
			STA $2251
			STA $2253
			
			NOP
			
			LDA $2306
			
			LDX $02
			STX $2251
			STX $2253

			CLC

			ADC $2306
		else
			SEP #$20
			LDA $00
			STA $4202
			STA $4203
			
			NOP #4
			
			LDX $4216
			
			LDA $02
			STA $4202
			STA $4203
			
			NOP #2
			REP #$21
			TXA
			ADC $4216
		endif
		
		BCS ..v10000
		CMP #$4000
		BCS ..v4000
		CMP #$1000
		BCS ..v1000
		CMP #$0400
		BCS ..v400
		CMP #$0100
		BCS ..v100
		ASL A
		TAX
		LDA.l ..recip_sqrt_lookup,x
		BRA ..s0
		
..v100		LSR A
		AND #$01FE
		TAX
		LDA.l ..recip_sqrt_lookup,x
		BRA ..s1
		
..v400		LSR #3
		AND #$01FE
		TAX
		LDA.l ..recip_sqrt_lookup,x
		BRA ..s2
		
..v1000		ASL #2
		XBA
		ASL A
		AND #$01FE
		TAX
		LDA.l ..recip_sqrt_lookup,x
		BRA ..s3
		
..v4000		XBA
		ASL A
		AND #$01FE
		TAX
		LDA.l ..recip_sqrt_lookup,x
		BRA ..s4

..v10000	ROR A
		XBA
		AND #$00FE
		TAX
		LDA.l ..recip_sqrt_lookup,x
..s5		LSR A
..s4		LSR A
..s3		LSR A
..s2		LSR A
..s1		LSR A
..s0
		if !SA1
			STA $2251
			ASL A
			LDA $0F
			AND #$00FF
			STA $2253
			BCC ..skip_conv
	..conv		
			XBA
			CLC
			ADC $2307
			BRA ?+
	..skip_conv	
			LDA $2307
	?+		STA $2251
			LDA $02
			STA $2253

			SEP #$20
			LSR $06

			LDA $2307
			BCS ..y_plus
			EOR #$FF
			INC A
	..y_plus	STA $02
		
			LDX $00
			STX $2253
			;LSR $06
			;LDA $2307
			;BCS ..x_plus
			
			NOP
			
			LDA $2307
			LDX $06
			BNE ..x_plus
			EOR #$FF
			INC A
	..x_plus	STA $00
		
		else
			SEP #$30
			LDX $0F
			STX $4202
			STA $4203
			
			NOP #4
			
			LDX $4217
			XBA
			STA $4203
			
			BRA $00
			REP #$21
			TXA
			ADC $4216
			STA $04
			SEP #$20
			
			LDX $02
			STX $4202
			STA $4203
			
			NOP #4
			
			LDX $4217
			XBA
			STA $4203
			
			BRA $00
			REP #$21
			TXA

			ADC $4216
			SEP #$20
			LSR $06
			BCS ..y_plus
			EOR #$FF
			INC A
	..y_plus	
			STA $02
		
			LDA $00
			STA $4202
			LDA $04
			STA $4203
			
			NOP #4
			
			LDX $4217
			LDA $05
			STA $4203
			
			BRA $00
			REP #$21
			TXA
			ADC $4216
			SEP #$20
			LDX $06
			BNE ..x_plus
			EOR #$FF
			INC A
	..x_plus	STA $00
		endif
		
		PLP
		PLX
		RTL
		
	
..recip_sqrt_lookup
		dw $FFFF,$FFFF,$B505,$93CD,$8000,$727D,$6883,$60C2
		dw $5A82,$5555,$50F4,$4D30,$49E7,$4700,$446B,$4219
		dw $4000,$3E17,$3C57,$3ABB,$393E,$37DD,$3694,$3561
		dw $3441,$3333,$3235,$3144,$3061,$2F8A,$2EBD,$2DFB
		dw $2D41,$2C90,$2BE7,$2B46,$2AAB,$2A16,$2987,$28FE
		dw $287A,$27FB,$2780,$270A,$2698,$262A,$25BF,$2557
		dw $24F3,$2492,$2434,$23D9,$2380,$232A,$22D6,$2285
		dw $2236,$21E8,$219D,$2154,$210D,$20C7,$2083,$2041
		dw $2000,$1FC1,$1F83,$1F46,$1F0B,$1ED2,$1E99,$1E62
		dw $1E2B,$1DF6,$1DC2,$1D8F,$1D5D,$1D2D,$1CFC,$1CCD
		dw $1C9F,$1C72,$1C45,$1C1A,$1BEF,$1BC4,$1B9B,$1B72
		dw $1B4A,$1B23,$1AFC,$1AD6,$1AB1,$1A8C,$1A68,$1A44
		dw $1A21,$19FE,$19DC,$19BB,$199A,$1979,$1959,$1939
		dw $191A,$18FC,$18DD,$18C0,$18A2,$1885,$1869,$184C
		dw $1831,$1815,$17FA,$17DF,$17C5,$17AB,$1791,$1778
		dw $175F,$1746,$172D,$1715,$16FD,$16E6,$16CE,$16B7
		dw $16A1,$168A,$1674,$165E,$1648,$1633,$161D,$1608
		dw $15F4,$15DF,$15CB,$15B7,$15A3,$158F,$157C,$1568
		dw $1555,$1542,$1530,$151D,$150B,$14F9,$14E7,$14D5
		dw $14C4,$14B2,$14A1,$1490,$147F,$146E,$145E,$144D
		dw $143D,$142D,$141D,$140D,$13FE,$13EE,$13DF,$13CF
		dw $13C0,$13B1,$13A2,$1394,$1385,$1377,$1368,$135A
		dw $134C,$133E,$1330,$1322,$1315,$1307,$12FA,$12ED
		dw $12DF,$12D2,$12C5,$12B8,$12AC,$129F,$1292,$1286
		dw $127A,$126D,$1261,$1255,$1249,$123D,$1231,$1226
		dw $121A,$120F,$1203,$11F8,$11EC,$11E1,$11D6,$11CB
		dw $11C0,$11B5,$11AA,$11A0,$1195,$118A,$1180,$1176
		dw $116B,$1161,$1157,$114D,$1142,$1138,$112E,$1125
		dw $111B,$1111,$1107,$10FE,$10F4,$10EB,$10E1,$10D8
		dw $10CF,$10C5,$10BC,$10B3,$10AA,$10A1,$1098,$108F
		dw $1086,$107E,$1075,$106C,$1064,$105B,$1052,$104A
		dw $1042,$1039,$1031,$1029,$1020,$1018,$1010,$1008