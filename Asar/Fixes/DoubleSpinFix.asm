if read1($00FFD5) == $23
sa1rom
!base2 = $6000
!base3 = $000000
else
lorom
!base2 = $0000
!base3 = $800000
endif

org $01A8B0|!base3
autoclean JML Mymain

freespace noram
Mymain:
LDA $7D
BPL .Downwards

LDY #$03
LDA #$02
.Loop:
CMP $17C0|!base2,y
BEQ .DownCheck
DEY
BPL .Loop

JML $01A8B4|!base3

.DownCheck:
;probably not needed
.Downwards:
JML $01A8C0|!base3
