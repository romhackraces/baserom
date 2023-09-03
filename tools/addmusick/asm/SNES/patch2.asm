
			; This file is internally combined with patch.asm, which needs to be assembled by itself at first to determine its size.
			; This contains mostly replacements to existing SMW code.  I HIGHLY recommend not changing anything unless absolutely necessary.


			
			


org $008079
UploadSPCData:				; This is an ever-so-slightly modified version of SMW's SPC upload routine.			
					; ENTRY CONDITIONS:
					; $00: \
					; $01: | Address of the block to upload
					; $02: /
					; $03: \ Position in ARAM to jump to upon completion
					; $04: / 
					; $05: \ Clobbered.  Unused on entry; will be the size of the transferred data when finished.
					; $06: / 
					; You can jump here at any time to upload data to the SPC.



		PHP			; Using PHP and PLP here feels like overkill...
		REP #$30		; Make A 16-bit
		LDY #$0000		;
		LDA #$BBAA		;\ Wait until SPC700 is ready to recive data
-		CMP $2140		;|
		BNE -			;/
		SEP #$20		; Make A 8-bit
		LDA #$CC		; Load byte to start transfer routine
		PHA			; Push A
		REP #$20		; Make A 16-bit
		LDA [$00],Y		; Load music data length
		STA $05
		INY			;\ Get ready to load the address
		INY			;/
		TAX			; Put the length in X
		LDA [$00],Y		; Load the address
		INY			;\ Get ready to load the data
		INY			;/
Entry2:		STA $2142		; Store the address to APU I/O ports 2 and 3 (SPC700's)
		SEP #$20		; Make A (8 bit)
		CPX #$0001		; Compare the previous address to 1 (if 0000, the carry flag will not be set and therfore the code will end)
		LDA #$00		;\ Clear A
		ROL			;| Puts carry into A
		STA $2141		;/ End the block transfer
		ADC #$7F		; Set the overflow flag if carry flag is set (Length is over 0000)
		PLA			;\ Take out A
		STA $2140		;| Store it into APU I/O port 0. Wait until they are equal (SPC700 has caught up)
-		CMP $2140		;|
		BNE -			;/
		BVS UploadData		; If the length was 0000, then finish the routine. Otherwise, upload the data.
		PLP
		RTL
		
Finished:	;print pc
		REP #$20		; $80B6
		LDA $03
		STA $2142
		LDA $05
		INC
		AND #$00FF
		STA $2140
		SEP #$20
-		CMP $2140
		BNE -
		PLP			; Return the processor's state back to normal
		RTL			; Return

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UploadData:	LDA [$00],Y		;\ Load the byte of data
		INY			;| (Ensure that the address is shifted properly)
		XBA			;|
		LDA #$00		;| Load the counter (00)
		BRA StoreByte		;/
GetNextByte:	XBA			;\ Load the byte of data
		LDA [$00],Y		;/
		INY			; Shift the used location appropriately
		XBA			; Make sure the byte of data is put into APU I/O port 1
-		CMP $2140		;\ Wait for $2140 to equal the counter (SPC700 has caught up)
		BNE -			;/
		INC A			; Increase the counter
StoreByte:	REP #$20		;\Make A 16-bit to input the byte of data into APU I/O port 1 and the counter into APU I/O port 0
		STA $2140		;|
		SEP #$20		;/Make A 8-bit
		DEX			;\ Repeat this until you have covered the whole block
		BNE GetNextByte		;/
-		CMP $2140		; Then make sure that APU I/O port 0 is the same as X
		BNE -			;
-		ADC #$03		;\ Increase the counter by 03 unless it would become 00, in which case, add another 03 to prevent the transfer from ending
		BEQ -			;/
		BRA Finished		;$8140
		;print pc
		

	
	
;org $008135
UploadSPCDataDynamic:			; $00: \
					; $01: | Address of the block to upload
					; $02: /
					; $03: \ Position in ARAM to jump to upon completion
					; $04: /
					; $05: \ Size of the data to upload (this address is NOT clobbered)
					; $06: / 
					; $07: \ Address in ARAM to upload to (recommended to increment it by ($05) when you finish to upload consecutive data)
					; $08: /
					
					; This is an alternate version of the upload routine.
					; Call this if it is impossible to determine ahead of
					; time where data will go.  This routine is used to
					; upload samples by default, but it can upload anything.
					
	PHP			;
	REP #$30		; Make A 16-bit
	LDY #$0000		;
	LDA #$BBAA		;\ Wait until SPC700 is ready to recive data
-	CMP $2140		;|
	BNE -			;/
	SEP #$20		; Make A 8-bit
	LDA #$CC		; Load byte to start transfer routine
	

		
		
	PHA
	REP #$20
	LDA $05
	TAX			; Put the length in x
	LDA $07			; Load the address
	JMP Entry2		; New entry point.
				; No RTL needed.

		
!SPCProgramLocation = $0F8000		; DO NOT TOUCH
		
UploadSPCEngine:
		REP #$20
		LDA.w #!SPCProgramLocation	;\ 0E8000 is used for most music data, etc.
		STA $00				;| ($00-$02 are later used by an LDA [$00],y)
		LDA #$0400
		STA $03
		SEP #$20
		LDA.b #!SPCProgramLocation>>16	;| 
		STA $02				;/  
		
		JSL UploadSPCData		;
		REP #$20
		LDA #$0000
		STA !FreeRAM+0
		STA !FreeRAM+2
		STA !FreeRAM+4
		STA !FreeRAM+6
		STA !FreeRAM+8
		STA !FreeRAM+10
		SEP #$20
		RTS                     	;
		;print pc

		!upram = $00
!idbyte = $03	
!xorstorage = $04
!spcjump = $05


;SPCUploadFast:
;					; ENTRY CONDITIONS:
;					; Sent #$FF to $2141
;					; $00: \
;					; $01: | Address of the block to upload
;					; $02: /
;					; $03: \ Position in ARAM to jump to upon completion
;					; $04: /
;					; $05: \ Size of the data to upload
;					; $06: / 
;					; $07: \ Address in ARAM to upload to (recommended to increment it by ($05) when you finish to upload consecutive data)
;					; $08: /
;					
;	REP #$30
;	LDA #$BBAA		; \ Wait until SPC700 is ready to recive data
;-	CMP $2140		; |
;	BNE -			; /
;	LDA $05			; \
;	STA $2140		; | Send the length and address of upload.
;	LDA $07			; |	
;	STA $2142		; /
;	LDA $00			; \
;	STA !upram		; |
;	SEP #$20		; | Set the address properly.
;	LDA $02			; |
;	STA !upram+2		; /
;	LDX $05			; \ Put the size into X
;	DEX			; /
;	LDA #$03		; \
;	STA !idbyte		; / 
	
	
	
;	.loop
;	REP #$20		; \
;	LDA [!upram],x		; | Get the next two bytes
;	STA $2141		; | Send them
;	STA !xorstorage		; / Store them
;	DEX			; \
;	DEX			; |
;	SEP #$20		; |
;	LDA [!upram],x		; | Get the next byte, send it, store it.
;	STA $2140		; |
;	STA !xorstorage		; /
;	DEX			;
;	BMI .noMoreData		; If X has become negative, then we've either sent just enough or to much.  Change the number of bytes to store and quit.
;	
;	LDA !idbyte		; \ Flip the second highest bit of the idbyte
;	EOR #$40		; | Just enough to make it "different" from the last.
;	STA $2143		; | Note that the lowest 2 bits are used to determine how many bytes to write, so we can't just INC $2143 or something.
;	STA !idbyte		; /
;	
;	LDA !xorstorage		; \
;	EOR !xorstorage+1	; | Get the xor of the data sent.
;	EOR !xorstorage+2	; /
;	
;	PHA			;
;	LDA !idbyte		;
;-	CMP $2143		; \ Wait for the SPC to echo back the id we sent.
;	BNE -			; / This tells us it's ready for more data.
;	PLA			; \
;	CMP $2140		; / The SPC will have eor'd the data we sent it together.  If it doesn't match, something's gone wrong.
;	BEQ .loop
;	
;	JMP EmergencyRestart	; > The data was wrong.  We need to restart the transfer.
;	
;.noMoreData			; We've sent either too many or just enough bytes.
;	TXA			; \
;	EOR #$FF		; | Get the number of bytes to send
;	INC			; /
;	ORA #$80		; > Highest bit indicates end of transfer.
;	STA $2123		; > Store
;	
;	LDA !xorstorage		; \
;	EOR !xorstorage+1	; | Get the xor of the data sent.
;	EOR !xorstorage+2	; /
;	PHA			;
;	LDA !idbyte		;
;-	CMP $2143		; \ Wait for the SPC to echo back the id we sent.
;	BNE -			; / This tells us it's ready for more data.
;	PLA			; \
;	CMP $2140		; / The SPC will have eor'd the data we sent it together.  If it doesn't match, something's gone wrong.
;	BEQ .transferOver
;	
;	JMP EmergencyRestart	; > The data was wrong.  We need to restart the transfer.	
;	
;.transferOver	
;	RTL
	
;EmergencyRestart:
;	LDA #$83
;	STA $2143
;	LDA #$FF
;	STA $2141
;	JMP SPCUploadFast

org $008052
	JSR UploadSPCEngine	


