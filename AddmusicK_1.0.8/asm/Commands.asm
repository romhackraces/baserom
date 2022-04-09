arch spc700-raw
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDA:					; Change the instrument (also contains code relevant to $E5 and $F3).
{
	mov	x, $46			;;; get channel*2 in X
	mov	a, #$00			; \ It's not a raw sample playing on this channel.
	mov	!BackupSRCN+x, a	; /
	
	mov	a, $48			; \ 
	eor	a, #$ff			; | No noise is playing on this channel.
	and	a, !MusicNoiseChannels	; | (EffectModifier is called later)
	mov	!MusicNoiseChannels, a	; /
	
	call	GetCommandData		; 
SetInstrument:				; Call this to start playing the instrument in A.
	mov	$14, #InstrumentTable	; \ $14w = the location of the instrument data.
	mov	$15, #InstrumentTable>>8 ;/
	mov	y, #$06			; Normal instruments have 6 bytes of data.
	
	inc	a			; \ 
L_0D4B:					; |		???
	mov	$c1+x, a		; |
	dec	a			; /
	
	bpl	.normalInstrument	; \ 
	mov	$14,#PercussionTable	; | If the instrument was negative, then we use the percussion table instead.	
	mov	$15,#PercussionTable>>8	; /
	setc				; \ 
	sbc	a, #$cf			; | Also "correct" A. (Percussion instruments are stored "as-is", otherwise we'd subtract #$d0.
	inc	y			; / Percussion instruments have 7 bytes of data.
	bra	+
	
	
.normalInstrument 
	cmp	a, #30			; \ 
	bcc 	+			; | If this instrument is >= $30, then it's a custom instrument.
	push	a			; |
	movw	ya, !CustomInstrumentPos ;| So we'll use the custom instrument table.
	movw	$14, ya			; |
	pop	a			; |
	setc				; |
	sbc	a, #30			; |
	mov	y, #$06			; /
+


ApplyInstrument:			; Call this to play the instrument in A whose data resides in a table pointed to by $14w with a width of y.
	mul	ya			; \ 
	addw	ya, $14			; |
	movw	$14, ya			; /

	mov   a, $48			; \ 
	and   a, $1d			; | If there's a sound effect playing, then don't change anything.
	bne   .noSet			; /
	
	call	GetBackupInstrTable	; \
	movw	$10, ya			; /
	
	push	x			; \ 
	mov	a, x			; |
	xcn	a			; | Make x contain the correct DSP register for this channel's voice.
	lsr	a			; |
	or	a, #$04			; |
	mov	x, a			; /
	
	
	
	
	mov	y, #$00			; \ 
	mov	a, ($14)+y		; / Get the first instrument byte (the sample)
	
	mov	($10)+y, a		; (save it in the backup table)
	
	bpl	+			; If the byte was positive, then it was a sample.  Just write it like normal.
	
	push	y
	call	ModifyNoise		; EffectModifier is called at the end of this routine, since it messes up $14 and $15.
	pop	y
	or	(!MusicNoiseChannels), ($48)
	inc	x
	inc	y

-
	mov	a, ($14)+y		; \ 
+	mov	$f2, x			; | 	
	mov	$f3, a			; |
	mov	($10)+y, a		; |
	inc	x			; | This loop will write to the correct DSP registers for this instrument.
	inc	y			; | And correctly set up the backup table.
	cmp	y, #$04			; |
	bne	-			; /
	
	pop	x
	mov	a, ($14)+y		; The next byte is the pitch multiplier.
	mov	$0210+x, a		;
	mov	($10)+y, a		;
	inc	y			;
	mov	a, ($14)+y		; The final byte is the sub multiplier.
	mov	$02f0+x, a		;
	mov	($10)+y, a		;
	
	inc	y			; If this was a percussion instrument,
	mov	a, ($14)+y		; Then it had one extra pitch byte.  Get it just in case.
	
	push	a	
	call	EffectModifier
	pop	a

.noSet
	ret
	
RestoreMusicSample:
	mov	a, #$01			; \ Force !BackupSRCN to contain a non-zero value.
	mov	!BackupSRCN+x, a	; /
	call	GetBackupInstrTable	; \ 
	movw	$14, ya			; |
UpdateInstr:
	mov	y, #$06
	mov	a, #$00
	jmp	ApplyInstrument		; / Set up the current instrument using the backup table instead of the main table.

GetBackupInstrTable:
	mov	$10, #$30		; \ 
	mov	$11, #$01		; |
	mov	y, #$06			; |
	mov	a, x			; | This short routine sets ya to contain a pointer to the current channel's backup instrument data.
	lsr	a			; | 
	mul	ya			; |	
	addw	ya, $10			; /
	ret

}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDB:					; Change the pan
{
	call  GetCommandData
	and   a, #$1f
	mov   !Pan+x, a         ; voice pan value
	mov   a, y
	and   a, #$c0
	mov   !SurroundSound+x, a         ; negate voice vol bits
	mov   a, #$00
	mov   $0280+x, a
	or    ($5c), ($48)       ; set vol chg flag
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDC:					; Fade the pan
{
	call  GetCommandData
	mov   !PanFadeDuration+x, a
	push  a
	call  GetCommandDataFast
	mov   !PanFadeDestination+x, a
	setc
	sbc   a, !Pan+x         ; current pan value
	pop   x
	call  Divide16             ; delta = pan value / steps
	mov   $0290+x, a
	mov   a, y
	mov   $0291+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDD:					; Pitch bend
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDE:					; Vibrato on
{
	call  GetCommandData
	mov   $0340+x, a
	mov   a, #$00
	mov   $0341+x, a
	call  GetCommandDataFast
	mov   $0331+x, a
	call  GetCommandDataFast
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDF:					; Vibrato off (vibrato on goes straight into this, so be wary.)
{
	mov   x, $46
	mov   $a1+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE0:					; Change the master volume
{
	call  GetCommandData
	mov   !MasterVolume, a
	mov   $56, #$00
	mov   $5c, #$ff          ; all vol chgd
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE1:					; Fade the master volume
{
	call  GetCommandData
	mov   $58, a
	call  GetCommandDataFast
	mov   $59, a
	mov   x, $58
	setc
	sbc   a, !MasterVolume
	call  Divide16
	movw  $5a, ya
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE2:					; Change the tempo
{
	call  GetCommandData
L_0E14: 
	adc   a, $0387			; WARNING: This is sometimes called to change the tempo.  Changing this function is NOT recommended!
	mov   $51, a
	mov   $50, #$00
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE3:					; Fade the tempo
{
	call  GetCommandData
	mov   $52, a
	call  GetCommandDataFast
	adc   a, $0387
	mov   $53, a
	mov   x, $52
	setc
	sbc   a, $51
	call  Divide16
	movw  $54, ya
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE4:					; Change the global transposition
{
	call  GetCommandData
	mov   $43, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE5:					; Tremolo on
{
	call  GetCommandData
	;bmi   TSampleLoad		; We're allowed the whole range now.
	mov   $0370+x, a
	call  GetCommandDataFast
	mov   $0361+x, a
	call  GetCommandDataFast
;cmdE6:					; Normally would be tremolo off
	mov   x, $46
	mov   $b1+x, a
	ret
	
	;0DCA
TSampleLoad:
	and   a, #$7F
MSampleLoad:
	push	a
	mov	a, #$01
	mov	!BackupSRCN+x, a
	call	GetBackupInstrTable	; \ 
	movw	$14, ya			; /
	pop	a			; \ 
	mov	y, #$00			; | Write the sample to the backup table.
	mov	($14)+y, a		; /
	call	GetCommandData		; \ 
	mov	y, #$04			; | Get the pitch multiplier byte.
	mov	($14)+y, a		; /
	jmp	UpdateInstr

}	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE6:					; Second loop
{
	call  GetCommandData
	
	bne   label2
	mov   a,$30+x			; \
	mov   $01e0+x,a			; | Save the current song position into $01e0
	mov   a,$31+x			; |
	mov   $01e1+x,a			; /
	mov   a,#$ff			; \ ?
	mov   $01f0+x,a			; /
	ret				;
label2:					;
	push  a				;
	mov   a,$01f0+x			;
	cmp   a,#$01			;
	bne   label3			;
	pop   a				;
	ret				;
label3:	
	cmp   a,#$ff
	beq   label4
	pop   a
	mov   a,$01f0+x
	dec   a
	mov   $01f0+x,a
	bra   label5
label4:	
	pop   a
	mov   $01f0+x,a
label5:	
	mov   a,$01e0+x
	mov   $30+x,a
	mov   a,$01e1+x
	mov   $31+x,a
	ret
}	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdED:					; ADSR
{
	
	call	GetCommandData		; \ 
	push	a			; /
	
	mov	a, #$01			; \ Force !BackupSRCN to contain a non-zero value.
	mov	!BackupSRCN+x, a	; /
	
	call	GetBackupInstrTable	; \ 
	movw	$14, ya			; /
	
	pop	a			; \ 
	eor	a,#$80			; | Write ADSR 1 to the table.
	bpl	.GAIN
	mov	y, #$01			; | 
	mov	($14)+y, a		; /
	call	GetCommandData		; \ 
	mov	y, #$02			; | Write ADSR 2 to the table.
-	mov	($14)+y, a		; /
	
	jmp	UpdateInstr
	
.GAIN
	mov	y, #$01			; \ 
	mov	($14)+y, a		; /
	call	GetCommandData		; \ 
	mov	y, #$03			; | Write GAIN to the table.
	bra	-
		
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE7:					; Change the volume
{
	call  GetCommandData
	mov   !Volume+x, a
	mov   a, #$00
	mov   $0240+x, a
	or    ($5c), ($48)       ; mark volume changed
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE8:					; Fade the volume
{
	call  GetCommandData
	mov   $80+x, a
	push  a
	call  GetCommandDataFast
	mov   $0260+x, a
	setc
	sbc   a, !Volume+x
	pop   x
	call  Divide16
	mov   $0250+x, a		; Never referenced?
	mov   a, y
	mov   $0251+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE9:					; Loop
{
	call  GetCommandData
	push  a
	call  GetCommandDataFast
	push  a
	call  GetCommandDataFast
	mov   $c0+x, a           ; repeat counter = op3
	mov   a, $30+x
	mov   $03e0+x, a
	mov   a, $31+x
	mov   $03e1+x, a         ; save current vptr in 3E0/1+X
	pop   a
	mov   $31+x, a
	mov   $03f1+x, a
	pop   a
	mov   $30+x, a
	mov   $03f0+x, a         ; set vptr/3F0/1+X to op1/2
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEA:					; Fade the vibrato
{
	call  GetCommandData
	mov   $0341+x, a
	push  a
	mov   a, $a1+x
	mov   $0351+x, a
	pop   x
	mov   y, #$00
	div   ya, x
	mov   x, $46
	mov   $0350+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEB:					; Pitch envelope (release)
{
	mov   a, #$01
	bra   L_0E55
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEC:					; Pitch envelope (attack)
{
	mov   a, #$00
L_0E55: 
	mov   x, $46
	mov   $0320+x, a
	call  GetCommandData
	mov   $0301+x, a
	call  GetCommandDataFast
	mov   $0300+x, a
	call  GetCommandDataFast
	mov   $0321+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEE:					; Set the tuning
{
	call  GetCommandData
	mov   $02d1+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEF:					; Echo command 1 (channels, volume)
{
	call	GetCommandData
	mov	!MusicEchoChannels, a
	call	EffectModifier
	call	GetCommandDataFast
	mov	a, #$00
	movw	$61, ya            ; set 61/2 from op2 * $100 (evol L)
	call	GetCommandDataFast
	mov	a, #$00
	movw	$63, ya            ; set 63/4 from op3 * $100 (evol R)
				
; set echo vols from shadows
L_0EEB: 
	mov	a, $62
	mov	y, #$2c
	call	DSPWrite             ; set echo vol L DSP from $62
	mov	a, $64
	mov	y, #$3c
	jmp	DSPWrite             ; set echo vol R DSP from $64
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF0:					; Echo off
{
	mov	x, $46
	mov	!MusicEchoChannels, a           ; clear all echo vbits
	push	a
	call	EffectModifier
	pop	a
L_0F22: 
	mov	y, a
	movw	$61, ya            ; zero echo vol L shadow
	movw	$63, ya            ; zero echo vol R shadow
	call	L_0EEB             ; set echo vol DSP regs from shadows
	;mov   $2e, a             ; zero 2E (but it's never used?)
	or	a, #$20
	mov	y, #$6c
	mov	!NCKValue, a
	jmp	DSPWrite             ; disable echo write, noise freq 0
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF1:					; Echo command 2 (delay, feedback, FIR)
{
	call	GetCommandData
	cmp	a, !MaxEchoDelay
	beq	.justSet
	bcc	.justSet
	bra	.needsModifying
.justSet
	mov	!EchoDelay, a		; \
	mov	$f2, #$7d		; | Write the new delay.
	mov	$f3, a			; /
	bra	+++++++++		; Go to the rest of the routine.
.needsModifying
	call	ModifyEchoDelay

+++++++++		
	;mov	$f2, #$6c		; \ Enable echo and sound once again.
	;mov	$f3, !NCKValue		; /
	and	!NCKValue, #$1f
	mov	a, #$00
	call	ModifyNoise
	
	call	GetCommandData		; From here on is the normal code.
	mov	y, #$0d			;
	call	DSPWrite		; set echo feedback from op2
	call	GetCommandDataFast	;
	mov	y, #$08			;
	mul	ya			;
	mov	x, a			;
	mov	y, #$0f			;
- 					;
	mov	a, EchoFilter0+x	; filter table
	call	DSPWrite		;
	inc	x			;
	mov	a, y			;
	clrc				;
	adc	a, #$10			;
	mov	y, a			;
	bpl	-			; set echo filter from table idx op3
	mov	x, $46			;

	jmp	L_0EEB			; Set the echo volume.
	
WaitForDelay:				; This stalls the SPC for the correct amount of time depending on the value in !EchoDelay.
	mov	a, !EchoDelay		; a delay of $00 doesn't need this
	beq	+
	mov	$14, #$00
	mov	$f2, #$6D
	mov	$15, $f3
	mov	a, #$00
	mov	y, a
	
-	mov	($14)+y, a		; clear the whole echo buffer
	dbnz	y, -
	inc	$15
	bne	-
	
+	ret
	
GetBufferAddress:
	cmp	a, #$00
	beq	+
	asl	a			; \
	asl	a			; |
	asl	a			; |
	asl	a			; | Gets the size of the buffer needed to hold an echo delay this large.
	mov	y, #$80			; |
	mul	ya			; /
	
	eor	a, #$ff			; \
	mov	x, a			; |
	mov	a, y			; |
	eor	a, #$ff			; | All this needed to flip a and y (at least it's only 8 bytes).
	mov	y, a			; |
	mov	a, x			; /
	inc	a			; \ incw in this case.
	inc	y			; /
	
	ret				; 
+
	mov	a, #$fc			; \ A delay of 0 needs 4 bytes for no adequately explained reason.
	mov	y, #$ff			; /
	ret
	
	
ModifyEchoDelay:			; a should contain the requested delay.

	push	a			; Save the requested delay.
	call	GetBufferAddress
	push	y

	mov	!NCKValue, #$60
	mov	a, #$00
	call	ModifyNoise
	
	pop	y			; \
	mov	$f2, #$6d		; | Write the new buffer address.
	mov	$f3, y			; / 
	
	pop	a
	mov	$f2, #$7d		; \
	mov	$f3, a			; | Write the new delay.
	mov	!EchoDelay, a		; |
	mov	!MaxEchoDelay, a	; /
	
	call	WaitForDelay		; > Wait until we can be sure that the echo buffer has been moved safely.

	
	mov	!NCKValue, #$40
	mov	a, #$00
	call	ModifyNoise
	
	
	
	call	WaitForDelay		; > Clear out the RAM associated with the new echo buffer.  This way we avoid noise from whatever data was there before.
	
	mov	!NCKValue, #$00
	mov	a, #$00
	jmp	ModifyNoise
	
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF2:					; Echo fade
{
	call  GetCommandData
	mov   $60, a
	call  GetCommandDataFast
	mov   $69, a
	mov   x, $60
	setc
	sbc   a, $62
	call  Divide16
	movw  $65, ya
	call  GetCommandDataFast
	mov   $6a, a
	mov   x, $60
	setc
	sbc   a, $64
	call  Divide16
	movw  $67, ya
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF3:					; Sample load command
{
	call GetCommandData
	jmp  MSampleLoad
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF4:					; Misc. command
{
	call	GetCommandData
	asl	a
	mov	x,a
	jmp	(SubC_table+x)

SubC_table:
	dw	SubC_0
	dw	SubC_1
	dw	SubC_2
	dw	SubC_3
	dw	$0000
	dw	SubC_5
	dw	SubC_6
	dw	SubC_7
	dw	SubC_8
	dw	SubC_9

SubC_0:
	mov     a, $6e				; 
	eor     a, #$20				;
	mov     $6e, a				;
	call	HandleYoshiDrums		; Handle the Yoshi drums.
SubC_01:	
	mov	a,#$01
SubC_00:
	eor	a,$0160
	mov	$0160,a
	mov     x, $46
	ret

SubC_1:
	mov	a, $0161
	eor	a, $48
	mov	$0161,a
	mov	a,$48
	eor	a,#$FF
	and	a, $0162		
	mov	$0162,a
	mov     x, $46
	ret

SubC_2:
	mov	a, !WaitTime
	eor	a,#$03
	mov	!WaitTime,a
	mov     x, $46
	ret

SubC_3:
	eor	(!MusicEchoChannels), ($48)
	mov     x, $46
	jmp	EffectModifier
	
SubC_5:
	mov    a, #$00
	mov    $0167, a
	mov    $0166, a
	mov	a,#$02
	bra	SubC_00	

	;ret
	
SubC_6:
	eor	($6e), ($48)
	call	HandleYoshiDrums		; Handle the Yoshi drums.
	bra	SubC_01
	
SubC_7:
	mov	$ffff, a
	mov	a, #$00				; \ 
	mov	$0387, a			; | Set the tempo to normal.
	mov	x, $46				; |
	mov	a, $51				; |
	jmp	L_0E14				; /
	
SubC_8:
	mov	!SecondVTable, #$01		; \
	mov	x, $46				; | Toggle which velocity table we're using.
	ret					; /
	
SubC_9:
	mov     x, $46				; \ 
	mov	a, #$00				; | Turn the current instrument back on.
	mov	!BackupSRCN+x, a		; | And make sure it's an instrument, not a sample or something.
	jmp	RestoreInstrumentInformation	; / This ensures stuff like an instrument's ADSR is restored as well.
	
	
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF5:					; FIR Filter command.
{
		mov   y,#$0f
-		push  y
		call  GetCommandData
		pop   y
		call  DSPWrite
		mov   a,y
		clrc
		adc   a,#$10
		mov   y,a
		bpl   -
		ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF6:					; DSP Write command.
{
	call GetCommandData
	push a
	call GetCommandDataFast
	pop y
	jmp DSPWrite
	;ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF7:					; Originally the "write to ARAM command". Disabled by default.
{
;	call GetCommandData
;	push a
;	call GetCommandDataFast
;	mov $21, a
;	call GetCommandDataFast
;	mov $20, a
;	pop a
;	mov y, #$00
;	mov ($20)+y, a
;	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF8:					; Noise command.
{
Noiz:
		call	GetCommandData
		or	(!MusicNoiseChannels), ($48)
		call	ModifyNoise
		jmp	EffectModifier		
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF9:					; Send data to 5A22 command.
{
	call	GetCommandData		; \ Get the next byte
	mov	$0167,a			; / Store it to the low byte of the timer.
	call	GetCommandDataFast	; \ Get the next byte
	mov	$0166,a			; / Store it to the high byte of the timer.
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdFA:					; Misc. comamnd that takes a parameter.
;HTuneValues
{
	call 	GetCommandData
	asl	a
	mov	x,a
	jmp	(SubC_table2+x)

SubC_table2:
	dw	.PitchMod		; 00
	dw	.GAIN			; 01
	dw	.HFDTune		; 02
	dw	.superVolume		; 03
	dw	.reserveBuffer		; 04
	dw	.gainRest		; 05
	dw	.manualVTable		; 06

.PitchMod
	call    GetCommandData		; \ Get the next byte
	mov     !MusicPModChannels, a	; | This is for music.
	jmp	EffectModifier		; / Call the effect modifier routine.
	
.GAIN	
	call    GetCommandData		; \ Get the next byte
	push	a			; / And save it.
	
	mov	a, #$01
	mov	!BackupSRCN+x, a
	
	call	GetBackupInstrTable	; \ 
	movw	$14, ya			; /
	
	pop	a			;
	mov     y, #$03			; \ GAIN byte = parameter
	mov 	($14)+y, a		; /
	mov	y, #$01			
	mov	a, ($14)+y		; \ Clear ADSR bit 7.
	and	a, #$7f			; /
	mov	($14)+y, a		;
	jmp	UpdateInstr
.HFDTune
	call	GetCommandData
	mov     !HTuneValues+x, a
	ret

.superVolume
	call    GetCommandData		; \ Get the next byte
	mov	!VolumeMult+x, a	; / Store it.
	or	($5c), ($48)		; Mark volume changed.
	ret
	
.reserveBuffer
;	
	
	call	GetCommandData
	beq	.modifyEchoDelay
	cmp	a, !MaxEchoDelay
	beq	+
	bcc	+
	bra	.modifyEchoDelay
+
	mov	!EchoDelay, a		; \
	mov	$f2, #$7d		; | Write the new delay.
	mov	$f3, a			; /
	
	and	!NCKValue, #$20
	mov	a, #$00
	jmp	ModifyNoise
	
	ret
	
.modifyEchoDelay
	push	a
	or	!NCKValue, #$20
	call	ModifyEchoDelay		; /
	pop	a			;
	mov	!MaxEchoDelay, a	;
	mov	x, $46			;
	ret				;
	
.gainRest
	;call	GetCommandData
	;mov	!RestGAINReplacement+x, a
	ret
	
.manualVTable
	call	GetCommandData		; \ Argument is which table we're using
	mov	!SecondVTable, a	; |
	mov	$5c, #$ff		; | Mark all channels as needing a volume refresh
	mov	x, $46			;
	ret				; /
	
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
cmdFB:					; Arpeggio command.
{
	call	GetCommandData		; \ Save the number of notes.
	bmi	.special		; | (But if it's negative, then it's a special command).
	mov	!ArpNoteCount+x, a	; /
	push	a			; Remember it.
	
	call	GetCommandDataFast	; \ Save the length between each change.
	mov	!ArpLength+x, a		; |
	mov	!ArpTimeLeft+x, a	; /
	
	mov	a, $30+x		; \
	mov	!ArpNotePtrs+x, a	; | The current channel pointer points to the sequence of notes,
	mov	a, $31+x		; | So save that.
	mov	!ArpNotePtrs+1+x, a	; /
	
	mov	a, #$00			; \
	mov	!ArpNoteIndex+x, a	; | We're currently at note 0.
	mov	!ArpCurrentDelta+x, a	; | The current pitch change is 0.
	mov	!ArpType+x, a		; | The type is 0 (normal arpeggio).
	mov	!ArpSpecial+x, a	; / The loop point is 0.
	
	pop	y			; Y contains the note count.
					; Now we need to skip over all the note data, it isn't important to us right now.
	
	cmp	y, #$00			; If y is already zero (arpeggio off), then skip this next part.
	beq +				;

-
	push	y			; Push y, GetCommandData modifies it.
	call	GetCommandDataFast	; Next byte...
	pop	y			; Get y back.
	dbnz	y, -			; Decrement it.  If it's zero, then we're done.
+
	ret				; And we're done.

.special
	and	a, #$7f			; \
	inc	a			; | Put this value into the type.
	mov	!ArpType+x, a		; /
	
	mov	a, #$02			; \ Force the note count to be non-zero, so it's treated as a valid command.
	mov	!ArpNoteCount+x, a	; / 
	
	call	GetCommandDataFast	; \ Save the length between each change.
	mov	!ArpLength+x, a		; |
	mov	!ArpTimeLeft+x, a	; /
	
	call	GetCommandDataFast	; \ The note difference goes into the note index.
	mov	!ArpSpecial+x, a	; / Yes, its purpose changes here.
	
	mov	a, #$00			; \
	mov	!ArpCurrentDelta+x, a	; / The current pitch change is 0.
	
	ret
	
HandleArpeggio:				; Routine that controls all things arpeggio-related.
	mov	a, !ArpNoteCount+x	; \ If the note count is 0, then this channel is not using arpeggio.
	beq	.return			; /
	
	mov	a, !ArpTimeLeft+x	; \
	dec	a			; | Decrement the timer.
	mov	!ArpTimeLeft+x, a	; /
	beq	.doStuff		; If the time left is 0, then we have work to do.
	cmp	a, !WaitTime		; \ If the time left is 2 (or 1), then key off this voice in preparation. 
	beq	.keyOffVoice		; /
.return
	ret				; Otherwise, do nothing.
	
.keyOffVoice
	mov	a, $48			; \ 
	push	a			; |
	and	a,$0161			; | Key off the current voice (with conditions).
	and	a,$0162			; |
	pop	a			; |
	bne	.return			; |
	;mov	y, #$5c			; | Key off this voice (but only if there's no sound effect currently playing on it).
	jmp	KeyOffVoicesWithCheck	; /
	

.doStuff
	mov	a, !ArpType		;
	cmp	a, #$01			; \ If it's 1, then it's a trill
	beq	.trill			; /
	cmp	a, #$02			; \ If it's 2, then it's a glissando.
	beq	.glissando		; /
.normal					; Otherwise (it's a 0), it's a normal arpeggio.
	mov	a, !ArpNoteIndex+x	; \
	inc	a			; / Increment the note index.
	cmp	a, !ArpNoteCount+x	; \ 
	bne +				; | If the note index is equal to the note count, then reset it to the loop point.
	mov	a, !ArpSpecial+x	; /
+					;
	mov	!ArpNoteIndex+x, a	; \
	mov	y, a			; / Save the current note index and put it into y.
	
	mov	a, !ArpNotePtrs+x	; \
	mov	$14, a			; |
	mov	a, !ArpNotePtrs+1+x	; | Put the current pointer into $14w
	mov	$15, a			; /
	
	mov	a, ($14)+y		; Get the current delta.
	cmp	a, #$80			; \
	beq	.setLoopPoint		; / If the current delta is #$80, then it's actually the loop point.
	mov	!ArpCurrentDelta+x, a	; 
	bra	.playNote
.setLoopPoint
	inc	y			; \
	mov	a, y			; | Set the current position as the loop point.
	mov	!ArpSpecial+x, a	; /
	bra	.normal			; Now get the next, -actual- note.

.playNote
	mov	a, !ArpLength+x		; \ Now wait for this many ticks again.
	mov	!ArpTimeLeft+x, a	; /
	
	mov	a, !PreviousNote+x	; \ Play this note.
	call	NoteVCMD		; /
	
	mov	a, $48			; \
	push	a			; |
	and	a,$0161			; | Key on the current voice (with conditions).
	and	a,$0162
	pop	a
	bne	.return			; |
+
	jmp	KeyOnVoices		; / Key on this voice.
	
.trill
	mov	a, !ArpCurrentDelta+x	; \ Opposite note.
	eor	a, !ArpSpecial+x	; |
	mov	!ArpCurrentDelta+x, a	; |
	bra	.playNote		; /
	
.glissando
	mov	a, !ArpCurrentDelta+x	; \
	clrc				; |
	adc	a, !ArpSpecial+x	; |
	mov	!ArpCurrentDelta+x, a	; |
	bra	.playNote		; /
	
}	
	
cmdFC:
{
	call	GetCommandData				; \
	push	a					; | Get and save the remote address (we don't know where it's going).
	call	GetCommandDataFast			; |
	push	a					; /
	call	GetCommandDataFast			; \
	cmp	a, #$ff					; |
	beq	.noteStartCommand			; | Handle types #$ff, #$04, and #$00. #$04 and #$00 take effect now; #$ff has special properties.
	cmp	a, #$04					; |
	beq	.immediateCall				; |
	cmp	a, #$00					; |
	beq	ClearRemoteCodeAddressesPre		; /
							;
	pop	a					; \
	mov	!remoteCodeTargetAddr+1+x, a		; | Normal code; get the address back and store it where it belongs.
	pop	a					; |
	mov	!remoteCodeTargetAddr+x, a		; /
							;
	mov	a, y					; \ Store the code type.
	cmp	a, #$05
	bne +
	mov	a, #$03
	+
	mov	!remoteCodeType+x, a			; |
	call	GetCommandDataFast			; \ Store the argument.
	mov	!remoteCodeTimeValue+x, a		; /
	ret						;
	
	
.noteStartCommand					;
	pop	a					; \
	mov	!remoteCodeTargetAddr2+1+x, a		; | Note start code; get the address back and store it where it belongs.
	pop	a					; |
	mov	!remoteCodeTargetAddr2+x, a		; /
-							;
	call	GetCommandDataFast			; \ Get the argument and discard it.
	ret						; /
							
.immediateCall						;
	mov	a, !remoteCodeTargetAddr+x		; \
	mov	$14, a					; | Save the current code address.
	mov	a, !remoteCodeTargetAddr+1+x		; |
	mov	$15, a					; /
							;
	pop	a					; \
	mov	!remoteCodeTargetAddr+1+x, a		; | Retrieve this command's code address
	pop	a					; | And pretend this is where it belongs.
	mov	!remoteCodeTargetAddr+x, a		; /
	
	mov	a, $15					; \
	push	a					; | Push onto the stack, since there's a very good chance
	mov	a, $14					; | that whatever code we call modifies $14.w
	push	a					; /
	
	call	RunRemoteCode				; 
							;
	pop	a					; \
	mov	!remoteCodeTargetAddr+x, a		; | Restore the standard remote code.
	pop	a					; |
	mov	!remoteCodeTargetAddr+1+x, a		; /
							;
	;call	GetCommandDataFast			; \ Get the argument, discard it, and return.
	bra	-					; /

	
ClearRemoteCodeAddressesPre:
	pop	a
	pop	a
	call	GetCommandDataFast
	
ClearRemoteCodeAddresses:
	mov	a, #$00
	mov	!remoteCodeTargetAddr2+1+x, a
	mov	!remoteCodeTargetAddr2+x, a
	mov	!remoteCodeTargetAddr+1+x, a
	mov	!remoteCodeTargetAddr+x, a
	mov	!remoteCodeTimeValue+x, a
	mov	!remoteCodeTimeLeft+x, a
	mov	!remoteCodeType+x, a
	mov	!remoteCodeTargetAddr+x, a
	mov	!remoteCodeTargetAddr+1+x, a
	mov	!runningRemoteCode, a
	ret
}

cmdFD:
cmdFE:
cmdFF:
;ret

