!freeram    =    $14BE        ; set to some empty address (this works fine by default)

org $00D07B
    autoclean JSL startSpin
    NOP

org $00CF3A
    JSL afterSpin
    NOP
    
freecode
startSpin:
    LDA !freeram
    BMI +
    LDA $76
    ORA #$80
  +
    EOR #$01
    STA !freeram
    LDA #$04
    STA $1DFC
    RTL

afterSpin:
    LDA $14A6
    BEQ .orig
    CMP #$01
    BNE .orig
    LDA !freeram
    STZ !freeram
    AND #$01
    BRA +
  .orig
    LDA $CEA1,x
  +
    STA $76
    RTL