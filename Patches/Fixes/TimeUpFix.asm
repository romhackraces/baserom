header

lorom
!bank = $800000
!addr = $0000

if read1($00ffd5) == $23
	sa1rom
	!bank = $000000
	!addr = $6000
endif

org $008E21|!bank
autoclean JML TickTime

org $008E4F|!bank
BNE TimeIsntZero

org $008E60|!bank
LDA $0F32|!addr
ORA $0F33|!addr
BNE TimeIsntZero
LDA #$FF
NOP
autoclean JSL TimeUp
TimeIsntZero:

org $00D0E6|!bank
autoclean JSL CheckIfTimeUpMsg
NOP



freecode



TickTime:
LDA $0D9B|!addr
CMP #$C1
BEQ .DontTick
LDA $0F30|!addr
BMI .DontTick
JML $008E28|!bank
.DontTick
JML $008E6F|!bank

TimeUp:
STA $0F30|!addr
JML $00F606|!bank

CheckIfTimeUpMsg:
LDY #$0B
LDA $0F31|!addr
LDX $0F30|!addr
BMI .DoTimeUp
INC A
.DoTimeUp:
RTL
