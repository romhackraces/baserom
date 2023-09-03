;~@sa1
	PHY					; Push X Register.
	LDY #$05			; Load 05 into register to check for all six score sprite slots.
.loop
	LDA $16E1|!addr,y			; Check score sprite slot.
	BNE .next			; If it's not empty, skip.

	LDA !1626,x			; Check amount of enemies having been stomped on.
	BEQ	.first			; If it's the first enemy, go to first stomp.
	CMP #$08			; Check if 8 enemies have been stomped (1up)
	BMI .notfirst		; If that's not the case, go to not first.
	LDA #$0D			;
	STA $16E1|!addr,y			; Lock to 1-UPs.
	BRA +

.notfirst
	CLC
	ADC #$06			; If one enemy has been stomped on already, add 06...
	STA $16E1|!addr,y			; And save the results to points awarded
	BRA +

.first
	LDA #$06
	STA $16E1|!addr,y			; Set to "200 points".

+	LDA !1626,x			; Check how many enemies have been stomped.
	CMP #$7F			; Is it 7F?
	BEQ ++				; Go to ++ to freeze the counter at 7F (to keep the code from bugging)

	INC !1626,x			; Increase the amount of enemies stomped.

++	LDA #$30
	STA $16FF|!addr,y			; Set score sprite Y movement.

	LDA $9A				; Load block's currently processing X position, low byte.
	STA $16ED|!addr,y			; Store score/1-up sprite X position, low byte.
	LDA $9B				; Load block's currently processing X position, high byte.
	STA $16F3|!addr,y			; Store score/1-up sprite X position, high byte.
	LDA $98				; Load block's currently processing Y position, low byte.
	STA $16E7|!addr,y			; Store score/1-up sprite Y position, low byte.
	LDA $99				; Load block's currently processing Y position, high byte.
	STA $16F9|!addr,y			; Store score/1-up sprite Y position, high byte.
	BRA .resume			; Resume normal code.

.next
	DEY					; Decrement X register.
	BPL .loop			; Loop back if value is still positive.

.resume
	PLY					; Pull X Register.

	LDA !1626,x			; Check amount of enemies having been stomped on.
	CLC					; Clear carry.
	ADC	#$12			; Add 12 with carry.
	CMP #$1A			; Compare with 1A.
	BMI +				; If 1A hits haven't been registered, go to +.

	LDA #$03			; Load "kicked shell" sound.
+	STA $1DF9|!addr			; Make the appropriate sound play.
	RTL

