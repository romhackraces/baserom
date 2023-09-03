; This file is inserted to the beginning of patch.asm during its final compilation.
; This undoes hijacks done by other music insertion tools.
; It does NOT erase the data inserted by those tools; the program itself does that.

lorom

if read1($008055) == $5C

print "Unnofficial Addmusic 4.05 data detected.  Undoing ASM hijacks..."

org $008055
	db $9C, $00, $01, $9C, $09, $01

org $00807C
	db $A0, $00, $00, $A9, $AA, $BB

org $00808D
	db $B7, $00, $C8, $EB, $A9, $00, $80, $0B, $EB, $B7, $00, $C8, $EB

org $0080B4
	db $C2, $20, $B7, $00, $C8, $C8, $AA, $B7, $00, $C8, $C8, $8D, $42, $21, $E2, $20

org $0080E9
	db $00, $8D, $00, $00, $A9, $80, $8D, $01, $00, $A9, $0E

org $0096C3
	db $20, $0E, $81, $A9, $01, $8D, $FB, $1D	
	
org $009702
	db $20, $34, $81
	
org $00973B
	db $29, $BF, $8D, $DA, $0D, $9C, $AE, $0D, $9C, $AF, $0D
	
org $00A162
	db $91, $8D, $04
	
org $00A64F
	db $22,$49,$85,$90,$EA
	
org $00A64F	
	db $09, $40, $8D, $DA, $0D

org $048DDA 
	db $D0, $03, $82, $55, $00

org $049AA5
	db $9D, $11, $1F, $29, $FF, $00

org $05855F
	db $D0
	
endif


if read1($05D8E6) == $22
print "Sample Tool data detected. Undoing ASM hijacks..."

org $00800A
	db $9C, $40, $21, $9C, $41, $21

org $00A0B9
	db $9C, $DA, $0D, $AE, $B3, $0D

org $05D8E6
	db $A9, $00, $00, $E2, $20
	
endif