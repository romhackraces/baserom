!true = 1
!false = 0

!LineGuideFix = !true ; Enable or disable the line guide fix
!GroundFix = !true ; Enable or disable the ground fix


if read1($00FFD5) == $23		; check if the rom is sa-1
	sa1rom
	!Base2 = $6000
	!D8 = $3216
	!163E = $33FA
else
	lorom
	!Base2 = $0000
	!D8 = $D8
	!163E = $163E
endif

if !GroundFix == !true
org $01DA17
autoclean JSL Mycode
NOP
endif

if !LineGuideFix == !true
org $01D9E1
autoclean JSL Mycode2
endif

freecode

if !GroundFix == !true
Mycode:
LDA $77
AND #$04
BNE .Return
LDA #$03
STA !163E,x
RTL
.Return
STZ !163E,x
STZ $18BE|!Base2
RTL
endif

if !LineGuideFix == !true
Mycode2:
SBC !D8,x
EOR #$FF
PHA
LDA $77
AND #$03
BEQ .Return
STZ !163E,x
STZ $18BE|!Base2
.Return
PLA
RTL
endif