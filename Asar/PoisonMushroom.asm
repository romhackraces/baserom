; Poison mushroom patch
; original binary by mikey, asm version plus slight modification by JackTheSpades
;
; This patch will overwrite an existing sprite and turn it into the poison mushroom instead.
; Note that you shouldn't reapply this patch to the same ROM after changing !NUM as it will
; NOT remove the previous insertion.

; You can however freely change the other defines and reapply then

!NUM ?= $85			;NORMAL sprite number to insert as
!Tile = $C2			;tile to use gfx
!Pal	= $A		;palette to use (not yxppccct, just plain normal palette row)
!Sec	= 0			;use second graphics page 0=no,1=yes

assert !NUM < $C9

	!dp = $0000
	!addr = $0000
	!bank = $800000
	!sa1 = 0
	!gsu = 0

if read1($00FFD6) == $15
	sfxrom
	!dp = $6000
	!addr = !dp
	!bank = $000000
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!sa1 = 1
endif

org ($01817D+(!NUM*2))|!bank	;sprite init pointer
	dw $858B				;power up init
org ($0185CC+(!NUM*2))|!bank	;main pointer
	dw $C353				;power up routine

org ($07F26C+!NUM)|!bank	;tweaker 1656
	db $00
org ($07F335+!NUM)|!bank	;tweaker 1662
	db $00
org ($07F3FE+!NUM)|!bank	;tweaker 166E
	db !Pal-8<<1|!Sec
org ($07F4C7+!NUM)|!bank	;tweaker 167A
	db $C2
org ($07F590+!NUM)|!bank	;tweaker 1686
	db $28
org ($07F659+!NUM)|!bank	;tweaker 190F
	db $40

;handle power up routine
org $01C4CB|!bank
	autoclean JML PoisonHurt
;handle GFX routine
org $01C6D6|!bank
	autoclean JSL PoisonGFX
	
freecode							

;input:  A = sprite number
PoisonHurt:				; code JML's here
	CMP #$21				; \
	BNE +					; | retore code for BEQ
	JML $01C4CF|!bank			; /
+	CMP #!NUM			; \ check if sprite is poison mushoroom
	BNE +					; /
	JSL $00F5B7|!bank			; \ hurt player 
	JML $01C57F|!bank			; / jump-returns to RTS
+	JML $01C538|!bank			; return to normal power-up code

;input:  A = sprite number - 74
;output: A = tile number
PoisonGFX:				; code JSL's here
	CMP.b #!NUM-$74	; \ check if sprite is poison mushroom and skip
	BNE +					; / if not.
	LDA #!Tile			; \ if, set tile to #$C2
	RTL					; / and return
+	TAX					; \ retore code
	LDA $C609,x			; / ROMMAP $01C609 (Tilemap powerups)
	RTL					; retrum
