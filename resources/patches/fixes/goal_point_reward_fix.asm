incsrc "../../../shared/freeram.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Goal Point Sprite Reward Fix
; by Ragey (29/06/2014)
;
; When you hit the goal tape nearby a lot of sprites, garbage tiles appear. This
; patch fixes that.  In addition, it allows you to control how many sprites need
; to be  nearby when cutting  the goal tape,  before Mario gets  1UPs  for them.
; The default settings will give a  1UP for each enemy beyond the fourth; reduce
; the value of  !FIRST_SPRITE_WORTH  to increase the amount of sprites required.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
lorom
!addr = $0000
if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
endif

!FREE_RAM = !goal_point_reward_fix_freeram      ; must be cleared on overworld or level load
!FIRST_SPRITE_WORTH = $09    ; default = 1000 points. Can be between $01 - $0D
!HIGHEST_SPRITE_WORTH = $0D  ; default = 1UP.         Can be between $01 - $0D

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $00FC0E
  autoclean jsl NewGivePoints

freedata

NewGivePoints:
	phx
	lda !FREE_RAM
	inc
	cmp #!FIRST_SPRITE_WORTH
	bcs +
	lda #!FIRST_SPRITE_WORTH
	bra ++
+	cmp #!HIGHEST_SPRITE_WORTH+1
	bcc ++
	lda #!HIGHEST_SPRITE_WORTH
++	sta !FREE_RAM
	jsl $02ACEF
	plx
	rtl;