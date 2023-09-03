;default yxccpppt properties of the bomb. change this if they're remapped in your game.

	!BombProp = $07

;sa1

!15F6 = $15F6
!bank = $800000

if read1($00FFD5) == $23
	sa1rom
	!15F6 = $33B8
	!bank = $000000
endif

;hijack

org $01AA24
	autoclean JML KickedBomb

;freecode

freecode

KickedBomb:
	CPY #$0D
	BEQ IsBomb
	JML $01AA2A|!bank

IsBomb:
	LDA #!BombProp
	STA !15F6,x
	JML $01AA28|!bank