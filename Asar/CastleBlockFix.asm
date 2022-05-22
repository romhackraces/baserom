;Moving Castle Block offscreen handling fix by Blind Devil
;This patch makes it so the castle block sprite is now properly handled
;when offscreen. Previously, it would never despawn - preventing sprite
;slots from being erased and leading to other sprites not spawning -
;despite the 'Process when off screen' option being unchecked in Tweaker.

;SA-1 detector - don't change this.
if read1($00FFD5) == $23
	sa1rom
	!1528 = $329A
	!bank = $000000
else
	lorom
	!1528 = $1528
	!bank = $800000
endif

org $038E9A|!bank
PHA				;flip high/low bytes of A
JSR $B84F			;call SubOffScreenX3 on bank 3
autoclean JML CastleBlock	;call custom code
NOP				;no operation once - erase leftover byte.

freedata

CastleBlock:
PLA			;flip high/low bytes of A
STA $B6,x		;(restored code) store to sprite's X speed. Sa-1 define for B6 is B6.
JSL $018022|!bank	;(restored code) update X-pos without gravity and object interaction
STA !1528,x		;(restored code) store to sprite table.
JML $038EA3|!bank			;return.
