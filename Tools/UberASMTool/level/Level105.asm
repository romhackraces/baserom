; must match RAMControlledFireballAmount
!fireballs_freeram = $60
!fireballs_level_amount = $05

; must match RAMToggledLR.asm
!LREnableToggle = $7C

; must match RAMToggledStatusbar.asm
!StatusBarToggle = $79


init:
    lda #$01 : sta !LREnableToggle
    lda.b #!fireballs_level_amount : sta !fireballs_freeram
    rtl

load:
	lda #$01 : sta !StatusBarToggle
	rtl