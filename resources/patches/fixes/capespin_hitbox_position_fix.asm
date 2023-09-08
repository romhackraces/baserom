;This patch fixes a glitch that if mario performs a cape spin and the game freezes ($7E009D),
;by taking damage, powerup animation, etc. at the same frame would causes the cape's interaction
;position to be added by the layer position multiple times.

if read1($00FFD5) == $23
	sa1rom
	!sa1	= 1
	!bank	= $000000
else
	lorom
	!sa1	= 0
	!bank	= $800000
endif

org $029512
autoclean JML CheckFrozenFlg

freecode

CheckFrozenFlg:
	BPL Ret				;\Restore code
	INC $0F				;/
	LDA $9D				;\If time frozen or player animation, then
	ORA $71				;|don't adjust cape hitbox position for multiple frames!
	BNE Ret				;/
	JML $029516|!bank
Ret:
	JML $02953B|!bank	;>Please tell me why using RTS here crashes the game when the player
	;RTS				; tries to do this glitch, its not cause by JSL/JSR mismatch.