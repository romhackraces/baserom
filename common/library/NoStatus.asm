;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sample UberASM which disables the status bar
; in the applied level
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Toggle = $1FFA|!addr ;FreeRAM cleared on level load, must match toggle_status.asm patch


load:
	LDA #$00
	STA !Toggle
    RTL