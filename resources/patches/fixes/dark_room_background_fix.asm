if read1($00FFD5) == $23
	sa1rom
	!sa1	= 1
	!bank	= $000000
else
	lorom
	!sa1	= 0
	!bank	= $800000
endif

org $03C503|!bank	; This is code for the Dark Room sprite
autoclean JSL NewRt	; Go to new routine that should fix the BG
freecode

NewRt:
LDA #$FF		; CGADSUB settings (affects all layers)
STA $40			; $40 being a mirror of $2131
if !sa1
    LDA.b #.snes	;
    STA $0183		;
    LDA.b #.snes/256	;
    STA $0184		;
    LDA.b #.snes/65536	;\
    STA $0185		; big thanks to LX5 for providing this part of the code
    LDA #$D0		;/
    STA $2209		;
-    LDA $018A		;
    BEQ -		;
    STZ $018A		;
    RTL
.snes
endif
LDA #$1F		; Use main-screen designation on all layers
STA $212C		; <-- Main screen designation
STZ $212D		; Do not use sub-screen designation
RTL