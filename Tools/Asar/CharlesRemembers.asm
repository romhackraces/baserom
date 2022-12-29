if read1($00FFD5) == $23
	sa1rom
	!9E = $3200
	!C2 = $D8
	!151C = $3284
	!157C = $3334
	!7FAB10 = $6040
	!Bank = $000000
else
	lorom
	!9E = $9E
	!C2 = $C2
	!151C = $151C
	!157C = $157C
	!7FAB10 = $7FAB10
	!Bank = $800000
endif

ORG $02C77D
autoclean JML RestoreType

freecode

RestoreType:

LDA !7FAB10,x				;/
AND #$04					;|
BEQ .ExBitClear				;| If the extra bit is clear or Chuck is already a Chargin' Chuck, jump to the code which would turn every Chuck into a Chargin' type.
LDA !9E,x					;|
CMP #$91					;|
BEQ .AlreadyChargin			;\

PEA.w (States>>16)|$0200	;/
PLB							;\ We need to set the DBR for a Y indexed table load.

CMP #$46					;/
BNE +						;| If a Diggin' Chuck, Use 0 for the index and go straight to the table load.
LDY #$00					;| His Sprite number isn't contiguous with the other Chucks, so the subtraction to get the index doesn't work for him.
BRA .GetState				;\

+
SEC							;/
SBC #$91					;| If one of the other Chucks, subtract #$91 to get an index (keeping in mind Diggin' Chuck is index 0).
TAY							;\
.GetState
LDA.w States,y				;/
STA !C2,x					;\ Get Chuck state to return to, indexed by Chuck type (sprite number).
LDA !157C,x					;/
ASL #2						;| Restore Chuck's head direction.
STA !151C,x					;\
PLB
JML $02C798|!Bank

.ExBitClear
LDA !9E,x					;/
CMP #$46					;| Special case for Diggin' Chuck.
BEQ .Diggin					;\
.AlreadyChargin
JML $02C785|!Bank			; Chargin' Chuck's restoration code.

.Diggin
JML $02C781|!Bank

States:
db $04,$05,$05,$0C,$08,$FF,$09,$0A		; $FF is a Chargin' Chuck duplicate but that's already handled. $0C is Whistling but that's already handled before our patch.