incsrc "../../../shared/freeram.asm"

; Springboard Fixes by MiracleWater made RAM-toggleable by AmperSam

; This will prevent Mario from being able to regrab a springboard very briefly after it has been kicked
!fix_interaction = $01			; $00 = no, $01 = yes

; This will prevent Mario's x speed for being set to 0 on the frame a springboard is picked up
!fix_carry = $01				; $00 = no, $01 = yes


; RAM Toggle
; Freeram address to the fixes
!Freeram_Toggle = !toggle_springboard_fixes_freeram

; SA-1 stuff
if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
	!14C8 = $3242
	!154C = $32DC
	!1602 = $33CE
else
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
    LDA !Freeram_Toggle
    BNE .default_interaction
    LDA !154C,x
    BNE .draw
    JSL $01A7DC|!bank
    BCC .draw
    JML $01E6B5|!bank
.draw
    JML $01E6F0|!bank

.default_interaction
    PHB
    db $F4,($01A7F7|!bank)>>16,..jslrtsreturn>>16
    PLB
    PEA ..jslrtsreturn-1
    PEA.w ($0180CA-1)|!bank
    JML $01A7F7|!bank
..jslrtsreturn
    PLB
    BCC .draw
    JML $01E6B5|!bank
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
	LDA !Freeram_Toggle
	BEQ +
	STZ $7B
+ 	LDA #$0B
	STA !14C8,x
	STZ !1602,x
	JML $01E6F0|!bank
endif
