db $42
JMP Mario : JMP Mario : JMP Mario : JMP End : JMP End : JMP End : JMP End
JMP End : JMP End : JMP End

Mario:
	LDA #$02 : STA $13FE|!addr
	RTL
End:
	RTL

print "Scroll camera right."