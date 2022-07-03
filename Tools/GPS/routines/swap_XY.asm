; This is required if the high byte of the block's position is used.

	PHP
	SEP #$20
	LDA $5B
	LSR
	BCC ?return
	LDA $99
	XBA
	LDA $9B
	STA $99
	XBA
	STA $9B
?return:
	PLP
	RTL
