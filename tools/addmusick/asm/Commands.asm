arch spc700-raw
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !noSFX = !false
TerminateIfSFXPlaying:
	mov	a, $48
	and	a, $1d
	beq	+
	;WARNING: Won't work if anything else is in the stack!
	pop	a	;Jump forward one pointer in the stack in order to
	pop	a	;terminate the entire preceding routine.
+
	ret
endif

SetBackupSRCN:
	mov	a, #$40			; \ Force !BackupSRCN to contain a non-zero value.
ORBackupSRCN:
	or	a, !BackupSRCN+x	; |
	mov	!BackupSRCN+x, a	; /
	ret

SetBackupSRCNAndGetBackupInstrTable:
	push	a
	call	SetBackupSRCN
	call	GetBackupInstrTable
	pop	a
	ret

SetupPercInstrument:
	setc
	sbc	a, #$cf			; Also "correct" A. (Percussion instruments are stored "as-is", otherwise we'd subtract #$d0.
	mov	y, #$07			; Percussion instruments have 7 bytes of data.
	mov	$10, #PercussionTable
	mov	$11, #PercussionTable>>8
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdED:					; ADSR
{
	call	SetBackupSRCNAndGetBackupInstrTable
	eor	a,#$80			; \ Write ADSR 1 to the table.
	push	p
	mov	y, #$01			; | 
	mov	($10)+y, a		; /
	call	GetCommandData		; \
	mov	y, #$02			; | Write ADSR 2 to the table.
	pop	p			; | 
	bmi	+			; | 
	inc	y			; | Write GAIN to the table.
+	mov	($10)+y, a		; /
	
	bra	UpdateInstr
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF3:					; Sample load command
{
MSampleLoad:
	call	SetBackupSRCNAndGetBackupInstrTable
	mov	y, #$00			; \ Write the sample to the backup table.
	mov	($10)+y, a		; /
	call	GetCommandData		; \ 
	mov	y, #$04			; | Get the pitch multiplier byte.
	mov	($10)+y, a		; |
.clearSubmultiplierPatchGate		; |
	bra	.clearSubmultiplierSkip	; |
	inc	y			; | Zero out pitch sub-multiplier.
	mov	a, #$00			; |
	mov	($10)+y, a		; /
.clearSubmultiplierSkip
	bra	UpdateInstr
}

SubC_table2_GAIN:
	call	SetBackupSRCNAndGetBackupInstrTable
	mov     y, #$03			; \ GAIN byte = parameter
	mov 	($10)+y, a		; /
	mov	y, #$01			
	mov	a, ($10)+y		; \ Clear ADSR bit 7.
	and	a, #$7f			; /
	mov	($10)+y, a		;
	bra	UpdateInstr

RestoreMusicSample:
	call	SetBackupSRCNAndGetBackupInstrTable
UpdateInstr:
	mov	a, #$00
	bra	ApplyInstrumentY6	; / Set up the current instrument using the backup table instead of the main table.

cmdDA:					; Change the instrument (also contains code relevant to $E5 and $F3).
{
	mov	a, #$00			; \ It's not a raw sample playing on this channel.
	mov	!BackupSRCN+x, a	; /
	
	mov	a, $48			; \ No noise is playing on this channel.
	tclr	!MusicNoiseChannels, a	; / (EffectModifier is called later)
	
	mov	a, y

SetInstrument:				; Call this to start playing the instrument in A.
	mov	$10, #InstrumentTable	; \ $10w = the location of the instrument data.
	mov	$11, #InstrumentTable>>8 ;/
	mov	y, #$06			; Normal instruments have 6 bytes of data.
	
	inc	a			; \ 
L_0D4B:					; |		???
	mov	$c1+x, a		; |
	dec	a			; /
	
	bpl	.normalInstrument	; \ 
	call	SetupPercInstrument	; / If the instrument was negative, then we use the percussion table instead.
	bra	+
	
	
.normalInstrument 
	cmp	a, #30			; \ 
	bcc 	+			; | If this instrument is >= $30, then it's a custom instrument.
	push	a			; |
	movw	ya, !CustomInstrumentPos ;| So we'll use the custom instrument table.
	movw	$10, ya			; |
	pop	a			; |
	setc				; |
	sbc	a, #30			; |
ApplyInstrumentY6:
	mov	y, #$06			; /
+


ApplyInstrument:			; Call this to play the instrument in A whose data resides in a table pointed to by $14w with a width of y.
	mul	ya			; \ 
	addw	ya, $10			; |
	movw	$14, ya			; /

	call	GetBackupInstrTable

	mov	y, #$00			; \ 
	mov	a, ($14)+y		; / Get the first instrument byte (the sample)
	bpl	+
if !noSFX = !false
	and	a, #$1f
	mov	$0389, a
endif
	or	(!MusicNoiseChannels), ($48)
	bra	++
+
	mov	($10)+y, a		; (save it in the backup table)
++
	mov	y, #$05
-
	mov	a, ($14)+y
	mov	($10)+y, a
	dbnz	y, -

if !noSFX = !false
	call	TerminateIfSFXPlaying	; If there's a sound effect playing, then don't change anything.
endif
	
	push	x			; \ 
	mov	a, x			; |
	xcn	a			; | Make x contain the correct DSP register for this channel's voice.
	lsr	a			; |
	or	a, #$04			; |
	mov	x, a			; /
	
	
	
	
	mov	y, #$00			; \ 
	mov	a, ($14)+y		; / Get the first instrument byte (the sample)
	bmi	.noiseInstrument	; If the byte was positive, then it was a sample.  Just write it like normal.

	mov	$f2, x	
	mov	$f3, a
	bra	.DSPWriteDirectionGate1

.noiseInstrument
if !noSFX = !false
	cmp	!SFXNoiseChannels, #$00
	bne	.DSPWriteDirectionGate1
endif	
	push	y
	call	ModifyNoise
	pop	y
.DSPWriteDirectionGate1
	bra	.incXY
	mov	a, x
	or	a, #$07
	mov	x, a
	mov	y, #$03

-
	mov	a, ($14)+y		; \ 
	mov	$f2, x			; | This loop will write to the correct DSP registers for this instrument.	
	mov	$f3, a			; /
.DSPWriteDirectionGate2
	bra	.incXY
	dec	x
	dbnz	y, -
	
	mov	y, #$04
	bra	+

.incXY
	inc	x
	inc	y
	cmp	y, #$04
	bne	-
+
	pop	x
	mov	a, ($14)+y		; The next byte is the pitch multiplier.
	mov	$0210+x, a		;
	inc	y			;
	mov	a, ($14)+y		; The final byte is the sub multiplier.
	mov	$02f0+x, a		;
	call	EffectModifier
	
	inc	y			; If this was a percussion instrument,
	mov	a, ($14)+y		; Then it had one extra pitch byte.  Get it just in case.

	ret

GetBackupInstrTable:
	mov	$10, #$30		; \ 
	mov	$11, #$01		; |
	mov	y, #(6/2)			; |
	mov	a, x			; | This short routine sets $10 to contain a pointer to the current channel's backup instrument data.
	mul	ya			; |	
	addw	ya, $10			; |
	movw	$10, ya			; /
	ret

}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDB:					; Change the pan
{
	and   a, #$1f
	mov   !Pan+x, a         ; voice pan value
	mov   a, y
	and   a, #$c0
	mov   !SurroundSound+x, a         ; negate voice vol bits
	mov   a, #$00
	mov   $0280+x, a
SetVolChangeFlag:
	or    ($5c), ($48)       ; set vol chg flag
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE7:					; Change the volume
{
	mov   !Volume+x, a
	mov   a, #$00
	mov   $0240+x, a
	bra   SetVolChangeFlag       ; mark volume changed
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SubC_table2_superVolume:
	mov	!VolumeMult+x, a
	bra	SetVolChangeFlag	; Mark volume changed.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmdDC:					; Fade the pan
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmdDD:					; Pitch bend
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdDE:					; Vibrato on
{
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
	mov   $a1+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE0:					; Change the master volume
{
	mov   !MasterVolume, a
	mov   $56, #$00
	mov   $5c, #$ff          ; all vol chgd
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE1:					; Fade the master volume
{
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
SubC_7:
	mov	a, #$00				; \ 
SubC_7_storeTo387:
	mov	$0387, a			; | Set the tempo to normal.
	mov	a, $51				; /

cmdE2:					; Change the tempo
{
L_0E14: 
	adc   a, $0387			; WARNING: This is sometimes called to change the tempo.  Changing this function is NOT recommended!
	mov   $51, a
	mov   $50, #$00
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE3:					; Fade the tempo
{
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
	mov   $43, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE5:					; Tremolo on
{
	;bmi   TSampleLoad		; We're allowed the whole range now.
	mov   $0370+x, a
	call  GetCommandDataFast
	mov   $0361+x, a
	call  GetCommandDataFast
cmdFD:					; Tremolo off
	mov   $b1+x, a
	ret
	
	;0DCA
TSampleLoad:
	;and   a, #$7F
	;jmp	MSampleLoad


}	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE6:					; Second loop
{
	bne   label2
	dec   a				; \ ?
	mov   $01f0+x,a			; /
	mov   a,$30+x			; \
	mov   $01e0+x,a			; | Save the current song position into $01e0
	mov   a,$31+x			; |
	mov   $01e1+x,a			; /
	ret				;

label2:
	mov   a, $01f0+x
	dec   a
	beq   label4
	cmp   a, #$fe
	bne   label3
	mov   a, y
label3:
	setp
	mov.b $01f0&$ff+x,a
	mov.b a,$01e0&$ff+x
	mov.b y,$01e1&$ff+x
	clrp
	mov   $30+x,a
	mov   $31+x,y
label4:
	ret
}	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmdE8:					; Fade the volume
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdE9:					; Loop
{
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
	mov   $0320+x, a
	mov   a, y
	mov   $0301+x, a
	call  GetCommandDataFast
	mov   $0300+x, a
	call  GetCommandDataFast
	mov   $0321+x, a
	ret
}
cmdFE:					; Pitch envelope off
{
	mov   $0300+x, a
	ret
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEE:					; Set the tuning
{
	mov   $02d1+x, a
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdEF:					; Echo command 1 (channels, volume)
{
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
	mov	$f2, #$2c            ; set echo vol L DSP from $62
	mov	$f3, $62
	set1	$f2.4                ; set echo vol R DSP from $64 
	mov	$f3, $64          
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmdF0:					; Echo off
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF1:					; Echo command 2 (delay, feedback, FIR)
{
	cmp	a, !MaxEchoDelay
	beq	.justSet
	bcs	.needsModifying
.justSet
	call	SetEDLVarDSP		; Write the new delay.
	bra	+++++++++		; Go to the rest of the routine.
.needsModifying
	call	ModifyEchoDelay

+++++++++		
	;mov	$f2, #$6c		; \ Enable echo and sound once again.
	;mov	$f3, !NCKValue		; /
	and	!NCKValue, #$1f
	call	SetFLGFromNCKValue
	
	call	GetCommandData		; From here on is the normal code.
	mov	a, #$0d			;
	movw	$f2, ya			; set echo feedback from op2
	call	GetCommandDataFast	;
	mov	y, #$08			;
	mul	ya			;
	mov	x, a			;
	mov	$f2, #$0f		;
-					;
	mov	a, EchoFilter0+x	; filter table
	mov	$f3, a			;
	inc	x			;
	clrc				;
	adc	$f2,#$10		;
	bpl	-			; set echo filter from table idx op3
	bra	L_0EEB			; Set the echo volume.

SetEDLVarDSP:
	mov	!EchoDelay, a		; \
SetEDLDSP:
	mov	$f2, #$7d		; | Write the new delay.
	mov	$f3, a			; /
	ret
	
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF2:					; Echo fade
{
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
cmdF4:					; Misc. command
{
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
	not1    $6e.5				; 
SubC_00:
	call	HandleYoshiDrums		; Handle the Yoshi drums.
	mov	a,#$01
	cmp	$6e, #$00
	beq	SubC_02

SubC_01:
	tset	$0160, a
	ret

SubC_02:
	tclr	$0160, a
	ret

SubC_1:
	mov	a,$48
	tclr	$0162, a
	eor	a, $0161
	mov	$0161,a
	ret

SubC_2:
	eor	!WaitTime, #$03
	ret
	
SubC_5:
	mov    a, #$00
	mov    $0167, a
	mov    $0166, a
	not1   $0160.1
	ret
	
SubC_6:
	eor	($6e), ($48)
	bra	SubC_00
	
SubC_8:
	mov	!SecondVTable, #$01		; Toggle which velocity table we're using.
cmdF5Ret:
	ret	
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF5:					; FIR Filter command.
{
		mov   a, #$0f
		movw  $f2, ya
-		clrc
		adc   $f2,#$10
		bmi   cmdF5Ret
		call  GetCommandData
		mov   $f3, a
		bra   -
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmdF6:					; DSP Write command.
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF7:					; Originally the "write to ARAM command". Disabled by default.
{
;	push a
;	call GetCommandDataFast
;	mov $15, a
;	call GetCommandDataFast
;	mov $14, a
;	pop a
;	mov y, #$00
;	mov ($14)+y, a
;	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;cmdF8:					; Noise command.
{
	; Handled elsewhere.
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdF9:					; Send data to 5A22 command.
{
	mov	$0167,a			; Store it to the low byte of the timer.
	call	GetCommandDataFast	; \ Get the next byte
	mov	$0166,a			; / Store it to the high byte of the timer.
	ret
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cmdFA:					; Misc. comamnd that takes a parameter.
;HTuneValues
{
	cmp	a, #$7F
	beq	HotPatchPresetVCMD
	cmp	a, #$FE
	beq	HotPatchVCMDByBit

	mov	$14, #SubC_table2+1&$FF
	mov	$15, #SubC_table2+1>>8&$FF
	asl	a
	mov	y, a
	adc	$15, #$00
	mov	a, ($14)+y
	push	a
	decw	$14
	mov	a, ($14)+y
	push	a
	push	y
	call	GetCommandData
	pop	y
	;Y will contain the command ID shifted left by one, A will contain
	;the incoming data and X will contain the channel ID.
	ret

HotPatchPresetVCMD:
	call	GetCommandData
	;bmi	HotPatchPresetVCMDUserPatch
	mov	y, $30+x
	push	y
	mov	y, $31+x
	push	y
	asl	a
	clrc
	adc	a, #HotPatchPresetTable&$FF
	mov	$30+x, a
	mov	a, #HotPatchPresetTable>>8&$FF
	adc	a, #$00
	mov	$31+x, a
	call	GetCommandDataFast
	call	HotPatchVCMDByBitByte0
	jmp	RestoreTrackPtrFromStack

HotPatchPresetVCMDUserPatch:
	;Make sure you uncommented bmi HotPatchPresetVCMDUserPatch before
	;using (and the ret opcode)!

	;Hello there! You've found the user hot patch section! This is
	;reserved for any code modifications you want to make on the fly
	;without accidentally breaking something later on due to a preset ID
	;being overwritten.

	;ret

HotPatchVCMDByBit:
	call	GetCommandData
HotPatchVCMDByBitByte0:
	mov	$10, a
	push	p
	mov	A, #HotPatchVCMDByte0StorageSet&$FF
	mov	Y, #(HotPatchVCMDByte0StorageSet>>8)&$FF
	call	HotPatchVCMDByBitProcessByte
	pop	p
HotPatchVCMDByBitByte1:
	call	HotPatchVCMDFetchNextByteIfMinus
	mov	$10, a
	push	p
	mov	A, #HotPatchVCMDByte1StorageSet&$FF
	mov	Y, #(HotPatchVCMDByte1StorageSet>>8)&$FF
	call	HotPatchVCMDByBitProcessByte
	pop	p

	;NOTE: For those of you that want to use extra bits, a template is
	;provided below, commented out. You will find the corresponding
	;collection nearby, also commented out.
	;- $10 will contain all of the bits to process in the current byte.
	;- $11 is reserved to execute an indexed X fetch via a subroutine
	;  call. The RET opcode is temporarily stored in $16 to do this,
	;  then overwritten for byte storage reasons.
	;- $12-$13 store the pointer to an array containing a pointer to the
	;  storage set, followed by the number of bytes to write for each of
	;  the seven bits to apply the hot patch (the highest bit means
	;  fetch another byte: if this is not set, all subsequent bits will
	;  be zero).
	;- $14-$15 store the pointer to the storage set. Each byte
	;  modified takes up a four-byte storage entry: two for the pointer,
	;  one to use when the bit is cleared, and one to use when the bit
	;  is set. A template will be found nearby that matches the label
	;  name shown.
	;- $16-$17 store the pointer that we will be writing a byte to.

HotPatchVCMDByBitByte2:
	;call	HotPatchVCMDFetchNextByteIfMinus
	;mov	$10, a
	;push	p
	;mov	A, #HotPatchVCMDByte2StorageSet&$FF
	;mov	Y, #(HotPatchVCMDByte2StorageSet>>8)&$FF
	;call	HotPatchVCMDByBitProcessByte
	;pop	p

HotPatchVCMDByBitByteFetchLoop:
	;There are still bytes to read, but the remaining bits do not yet have a function.
	call	HotPatchVCMDFetchNextByteIfMinus
	bmi	HotPatchVCMDByBitByteFetchLoop
HotPatchVCMDByBitByteFetchLoopSkip:
	ret

HotPatchVCMDByBitProcessByte:
	mov	$11, #$F5 ;MOV A, !A+X opcode
	movw	$12, ya
HotPatchVCMDByBitProcessByte_count:
	mov	y, #$07
	mov	$14, #$6F ;RET opcode
	mov	x, #$00
	call	$0011
	mov	HotPatchVCMDByBitProcessByte_storagePtrLo+1, a
	inc	x
	call	$0011
	mov	$15, a
-
	mov	$14, #$6F ;RET opcode
	lsr	$10
	inc	x
	call	$0011
	push	y
	mov	y, a
	beq	+
HotPatchVCMDByBitProcessByte_storagePtrLo:
	mov	$14, #$00
	call	HotPatchVCMDByBitProcessStorages
+
	pop	y
	dbnz	y, -
	ret

HotPatchVCMDByBitProcessStorages:
-
	push	p
	push	y
	mov	y, #$00
	mov	a, ($14)+y
	mov	$16, a
	inc	y
	mov	a, ($14)+y
	mov	$17, a
	inc	y
	bcc	+
	inc	y
+
	mov	a, ($14)+y
	mov	y, #$00
	mov	($16)+y, a
	mov	a, #$04
	addw	ya, $14
	movw	$14, ya
	mov	HotPatchVCMDByBitProcessByte_storagePtrLo+1, a
	pop	y
	pop	p
	dbnz	y, -
	ret

HotPatchVCMDByte0StorageSet:
	dw	HotPatchVCMDByte0Bit0Storages
	db	(HotPatchVCMDByte0Bit0StoragesEOF-HotPatchVCMDByte0Bit0Storages)/4
	db	(HotPatchVCMDByte0Bit1StoragesEOF-HotPatchVCMDByte0Bit1Storages)/4
	db	(HotPatchVCMDByte0Bit2StoragesEOF-HotPatchVCMDByte0Bit2Storages)/4
	db	(HotPatchVCMDByte0Bit3StoragesEOF-HotPatchVCMDByte0Bit3Storages)/4
	db	(HotPatchVCMDByte0Bit4StoragesEOF-HotPatchVCMDByte0Bit4Storages)/4
	db	(HotPatchVCMDByte0Bit5StoragesEOF-HotPatchVCMDByte0Bit5Storages)/4
	db	(HotPatchVCMDByte0Bit6StoragesEOF-HotPatchVCMDByte0Bit6Storages)/4

	;Storage set format:
	;xx xx yy zz
	;xx xx - Storage pointer
	;yy - Byte to store when bit is clear
	;zz - Byte to store when bit is set

	;Byte 0 Bit 0 Clear - Arpeggio plays during rests
	;Byte 0 Bit 0 Set - Arpeggio doesn't play during rests
HotPatchVCMDByte0Bit0Storages:
	dw	HandleArpeggioInterrupt_restOpcodeGate
	db	$B0 ;BCS opcode
	db	$F0 ;BEQ opcode

	dw	HandleArpeggio_restBranchGate+1
	db	$00
	db	HandleArpeggio_return2-HandleArpeggio_restBranchGate-2
HotPatchVCMDByte0Bit0StoragesEOF:

	;Byte 0 Bit 1 Clear - Write ADSR to DSP registers first during instrument setup
	;Byte 0 Bit 1 Clear - Write GAIN to DSP registers first during instrument setup
HotPatchVCMDByte0Bit1Storages:
	dw	ApplyInstrument_DSPWriteDirectionGate1+1
	db	ApplyInstrument_incXY-ApplyInstrument_DSPWriteDirectionGate1-2
	db	$00

	dw	ApplyInstrument_DSPWriteDirectionGate2+1
	db	ApplyInstrument_incXY-ApplyInstrument_DSPWriteDirectionGate2-2
	db	$00
HotPatchVCMDByte0Bit1StoragesEOF:

	;Byte 0 Bit 2 Clear - Readahead does not look inside subroutines and loop sections
	;Byte 0 Bit 2 Set - Readahead looks inside subroutines and loop sections
HotPatchVCMDByte0Bit2Storages:
	dw	L_10B2_loopSectionBranchGate+1
	db	$00
	db	L_10B2_loopSection-L_10B2_loopSectionBranchGate-2

	dw	L_10B2_subroutineBranchGate+1
	db	$00
	db	L_10B2_subroutine-L_10B2_subroutineBranchGate-2

	dw	L_10B2_zeroVCMDCheckGate+1
	db	L_10B2_jmpToL_10D1-L_10B2_zeroVCMDCheckGate-2
	db	L_10B2_subroutineCheck-L_10B2_zeroVCMDCheckGate-2
HotPatchVCMDByte0Bit2StoragesEOF:

	;Byte 0 Bit 3 Clear - $DD VCMD does not account for per-channel transposition
	;Byte 0 Bit 3 Set - $DD VCMD accounts for per-channel transposition
HotPatchVCMDByte0Bit3Storages:
	dw	cmdDDAddHTuneValuesGate+1
	db	cmdDDAddHTuneValuesSkip-cmdDDAddHTuneValuesGate-2
	db	$00
HotPatchVCMDByte0Bit3StoragesEOF:

	;Byte 0 Bit 4 Clear - $F3 VCMD does not zero out pitch base fractional multiplier
	;Byte 0 Bit 4 Set - $F3 VCMD zeroes out pitch base fractional multiplier
HotPatchVCMDByte0Bit4Storages:
	dw	MSampleLoad_clearSubmultiplierPatchGate+1
	db	MSampleLoad_clearSubmultiplierSkip-MSampleLoad_clearSubmultiplierPatchGate-2
	db	$00
HotPatchVCMDByte0Bit4StoragesEOF:

	;Byte 0 Bit 5 Clear - Echo writes are not disabled when EDL is zero on initial playback of local song
	;Byte 0 Bit 5 Set - Echo writes are disabled when EDL is zero on initial playback of local song
	;NOTE: This bit is sensitive to order of execution! The $FA $04 VCMD
	;must be executed after the patch is set, not before!
HotPatchVCMDByte0Bit5Storages:
	dw	SubC_table2_reserveBuffer_echoWriteBitClearLoc+1
	db	!NCKValue
	db	$10
HotPatchVCMDByte0Bit5StoragesEOF:

	;Byte 0 Bit 6 Clear - When using arpeggio, glissando disables itself after two base notes
	;Byte 0 Bit 6 Set - When using arpeggio, glissando disables itself after one base note
HotPatchVCMDByte0Bit6Storages:
	dw	cmdFB_glissNoteCounter+1
	db	$02
	db	$01
HotPatchVCMDByte0Bit6StoragesEOF:

HotPatchVCMDByte1StorageSet:
	dw	HotPatchVCMDByte1Bit0Storages
	db	(HotPatchVCMDByte1Bit0StoragesEOF-HotPatchVCMDByte1Bit0Storages)/4
	db	(HotPatchVCMDByte1Bit1StoragesEOF-HotPatchVCMDByte1Bit1Storages)/4
	db	(HotPatchVCMDByte1Bit2StoragesEOF-HotPatchVCMDByte1Bit2Storages)/4
	db	(HotPatchVCMDByte1Bit3StoragesEOF-HotPatchVCMDByte1Bit3Storages)/4
	db	(HotPatchVCMDByte1Bit4StoragesEOF-HotPatchVCMDByte1Bit4Storages)/4
	db	(HotPatchVCMDByte1Bit5StoragesEOF-HotPatchVCMDByte1Bit5Storages)/4
	db	(HotPatchVCMDByte1Bit6StoragesEOF-HotPatchVCMDByte1Bit6Storages)/4

HotPatchVCMDByte1Bit0Storages:
	;Byte 1 Bit 0 Clear - Rests are forcibly keyed off when read
	;Byte 1 Bit 0 Set - Rests are only keyed off if encountered in readahead
	dw	if_rest_koffCheckGate
	db	$F0 ;BEQ opcode
	db	$2F ;BRA opcode
HotPatchVCMDByte1Bit0StoragesEOF:

HotPatchVCMDByte1Bit1Storages:
	;This bit is not yet defined.
HotPatchVCMDByte1Bit1StoragesEOF:

HotPatchVCMDByte1Bit2Storages:
	;This bit is not yet defined.
HotPatchVCMDByte1Bit2StoragesEOF:

HotPatchVCMDByte1Bit3Storages:
	;This bit is not yet defined.
HotPatchVCMDByte1Bit3StoragesEOF:

HotPatchVCMDByte1Bit4Storages:
	;This bit is not yet defined.
HotPatchVCMDByte1Bit4StoragesEOF:

HotPatchVCMDByte1Bit5Storages:
	;This bit is not yet defined.
HotPatchVCMDByte1Bit5StoragesEOF:

HotPatchVCMDByte1Bit6Storages:
	;This bit is not yet defined.
HotPatchVCMDByte1Bit6StoragesEOF:

HotPatchVCMDByte2StorageSet:
	;dw	HotPatchVCMDByte2Bit0Storages
	;db	(HotPatchVCMDByte2Bit0StoragesEOF-HotPatchVCMDByte2Bit0Storages)/4
	;db	(HotPatchVCMDByte2Bit1StoragesEOF-HotPatchVCMDByte2Bit1Storages)/4
	;db	(HotPatchVCMDByte2Bit2StoragesEOF-HotPatchVCMDByte2Bit2Storages)/4
	;db	(HotPatchVCMDByte2Bit3StoragesEOF-HotPatchVCMDByte2Bit3Storages)/4
	;db	(HotPatchVCMDByte2Bit4StoragesEOF-HotPatchVCMDByte2Bit4Storages)/4
	;db	(HotPatchVCMDByte2Bit5StoragesEOF-HotPatchVCMDByte2Bit5Storages)/4
	;db	(HotPatchVCMDByte2Bit6StoragesEOF-HotPatchVCMDByte2Bit6Storages)/4

HotPatchVCMDByte2Bit0Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit0StoragesEOF:

HotPatchVCMDByte2Bit1Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit1StoragesEOF:

HotPatchVCMDByte2Bit2Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit2StoragesEOF:

HotPatchVCMDByte2Bit3Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit3StoragesEOF:

HotPatchVCMDByte2Bit4Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit4StoragesEOF:

HotPatchVCMDByte2Bit5Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit5StoragesEOF:

HotPatchVCMDByte2Bit6Storages:
	;dw memory location here
	;db byte to write when bit is cleared here
	;db byte to write when bit is set here
	;repeat as many times as you want prior to the EOF label
	;then proceed to the next bit
HotPatchVCMDByte2Bit6StoragesEOF:

HotPatchPresetTable:
	;All presets are specified as two bytes for indexing and
	;divisibility reasons. This means the highest byte is set on the
	;first byte.
	  ;First byte is specified as...
	  ;%!xyzabcd
	  ;%! - New byte specified
	   ;%x - When using arpeggio, glissando disables itself after one base note
	    ;%y - Echo writes are disabled when EDL is zero on initial playback of local song
	     ;%z - $F3 VCMD zeroes out pitch base fractional multiplier
	      ;%a - $DD VCMD accounts for per-channel transposition
               ;%b - Readahead looks inside subroutines and loop sections
	        ;%c - ADSR/GAIN write orders are flipped during instrument setup
	         ;%d - Arpeggio doesn't play during rests

	  ;Second byte is specified as...
	  ;%!xyzabcd
	  ;%! - New byte specified
	   ;%x - Reserved for playback adjustment for other Addmusics
	    ;%y - Reserved for playback adjustment for other Addmusics
	     ;%z - Reserved for playback adjustment for other Addmusics
	      ;%a - Reserved for playback adjustment for other Addmusics
	       ;%b - Reserved for playback adjustment for other Addmusics
	        ;%c - Reserved for playback adjustment for other Addmusics
	         ;%d - Rests are only keyed off if encountered in readahead

	db %10000000 ; 00 - AddmusicK1.0.8 and earlier (not counting Beta)
	             ; %??0?000? also replicates Vanilla SMW's behavior
	db %00000000 ; %???????1 also replicates Vanilla SMW's behavior
	db %11111111 ; 01 - AddmusicK1.0.9
	db %00000000 ;
	db %10000000 ; 02 - AddmusicK Beta
	db %00000000 ;
	db %10000000 ; 03 - Romi's Addmusic404
	db %00000001 ;
	db %10000000 ; 04 - Addmusic405
	db %00000001 ;
	             ; NOTE: Although it's not implemented yet, there are
                     ; readahead-related differences due to the $ED VCMD
	             ; having inconsistent parameter sizes for $80 and up
	             ; and Addmusic405 failing to account for these.
	db %10001000 ; 05 - AddmusicM
	db %00000000 ;
	db %10000000 ; 06 - carol's MORE.bin
	db %00000001 ;
	db %10000000 ; 07 - Vanilla SMW
	db %00000001 ;
	; 08-7F - Reserved for future Addmusics (or any extra past ones)
	; 80-FF - See HotPatchPresetVCMDUserPatch (doesn't use the bit table)

SubC_table2:
	dw	.PitchMod		; 00
	dw	.GAIN			; 01
	dw	.HFDTune		; 02
	dw	.superVolume		; 03
	dw	.reserveBuffer		; 04
	dw	$0000 ;.gainRest	; 05
	dw	.manualVTable		; 06
	
.HFDTune
	mov     !HTuneValues+x, a
	ret
	
.gainRest
	;$F4 $05 has been replaced. This function can be replicated by a
	;type 3 remote code command.
	;mov	!RestGAINReplacement+x, a ; There is no memory location allocated for this at the moment.
	;ret
	
.manualVTable
	mov	!SecondVTable, a	; \ Argument is which table we're using
	mov	$5c, #$ff		; | Mark all channels as needing a volume refresh
	ret				; /
	
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
cmdFB:					; Arpeggio command.
{
	bmi	.special		; \ Save the number of notes.
	mov	!ArpNoteCount+x, a	; / (But if it's negative, then it's a special command).
	push	a			; Remember it.
	
	call	.fetchLength
	
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

.glissNoteCounter
	mov	a, #$02			; \ Force the note count to be non-zero, so it's treated as a valid command.
	mov	!ArpNoteCount+x, a	; / 
	
	call	.fetchLength
	
	call	GetCommandDataFast	; \ The note difference goes into the note index.
	mov	!ArpSpecial+x, a	; / Yes, its purpose changes here.
	
	mov	a, #$00			; \
	mov	!ArpCurrentDelta+x, a	; / The current pitch change is 0.
HandleArpeggio_return:
	ret

cmdFB_fetchLength:
	call	GetCommandDataFast	; \ Save the length between each change.
	mov	!ArpLength+x, a		; |
	mov	!ArpTimeLeft+x, a	; /
	ret
	
HandleArpeggio:				; Routine that controls all things arpeggio-related.
	mov	a, !ArpNoteCount+x	; \ If the note count is 0, then this channel is not using arpeggio.
	beq	.return			; /
.nextNoteCheck
	beq	.skipWaitTimeCheck
	mov	a, !WaitTime		; \
	cmp	a, !ArpLength+x		; | Don't prepare another note when the next base note is to be keyed on.
	bcs	.skipWaitTimeCheck	; | An exception is made if the requested length is less than or equal
	cmp	a, $70+x		; | to !WaitTime, since they bypass keying off anyways that way.
	bcs	.return			; /
.skipWaitTimeCheck
	mov	a, !ArpTimeLeft+x	; \
	dec	a			; | Decrement the timer.
	mov	!ArpTimeLeft+x, a	; /
	beq	.doStuff		; If the time left is 0, then we have work to do.
	cbne	!WaitTime, .return	; If the time left is 2 (or 1), then key off this voice in preparation. 
					; Otherwise, do nothing.
	
.keyOffVoice
	call	TerminateOnLegatoEnable ; Key off the current voice (with conditions).
	;mov	a, $48			; \ 
	;mov	y, #$5c			; | Key off this voice (but only if there's no sound effect currently playing on it).
	jmp	KeyOffVoiceWithCheck	; /
	

.doStuff
	mov	a, !ArpType+x		;
	beq	.normal			;
	mov	y, a
	mov	a, !ArpCurrentDelta+x	;
	cmp	y, #$01			; \ If it's 1, then it's a trill
	beq	.trill			; /
	;cmp	y, #$02			; \ If it's 2, then it's a glissando.
	;beq	.glissando		; /

.glissando
	clrc				; \
	adc	a, !ArpSpecial+x	; |
	bra	++			; /

.trill
	eor	a, !ArpSpecial+x	; \ Opposite note.
	bra	++			; /

.normal					; If it's 0, it's a normal arpeggio.
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
++	mov	!ArpCurrentDelta+x, a	; 
	bra	.playNote
.setLoopPoint
	inc	y			; \
	mov	a, y			; | Set the current position as the loop point.
	mov	!ArpSpecial+x, a	; /
	bra	.normal			; Now get the next, -actual- note.

.playNote
	mov	a, !ArpLength+x		; \ Now wait for this many ticks again.
	mov	!ArpTimeLeft+x, a	; /
if !noSFX = !false
	call	TerminateIfSFXPlaying
endif
	
	mov	a, !PreviousNote+x	; \ Play this note.
	cmp	a, #$c7			;  |(unless it's a rest)
.restBranchGate				;  |
	beq	+			;  |
+					;  | Default state of this branch gate is open.
	call	NoteVCMD		; /
	
	call	TerminateOnLegatoEnable ; \ Key on the current voice (with conditions).
	or	($47), ($48)		; / Set this voice to be keyed on.
.return2
	ret
}	
	
cmdFC:
{
	push	a					; \ Get and save the remote address (we don't know where it's going).
	call	GetCommandDataFast			; |
	push	a					; /
	call	GetCommandDataFast			; \
	beq	ClearRemoteCodeAddressesPre		; | Handle types #$ff, #$04, and #$00. #$04 and #$00 take effect now; #$ff has special properties.
	cmp	a, #$ff					; |
	beq	.noteStartCommand			; |
	cmp	a, #$04					; |
	beq	.immediateCall				; |
	cmp	a, #$06					; | Handle type $06, which is reserved for AMK beta gain conversions due to containing an auto-restore.
	beq	.noteStartCommand			; | It takes up a slot normally reserved for key on VCMDs since it comes built-in to the code type AND it needs to execute simultaneously with remote code type $05.
	cmp	a, #$07					; |
	beq	ClearNonKONRemoteCodeAddressesPre	; |
	cmp	a, #$08					; |
	beq	ClearKONRemoteCodeAddressesPre		; /
							;
	pop	a					; \
	mov	!remoteCodeTargetAddr+1+x, a		; | Normal code; get the address back and store it where it belongs.
	pop	a					; |
	mov	!remoteCodeTargetAddr+x, a		; /
							;
	mov	a, y					; \ Store the code type.
	mov	!remoteCodeType+x, a			; |
	call	GetCommandDataFast			; \ Store the argument.
	mov	!remoteCodeTimeValue+x, a		; /
	ret						;
	
	
.noteStartCommand					;
	mov	!remoteCodeType2+x, a			;
	pop	a					; \
	mov	!remoteCodeTargetAddr2+1+x, a		; | Note start code; get the address back and store it where it belongs.
	pop	a					; |
	mov	!remoteCodeTargetAddr2+x, a		; /
-							;
	jmp	L_1260					; Get the argument and discard it.
							
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
	
	movw	ya, $14					; \
	push	a					; | Push onto the stack, since there's a very good chance
	push	y					; / that whatever code we call modifies $14.w
	
	call	RunRemoteCode				; 
							;
	pop	a					; \
	mov	!remoteCodeTargetAddr+1+x, a		; | Restore the standard remote code.
	pop	a					; |
	mov	!remoteCodeTargetAddr+x, a		; /
							;
	;call	GetCommandDataFast			; \ Get the argument, discard it, and return.
	bra	-					; /

	
ClearRemoteCodeAddressesPre:
	pop	a
	pop	a
	call	L_1260
	
ClearRemoteCodeAddressesAndOpenGate:
	%OpenRunningRemoteCodeGate()
ClearRemoteCodeAddresses:
	call	ClearKONRemoteCodeAddresses
	call	ClearNonKONRemoteCodeAddresses
	ret

ClearRemoteCodeAddressesXInit:
	;mov	x, $46
	;bra	ClearRemoteCodeAddresses

ClearNonKONRemoteCodeAddressesPre:
	pop	a
	pop	a
	call	L_1260

ClearNonKONRemoteCodeAddressesXInit:
	;mov	x, $46
ClearNonKONRemoteCodeAddresses:
	mov	a, #$00
	mov	!remoteCodeTargetAddr+1+x, a
	mov	!remoteCodeTargetAddr+x, a
	mov	!remoteCodeTimeValue+x, a
	mov	!remoteCodeTimeLeft+x, a
	mov	!remoteCodeType+x, a
	ret

ClearKONRemoteCodeAddressesPre:
	pop	a
	pop	a
	call	L_1260

ClearKONRemoteCodeAddressesXInit:
	;mov	x, $46
ClearKONRemoteCodeAddresses:
	mov	a, #$00
	mov	!remoteCodeTargetAddr2+1+x, a
	mov	!remoteCodeTargetAddr2+x, a
	mov	!remoteCodeType2+x, a
	ret
}

cmdFF:
;ret

