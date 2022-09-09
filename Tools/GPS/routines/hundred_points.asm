;~@sa1
	PHX					; Push X Register.
	LDX #$05			; Load 05 into register to check for all six score sprite slots.
.loop
	LDA $16E1|!addr,x			; Check score sprite slot.
	BNE .next			; If it's not empty, skip.

	INC $1697|!addr			; Check how many enemies have been stomped.


	LDA #$05
	STA $16E1|!addr,x			; Set to "100 points".
	LDA #$30
	STA $16FF|!addr,x			; Set score sprite Y movement.

	LDA $9A				; Load block's currently processing X position, low byte.
	STA $16ED|!addr,x			; Store score/1-up sprite X position, low byte.
	LDA $9B				; Load block's currently processing X position, high byte.
	STA $16F3|!addr,x			; Store score/1-up sprite X position, high byte.
	LDA $98				; Load block's currently processing Y position, low byte.
	STA $16E7|!addr,x			; Store score/1-up sprite Y position, low byte.
	LDA $99				; Load block's currently processing Y position, high byte.
	STA $16F9|!addr,x			; Store score/1-up sprite Y position, high byte.
	BRA .resume			; Resume normal code.

.next
	DEX					; Decrement X register.
	BPL .loop			; Loop back if value is still positive.

.resume
	PLX					; Pull X Register.

	LDA #$03			; Load "kicked shell" sound.
+	STA $1DF9|!addr			; Make the appropriate sound play.
	RTL
