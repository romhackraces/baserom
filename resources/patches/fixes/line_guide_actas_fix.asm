;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; Line-Guide "Acts Like" Fix, by imamelia
;
; This patch makes the line guide processing routine depend on the "acts like"
; setting of the Map16 tiles rather than the tile number.  This allows you to put
; line guide tiles anywhere on any Map16 page, as long as they act like the original
; tiles (or a tile set to act like one of the original tiles).
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


; worldpeace's note:
; The vanilla code of line guide interaction sometimes tries to restore the sprite's position from backup RAM, even if they aren't properly stored.
; This results in teleportation of line-guided sprites. (Like other vanilla glitches, this has been regarded as a feature and utilized for vanilla tricks!)
;
; The previous version assumed the correctness of Nintendo's code however, and accessed some invalid "acts like" values as a result.
; It caused game freezing in some emulators (e.g. higan v092); for those who're interested, the patch got the map16 value outside of the level area and repeated a loop infinitely.
;
; My version fixes the freezing issue, as well as giving some extra option regarding behaviors of line guide.




!glitch_level = $03	; modify this as you want ($00-$03)


; Explanation: you can choose the frequency of odd behaviors, which are the following:
; 1) Map16 tiles in the page 1 (or acting like one) work as "line guide end".
; 2) Those tiles let line-guided sprites teleport to certain position. (see ft029's swissotel in vldcx)
;
; These behaviors can be rarely observed in vanilla; only when the line-guided sprite is at a specific position which is decided by the map16 page of interacting tiles.
;
; $03 = always allows those two behaviors regardless of the position of a line-guided sprite, like the previous version of the patch.
; $02 = always allows the "line guide end" behavior, but disallows the teleportation. (good for non-janky hacks)
; $01 = sparsely allows them as frequent as the true vanilla where there are only map16 pages 0 and 1. (might be useful for a restrictive compilation hack of something)
; $00 = disallows them completely. (another option for non-janky hacks)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; don't need to care about the below code         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


!addr	= $0000
!bank	= $800000
!state	= $C2

if read1($00FFD5) == $23
	sa1rom
	!addr	= $6000
	!bank	= $000000
	!state	= $D8
endif



org $01D99C
autoclean JML LineGuideActFix




freecode

LineGuideActFix:
	CMP #$80
	BCS .reject
	PHX
	LDX #$00
	CMP #$40
	BCC +
	LDX #$16
+
-	XBA
	LDA $1693|!addr
	REP #$20
	ASL
	ADC $06F624|!bank,x
	STA $0D
	SEP #$20
	LDA $06F626|!bank,x
	STA $0F
	REP #$20
	LDA [$0D]
	SEP #$20
	STA $1693|!addr
	XBA
	CMP #$02
	BCS -
	PLX

	if !glitch_level == $00
		CMP #$00
		BNE .reject
		LDA $1693|!addr
		CMP #$9A
		BCS .reject
		PLA
		PLA
		JML $01D83F|!bank
	elseif !glitch_level == $01
		PHA
		LDA $05
		AND #$07
		JML $01D9A1|!bank
	elseif !glitch_level == $02
		LDY !state,x
		CPY #$02
		BEQ +
		CMP #$00
		JML $01D9A6|!bank
	+
		CMP #$00
		BNE .reject
		LDA $1693|!addr
		CMP #$9A
		BCS .reject
		PLA
		PLA
		JML $01D83F|!bank
	else
		CMP #$00
		JML $01D9A6|!bank
	endif
.reject
	PLA
	PLA
	JML $01D861|!bank
