;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is a helper for the graphics routine.  It sets off screen flags, and sets up
; variables.
;
; Output:
;  Y = index to sprite OAM ($300)
;  $00 = sprite x position relative to screen boarder
;  $01 = sprite y position relative to screen boarder  
;
; It is adapted from the subroutine at $03B760
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

?main:
   STZ !186C,x
   LDA !14E0,x
   XBA
   LDA !E4,x
   REP #$20
   SEC : SBC $1A
   STA $00
   CLC
   ADC.w #$0040
   CMP.w #$0180
   SEP #$20
   LDA $01
   BEQ ?.on_screen_x
   LDA #$01
?.on_screen_x
   STA !15A0,x
   ; in sa-1, this isn't #$000
   ; this actually doesn't matter
   ; because we change A and B to different stuff
   TDC
   ROL A
   STA !15C4,x
   BNE ?.invalid

   LDA !14D4,x
   XBA
   LDA !190F,x
   AND #$20
   BEQ ?.check_once
?.check_twice
   LDA !D8,x
   REP #$21
   ADC.w #$0020
   SEC : SBC $1C
   SEP #$20
   LDA !14D4,x
   XBA
   BEQ ?.check_once
   LDA #$02
?.check_once
   STA !186C,x
   LDA !D8,x
   REP #$21
   ADC.w #$0010
   SEC : SBC $1C
   SEP #$21
   SBC #$10
   STA $01
   XBA
   BEQ ?.on_screen_y
   INC !186C,x
?.on_screen_y
   LDY !15EA,x
   RTL
 
?.invalid
   PLA             ; destroy the JSL
   PLA
   PLA
   PLA             ; sneak in the bank
   PLY
   PHB
   PHY
   PHA
   RTL
