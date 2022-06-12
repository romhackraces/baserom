; check if the rom is sa-1
if read1($00FFD5) == $23		
	sa1rom
	!Base2 = $6000
else
	lorom
	!Base2 = $0000
endif

org $01C545
autoclean JSL Main
NOP

freecode

Main:
CMP #$01
BNE .Store
LDX $0DC2|!Base2
BNE .DontStore
.Store
STA $0DC2|!Base2
.DontStore
LDX $15E9|!Base2
LDA #$0B
RTL