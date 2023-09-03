;; Extended Sprite cape clipping routine
;; input:
;; $00 = X clipping offsets
;; $01 = Width
;; $02 = Y clipping offsets
;; $03 = Height
;; returns: carry set if contact, clear if not

?main:
    JSR ?.ClippingExt
    JSR ?.MarioInteractVal
    JSL $03B72B|!BankB
    RTL



?.ClippingExt                     ; Subroutine to get clipping values (B) for an extended sprite.
    LDA !extended_x_low,X
    CLC
    ADC $00
    STA $04
    LDA !extended_x_high,X
    ADC #$00
    STA $0A
    LDA $01
    STA $06
    LDA !extended_y_low,X
    CLC
    ADC $02
    STA $05
    LDA !extended_y_high,X
    ADC #$00
    STA $0B
    LDA $03
    STA $07
    RTS

?.MarioInteractVal               ; Routine to get interaction values for Mario's cape and net punches. Takes the place of "sprite B".
    LDA.w $13E9|!addr
    SEC
    SBC.b #$02
    STA $00                     ; Get X displacement.
    LDA.w $13EA|!addr
    SBC.b #$00
    STA $08
    LDA.b #$14                  ; Width for Mario's capesin and net punch.
    STA $02
    LDA.w $13EB|!addr
    STA $01                     ; Get Y displacement.
    LDA.w $13EC|!addr
    STA $09
    LDA.b #$10                  ; Height for Mario's capesin and net punch.
    STA $03
    RTS