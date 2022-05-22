!flag = $79	; from RAMToggledStatusbar.asm

load:
	lda #$01
	sta !flag
	rtl