;Put this in uberasm tool's library file.

incsrc "../../../shared/defines/ScreenScrollingPipes.asm"

main:
	PHB					;\Setup banks
	PHK					;|
	PLB					;/
.DeathAnimationCheck
	;If Mario is inside a pipe AND dying, reset all his status for 1 frame.
	LDA !Freeram_SSP_PipeDir	;
	AND.b #%00001111		;>After this, A register = Pipe state
	BNE ..InPipe			;>If in pipe, execute (also check needed that if the player is already outside the pipe, not to run this code again, to ensure a execute-once for the reset when dying inside pipe).
	JMP .PipeCodeReturn

	..InPipe
		LDX $71					;\Prevent potential glitch that the player enters pipe and dies (often by level timer)
		CPX #$09				;|during travel (if freezing enabled, at the same frame the players interacts a pipe cap).
		BNE .PipeStateCheck			;/

	..MarioDiedReset
		LDA #$00				;\Reset all things.
		STA !Freeram_SSP_PipeDir		;|>Reset pipe state to ensure that [ResetStatus] is executed only once as the check before this code will assume player out of pipe on the next game loop.
		STA !Freeram_SSP_EntrExtFlg		;|
		STA !Freeram_SSP_PipeTmr		;/
		STA !Freeram_SSP_CarrySpr		;\Remove any carryable sprites.
		STA !Freeram_BlockedStatBkp		;/
		JMP .ResetStatus	;>Bring mario back to the foreground, amoung other things.

.PipeStateCheck
	CMP #$00				;\>This is needed so it wouldn't use the processor flags from the CPX.
	BNE .InPipeTraveling			;|
	JMP .PipeCodeReturn			;/>If pipe state == 0, end.

.InPipeTraveling
	..FreezeCheck
		LDA $13D4|!addr				;>$13D4 - pause flag.
		if !Setting_SSP_FreezeTime == 0
		ORA $9D				;>Prevent glitches in which !Freeram_SSP_PipeTmr still decrements during freezes like baby yoshi growing when the user disable pipe freezing.
		endif
		ORA $1426|!addr				;>Don't lock controls on message boxes.
		ORA $13FB|!addr				;>Player frozen (such as yoshi growing animation).
		;ORA <address>				;>Other RAM to disable running pipe code.
		BEQ .HandleCarryingSprites
		JMP .pose				;>While the pipe-related code should stop running during a freeze, the pose should still be running (during freeze, he reverts to his normal pose).

.HandleCarryingSprites
	if !Setting_SSP_CarryAllowed != 0
	..KeyGlitchFailsafe			;>A glitch that forces the player to drop the key upon exiting should the player enter and pick up the key the same frame.
		LDA $1470|!addr
		ORA $148F|!addr
		BEQ ...NoCarry
		LDA #$01
		STA !Freeram_SSP_CarrySpr

	...NoCarry
			LDY #$00			;>Default Y as #$00 (later on, will remain #$00 if not carrying sprites)
			LDA !Freeram_SSP_CarrySpr	;\fix automatic drop item when carrying (when freeze disabled, he shouldn't automatically
			BEQ ..NotCarrying		;/pick up sprites when the player didn't intend to do so.)

	..CarryingSprite
		INY

	..NotCarrying
	endif
.ForceControlsSetAndClear
	LDA $15					;\
	ORA SSP_CarryControlsForceSet,y		;|>Force X and Y on controller to be set when carrying sprites.
	AND SSP_CarryControlsForceClear,y	;|>Clear out other than XY and START.
	STA $15					;|
	LDA $16					;|\Prevent fireballs and cape action.
	AND.b #%00010000			;||While enabling only the pause button.
	STA $16					;//

	.ResetControlsPBalloonStompCountAndFire
		STZ $17			;\Lock other controls.
		STZ $18			;/
		STZ $13F3|!addr		;\remove p-balloon
		STZ $1891|!addr		;/
		STZ $1697|!addr		;>remove consecutive stomps.
		STZ $140D|!addr		;>so fire mario cannot shoot fireballs in pipe

.HidePlayer
	LDA !Freeram_SSP_EntrExtFlg	;\hide player if timer hits zero when entering.
	CMP #$02			;|
	BEQ ..NoHide			;|
	LDA !Freeram_SSP_PipeTmr	;|
	BNE ..NoHide			;|
		if !Setting_SSP_PipeDebug == 0
			LDA #$EF
			LDY $187A|!addr
			BEQ +
			LDA #$FF
			+
			STA $78
		endif

	..NoHide
.YoshiImage
	LDA $187A|!addr		;\if on yoshi, then use yoshi poses
	BNE ..OnYoshi		;/

	..OffYoshi
		STZ $73			;>so mario cannot remain ducking (unless on yoshi) as he exits.

	..OnYoshi
	..YoshiPipePose
		LDA !Freeram_SSP_PipeDir
		AND.b #%00000001		;
		BNE ...YoshiFaceScreen		;>Bit 0 clear = horizontal movement, set = vertical movement.

		...YoshiDuck			;>horizontal pipe
			LDA $187A|!addr			;\Do not duck if not riding yoshi.
			BEQ ....NoDuck			;/
			LDA #$04			;\crouch on yoshi
			STA $73				;/

			....NoDuck
				LDA #$01			;\(this should make mario face left or right carrying sprites to the side)
				BRA ...SetYoshiPipePose		;/

		...YoshiFaceScreen		;\yoshi face the screen (vertical pipe, Nintendo did this so that yoshi's head
			LDA #$02			;/doesn't display a glitch graphic).

		...SetYoshiPipePose
			STA $1419|!addr			;>Even if you are not mounted on yoshi, you still have to write a value here, or carrying sprites don't work.

.InPipeMode
	if !Setting_SSP_PipeDebug == 0
	LDA #$02		;\go behind layers
	STA $13F9|!addr		;/
	endif
		if !Setting_SSP_FreezeTime != 0
			LDA #$0B		;\freeze player (blame $00CDE8 for not allowing freezing), note that this also renders the plater invulnerable for most sprites.
			STA $71			;/
			STA $9D			;>Freeze time
		endif
	LDA #$01			;\allow vertical scroll up.
	STA $1404|!addr			;/
	STZ $14A6|!addr			;>no spinning.
	STZ $1407|!addr			;>so mario cannot fly out of the cap
	STZ $72				;>zero air flag.
	STZ $14A3|!addr			;>no yoshi tongue
	if !Setting_SSP_CarryAllowed != 0
	LDA !Freeram_SSP_CarrySpr	;\if mario not carrying anything, then skip
	BEQ ..NotCarry			;/
	LDA #$01			;\force keep carrying
	STA $1470|!addr			;|
	STA $148F|!addr			;/

	..NotCarry
	endif
.DirectionalSpeed
	LDA !Freeram_SSP_PipeDir	;\set player speed within pipe (use transfer commands
	AND.b #%00001111		;|>Only read the low 4 bits (nibble)
	TAY				;|so you can use long freeram address)
	LDA.w SSP_PipeXSpeed-1,y	;|
	STA $7B				;|
	LDA.w SSP_PipeYSpeed-1,y	;|
	STA $7D				;/

.EnterExitTransition
	LDA !Freeram_SSP_EntrExtFlg	;\If mario is already entered the pipe, return.
	BNE ..InPipe			;/
	JMP .PipeCodeReturn

	..InPipe
		CMP #$01		;\If entering a pipe...
		BEQ ...EnteringPipe	;/
		CMP #$02		;\If exiting a pipe...
		BEQ ...ExitingPipe	;/
		JMP .PipeCodeReturn

		...EnteringPipe		;
			LDA !Freeram_SSP_PipeTmr	;\If timer isn't 0, set pose
			BNE +
			JMP .pose			;/
			+
			DEC A				;\Otherwise decrement it
			STA !Freeram_SSP_PipeTmr	;/
			BEQ ...StemSpeed		;>If decremented from 1 to 0, accelerate for stem speed
			JMP .pose			;>Otherwise still set pose (cap speed).

			...StemSpeed
									LDA !Freeram_SSP_PipeDir	;\Switch to stem speed keeping the same direction.
				AND.b #%00001111		;|>Check only bits 0-3 (normal direction bits)
				CMP #$05			;|\If already at stem speed, don't subtract again.
				BCC ....StemSpeedDone		;|/(It shouldn't land on #$00 or underflow, stay within #$01-#$08)
				LDA !Freeram_SSP_PipeDir	;|>Reload because we want to retain bits 4-7 (planned direction bits).
				SEC				;|
				SBC #$04			;/
				STA !Freeram_SSP_PipeDir	;>And set pipe direction from cap to stem speed with the same direction.

				....StemSpeedDone
					BRA .pose

		...ExitingPipe			;
			LDA !Freeram_SSP_PipeTmr	;\if timer already = 0, then skip the reset (so it does it once).
			BEQ .pose			;/
			DEC A				;\otherwise decrement timer.
			STA !Freeram_SSP_PipeTmr	;/
			BEQ .ResetStatus		;>Reset status if timer hits zero (happens once after -1 to 0).

			LDA !Freeram_SSP_PipeDir	;\Switch to cap speed keeping the same direction.
			AND.b #%00001111		;|>Check only bits 0-3 (normal direction bits)
			CMP #$05			;|\If already at pipe cap speed, don't add again.
			BCS .pose			;|/
			LDA !Freeram_SSP_PipeDir	;|>Reload because we want to retain bits 4-7 (planned direction bits).
			CLC				;|
			ADC #$04			;/
			STA !Freeram_SSP_PipeDir	;>Set direction
			BRA .pose			;>and skip the reset routine
;---------------------------------
;This resets mario's status.
;It must be exceuted for one frame
;(or bugs will occur if executed every frame)
;the player exits a pipe.
;---------------------------------
.ResetStatus
	..HandleCarryingSprites
	if !Setting_SSP_CarryAllowed != 0
		LDA !Freeram_SSP_CarrySpr	;\Holding sprites routine
		BEQ ...NotCarrySprite		;|

		...CarrySprite
			LDA #$40			;|
			BRA ...WriteXYBitController	;|
	endif
		...NotCarrySprite		;|
			LDA #$00			;|

		...WriteXYBitController		;|
			STA $15				;/
	..RevertPipeStatus
		if !Setting_SSP_FreezeTime != 0
			STZ $9D			;>back in motion
		endif
			STZ $13F9|!addr			;>go in front
			STZ $71				;>mario can move
			STZ $73				;>stop crouching (when going exiting down on yoshi)
			STZ $140D|!addr			;>no spinjump out the pipe (possable if both enter and exit caps are bottoms)
			STZ $7B				;\cancel speed
			STZ $7D				;/
			STZ $1419|!addr			;>revert yoshi
			STZ $149F|!addr			;>zero cape "rise up timer"
			STZ $185C|!addr			;>Reenable block interaction, just in case...
			LDA $16				;\Prevent fireballs and cape action.
			AND.b #%00010000		;|While enabling only the pause button.
			STA $16				;/
			LDA #$00			;\reset freeram flags
			STA !Freeram_SSP_PipeTmr	;|
			if !Setting_SSP_CarryAllowed != 0
			STA !Freeram_SSP_CarrySpr	;|
			endif
			STA !Freeram_SSP_EntrExtFlg	;/>Make code assume mario is out of the pipe.
			LDA !Freeram_SSP_PipeDir	;\Clear direction bits (resets the pipe state).
			AND.b #%11110000		;|
			STA !Freeram_SSP_PipeDir	;/
			JMP .PipeCodeReturn
;-----------------------------------------
;code that controls mario's pose
;-----------------------------------------
.pose
	LDA !Freeram_SSP_PipeDir
	AND #$01
	BEQ ..Horiz		;>If even number (bit 0 is clear), branch to Horizontal

	..Vert
		LDA $187A|!addr		;\if mario is riding yoshi, then
		BNE ...YoshiFaceScrn	;/use face screen instead
		LDA #$0F		;>vertical pipe pose (without regard to powerup status)
		BRA ..SetPose

		...YoshiFaceScrn
			LDA #$21		;>pose that mario turns around partially face the screen
			BRA ..SetPose

	..Horiz
		LDA $187A|!addr		;\if mario is riding yoshi, then
		BNE ...YoshiFaceHoriz	;/use "ride yoshi" pose
		LDA #$3C
		BRA ..SetPose

		...YoshiFaceHoriz
			LDA #$1D		;>crouch as entering a horizontal pipe on yoshi.

	..SetPose
		STA $13E0|!addr		;>set player pose

.PipeCodeReturn
	PLB
	RTL
;-------------------------------------------------------
;tables.
;-------------------------------------------------------

SSP_PipeXSpeed:
;X speed table
db $00 ;>#$01 Stem upwards
db $40 ;>#$02 Stem rightwards
db $00 ;>#$03 Stem downwards
db $C0 ;>#$04 Stem leftwards
db $00 ;>#$05 Pipe cap upwards
db $40 ;>#$06 Pipe cap rightwards
db $00 ;>#$07 Pipe cap downwards
db $C0 ;>#$08 Pipe cap leftwards

SSP_PipeYSpeed:
;Y speed table
db $C0 ;>#$01 Stem upwards
db $00 ;>#$02 Stem rightwards
db $40 ;>#$03 Stem downwards
db $00 ;>#$04 Stem leftwards
db $C0 ;>#$05 Pipe cap upwards
db $00 ;>#$06 Pipe cap rightwards
db $40 ;>#$07 Pipe cap downwards
db $00 ;>#$08 Pipe cap leftwards

SSP_CarryControlsForceSet:
; first number = force button held when not carrying sprites, second is when carrying.
; a set bit here means a bit is forced to be enabled (button will be held down)
db %00000000, %01000000
SSP_CarryControlsForceClear:
; Same format as above, but fores a button to not be pressed.
; a bit clear here means the button will be forced to be cleared.
db %00010000, %01010000
