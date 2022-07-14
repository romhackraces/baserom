lorom
if read1($00FFD5) == $23
	!base = $6000
	!1626 = $758E
	sa1rom
else
	!base = $0000
	!1626 = $1626
endif


org $00D273
	autoclean JSL PipeFix
	NOP

org $01A64B
	autoclean JSL ShellFix

org $01AB4E
	autoclean JSL BounceFix


freecode
PipeFix:
	LDA $141A|!base
	INC
	BPL PipeEnd
	LDA #$70
PipeEnd:
	STA $141A|!base
	LDA #$0F
	RTL

BounceFix:
	PHA
	LDA $1697|!base
	INC
	BPL BounceEnd
	LDA #$70
BounceEnd:
	STA $1697|!base
	PLY
	RTL

ShellFix:
	LDA !1626,y
	INC
	BPL ShellEnd
	LDA #$70
ShellEnd:
	RTL 