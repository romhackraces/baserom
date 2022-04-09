;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sample UberASM which toggles that status bar
; on a button press
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Toggle = $1FFA|!addr ;FreeRAM cleared on level load, must match toggle_status.asm patch

!ButtonRAM = $16 ; Which button ram to check
!Button    = $20 ; Which button value to compare to

macro localJSL(dest, rtlop, db)
	PHB			;first save our own DB
	PHK			;first form 24bit return address
	PEA.w ?return-1
	PEA.w <rtlop>-1		;second comes 16bit return address
	PEA.w <db><<8|<db>	;change db to desired value
	PLB
	PLB
	JML <dest>
?return:
	PLB			;restore our own DB
endmacro

nmi:
	LDA !ButtonRAM
	AND #!Button
	BEQ +

	LDA !Toggle
	EOR #$01
	STA !Toggle

	%localJSL($008CFF|!bank, $F3B1, $00|!bank8)

	LDA !Toggle
	BEQ +

	%localJSL($008E6F|!bank, $F3B1, $00|!bank8)
	+
	RTL