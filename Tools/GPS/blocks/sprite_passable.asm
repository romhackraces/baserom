db $37

JMP + : JMP + : JMP +
JMP ++ : JMP ++ : JMP ++ : JMP ++
JMP + : JMP + : JMP +
JMP + : JMP +

++	LDY #$00
	LDA #$25
	STA $1693|!addr
+	RTL

print "A block that is passable by sprites. To Mario, it will obey the Act as setting."