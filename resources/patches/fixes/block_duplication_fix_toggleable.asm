incsrc "callisto.asm"
%import_library("freeram.asm")

; Block Duplication Fix v1.5 by lolcats439 (Asar conversion and SA-1/SuperFX hybrid by LDA)
; Fixes the block duplication glitch

; The root cause of the glitch is that the sprite used for the glitch gets moved to the left or right
; by the code at $0191D0, which is the code that moves a sprite in case it gets stuck in a block,
; to try to get it unstuck; unfortunately, simply NOPing it out makes the sprite disappear when
; it is inside a block, and for some reason can crash the rom. After this code runs, $9A and $98
; are set using the moved position instead of the correct position. The high nybble of the sprite's
; new x (+ 8) position is one more or one less than the block's actual x position, and then is used
; to spawn the bounce sprite. The block is then respawned using the coordinates of the bounce sprite,
; causing the block to be duplicated.

; Duplicating a block vertically is a little different, and is not caused by the stuck-sprite code.
; It happens when a throwable sprite clips through a block so much that it's y position is up
; to 2 pixels above the block's y position, but somehow still counts as a hit and triggers the
; bounce sprite. Since the high nybble of the sprite y position is then one less than the
; block's y position high nybble, the block is duplicated vertically.

; The fix is to store the sprite's x position to FreeRAM before the stuck sprite code runs,
; then get it back afterwards. For vertical duplication, the fix is to add 02 to the sprite's
; y position to increment the high nybble if necessary before clearing the low nybble.

; 1 byte of FreeRAM
!FreeRAM = !block_duplication_freeram


; Default behaviour
; 0 = patched, setting flag enables block dupes
; 1 = unpatched, setting flag disables block dupes
!default = 0

; FreeRAM for toggle, cleared on level load
!Toggle = !toggle_block_duplication_freeram


!addr = $0000
!sa1 = 0
!gsu = 0
!9E = $9E
!E4 = $E4
!D8 = $D8
!14D4 = $14D4
!bank = $800000

if read1($00FFD5) == $23
	if read1($00FFD7) == $0D ; full 6/8 mb sa-1 rom
		fullsa1rom
	else
	sa1rom
	endif
	!addr = $6000
	!sa1 = 1
	!9E = $3200
	!E4 = $322C
	!D8 = $3216
	!14D4 = $3258
	!bank = $000000
endif

org $0192FC
	autoclean JSL CodeStart
	NOP #2

org $0195A6
	JSL GetUnmodifiedSpriteXPos
	NOP

org $0195B4
	autoclean JML Add2toSpriteYPos

org $0195E0
	autoclean JML Add8toSpriteYPos

freecode
CodeStart:
	LDA $1693|!addr		;\ restore overwritten code
	STA $1868|!addr		;/
	LDA !E4,x			;\ Store x position of sprite to FreeRAM so the original value can be used
	STA !FreeRAM		;/ after the stuck-sprite code runs
	RTL

GetUnmodifiedSpriteXPos:
	LDA !Toggle
if !default
	BNE .patched
else
	BEQ .patched
endif
	LDA !E4,x
	CLC
	ADC #$08
	RTL

.patched
	LDA !FreeRAM		;\ Get the sprite x pos
	CLC					;| restore overwritten code
	ADC #$08			;|
	STZ !FreeRAM		;/
	RTL

Add2toSpriteYPos:
	LDA !Toggle

if !default
	BNE .patched
else
	BEQ .patched
endif

	LDA !D8,x
	AND #$F0
	JML $0195B8

.patched
	LDA !D8,x			;\ y position of block
	CLC					;| add 02 to prevent duplicating blocks vertically,
	ADC #$02			;| by making the high nybble increment if necessary
	AND #$F0
	STA $98
	LDA.w !14D4,x
	ADC #$00
	STA $99

	JML $0195BF|!bank



; For this tweak:
; ; fix glitch with blocks not activating when hit with thrown sprites
; org $0195A5 : db $00
;
; another fix is necessary:
; Fix similar to Add2toSpriteYPos for X interaction (after running Y interaction)
; (it can happen that the block for X interaction is below the one for Y interaction, due to differing clipping offsets)
; What happens:
;  Object interaction runs, blocking is set to both X and Y (top)
;  Add2toSpriteYPos sets $98 for Y clipping (SpriteObjClippingY+$03)
;  $98 value is reused for X interaction, bounce sprite is spawned in wrong position, since SpriteObjClippingY+$01 != SpriteObjClippingY+03
; n.b. 2 and 8 come from SpriteObjClippingY and are likely wrong for sprites without object clipping=0

Add8toSpriteYPos:
	LDA !9E,X					;$0195E0	||\
	CMP.b #$0D					;$0195E2	||| If the sprite is touching the side of a block and is not a shell, then interact with that block.
	; BCC CODE_0195E9			;$0195E4	|||
	; JSR CODE_01999E			;$0195E6	||/
	BCS +
	JML $0195E9|!bank
+

	LDA !D8,x					;\ y position of block
	; CLC						;| add SpriteObjClippingY+$01
	; n.b. carry is set here
	ADC.b #$08-1				;| by making the high nybble increment if necessary
	AND #$F0
	STA $98
	LDA.w !14D4,x
	ADC #$00
	STA $99

	JML $0195E6|!bank
