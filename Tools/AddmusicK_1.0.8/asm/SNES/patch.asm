
lorom

!FreeROM		= $0E8000		; DO NOT TOUCH THESE, otherwise the program won't be able to determine where the data in your ROM is stored!
;!Data			= $0E8000		; Data+$0000 = Table of music data pointers 300 bytes long. 
						; 	The first few entries are bogus because they're global songs uploaded with the SPC engine.
						; Data+$0300 = Table of sample data pointers 300 bytes long.
						; Data+$0600 = Table of sample loop pointers (relative to $0000; modified in-game).
						; Note that the first few bytes of !Data are meta bytes, so it's actually something like !Data+$0308
						
if read1($00FFD5) == $23			; \
	!UsingSA1 = 1				; | Check if this ROM uses the SA-1 patch.	
else						; |
	!UsingSA1 = 0				; / 
endif


if !UsingSA1
	sa1rom
	!SA1Addr1 = $3000
	!SA1Addr2 = $6000
else
	fastrom
	!SA1Addr1 = $0000
	!SA1Addr2 = $0000
endif






!Version = $00

!SampleGroupPtrsLoc	= $008000

!FreeRAM		= $7FB000
!CurrentSong		= !FreeRAM+$00
!NoUploadSamples	= !FreeRAM+$01
!SongPositionLow	= !FreeRAM+$04
!SongPositionHigh	= !FreeRAM+$05
!SPCOutput1		= !SongPositionLow
!SPCOutput2		= !SongPositionHigh
!SPCOutput3		= !FreeRAM+$06
!SPCOutput4		= !FreeRAM+$07
;!MusicBackup		= !FreeRAM+$08
!SampleCount		= !FreeRAM+$09
!SRCNTableBuffer	= !FreeRAM+$0A

; FREERAM requires anywhere between 2 to potentially 1032 bytes of unused RAM (though somewhere in the range of, say, 100 is much more likely).
; Normally you shouldn't need to change this.
;
; Format:
; FREERAM+$0000: Current song being played.
; FREERAM+$0001: Flag.  If set, sample data will not be transferred when switching songs.
; FREERAM+$0002: ARAM/DSP Address lo byte (see below).
; FREERAM+$0003: ARAM/DSP Address hi byte
; FREERAM+$0004: Value to write to ARAM/DSP
; FREERAM+$0005: Current song position in ticks.
; FREERAM+$0006: Hi byte of above.
; FREERAM+$0007: Echo buffer location.  Recommended that you don't touch this unless necessary.  It's modified every time sample upload occurs, and referenced every time music upload occurs.
; FREERAM+$0008: Number of samples in current song (between 0 and 255)
; FREERAM+$0009: Used as a buffer for the sample pointer/loop table.  Could be up to 1024 bytes long, but this is unlikely (4 bytes per sample; do the math).

; 1DFB: Use this to request a song to play (more or less default behavior).
; 1DDA: Song to play once star/P-switch runs out.  If $FF, don't restore.

; Special status byte details:


; To write to ARAM: Set FREERAM+$02 and FREERAM+$03 to the address, and FREERAM+$04 to the value to write.  Note that the address cannot be $FFxx.  
; To write to the S-DSP: Set FREERAM+$02 to the address, FREERAM+$03 to #$FF, and FREERAM+$04 to the value to write.



; BE VERY CAREFUL WHEN CHANGING THIS FILE.  To be perfectly blunt, the parsing the program
; uses to find certain things is as dead simple as it gets, so if you change any labels or 
; defines and the program can no longer find them, Bad Things (TM) may happen.  Best to 
; leave this file alone unless absolutely necessary.

!GlobalMusicCount = #$00	; Changed automatically

!SFX1DF9Reg = 	$2140
!SpecialReg = 	$2141
!MusicReg = 	$2142
!SFX1DFCReg = 	$2143	


!SFX1DF9Mir = 	$1DF9|!SA1Addr2
!SpecialMir = 	$1DFA|!SA1Addr2
!MusicMir = 	$1DFB|!SA1Addr2
!SFX1DFCMir = 	$1DFC|!SA1Addr2

!MusicBackup = $0DDA|!SA1Addr2


!DefARAMRet = $044E	; This is the address that the SPC will jump to after uploading a block of data normally.
!ExpARAMRet = $0400	; This is the address that the SPC will jump to after uploading a block of data that precedes another block of data (used when uploading multiple blocks).
!TabARAMRet = $0400	; This is the address that the SPC will jump to after uploading samples.  It changes the sample table address to its correct location in ARAM.
			; All of these are changed automatically.
!SongCount = $00	; How many songs exist.  Used by the fading routine; changed automatically.

incsrc "tweaks.asm"			
			
			
org $0E8000		; Clear out what parts of bank E we can (Lunar Magic install some hacks there).
rep $7100 : db $55
org $0F8000		; Clear out what parts of bank F we can (Lunar Magic install some more hacks there).
rep $7051 : db $55
	
org $8075
	JML MainLabel

org !FreeROM
db "@AMK"			; Program name
db !Version
dl SampleGroupPtrs		; Position of the sample group pointers.
dl MusicPtrs			; Position of music and sample pointers.
db $00, $00, $00, $00, $00	; Reserve some space for meta data.
db $00, $00, $00, $00		;
db $00, $00, $00, $00		;
db $00, $00, $00, $00		;
db $00, $00, $00, $00		;

MainLabel:
	STZ $10
	PHP
	PHB
	PHK
	PLB
	JSR HandleSpecialSongs
	REP #$20
	LDA !SFX1DF9Reg
	STA !SPCOutput1
	LDA !MusicReg
	STA !SPCOutput3
	SEP #$20

	LDA !SpecialMir
	STA !SpecialReg
	LDA !SFX1DF9Mir
	STA !SFX1DF9Reg
	LDA !SFX1DFCMir
	STA !SFX1DFCReg
	STZ !SFX1DF9Mir
	STZ !SpecialMir
	STZ !SFX1DFCMir
	LDA !MusicMir
	BEQ NoMusic
	CMP !CurrentSong
	BNE ChangeMusic

End:	
	CLI
	PLB
	PLP


	JML $00806B		; Return.  TODO: Detect if the ROM is using the Wait Replace patch.

NoMusic:
	LDA #$00
	STA !NoUploadSamples
	BRA End
	
Fade:
	STA !MusicReg
	;STA !CurrentSong
	BRA End

PlayDirect:
;	PHA
;	STA !MusicReg
;	LDA !CurrentSong
;	STA !MusicBackup
;	PLA
;	STA !CurrentSong
;	BRA End

;	STA !MusicReg
;	PHA
;	LDA !CurrentSong
;	CMP !GlobalMusicCount+1
;	BCC +
;	STA !MusicBackup
;+
;	PLA
;	STA !CurrentSong
;	BRA End

	STA !MusicReg
	STA !CurrentSong
	BRA End

	
ChangeMusic:
	LDA $187A|!SA1Addr2		; \ 
	BEQ +
	LDA #$FF
+
	SEC
	SBC #$FD
	STA !SpecialMir
	
	;STA $7FFFFF
	
;	LDA !MusicMir
;	CMP !PSwitch
;	BEQ .doExtraChecks
;	CMP !Starman
;	BEQ .doExtraChecks
;	BRA .okay
;	
;.doExtraChecks			; We can't allow the p-switch or starman songs to play during the level clear themes.
	LDA !CurrentSong
	CMP !StageClear
	BEQ LevelEndMusicChange
	CMP !IrisOut
	BEQ LevelEndMusicChange
	CMP !Keyhole
	BEQ LevelEndMusicChange
	CMP !BossClear		;;; this one too
	BNE Okay
	
LevelEndMusicChange:
	LDA !MusicMir
	CMP !IrisOut
	BEQ Okay
	CMP !SwitchPalace	;;; bonus game fix
	BEQ Okay
	CMP !Miss		;;; sure why not
	BEQ Okay
	CMP !RescueEgg
	BEQ Okay		; Yep
	CMP !StaffRoll	; Added credits check
	BEQ Okay
	LDA $0100|!SA1Addr2		
	CMP #$10			
	BCC Okay
	;;; LDA !CurrentSong	;;; this is why we got here in first place, seems redundant
	;;; CMP !StageClear
	;;; BEQ EndWithCancel
	;;; CMP !IrisOut
	;;; BEQ EndWithCancel
EndWithCancel:
	STZ !MusicMir
	BRA End
	
Okay:
	LDA !MusicMir			; \ Global songs require no uploads.
	CMP !GlobalMusicCount+1		; |
	BCC PlayDirect			; /
	

	CMP #$FF			; \ #$FF is fade.
	BEQ Fade			; /
	
	LDA !CurrentSong		; \ 
	CMP !PSwitch			; |
	BEQ +				; |
	CMP !Starman			; |
	BNE ++				; | Don't upload samples if we're coming back from the pswitch or starman musics.
	;;;BRA ++			; |
+					; |
	LDA $0100|!SA1Addr2		; | \
	CMP #$12+1			; | | But if we're coming back from the p-switch or starman musics AND we're loading a new level, then we might need to reload the song as well.
	BCC ++				; | / ;;; can't be bad to allow everything below
	LDA !MusicMir			; |
	STA !CurrentSong		; |
	STA !MusicBackup		; |
	JMP SPCNormal			; |
++					; /
	LDA !MusicMir
	STA !CurrentSong
	STA !MusicBackup
	STA $0DDA|!SA1Addr2
	
;	LDA $0100|!SA1Addr2
;	CMP #$0F
;	BCC .forceMusicToPlay
;	LDA !CurrentSong
;	CMP !StageClear
;	BEQ EndWithCancel
;	CMP !IrisOut
;	BEQ EndWithCancel
;.forceMusicToPlay



;	LDA !MusicMir
;	CMP !MusicBackup
;	BNE +
;	STA !CurrentSong
;	JMP SkipSPCNormal
;+
;	LDA #$00
;	STA !MusicBackup
;+	LDA !MusicMir		;
;	STA !CurrentSong
;
;+++


	LDA !MusicMir
	CMP #!SongCount
	BCC +
	LDA #$FF
	JMP Fade
+
;	REP #$30
;	LDA !MusicMir		; If the selected music is invalid,
;	AND #$00FF		; then fade out.  This is to mimic #$80 being the value to fade out
;	STA $00			; since that's used a lot (while any negative value would work).
;	ASL			; Of course, this won't work correctly if the user has more than #$80 songs,
;	CLC			; But they'd have issues anyway.  Might as well try to avoid complications
;	ADC $00			; when it's possible.
;	INC
;	INC
;	TAX
;	SEP #$20
;	LDA MusicPtrs,x
;	SEP #$30
;	INC			; \ If the bank byte is 0 or FF, then this music is invalid.
;	CMP #$02		; /
;	BCS +
;	LDA #$FF
;	JMP Fade
;+


	

	LDA #$FF		; Send this as early as possible
	STA $2141		;
	
	SEI
	
	STZ $4200		; Disable NMI.  While NMI no longer messes with the audio ports,
				; interrupts at the wrong time during this delicate routine are bad.
	
	REP #$30		; $108055
	;LDA #$0000
	;SEP #$20
	LDA !MusicMir
	;REP #$30
	AND #$00FF
	STA $00
	ASL			;\
	CLC			;| Multiply by 3.
	ADC $00			;/
	TAX			; To index
	SEP #$20		; the music
	LDA MusicPtrs,x		; table data.
	STA $00
	INX
	LDA MusicPtrs,x
	STA $01
	INX
	LDA MusicPtrs,x
	STA $02
	
	REP #$10
	LDX #!DefARAMRet
	LDA !NoUploadSamples
	BNE +
	LDX #!ExpARAMRet
+	STX $03
	SEP #$10
	JSL UploadSPCData
	
	
	;STZ $2140		; $1080a1
	;STZ $2142
	;STZ $2143
	
	LDA !NoUploadSamples
	BEQ +
	NOP #3			; Missing waiting cycles after UploadSPCData added
	JMP SPCNormal
+
	
	REP #$20
	
	LDY #$02		; \
	LDA [$00]		; | 
	STA $09			; |
	LDA [$00],y		; | This puts the location of the ARAM sample table into $09.
	CLC			; |
	ADC $09			; |
	XBA : XBA		; | Test the low byte of the accumulator
	BEQ NoAdd		; |
	CLC			; | The low byte of the sample table must be 0.
	ADC #$0100		; |
	AND #$FF00		; |
NoAdd:	STA $09			; /
	

	SEP #$20
	
					
	LDA.b #SampleGroupPtrs		; [$0D] is the pointer to this song's sample group.
	STA $0D				; Sample groups contain the number of samples in their first byte
	LDA.b #SampleGroupPtrs>>8	; Then the sample numbers themselves after that.
	STA $0E
	LDA.b #SampleGroupPtrs>>16
	STA $0F
	
	LDA !MusicMir			; \
	REP #$30			; |
	AND #$00FF			; |
	ASL				; | Index the table by the music number
	TAY				; |
	LDA [$0D],y			; /
	STA $0D				; The sample groups are stored in the same bank as the table.
	SEP #$30
	
	LDA [$0D]			; Get the number of samples
	STA !SampleCount
	
	STA $0B				; $0A is used as a copy because CPX $XXXXXX doesn't exist.
	STZ $0C				; Zero out $0B because we'll be in 16-bit mode for a while.
	
	REP #$20
	AND #$00FF
	ASL
	ASL
	CLC
	ADC $09				; $09 contains the location of the ARAM SRCN table (positions and loop positions).
	STA $07				; $07 contains where each sample should go in ARAM.
	
	REP #$30
	LDX #$0000			; Clear out x and y.
	LDY #$0000
	DEC $0D				; Needed because we INC $0D twice.
	
.loop
	CPX $0B				; 108100
	BEQ NoMoreSamples
	PHX				; We use x for indexing as well; push it.
	
	
	TXA				; \
	ASL				; |
	ASL				; | Get index for the SRCN buffer table
	TAX				; | and save it in Y.
	TAY				; |
	INY : INY			; /
	
	LDA $07
	STA !SRCNTableBuffer,x
			
	INC $0D				; $0D is the current position in the table.
	INC $0D				;
	
	LDA [$0D]			; Get the next sample
	STA $00
	
					; A contains the sample number

	ASL				; \ A contains the sample loop position table index
	TAX				; | X contains the sample loop position table index
	LDA SampleLoopPtrs,x		; | A contains this sample's loop position
	CLC				; |
	ADC $07				; | A contains this sample's loop position relative to its position in ARAM. 
	TYX				; | Copy y (the SRCN buffer table index) to x.
	STA !SRCNTableBuffer,x		; / Store the loop position to the SRCN table buffer.

	
	LDA $00				; \
	ASL				; |
	CLC				; | Multiply by 3 to index the sample table data.
	ADC $00				; |
	TAX				; /
	
	;SEP #$10			
	LDA SamplePtrs,x
	STA $00
	INX
	INX

	SEP #$20
	LDA SamplePtrs,x
	STA $02
	
	REP #$20
	LDA #!ExpARAMRet
	STA $03
	LDA [$00]
	STA $05
	BEQ .empty			; If the sample's position in the ROM is 0 (which is invalid), skip it; it's empty.
	INC $00
	INC $00
	SEP #$30
	JSL UploadSPCDataDynamic
.empty
	REP #$30			; 10814f
	LDA $07
	CLC
	ADC $05
	STA $07
	PLX
	INX
	BRA .loop
NoMoreSamples:
					; $108166
	
	LDA $09				; \ $09 is the address of the ARAM SRCN table.
	STA $07				; |
	LDA $0B				; |
	ASL				; |
	ASL				; |
	STA $05				; |
	LDA #!TabARAMRet		; | Jump in ARAM to the DIR set routine.
	STA $03				; |
	LDA.w #!SRCNTableBuffer		; |
	STA $00				; | Upload the ARAM SRCN table.
	SEP #$20			; |
	LDA.b #!SRCNTableBuffer>>16	; |
	STA $02				; |
	JSL UploadSPCDataDynamic	; /
	
	NOP #11				; Needed to waste time. 10817b
					; On ZSNES it works with only 4 NOPs because...ZSNES.
					
	REP #$20
	LDA #!DefARAMRet
	STA $2142
	SEP #$20
	LDA $08
	STA $2141
	LDA #$CC
	STA $2140
	LDA $08
-	CMP $2141			; Wait for the SPC to echo the value back before continuing.
	BNE -
	JMP SkipSPCNormal
	
					; Time to get the SPC out of its loop.
					
	REP #$20			; \ 108173
	STZ $09				; | Size = 0 (jump to location instead of upload data).
	LDA #!DefARAMRet		; | 
	STA $0B				; | Location = #!DefARAMRet
	LDA #$0009|!SA1Addr1		; | 
	STA $00				; | 
	SEP #$30			; | 
if !UsingSA1				; |
	LDA #$7E			; | 
else					; |
	LDA #$00			; |
endif					; |
	STA $02				; | 
	JSL UploadSPCData		; /
	
	NOP #8				; Needed to waste time.
					; On ZSNES it works with only 4 NOPs because...ZSNES.
SPCNormal:				
	SEP #$30
	
	LDA #$00
	STA !NoUploadSamples

SkipSPCNormal:
	LDA !GlobalMusicCount+1
	
;NoUpload:
	STA !MusicReg
	
	LDA #$81
	STA $4200
	JMP End
	
HandleSpecialSongs:
	LDA $0100|!SA1Addr2
	CMP #$0F
	BEQ +
	LDA !MusicMir
	CMP !Miss
	BEQ +
	CMP !GameOver
	BEQ +
	CMP !StageClear		;;; more checks here should help
	BEQ ++
	CMP !IrisOut
	BEQ ++
	CMP !BossClear
	BEQ ++
	CMP !Keyhole
	BEQ ++
	LDA $14AD|!SA1Addr2
	ORA $14AE|!SA1Addr2
	ORA $190C|!SA1Addr2
	BNE .powMusic
	LDA $1490|!SA1Addr2
	CMP #$1E
	BCS .starMusic
	BEQ .restoreFromStarMusic
++
	RTS
	
+
	STZ $14AD|!SA1Addr2
	STZ $14AE|!SA1Addr2
	STZ $190C|!SA1Addr2
	STZ $1490|!SA1Addr2
	RTS
	
.powMusic
	LDA $1490|!SA1Addr2		; If both P-switch and starman music should be playing
	BNE .starMusic			;;; just play the star music
	LDA !PSwitch
	STA !MusicMir
+
	RTS
	
.starMusic
	LDA !Starman
	STA !MusicMir
+
	RTS
	
.restoreFromStarMusic
	LDA !MusicBackup
	STA !MusicMir
+
	RTS
	
pushpc

incsrc "SongSampleList.asm"

MusicPtrs:
SamplePtrs:
SampleLoopPtrs:
UploadSPCEngine:
UploadSPCData:
UploadSPCDataDynamic:

pullpc