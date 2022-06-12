; This will prevent Mario from being able to regrab a springboard very briefly after it has been kicked
!fix_interaction = $01			; $00 = no, $01 = yes

; This will prevent Mario's x speed for being set to 0 on the frame a springboard is picked up
!fix_carry = $01				; $00 = no, $01 = yes


if read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!14C8 = $3242
	!154C = $32DC
	!1602 = $33CE
else
	!dp = $0000
	!addr = $0000
	!bank = $800000
	!14C8 = $14C8
	!154C = $154C
	!1602 = $1602
endif


if !fix_interaction
org $01E6B0
	autoclean JML interact
	NOP

freecode
interact:
	LDA !154C,x
	BNE +
	JSL $01A7DC|!bank
	BCC +
	JML $01E6B5|!bank
+
	JML $01E6F0|!bank
endif

if !fix_carry
org $01E6DA
	autoclean JML carried
	NOP
	
freecode	
carried:
	LDA #$01
	STA $1470|!addr
	STA $148F|!addr
	LDA #$0B
	STA !14C8,x
	STZ !1602,x
	JML $01E6F0|!bank
endif
