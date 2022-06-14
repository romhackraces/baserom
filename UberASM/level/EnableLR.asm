; must match Asar/RAMToggledLR.asm
!LREnableToggle = $7C 

init:
	lda #$01
	sta !LREnableToggle
	rtl