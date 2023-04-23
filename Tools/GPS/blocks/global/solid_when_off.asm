; act as 130

db $37
JMP Solid : JMP Solid : JMP Solid : JMP Solid : JMP Solid : JMP Solid : JMP Solid
JMP Solid : JMP Solid : JMP Solid : JMP Solid : JMP Solid

!ActAsWhenSwitch = $0025

Solid:
	LDA $14AF|!addr		;> check ON/OFF state
	BNE .return
	LDY.b #!ActAsWhenSwitch>>8	;\ change tile Act As air
	LDA.b #!ActAsWhenSwitch		;|
	STA $1693|!addr				;/
.return
	RTL

print "Block that is solid when ON/OFF switch is OFF."