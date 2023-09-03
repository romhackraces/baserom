; The global init routine is included in the same freecode block as the main patch, so it should end with RTS rather than RTL

init:
    rts

main:
    !controller_read_optimization = 1 ; set to 0 to uninstall
	pushpc
	org $008650
	ControllerUpdate:
	if !controller_read_optimization
		org $008243
		BRA $01
		org $0082F4
		BRA $01
		org $0086C6
		RTL
		pullpc
		JSL ControllerUpdate|!bank

	else
		org $008243
		JSR ControllerUpdate
		org $0082F4
		JSR ControllerUpdate
		org $0086C6
		RTS
		pullpc
	endif
	assert read1($0086C1) != $5C, "Incompatible with optimized block change patch"

	rts