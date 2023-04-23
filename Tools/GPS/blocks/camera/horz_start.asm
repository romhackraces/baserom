
db $42
JMP Mario : JMP Mario : JMP Mario : JMP End : JMP End : JMP End : JMP End
JMP End : JMP End : JMP End

Mario:
	LDA #$01 : STA $1411|!addr
End:
	RTL

print "Enable horizontal camera scroll."