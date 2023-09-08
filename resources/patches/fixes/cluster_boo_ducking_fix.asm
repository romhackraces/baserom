if read1($00FFD5) == $23
	sa1rom
	!sa1	= 1
	!bank	= $000000
else
	lorom
	!sa1	= 0
	!bank	= $800000
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
JML $02FEB0|!bank
