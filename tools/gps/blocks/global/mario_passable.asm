db $37

JMP + : JMP + : JMP +
JMP ++ : JMP ++ : JMP ++ : JMP ++
JMP + : JMP + : JMP +
JMP + : JMP +

+	LDY #$00
	LDA #$25
	STA $1693|!addr
++	RTL

print "A block that is only passable by Mario. To sprites, it will obey the Act as setting."