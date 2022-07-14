;If you make changes here, make sure you apply the changes to all the copies of this define files
;elsewhere by simply copying the folder containing this file.

;If you're using notepad++, the tab size is 8 in case if you don't like the text vertical misalignment.

;Places to put this define file to:
;-In GPS's main directory (same where the exe is in, not in the sub-folder/subdirectory)
;-In uberasm tool's main directory, same style as above.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SA1 detector:
;Place this at the very top of gamemode_code.asm.
;Do not change anything here unless you know what are you doing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if defined("sa1") == 0
	!dp = $0000
	!addr = $0000
	!sa1 = 0
	!gsu = 0
	
	if read1($00FFD6) == $15
		sfxrom
		!dp = $6000
		!addr = !dp
		!gsu = 1
	elseif read1($00FFD5) == $23
		sa1rom
		!dp = $3000
		!addr = $6000
		!sa1 = 1
	endif
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;uberasm code for GHB's screen scrolling pipes.
;Do not insert this as blocks, paste this code in "gamemode_code.asm"
;labeled "gamemode_14:" so blocks works in all levels.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;freeram addresses, you can use long address also.--------------------------
;Do note that these freerams above are not automatically converted to SA-1 addressing. Remember to use banks $40/41 if you
;use 3-byte addressing ($xxxxxx).

;Also be careful if you are using untouched RAM, as the game does not even reset them on level load, therefore the player
;will maintain his pipe state even after he dies and enters the level. You'll have to initialize them by resetting all these
;RAM address.

 if !sa1 == 0
  !Freeram_SSP_PipeDir		= $7E0F42
 else
  !Freeram_SSP_PipeDir		= $0F42
 endif
  ;^[1 byte] this controls the directions within a pipe. Values stored on
  ;this RAM as follows:
  ;
  ; Bit format: PPPPDDDD
  ;
  ;-DDDD bits (The stem and pipe cap directions):
  ;--$00 = out of pipe (normal mode).
  ;--Values $01-$0A:
  ;---$01-$04 (%0001-%0100) = travel up, right, down and left (in that order) for stem sections.
  ;---$05-$08 (%0101-%1000) = same as above, but for cap speeds.
  ;---$09 (%1001) = Warp mode (more like drag) to specific XY position (!Freeram_SSP_DragWarpPipeDestinationXPos and
  ;   !Freeram_SSP_DragWarpPipeDestinationYPos)
  ;
  ;-PPPP bits (the planned direction for "special turning corners"):
  ;--$00 = Keep going straight, don't change direction. If in drag mode, reverts the player into his out-of-pipe state upon reaching his destination.
  ;  This is also known as "NULL" prep direction.
  ;--Values $01-$04:
  ;---$01-$04 (%0001-%0100) = travel up, right, down and left (in that order).
  ;   Note: When using warp mode, this will be the direction upon Mario reaches his warp destination his DDDD bits to be set to.

 if !sa1 == 0
  !Freeram_SSP_PipeTmr		= $7E0F43
 else
  !Freeram_SSP_PipeTmr		= $0F43
 endif
  ;^[1 byte] Used for various purposes:
  ;-If !Freeram_SSP_PipeDir's low nybble (DDDD bits) is 0-4:
  ; -for exiting and entering animations. Stored here is how
  ;  long the player perform a cap entering and exiting, in frames.
  ;

 if !sa1 == 0
  !Freeram_SSP_EntrExtFlg	= $7E0F44
 else
  !Freeram_SSP_EntrExtFlg	= $0F44
 endif
  ;^[1 byte] use to determine if mario's entering or
  ; exiting, stored values are:
  ; #$00 = outside the pipe
  ; #$01 = entering (including during the entire pipe trip between pipe caps).
  ; #$02 = exiting
  
 if !sa1 == 0
  !Freeram_SSP_CarrySpr		= $7E0F45
 else
  !Freeram_SSP_CarrySpr		= $0F45
 endif
  ;^[BytesUsed = !Setting_SSP_CarryAllowed, either not used or 1 byte taken] used for if
  ; mario enters a pipe while holding a sprite. Will store a #$01 if you did carry a
  ; sprite though pipe. Not used should your entire hack doesn't allow entering SSP with
  ; a sprite, otherwise 1 byte taken.
  
 if !sa1 == 0
  !Freeram_BlockedStatBkp	= $7E0F46
 else
  !Freeram_BlockedStatBkp	= $0F46
 endif
  ;^[1 byte] A backup of $77 to determine if Mario is on the ground.
 ;Warp mode destination. 2 bytes each. This determines where Mario will
 ;be warped to (via dragging the player towards that location).
  if !sa1 == 0
   !Freeram_SSP_DragWarpPipeDestinationXPos = $0F3A
  else
   !Freeram_SSP_DragWarpPipeDestinationXPos = $0F3A|!addr
  endif
  if !sa1 == 0
   !Freeram_SSP_DragWarpPipeDestinationYPos = $0F3C
  else
   !Freeram_SSP_DragWarpPipeDestinationYPos = $0F3C|!addr
  endif

;Settings. NOTE: There are other defines settings in [SSP_Tiles\caps\enterable\*\cap_defines.asm] (* means any valid filename, including "default")
;so that you can multiple blocks with different variations (such as having some pipe caps that allow carrying sprites or allowing yoshi).
 !Setting_SSP_Hijack_00EA18	= 0
  ;^If you are planning to install the “Walljump/Note Block Glitch Fix” patch, set this to 0, reinstall Fixes.asm, and then patch the WJNB fix patch.
  ; Otherwise set this to 1 to prevent potential pushing the player 1 pixel to the left when entering small pipes facing downwards by hitting their
  ; bottom corners.
  ;
  ; Make sure you avoid doing this: set to 1, patch Fixes.asm, and then patch WJNB fix afterwards, because the WJNB fix will merely overwrite
  ; $00EA16-$00EA21 (which overwrites Fixes.asm's $00EA18 hijack), but not clean out the old freespace code, which may have a freespace leak.
 !Setting_SSP_PipeDebug		= 0
  ;^0 = off
  ; 1 = on
  ; This will make mario visible and in front of objects when enabled, set to 1 if you encounter issues and need to know where is Mario. NOTE:
  ; Mario INTERACTS with sprites in his path (causes them to face his direction and take damage, for example) when turned on.
  
 ;SFX stuff for yoshi prohibited from entering pipes (only for normal-sized pipes, since you cannot enter small pipes on yoshi even as small Mario):
  !Setting_SSP_YoshiProhibitSFXNum	= $20
   ;^Set this to $00 for no sound (no worry, it won't cancel the SFX port of any current SFX on all frames when the button is held down).
  !Setting_SSP_YoshiProhibitSFXPort	= $1DF9
   ;^The sound effect played when you tried to enter pipes on yoshi when yoshi is prohibited.
 
 !Setting_SSP_Description	= 1
  ;^0 = off, 1 = on. Due to a bug in GPS with blocks with the wrong description, I added an option just in case if GPS has that fixed in the future.
  
 !Setting_SSP_FreezeTime	= 0
  ;^0 = FuSoYa's pipe to not freeze stuff, 1 = freeze stuff.
  
 !Setting_SSP_FuSoYaSpd		= 1
  ;^0 = SMW styled speed (pipe caps recreated from SMW's exit-enabled pipes, but with fast stem speed by default), 1 = FuSoYa's SSP speed.
 !Setting_SSP_CarryAllowed	= 1
  ;^0 = In your entire hack, you never allowed carrying sprites through pipes.
  ; 1 = In your entire hack, there are at least 1 case that you can enter pipes while carrying sprites.
 !Setting_SSP_Minimal_StuntimerSprites	= $5A
  ;^When having !Setting_SSP_FreezeTime = 0, this is the minimum amount of "double-frames" (each value here is 2 frames) remaining allowed when sprites
  ; are carried through SSPs. What this mean is when the timer goes below this value, will be set to this value* so that they cannot unstun
  ; during pipe travels and waits until the player exits the pipe, afterwards, the timer will continue counting and then unstun.
  ;
  ; You can remove the "$" to signal that this is a decimal number.
  ;
  ; Enter only values $00-$FC (0-252), values $FD-$FF (253-255) results an infinite stun time if the player exits the pipe after the timer runs out
  ; mid-travel.
  ;
  ; 1 second is 30 ($1E) double-frames (DoubleFrames = Seconds*30). Therefore ~8.47 seconds (using $FC double-frames) is the maximum length of stun time. $00 here
  ; means the sprite will immediately unstun once the timer runs out during travel and exits with the player, which may be seen as "unfair" to the
  ; player, so I recommend giving a little reaction time upon exiting.
  ;
  ;*Note: The sprite actually unstun themselves when the stun timer value hits $03, so the actual amount of double-frames is that stun timer value, minus 3.
  ; Infinite stun times occur if the timer is in range $00-$02.
  ;
  ; Note: This will also apply even if !Setting_SSP_FreezeTime = 1, because again, the player could enter the pipe on the last double-frame and can unfairly get hurt
  ; on exit. The original SMW, when carrying stunned sprites into exit-enabled pipes causes them to remain stunned forever.
 !Setting_SSP_VerticalCapsEnterableWidth	= $0005
  ;^This is the number of pixels far from the center the player is allowed to enter vertical normal-sized pipe caps. The higher the value, the further away from the
  ; center the player can enter them:
  ; Tested via the left edge of the pipe:
  ; $0005 is SMW's vanilla vertical pipes.
  ; $0008 is a full block width (half-block from the center on either side).
  ; $000B is the distance from the center to standing *ON* the edge; a position that Mario is hugging the wall placed to the side of the vertical pipe.
  ; $0013 is *OVER* the edge (a pixel before falling off the edge).
  ; $0014+ is off the pipe (can enter no matter how far off-centered you are, even at the edges).
  ;
  ; Having a bigger range of being able to enter the pipe is great for kaizo hacks if you want a bigger margin of error on how narrow the range the player
  ; could enter. I wouldn't recommend higher than $000B as it is possible the player could snap to be centered at such a long distance may feel jerky and
  ; could potentially result the screen jolting and revealing a layer 1 column of glitch graphics.
 !Setting_SSP_UsingCustomSprites = 1
  ;^0 = only using vanilla sprites in your entire hack
  ; 1 = using custom sprites.
  ; This is only used during setting the player's facing direction upon exiting horizontal pipe caps while riding yoshi.
;Pipe travel speeds:
;Use only values $01-$7F (negative speeds already calculated).
 if !Setting_SSP_FuSoYaSpd == 0		;>Don't change this if statement.
  ;SMW styled speed
  !SSP_HorizontalSpd		= $40 ;\Stem speed (changing this does not affect the timing of the entering/exiting)
  !SSP_VerticalSpd		= $40 ;/
  !SSP_HorizontalSpdPipeCap	= $08 ;\cap speed (if changed, you must change the timers below this section)
  !SSP_VerticalSpdPipeCap	= $10 ;/
  !SSP_DragSpd			= $40 ;>Speed mario travels when using warp mode.
 else
  ;FuSoYa styled speed.
  !SSP_HorizontalSpd		= $40 ;\Duplicate of above, but for fusoya style speeds.
  !SSP_VerticalSpd		= $40 ;|
  !SSP_HorizontalSpdPipeCap	= $40 ;|
  !SSP_VerticalSpdPipeCap	= $40 ;/
  !SSP_DragSpd			= $40 ;>Speed mario travels when using warp mode. Remember, high speeds and the player could overshoot and softlock oscillating around his target position!
 endif
 ;Cannon launcher speeds (special pipe caps that fire the player out of the caps with momentum):
  !SSP_Cannon_HorizontalSpd	= $40		;>Use only $01-$7F, this covers both left and right speeds
  !SSP_Cannon_UpwardsSpd	= $B0		;>Use only $80-$FF, fires the player upwards
  !SSP_Cannon_DownwardsSpd	= $40		;>Use only $01-$7F, fires the player downwards.
   ;^Note: The downwards speed, once initially exiting the cap and returning to normal state, you'll lose your additional speed,
   ; and will revert to your normal maximum downwards Y speed. If you don't want this, install “Same Fall Acceleration Speed”
   ; from the patch section: https://www.smwcentral.net/?p=section&a=details&id=24286 and you can fall faster gained from the
   ; downwards cap. The only difference is that the regular pipe caps zero out your XY speed, so upon exiting a downwards cap,
   ; you kinda “slow down”.

 ;Pipe entering/exiting timers (in frames). These are used to determine when the player "fully" enters or exits the pipe:
 ;-When entering, it is the amount of time before the player (and carried sprite) turns invisible and goes from his cap speed to his stem speed.
 ;-When exiting, it is the amount of time before the player is reverted to "out of pipe" (normal) state. He'll (and sprite) becomes visible
 ; and goes cap speed immediately when triggering the pipe caps to exit.
 ;
 ;The faster you set the pipe cap speed, the lower the values here should be.
 ;Hint: by using the scale by factor (Speed*X leads to Timer/X), it makes it much easier to work with this.
 ;
 ;How to get the correct number of frames when exiting pipes:
 ; Easiest to know is to test them, if the player exits the pipe further ahead of the cap past it, the timer is too long
 ; and needs to be a lower value, if the player exits the pipe while inside the cap (partially embedded inside the solid pipe,
 ; which may kill the player), the timer is too short and needs to be a higher value. For downwards facing pipes, shorter
 ; timers also enable entering back in them just after exiting it by holding up (you don't need to jump).
 ;
 ; An alternative way: have the timer be $FF. Then use a debugger and check out the RAM address "!Freeram_SSP_PipeTmr" is
 ; using, from the time the timer is $FF about to decrement to the time the value is at a certain number when the player's
 ; body (including yoshi when riding it) is at the position he should be freely be able to move, the difference is the
 ; correct amount of frames for the player to exit the pipe properly:
 ;
 ; CorrectTimerValue = $FF - <Timer value when the player is completely out of the pipe>
 ;
 ; Example:
 ;
 ; Right when mario exits the pipe leftwards, his time value was $C5, so [$FF - C5 = $3A]. That $3A is the correct time
 ; amount.
 ;
 ;Again, only use speeds $01-$7F, the negative speeds are automatically calculated when inserted.
 
  if !Setting_SSP_FuSoYaSpd == 0
   ;Regular pipe timing
   !SSP_PipeTimer_Enter_Leftwards			= $3A
   !SSP_PipeTimer_Enter_Rightwards			= $3C
   !SSP_PipeTimer_Enter_Upwards_OffYoshi		= $1D
   !SSP_PipeTimer_Enter_Upwards_OnYoshi			= $27
   !SSP_PipeTimer_Enter_Downwards_OffYoshi		= $20
   !SSP_PipeTimer_Enter_Downwards_OnYoshi		= $30
   !SSP_PipeTimer_Enter_Downwards_SmallPipe		= $1D
   
   !SSP_PipeTimer_Exit_Leftwards			= $1B
   !SSP_PipeTimer_Exit_Rightwards			= $1B
   !SSP_PipeTimer_Exit_Upwards_OffYoshi			= $1D
   !SSP_PipeTimer_Exit_Upwards_OnYoshi			= $27
   !SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario	= $0E
   !SSP_PipeTimer_Exit_Downwards_OffYoshi_BigMario	= $1B
   !SSP_PipeTimer_Exit_Downwards_OnYoshi_SmallMario	= $18
   !SSP_PipeTimer_Exit_Downwards_OnYoshi_BigMario	= $25
  else
   ;FuSoYa enter and exit timers.
   !SSP_PipeTimer_Enter_Leftwards			= $06
   !SSP_PipeTimer_Enter_Rightwards			= $06
   !SSP_PipeTimer_Enter_Upwards_OffYoshi		= $06
   !SSP_PipeTimer_Enter_Upwards_OnYoshi			= $0A
   !SSP_PipeTimer_Enter_Downwards_OffYoshi		= $08
   !SSP_PipeTimer_Enter_Downwards_OnYoshi		= $0A
   !SSP_PipeTimer_Enter_Downwards_SmallPipe		= $06
 
   !SSP_PipeTimer_Exit_Leftwards			= $04
   !SSP_PipeTimer_Exit_Rightwards			= $04
   !SSP_PipeTimer_Exit_Upwards_OffYoshi			= $09
   !SSP_PipeTimer_Exit_Upwards_OnYoshi			= $0A
   !SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario	= $06
   !SSP_PipeTimer_Exit_Downwards_OffYoshi_BigMario	= $08
   !SSP_PipeTimer_Exit_Downwards_OnYoshi_SmallMario	= $07
   !SSP_PipeTimer_Exit_Downwards_OnYoshi_BigMario	= $08
  endif
  ;Cannon exit timers
   !SSP_PipeTimer_CannonExit_Leftwards				= $04
   !SSP_PipeTimer_CannonExit_Rightwards				= $04
   !SSP_PipeTimer_CannonExit_Upwards_OffYoshi			= $09
   !SSP_PipeTimer_CannonExit_Upwards_OnYoshi			= $09
   !SSP_PipeTimer_CannonExit_Downwards_OffYoshi_SmallMario	= $06
   !SSP_PipeTimer_CannonExit_Downwards_OffYoshi_BigMario	= $09
   !SSP_PipeTimer_CannonExit_Downwards_OnYoshi_SmallMario	= $09
   !SSP_PipeTimer_CannonExit_Downwards_OnYoshi_BigMario		= $09