;~@sa1
	PHY
	TAY
	LDA !D8,x
	STA.w !D8,y
	LDA !14D4,x
	STA !14D4,y
	LDA !E4,x
	STA.w !E4,y
	LDA !14E0,x
	STA !14E0,y
	PLY
	RTL
