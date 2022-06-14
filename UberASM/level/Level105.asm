; Make sure this is the same as the patch
!fireballs_freeram = $60

; How many fireballs to have in this level
!fireballs_level_amount = $05


!LREnableToggle = $7C 	; must match RAMToggledLR.asm

!StatusBarToggle = $79	; must match RAMToggledStatusbar.asm


init:
    lda #$01
    sta !LREnableToggle

    lda.b #!fireballs_level_amount 
    sta !fireballs_freeram
    rtl

load:
	lda #$01
	sta !StatusBarToggle
	rtl