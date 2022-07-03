;=======================================================================;
; P-Switch duplication with Yoshi fix									;
; by KevinM																;
;																		;
; This patch prevents Yoshi to eat P-Switches in the "pressed" state,	;
; which would also allow to get a new P-Switch after having hit it		;
; (and sometimes it can also cause another sprite to be spit by Yoshi).	;
;========================================================================

if read1($00FFD5) == $23
	sa1rom
	!bank = $000000
	!1686 = $762C
else
	lorom
	!bank = $800000
	!1686 = $1686
endif

org $01A202
	autoclean jml Main

freedata

; We get here if !163E != 0, so if the switch is pressed.
Main:
	lda !1686,x			;\ Make the switch inedible.
	ora #$01			;|
	sta !1686,x			;/
	cpy #$01			;\ Restore original code.
	bne +				;|
	jml $019ACB|!bank	;|
+	jml $01A209|!bank	;/
