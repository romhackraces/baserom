!base = $0000
if read1($00FFD5) == $23
sa1rom
!base = $6000
endif

org $00E49A
autoclean JSL Fix

freecode
Fix:
	PHA
	LDA $19
	BNE .normal
	LDA $13E0|!base		; sets player pose
	CMP #$14
	BNE .normal
	CPY #$10
	BNE .normal
	LDA $76 ; direction
	ASL ; * 2
	DEC ; - 1
	ASL ; * 2
	STA $0E		; left = -2, right = +2
	PLA
	CLC : ADC $0E
	BRA .store
.normal
	PLA
.store
	STA $0300|!base,y
	XBA
	RTL
