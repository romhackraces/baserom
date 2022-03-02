	lorom
	!sa1 = 0
	!bank = $800000
	!addr = $0000

if read1($00FFD5) == $23	; Detects SA-1.
	sa1rom
	!sa1 = 1
	!bank = $000000
	!addr = $6000
endif

!Tile = $0C		;Tile where the extended tiles will be loaded to. Takes up 2 8x8's
			;located in SP1


org $00A300
autoclean JML BEGINDMA
RTS

org $00F691
ADC.w #BEGINXTND

org $00E1D4+$2B
db $00,$8C,$14,$14,$2E
db $00,$CA,$16,$16,$2E
db $00,$8E,$18,$18,$2E
db $00,$EB,$1A,$1A,$2E
db $04,$ED,$1C,$1C

org $00DF1A
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

db $00,$00,$00,$00,$00,$00,$28,$00
db $00

db $00,$00,$00,$00,$82,$82,$82,$00
db $00,$00,$00,$00,$84,$00,$00,$00
db $00,$86,$86,$86,$00,$00,$88,$88
db $8A,$8A,$8C,$8C,$00,$00,$90,$00
db $00,$00,$00,$8E,$00,$00,$00,$00
db $92,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

db $00,$00,$00,$00,$82,$82,$82,$00
db $00,$00,$00,$00,$84,$00,$00,$00
db $00,$86,$86,$86,$00,$00,$88,$88
db $8A,$8A,$8C,$8C,$00,$00,$90,$00
db $00,$00,$00,$8E,$00,$00,$00,$00
db $92,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

org $00E3B1
JSR chartilehijack

org $00E40D
JSR capetilehijack

org $00DFDA
db $00,$02,$80,$80		;[00-03]
db $00,$02,!Tile,!Tile+$1	;[04-07]
chartilehijack:
LDA $DF1A,y
BPL +
AND #$7F
STA $0D
LDA #$04
+
RTS
capetilehijack:
LDA $0D
CPX #$2B
BCC +
CPX #$40
BCS +
LDA $E1D7,x
+
RTS
db $FF,$FF			;[22-23]
db $FF,$FF,$FF,$FF		;[24-27]
db $00,$02,$02,$80		;[28-2B]	Balloon Mario
db $04				;[2C]		Cape
db !Tile,!Tile+$1		;[2D-2E]	Random Gliding tiles
db $FF,$FF,$FF			;[2F-31]


freedata

BEGINDMA:
REP #$20
LDX #$04
LDY $0D84|!addr
BNE +
JMP .skipall
+

;;
;Mario's Palette
;;

LDY #$86
STY $2121
LDA #$2200
STA $4320
TAY
LDA $0D82|!addr
STA $4322
STY $4324
LDA #$0014
STA $4325
STX $420B

LDY #$80
STY $2115
LDA #$1801
STA $4320
LDY #$7E
STY $4324

;;
;Misc top tiles (mario, cape, yoshi, podoboo)
;;

LDA #$6000
STA $2116
TAY
-
LDA $0D85|!addr,y
STA $4322
LDA #$0040
STA $4325
STX $420B
INY #2
CPY $0D84|!addr
BCC -

;;
;Misc bottom tiles (mario, cape, yoshi, podoboo)
;;

LDA #$6100
STA $2116
TAY
-
LDA $0D8F|!addr,y
STA $4322
LDA #$0040
STA $4325
STX $420B
INY #2
CPY $0D84|!addr
BCC -

;;
;Mario's 8x8 tiles
;;

LDY $0D9B|!addr
CPY #$02
BEQ .skipall

LDA.w #!Tile<<4|$6000
STA $2116
LDA $0D99|!addr
STA $4322
LDY.b #BEGINXTND>>16
STY $4324
LDA #$0040
STA $4325
STX $420B

.skipall
SEP #$20
JML $00A304|!bank


BEGINXTND:
incbin "ExtendGFX.bin"