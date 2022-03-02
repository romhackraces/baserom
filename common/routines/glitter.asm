;~@sa1

;;; glitter effect
;;; usage: %glitter()

	PHY		;preserve map16 high
        LDY.b #$03
?LoopStart:
        LDA.w $17C0|!addr,Y
        BEQ ?CreateGlitter
        DEY
        BPL ?LoopStart

?CreateGlitter:
		LDA #$05
        STA $17C0|!addr,Y
        LDA $9A
        AND #$F0
        STA $17C8|!addr,Y
        LDA $98
        AND #$F0
        STA $17C4|!addr,Y
        LDA $1933|!addr
        BEQ ?ADDR_00FD97
        LDA $9A
        SEC
        SBC $26
        AND #$F0
        STA $17C8|!addr,Y
        LDA $98
        SEC
        SBC $28
        AND #$F0
        STA $17C4|!addr,Y
?ADDR_00FD97:
        LDA #$10
        STA $17CC|!addr,Y
	PLY		;restore map16 high
RTL
