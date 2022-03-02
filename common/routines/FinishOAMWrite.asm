        ;; Optimized finishOAMWrite - routine by Akaginite
        ;; Input: A = number of tiles to draw - 1
        ;; Input: Y = size, $00 -> 8x8 tiles, $02 -> 16x16 tiles, $FF -> manually set the size
        STY $0B
		STA $08
		LDA !D8,x
		SEC
		SBC $1C
		STA $00
		LDA !14D4,x
		SBC $1D
		STA $01
		LDY !15EA,x
		LDA !14E0,x
		XBA
		LDA !E4,x
		REP #$20
		SEC
		SBC $1A
		STA $02
		TYA
        LSR #2
		TAX
		SEP #$21

?loop	LDA $0300|!addr,y
		SBC $02
		REP #$21
		BPL +
		ORA.w #$FF00
+		ADC $02
		CMP.w #$0100
		TXA
		SEP #$20
		LDA $0B
		BPL +
		LDA $0460|!addr,x
		AND #$02
+		ADC #$00
		STA $0460|!addr,x
		LDA $0301|!addr,y
		SEC
		SBC $00
		REP #$21
		BPL +
		ORA.w #$FF00
+		ADC $00
		CLC
		ADC.w #$0010
		CMP.w #$0100
		BCC ?next
		LDA.w #$00F0
		SEP #$20
		STA $0301|!addr,y
?next	SEP #$21
		INY #4
		INX
		DEC $08
		BPL ?loop
		LDX $15E9|!addr
        RTL