; Routine to update the Y position of a spinning coin sprite.
; 
; Input:
;   N/A
; 
; Output:
;   N/A


?main:
    LDA !spinning_coin_y_speed,x
    ASL #4
    CLC 
    ADC !spinning_coin_y_bits,x
    STA !spinning_coin_y_bits,x
    PHP 
    LDY #$00
    LDA !spinning_coin_y_speed,x
    LSR #4
    CMP #$08
    BCC ?.pos
    ORA #$F0
    DEY
?.pos
    PLP
    ADC !spinning_coin_y_low,x
    STA !spinning_coin_y_low,x
    TYA 
    ADC !spinning_coin_y_high,x
    STA !spinning_coin_y_high,x
    RTL