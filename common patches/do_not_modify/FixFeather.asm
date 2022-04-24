;Use xkas to patch
lorom
header

org $01C5AE
			LDA #$03
			STA $71
			LDA #$18
			STA $1496
			LDA $81
			ORA $7F
			BNE $2E