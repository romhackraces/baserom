;Spike Swim Fix by yoshifanatic
;This is a simple bug fix patch that fixes the bug that causes Mario's powerdown animation to glitch up if you touch a spike/muncher while swimming.
;This is an update for Alcaro's version of the patch that fixes the bug in a better way,adds SA-1 support and also fixes another small issue where the power down sound does not play if you swim down while holding an item.
;Credit is not necessary, but would be appreciated

if read1($00FFD5) == $23
	sa1rom
	!SA1Offset1 = $3000
	!SA1Offset2 = $6000
else
	!SA1Offset1 = $0000
	!SA1Offset2 = $0000
endif

org $00DAA9
autoclean JSL Main
	RTS

freecode
Main:
	LDA $71|!SA1Offset1			;\ If Mario is not in his normal state, don't play the swim sound or set the swim animation timer.
	BNE .Return				;/
	LDA #$0E
	STA $1DF9|!SA1Offset2
	LDA $1496|!SA1Offset2
	ORA #$10
	STA $1496|!SA1Offset2
.Return
	RTL