;; extended sprite -> mario interaction.

?main:
    LDA !extended_x_low,x
    CLC
    ADC #$03
    STA $04
    LDA !extended_x_high,x
    ADC #$00
    STA $0A
    LDA #$0A
    STA $06
    STA $07
    LDA !extended_y_low,x
    CLC
    ADC #$03
    STA $05
    LDA !extended_y_high,x
    ADC #$00
    STA $0B
    JSL $03B664|!BankB
    JSL $03B72B|!BankB
    BCC ?.skip
    PHB
    LDA.b #($02|!BankB>>16)
    PHA
    PLB
    PHK
    PEA.w ?.return-1
    PEA.w $B888
    JML $02A469|!BankB
?.return
    PLB 
?.skip
    RTL
