;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sprite Ceiling Fix by Davros.
;;
;; Fixes the glitch that allows Spiny Eggs, Hopping Flames, Monty Moles, Bowser Statues,
;; Dino Rhinos, Dino Torches and Ninjis to jump through ceilings.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if read1($00ffd5) == $23
	sa1rom
	!base = $000000
	!1588 = $334A
	!AA = $9E
else
	!base = $800000
	!1588 = $1588
	!AA = $AA
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Spiny Egg code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $018C2B|!base
	autoclean JML SpinyEggCode	; go to new routine
	NOP							; cancel out routine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hopping Flame code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $018F21|!base
	autoclean JML HoppingFlameCode	; go to new routine
	NOP								; cancel out routine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Monty Mole code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $01E413|!base
	autoclean JML MontyMoleCode	; go to new routine
	NOP							; cancel out routine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Bowser Statue code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $038A7F|!base
	autoclean JSL BowserStatueCode	; go to new routine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Dino Rhino and Dino Torch code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $039C5C|!base
	autoclean JSL DinoCode	; go to new routine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ninji code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

org $03C36A
	db $0C	; fix Ninji ceiling contact

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ceiling fix routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	freecode
	reset bytes
	print "Code is located at: $", pc

SpinyEggCode:
	JSL Hit_Ceiling|!base	; touch the ceiling routine
	LDA !1588,x				; \ if touching the ground...
	AND #$04				;  |
	BEQ Set_Side_Contact	; /

	JML $018C30|!base		; \ return to original routine
Set_Side_Contact:			;  |
	JML $018C3E|!base		; /

HoppingFlameCode:
	JSL Hit_Ceiling|!base	; touch the ceiling routine
	LDA !1588,x				; \ if touching the ground...
	AND #$04				;  |
	BEQ Set_Side_Contact2	; /

	JML $018F26|!base		; \ return to original routine
Set_Side_Contact2:			;  |
	JML $018F43|!base		; /

MontyMoleCode:
	JSL Hit_Ceiling|!base	; touch the ceiling routine
	LDA !1588,x				; \ if sprite is in contact with an object...
	AND #$03				;  |
	BEQ Set_Return			; /

	JML $01E418|!base	; \ return to original routine
Set_Return:				;  |
	JML $01E41B|!base	; /

DinoCode:
BowserStatueCode:
	JSL $01802A|!base		; update position based on speed values

Hit_Ceiling:
	LDA !1588,x	; \ if touching the ceiling...
	AND #$08	;  |
	BEQ Return	; /
	STZ !AA,x	; no y speed
Return:
	RTL			; return

print "Freespace used: ",bytes," bytes."