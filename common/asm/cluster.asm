
;original cluster sprite tool code by Alcaro
;slight modification and sa-1 compability by JackTheSpades

incsrc "sa1def.asm"
incsrc "pointer_caller.asm"

org $00A686|!BankB
	autoclean JML NotQuiteMain
	autoclean dl Ptr      ; org $0x00A68A, default dl $9C1498

org $02F815|!BankB
	autoclean JML Main


freecode
NotQuiteMain:
	STZ $149A|!Base2      ; \ Hijack restore code.
	STZ $1498|!Base2      ; | 
	STZ $1495|!Base2      ; /
	REP #$20
	LDX #$9E              ; \ Set $1E02-$1EA1 to zero on level load.
.loop                    ; |
	STZ $1E02|!Base2,x    ; |
	DEX                   ; |
	DEX                   ; |
	BNE .loop             ; /
	SEP #$20
	JML $00A68F|!BankB    ; Return.


Main:
	LDA $0100|!Base2      ; \ If in mosaic routine, don't run sprite.
	CMP #$13              ;  |
	BEQ .return           ; /
	LDA $1892|!Base2,x    ; \ Check if $1892,x is 00 (free slot). If so, return.
	BEQ .return           ; /
	CMP #$09              ; \ Check if >=09.
	BCS .custom           ; / If so, run custom cluster sprite routine.
	PEA $F81C             ; \ Go to old pointer.
	JML $02F821|!BankB    ; /


.custom:
	;PHB : PHK : PLB       ; magic bank wrapper
	SEC                   ; \ Subtract 9. (Also allows you to use slots up to $88 instead of $7F in this version.)
	SBC #$09              ; / (Not that you'll ever use all of them though)
	AND #$7F

	%CallSprite(Ptr)

.return:
	JML $02F81D|!BankB

freedata
Ptr:
	incbin "_ClusterPtr.bin"