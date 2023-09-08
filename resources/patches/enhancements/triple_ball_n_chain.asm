if read1($00FFD5) == $23
	sa1rom
	!sa1	= 1
	!bank	= $000000
else
	lorom
	!sa1	= 0
	!bank	= $800000
endif

!Scratch = $0D

org $02AF37
autoclean JML Start

if !sa1
  org $02AF55				;don't want to mess with JSL before
  autoclean JSL StoreSprite		;SA-1 does things differently, so we have to do things differently as well
else
  org $02AF51
  LDA !Scratch				;on LoROM (and possibly others) we can simply load scratch ram and move on
endif

freecode

Start:
PHA			;positions of platforms/balls
PHA			;save bit info twice for position and sprite number
AND #$F0		;
STA $08			;
PLA			;
AND #$01		;
STA $09			;
PLA			;
AND #$04		;
BNE .L1			;load ball 'n chain if bit 0 is set

LDA #$A3		;otherwise it'll act like grey platform
BRA .L2			;

.L1
LDA #$9E		;ball 'n chain

.L2
STA !Scratch		;store sprite number to scratch ram
JML $02AF41|!bank		;

StoreSprite:
LDA !Scratch		;
STA $3200,x		;sprite number
JML $07F7D2|!bank		;restore sprite table reset call