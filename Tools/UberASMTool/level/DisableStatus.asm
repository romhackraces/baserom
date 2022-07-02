!StatusBarToggle = $79	; must match RAMToggledStatusbar.asm

load:
	lda #$01
	sta !StatusBarToggle
	rtl