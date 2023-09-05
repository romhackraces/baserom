;The following ASM file is shared between the SPC700-side and SNES-side
;code. Some defines will only affect the SPC700 side, and some will only
;affect the SNES-side, but all of them are stored here for the sake of
;having them stored in a consistent location.

includeonce

;=======================================
;---------------
!PSwitchIsSFX = !false

;Default setting: !false
;---------------
; If you set this to true, then the P-switch song will be a sound effect
; instead of a song that interrupts the current music.
; Note, however, that it is hardcoded and cannot be changed unless you
; do it yourself.
; This also enables a hijack on the SNES side to account for the
; modification made on the SPC700-side.
;=======================================

;=======================================
;---------------
!noSFX = !false

;Default setting: !false
;---------------
; Causes the sound driver to have no SFX-related code in it.
;=======================================

;=======================================
;---------------
!noiseFrequencyMatchChecks = !false

;Default setting: !false
;---------------
; Requires SFX code to actually be present (!noSFX is false).
; Adds in code that allows noise frequencies that match to the current noise
; frequency being used to continue to be audible, thus allowing the volume
; of the noise to stack on top of each other. Without this, only one channel
; will be audible at a time for noise, regardless of the circumstance.
;=======================================

;=======================================
;---------------
!noiseFrequencySFXInstanceResolution = !false

;Default setting: !false
;---------------
; Requires SFX code to actually be present (!noSFX is false).
; Adds in code that resolves noise frequency conflicts between SFX
; instances.
; Not needed unless you're using noise SFX across more than one channel.
; Vanilla SMW doesn't use noise SFX across more than one channel.
;=======================================

;=======================================
;---------------
!1DF9SFXChannel = 6

;Default setting: 6
;Vanilla SMW setting: 4
;---------------
; Changes the channel assigned to 1DF9.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!1DFASFXChannel = 7

;Default setting: 7
;Vanilla SMW setting: 7
;---------------
; Changes the channel assigned to 1DFA.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!1DFCSFXChannel = 7

;Default setting: 7
;Vanilla SMW setting: 6
;---------------
; Changes the channel assigned to 1DFC.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!JumpSFXOn1DF9 = !false

;Default setting: !false
;Vanilla SMW setting: !false
;---------------
; Change this to !true to move the jump sound effect to 1DF9.
;=======================================

;=======================================
;---------------
!JumpSFXOn1DFC = !true

;Default setting: !true
;Vanilla SMW setting: !false
;---------------
; Change this to !true to move the jump sound effect to 1DFC.
;=======================================

;=======================================
;---------------
!GrinderSFXOn1DF9 = !true

;Default setting: !true
;Vanilla SMW setting: !false
;---------------
; Change this to !true to move the grinder sound effect to 1DF9.
;=======================================

;=======================================
;---------------
!GrinderSFXOn1DFC = !false

;Default setting: !false
;Vanilla SMW setting: !false
;---------------
; Change this to !true to move the grinder sound effect to 1DFC.
;=======================================

;=======================================
;---------------
!JumpSFX1DFAPriority = $00

;Default setting: $00
;Vanilla SMW setting: $20
;---------------
; Sets the priority for the jump SFX in 1DFA.
;=======================================

;=======================================
;---------------
!GirderSFX1DFAPriority = $00

;Default setting: $00
;Vanilla SMW setting: $10
;---------------
; Sets the priority for the girder SFX in 1DFA.
;=======================================

;=======================================
;---------------
!useSFXSequenceFor1DFASFX = !true

;Default setting: !true
;Vanilla SMW setting: !false
;---------------
; Replaces the hard-coded 1DFA SFX with a standard sequence used for 1DF9
; and 1DFB.
;=======================================

;=======================================
;---------------
!PSwitchSFXCh0ID = 5

;Default setting: 5
;---------------
; Requires !PSwitchIsSFX to be true to do anything.
; Changes the channel assigned to the first channel of the P-Switch SFX.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!PSwitchSFXCh1ID = 6

;Default setting: 6
;---------------
; Requires !PSwitchIsSFX to be true to do anything.
; Changes the channel assigned to the second channel of the P-Switch SFX.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!PSwitchSFXCh2ID = 7

;Default setting: 7
;---------------
; Requires !PSwitchIsSFX to be true to do anything.
; Changes the channel assigned to the third channel of the P-Switch SFX.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!PSwitchSFXTriggerChID = 4

;Default setting: 4
;---------------
; Requires !PSwitchIsSFX to be true to do anything.
; Changes the channel assigned to the trigger SFX for the P-Switch.
; WARNING: This number starts from zero, not 1, like the MML channels!
; Also, please don't include the # sign: this is used for more than just a
; constant number: it's also involved in math operations.
;=======================================

;=======================================
;---------------
!PSwitchStarRestart = !true

;Default setting: !true (!false in AddmusicK 1.0.8 and earlier)
;Vanilla SMW setting: !true
;---------------
; If you set this to true, then the P-switch and star global songs will
; restart whenever they're called again (i.e., by pressing another P-switch
; or collecting another star).
;=======================================

;=======================================
; If you've changed list.txt and plan on using the original SMW songs
; change these constants to whatever they are in list.txt
; For example, if you changed the "Stage Clear" music to be number 9,
; Then you'd change "!StageClear = $04" to "!StageClear = $09".
!Starman	= $05
!Miss		= $01
!GameOver	= $02
!BossClear	= $03
!StageClear	= $04
!PSwitch	= $06
!Keyhole	= $07
!IrisOut	= $08
!BonusEnd	= $09
!Piano		= $0A
!HereWeGo	= $0B
!Water		= $0C
!Bowser		= $0D
!Boss		= $0E
!Cave		= $0F
!GhostHouse	= $10
!Castle		= $11
!SwitchPalace	= $12
!Welcome	= $13
!RescueEgg	= $14
!Title		= $15
!VoBAppears	= $16
!Overworld	= $17
!YoshisIsland	= $18
!VanillaDome	= $19
!StarRoad	= $1A
!ForestOfIllusion = $1B
!ValleyOfBowser	= $1C
!SpecialWorld	= $1D
!NintPresents   = $1E		; Note that this is a song, not a sound effect!

!Bowser2	= $1F		;
!Bowser3	= $20
!BowserDefeated = $21
!BowserIntrlude = $22
!BowserZoomIn	= $23
!BowserZoomOut	= $24
!PrincessSaved	= $25
!StaffRoll	= $26
!YoshisAreHome	= $27
!CastList	= $28
;=======================================