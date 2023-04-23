db $42
JMP Mario : JMP Mario : JMP Mario : JMP End : JMP End : JMP End : JMP End
JMP End : JMP End : JMP End

Mario:
	LDA #$01 : STA $1412|!addr
End:
	RTL

print "Enable vertical camera scroll."