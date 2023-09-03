
; Gets the OAM index to be used, deletes when off screen, etc.

?main:
    LDA.l $02A153|!BankB,x
    TAY
   
?.noIndex
    LDA !extended_x_speed,x
    AND #$80
    EOR #$80
    LSR
    STA $00
    LDA !extended_x_low,x
    SEC
    SBC $1A
    STA $01
    LDA !extended_x_high,x
    SBC $1B
    BNE ?.erasespr
    LDA !extended_y_low,x
    SEC
    SBC $1C
    STA $02
    LDA !extended_y_high,x
    SBC $1D
    BNE ?.vert_offscreen
    LDA $02
    CMP #$F0
    BCS ?.erasespr
    RTL
?.vert_offscreen
    CMP #$FF
    BNE ?.erasespr ; erase: not within 1 screen above top of screen
    LDA $02
    CMP #$C0
    BCC ?.erasespr
    CMP #$E0
    BCC ?.hidespr
    RTL
?.erasespr
    STZ !extended_num,x    ; delete sprite.
?.hidespr
    LDA #$F0    ; prevent OAM flicker
    STA $02
    RTL
