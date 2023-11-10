incsrc "../../../shared/freeram.asm"

; Capespin Direction Consistency (a.k.a. Turnaround) by Katun24, converted to SA-1 by AmperSam, made freeram toggleable by binavik
; This patch makes it so a capespin always results in Mario turning around, and makes the face direction consistent during the capespin animation.

!CapespinTimer = $14A6|!addr

if read1($00FFD5) == $23
    ; SA-1 base addresses
    sa1rom
    !SA1  = 1
    !addr = $6000
    !bank = $000000
else
    ; Non SA-1 base addresses
    lorom
    !SA1  = 0
    !addr = $0000
    !bank = $800000
endif

!FreeRam = !capespin_direction_freeram


; Default behaviour
; 0 = patched turnarounds, setting flag unpatches turnarounds
; 1 = unpatched turnarounds, setting flag patches turnarounds
!default = 0
; FreeRAM for toggle, cleared on level load
!Toggle = !toggle_capespin_direction_freeram


org $00D076|!bank
    autoclean JML CapeSpinStart                 ; called at the start of the capespin

org $00CF20|!bank
    autoclean JML CapeSpinAnimation             ; called during capespin

freecode

CapeSpinStart:
    LDA !Toggle
if !default
	BNE .patched
else
	BEQ .patched
endif
	LDA.b #$12
	STA !CapespinTimer
	JML $00D07B|!bank

.patched
    LDA $76                                 ; load Mario's face direction

    LDY !CapespinTimer                      ; if already capespinning, load the current flight direction instead of Mario's face direction
    BEQ +
    LDA !FreeRam
    +
    EOR #$01                                ; invert the direction and store it into the freeram address
    STA !FreeRam

    LDA #$12
    STA !CapespinTimer
    JML $00D07B|!bank


CapespinStartframe:
    db $01,$05

CapeSpinAnimation:
    LDA !Toggle
if !default
	BNE .patched
else
	BEQ .patched
endif
	LDA $14
	AND.b #$06
	JML $00CF24|!bank

.patched
    LDA $140D|!addr                         ; if spinjumping, use the global timer for the capespin animation
    BEQ +
    LDA $14
    JMP .StartCapespin
    +

    LDX !FreeRam                            ; otherwise (capespinning with X), use the freeram address instead of the global timer to determine where to start the capespin animation (this will make turnarounds during flight consistent both with the direction and the timing)
    LDA !CapespinTimer
    CLC : ADC.l CapespinStartframe,X
.StartCapespin
    AND #$06
    JML $00CF24|!bank