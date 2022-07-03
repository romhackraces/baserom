lorom
if read1($00FFD5) == $23
	sa1rom
endif

org $02FEAB
autoclean JML boofix : NOP

freespace noram
boofix:
BEQ +
LDY $73
BNE +
LDA.w #$0020
+
JML $02FEB0
