@include
; tweaks.asm
; Changes the song numbers for various default actions in the ROM.
; Needed because, by design, the song numbers for this program are different
; from the default in SMW.  Normally nothing but the definitions at the start
; here need to be changed, and even then that's only necessary if you've
; changed list.txt (see instructions below).
; 
; This also removes various routines that play with the music mirrors in SMW.
; The engine has changed, so there's no longer any need for most of the code.
; It all has been NOP'd out and branched over.
!true = 1
!false = 0



!JumpSFXOn1DFC = !true			; Change this to !false to move the jump sound effect to 1DFA.
				
!Miss		= #$01			; If you've changed list.txt and plan on using the original SMW songs
!GameOver	= #$02			; change these constants to whatever they are in list.txt
!BossClear	= #$03			; For example, if you changed the "Stage Clear" music to be number 9,
!StageClear	= #$04			; Then you'd change "!StageClear = #$04" to "!StageClear = #$09".
!Starman	= #$05
!PSwitch	= #$06
!Keyhole	= #$07
!IrisOut	= #$08
!BonusEnd	= #$09
!Piano		= #$0A
!HereWeGo	= #$0B
!Water		= #$0C
!Bowser		= #$0D
!Boss		= #$0E
!Cave		= #$0F
!GhostHouse	= #$10
!Castle		= #$11
!SwitchPalace	= #$12
!Welcome	= #$13
!RescueEgg	= #$14
!Title		= #$15
!VoBAppears	= #$16
!Overworld	= #$17
!YoshisIsland	= #$18
!VanillaDome	= #$19
!StarRoad	= #$1A
!ForestOfIllusion = #$1B
!ValleyOfBowser	= #$1C
!SpecialWorld	= #$1D
!NintPresents   = #$1E		; Note that this is a song, not a sound effect!

!Bowser2	= #$1F		;
!Bowser3	= #$20
!BowserDefeated = #$21
!BowserIntrlude = #$22
!BowserZoomIn	= #$23
!BowserZoomOut	= #$24
!PrincessSaved	= #$25
!StaffRoll	= #$26
!YoshisAreHome	= #$27
!CastList	= #$28


org $9724		; Fix the title music
	db !Title
org $94B3
	db !RescueEgg
org $96C7
	db !Title
org $009737
	db !Bowser
;;; org $009E18		;;; except this one needs nuking
	;;; db $FF
org $0CD5D4 ; Change castle destruction sequence song 2
    db !Welcome	
org $00C526
	db !BonusEnd
org $00C9BD
	db !IrisOut
org $00D0DE
	db !GameOver
org $00E304
	db !PSwitch
org $00EEC3
	db !StageClear
org $00F60B
	db !Miss
org $018784
	db !BossClear
org $01AB08
	db !PSwitch
org $01C0F0
	db !StageClear
org $01C586
	db !Starman
org $01D04F
	db !BossClear
org $01E216
	db !Keyhole
org $01FB2E
	db !BossClear
org $028968
	db !PSwitch
org $03809D
	db !BossClear
org $0398E7
	db !BossClear
org $03A702
	db !BowserZoomOut
org $03A7A8
	db !BowserIntrlude
org $03A7C2
	db !BowserZoomIn
org $03ABF4
	db !BowserDefeated
org $03AC53
	db !PrincessSaved
org $03CE9A
	db !BossClear
org $0483D2
	db !VoBAppears

org $048E44
	NOP : NOP : NOP

org $0491E1
	db $FF



if read1($04DBC8) == $02 && read1($04DBC9) == $03 && read1($04DBCA) == $04 && read1($04DBCB) == $06 && read1($04DBCC) == $07 && read1($04DBCD) == $09 && read1($04DBCE) == $05 
org $048D8A
	db !Overworld, !YoshisIsland, !VanillaDome, !ForestOfIllusion, !ValleyOfBowser, !SpecialWorld, !StarRoad
org $04DBC8
	db !Overworld, !YoshisIsland, !VanillaDome, !ForestOfIllusion, !ValleyOfBowser, !SpecialWorld, !StarRoad
endif
	
org $0584DB
	db !HereWeGo, !Cave, !Piano, !Castle, !GhostHouse, !Water, !Boss, !SwitchPalace
org $0C9447
	db !StaffRoll
org $0CA40C
	db !YoshisAreHome
org $0CA5C2
	db !CastList
	

	
	
org $009723
	LDA.b !Welcome
	STA.w $1DFB|!SA1Addr2
	
	
	
org $009734			; Skip over Bowser fight music stuff.
	BNE $05
	
	
	
	
	
	

org $008134			; Don't upload the overworld music bank.
        RTS

if read1($008176) == $5c
	
	org $00817C			; For LevelNMI.  Three fewer bytes placed three bytes later.
		BRA Skip : NOP
		NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
	Skip:

elseif read1($008179) == $5c
	org $00817D			; For PowerTool.  Four fewer bytes placed four bytes later.
		BRA Skip : NOP
		NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP
	Skip:
else
	org $008179			; Skip over the standard NMI audio port stuff.  We handle that ourselves now every loop.
		BRA Skip : NOP
		NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
		NOP : NOP : NOP
	Skip:
endif

org $0094A0				; Don't upload music bank 1
	BRA Skip1Point25 : NOP
Skip1Point25:
	
org $0096C3				; Don't upload music bank 1
	BRA Skip1Point5 : NOP
Skip1Point5:

org $00A0B3				;;; ditto
	BRA + : NOP
	+

org $009702				; Don't upload music bank 2...or something.
	NOP #3

org $009728					
	LDA.w $0DDA|!SA1Addr2	; 
	NOP : NOP		; 
	NOP : NOP		; 
	LDY.w $0D9B|!SA1Addr2	; 
	CPY.b #$C1		; 
	BNE CODE_009738		; 
	LDA.b !Bowser		; 
CODE_009738:			;
	STA.w $1DFB|!SA1Addr2	; 
CODE_00973B:			;
BRA +				; 
	NOP : NOP : NOP		; 
+


org $00A231				; Change how pausing works
	LDY #$08
org $00A23D
    LDY #$07
    STY $1DFA|!SA1Addr2

org $00A635
	BRA Skip2 : NOP
; KevinM's edit: use this small freed up space for the start+select sfx
StartSelectSfx:
	sta $0100|!SA1Addr2 	; Overwritten code
	lda #$09 				;\ Play sfx
	sta $1DFA|!SA1Addr2 	;/
	jmp $A289 				; Return back
	;NOP : NOP : NOP  		;\
	;NOP : NOP : NOP 		;| We used 11 bytes for the routine
	;NOP : NOP 				;| so 11 less NOPs needed.
	;NOP : NOP : NOP 		;/
	NOP : NOP
	NOP : NOP : NOP
	NOP : NOP
	NOP : NOP : NOP
	NOP : NOP
	NOP : NOP
	NOP : NOP : NOP
Skip2:

; KevinM's edit: jump to code that plays sfx on start+select
org $00A286
	jmp StartSelectSfx

org $00C53E
	LDA !MusicBackup
	NOP	: NOP

;org $00C53E
	
	;BRA Skip3 : NOP 
	;NOP : NOP 
	;Skip3:
	
;org $00C54C
;	BRA Skip4 : NOP
;	Skip4:
	
org $02E277		;;; fix for the directional coins (more like code restore)
	LDA $14AD|!SA1Addr2
	
org $02E27F		;;; ditto
	LDA !MusicBackup
	NOP : NOP
	
org $03A842
	db $2E,$2F,$30,$31,$32,$33,$34,!Bowser2,!Bowser3
	
	
org $03A88B		; Was NOPs before.  Restore that.
	LDA $A842,y
	STA $1DFB|!SA1Addr2
	PLA
	LSR
	LSR
	LSR
	TAY
	LDA $A437,y   
if !UsingSA1 == !true
	STA $331E,x
else
	STA $1570,x             
endif
	RTS
	
org $00973B
	NOP : NOP		;BRA Skip6
	STA.w $0DDA|!SA1Addr2	;NOP : NOP : NOP
Skip6:

; KevinM's edit: this is already skipped by the hex edit at $00A635	
;org $00A645			; Related to restoring the music upon level load.
;	BRA Skip7 : NOP
;	NOP : NOP
;	NOP : NOP : NOP
;	NOP : NOP
;	NOP : NOP
;	NOP : NOP : NOP
;Skip7:

org $00A6ED
	BRA Skip8 : NOP
	NOP : NOP
	NOP : NOP : NOP
Skip8:

;org $00E2EB
	;BRA Skip9 : NOP
	;NOP : NOP
org $00E2EE
	BRA Skip9
	NOP : NOP
	NOP : NOP
	NOP : NOP : NOP
	;NOP
Skip9:

org $01AB02
	BRA Skip10 : NOP
	NOP : NOP
Skip10:

org $01C585	; 13 bytes
	;LDA $1DFB|!SA1Addr2
	;STA $0DDA|!SA1Addr2
	LDA !Starman
	STA $1DFB|!SA1Addr2
	RTL
	
;org $01C58A
;	RTL
	
org $058555
	LDX $0100|!SA1Addr2
	CPX #$07
	BCC Skip11

	STA $0DDA|!SA1Addr2
	BRA Skip11 

	NOP : NOP
	NOP : NOP : NOP
Skip11:


org $00805E			; Don't upload the standard sample bank.
	NOP : NOP : NOP
	
org $0093C0
LDA.b !NintPresents
STA $1DFB|!SA1Addr2


org $049AC2
JMP OWMusicHijack		; Force music to play when fading out from an exit tile, not just from pipe/star fade-outs.

org $049882
JMP OWMusicHijack


org $04FFB1			; 5 free bytes in bank 4 required.
OWMusicHijack:
	SEP #$30		; Restore hijacked code (if it weren't for this, we could just JMP directly there...
	JMP $DBD7		; Jump to normal music changing code, which perform the RTS that we overwrote.
	








; Remap the jump SFX to $1DFA or $1DFC.
if !JumpSFXOn1DFC == !true
	org $00D65E
	LDA #$35
	STA $1DFC|!SA1Addr2

	org $00DBA5
	LDA #$35
	STA $1DFC|!SA1Addr2
else
	org $00D65E
	LDA #$2B
	STA $1DF9|!SA1Addr2

	org $00DBA5
	LDA #$2B
	STA $1DF9|!SA1Addr2
endif

; Remap the grinder SFX too.
org $01D745
LDA #$1A
STA $1DF9|!SA1Addr2

org $01DB70
LDA #$1A
STA $1DF9|!SA1Addr2

org $0392B8
LDA #$1A
STA $1DF9|!SA1Addr2

;;; checking whether mario and luigi are on the same submap isn't necessary anymore
org $04DBDD
	BRA +
	NOP #20
	+
	
	
;;; prevent game overs from fading overworld songs out
org $009E17
	BRA +
	NOP #3
	+
	
