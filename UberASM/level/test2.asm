; Example 2. Set Conditional DM16 flag 0 if the player has either Cape or Fire power-up.

load:
	lda $19
	lsr
	and #$01
	sta $7FC060
	rtl
