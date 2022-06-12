; Capespin Direction Consistency - patch by Katun24
; This patch makes it so a capespin always results in Mario turning around, and makes the face direction consistent during the capespin animation.

!FreeRam = $140B

org $00D076
autoclean JML CapeSpinStart                 ; called at the start of the capespin

org $00CF20
autoclean JML CapeSpinAnimation             ; called during capespin

freecode


CapeSpinStart:
    LDA $76                                 ; load Mario's face direction
    
    LDY $14A6                               ; if already capespinning, load the current flight direction instead of Mario's face direction
    BEQ +
    LDA !FreeRam
    +
    EOR #$01                                ; invert the direction and store it into the freeram address
    STA !FreeRam
    
    LDA #$12
    STA $14A6
    JML $00D07B


CapespinStartframe:
    db $01,$05

CapeSpinAnimation:
    LDA $140D                               ; if spinjumping, use the global timer for the capespin animation
    BEQ +
    LDA $14
    JMP .StartCapespin
    +
    
    LDX !FreeRam                               ; otherwise (capespinning with X), use the freeram address instead of the global timer to determine where to start the capespin animation (this will make turnarounds during flight consistent both with the direction and the timing)
    LDA $14A6
    CLC : ADC.l CapespinStartframe,X
.StartCapespin
    AND #$06
    JML $00CF24