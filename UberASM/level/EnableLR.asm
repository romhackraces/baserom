init:
	lda #$01
	sta $7C ; must match Asar/RAMToggledLR.asm
	rtl