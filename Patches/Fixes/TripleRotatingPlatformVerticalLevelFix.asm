;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Triple rotating platform (sprite E0) vertical level fix ;
;  by Zeldara109                                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if read1($00FFD5) == $23
	sa1rom
	!long	= $000000

	!D8		= $3216
	!E4		= $322C
	!14D4	= $3258
	!14E0	= $326E
else
	lorom
	!long	= $800000

	!D8		= $D8
	!E4		= $E4
	!14D4	= $14D4
	!14E0	= $14E0
endif


org $02AF59 : autoclean JML RotatPlat3Init

freecode

RotatPlat3Init:
LDA $5B
AND #$03
BNE .Vertical

.Horizontal
LDA $00          ;\
STA !E4,x        ;/ replaced
JML $02AF5D|!long

.Vertical
LDA $08          ;\
STA !E4,x        ;|
LDA $09          ;|
STA !14E0,x      ;| swap $00/$08, $01/$09
LDA $00          ;|
STA !D8,x        ;|
LDA $01          ;|
STA !14D4,x      ;/
JML $02AF6B|!long
