includeonce

; check if the rom is sa-1
if read1($00FFD5) == $23
    ; full 6/8 mb sa-1 rom
	if read1($00FFD7) == $0D
		fullsa1rom
		!fullsa1 = 1
	else
		sa1rom
		!fullsa1 = 0
	endif
	!sa1 = 1
	!SA1 = 1
	!SA_1 = 1
	!Base1 = $3000
	!Base2 = $6000
	!dp = $3000
	!addr = $6000

	!BankA = $400000
	!BankB = $000000
	!bank = $000000

	!Bank8 = $00
	!bank8 = $00

	!SprSize = $16
else
	lorom
	!sa1 = 0
	!SA1 = 0
	!SA_1 = 0
	!Base1 = $0000
	!Base2 = $0000
	!dp = $0000
	!addr = $0000

	!BankA = $7E0000
	!BankB = $800000
	!bank = $800000

	!Bank8 = $80
	!bank8 = $80

	!SprSize = $0C
endif
