;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game Fixes & Tweaks ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

; check for interaction every single frame (as opposed to every other frame)
org $02A0B2 : db $00 ; fireball-sprite
org $01A7EF : db $00 ; mario-sprite
org $029500 : db $00 ; cape-sprite

; make doors more easy to enter adjust door proximity check
org $00F44B : db $10 ; width of the enterable region of the door (up to 0x10, default 0x08)  
org $00F447 : db $05 ; offset the enterable region, which is half of above (default 0x04)

; play SFX when exiting horizontal pipes
org $00D24E : LDA $7D : NOP : NOP

; restore Classic Piranha Plants
org $018E8D : db $20,$C0,$FF,$EA,$EA,$EA,$EA,$EA,$EA,$EA
org $01FFC0 : db $B5,$9E,$C9,$1A,$F0,$0B,$B9,$0B,$03,$29,$F1,$09,$0B,$99,$0B,$03,$60,$B9,$07,$03,$29,$F1,$09,$0B,$99,$07,$03,$60

; make Classic Piranha Plants use the first graphics page
org $01FFD7 : db $0A

; make Upside-Down Piranha Plants use the first graphics page
org $01FFCC : db $0A

; fix bug in yoshi stomp hitbox 
org $0286D7 : db $D5

; disable L/R
org $00CDFC : db $80

; no powerups from midways
org $00F2E2 : db $80

; stop the bridge breaking in the Reznor fight
org $03989F : db $EA,$EA,$EA,$EA

; fix disappearing music on overworld when boss defeated
org $048E2E : db $80  

; Sunken Ghost Ship glitch
org $048DDA : db $80

;;;;;;;;;;;;;;;;;;;;;;;;
;; GFX Tweaks & Fixes ;;
;;;;;;;;;;;;;;;;;;;;;;;;

; fix dark palette on "Erase Game" screen
org $009D30 : db $EA,$EA,$EA,$EA,$EA

; fix a misplaced tile on the keyhole "iris in" effect
org $00CBA3 : db $49

; fix the S in "Mario/Luigi Start".
org $00913F : db $34
org $009170 : db $F4

; fix chuck arm palette
org $02CAFA : db $4B,$0B

; fix the Dolphin tails showing up when they're vertically off-screen
org $07F69C : db $25

; fix bat ceiling gfx
org $02FDB8 : db $AE,$AE,$C0,$E8

; fix dead Swooper tilemap
org $02FDB8 : db $C0

; fix the last tile of the Turnblock Bridge being X flipped.
org $01B79D : db $20

; fix Wendy's bow
org $03CFAF : db $08
org $03CFB5 : db $08
org $03D1D7 : db $1F,$1E
org $03D1DD : db $1E,$1F

; fix vertical level priorities
org $0584BE : db $20,$20        ; level mode 07 & 08
org $0584C1 : db $20            ; level mode 0A
org $0584C3 : db $20,$20,$20    ; level mode 0C, 0D & 0E
org $0584C8 : db $20            ; level mode 11
org $0584D5 : db $20,$20        ; level mode 1E & 1F

; changes the palette the special 'double-bounce' shell uses (also changes koopas)
org $07F407
;   db $00 ; yellow
    db $02 ; silver
;   db $0C ; grey
;   db $0E ; green


;;;;;;;;;;;;;;;;;;;
;; Sprite Remaps ;;
;;;;;;;;;;;;;;;;;;;

; Note block bounce sprite
org $0291F2 : db $22 : org $02878A : db $02 : org $02925D : db $02
; Side turn block bounce sprite
org $0291F4 : db $40 : org $02878C : db $00 : org $02925D : db $02
; ON/OFF bounce sprite
org $0291F6 : db $20 : org $02878E : db $06 : org $02925D : db $02

; Yoshi's tongue, end
org $01F48C : db $4A : org $01F494 : db $08
; Yoshi's tongue, middle
org $01F488 : db $4B : org $01F494 : db $08
; Yoshi's throat
org $01F08B : db $5B : org $01F097 : db $00

; Piranha plant Head 1
org $019BBD : db $AC : org $07F418 : db $08
; Piranha plant Stem 1
org $019BBE : db $0A : org $018E92 : db $0B
; Piranha plant Head 2
org $019BBF : db $AE : org $07F418 : db $08
; Piranha plant Stem 2
org $019BC0 : db $0A : org $018E92 : db $09
