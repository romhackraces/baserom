if read1($00FFD5) == $23
	sa1rom
	!E4 = ($EE)
	!1FD6 = $766E
else
	lorom
	!E4 = $E4,x
	!1FD6 = $1FD6
endif

org $01D6C4
	LDA !E4
	AND #$10
	STA !1FD6,x
; CPX #$06 : BCC $18 : LDA $1692     

org $01DC73
	BRA $02
	NOP #2
	LDY !1FD6,x
; CPX #$06 : BCC $07 : LDY $1692
org $01DCC3
	BRA $02
	NOP #2
	LDY !1FD6,x
; CPX #$06 : BCC $07 : LDY $1692
