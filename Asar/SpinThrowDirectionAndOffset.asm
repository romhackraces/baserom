;==============================================================================
;
; Spin Throw Direction and Offset, by AmazingChest
;
; Throw items in a consistent direction while spinning, with options to control
; their release offset for both throws and up-tosses.
;
; Modified from PangaeaPanga's ThrowDirection patch used in the RHR baserom.
;
;==============================================================================

!OffsetThrow   = 2      ; Controls sprite's initial horizontal position when thrown while holding left or right.
                        ;   0 = Vanilla (random)
                        ;   1 = Centered on the player
                        ;   2 = Offset in the direction pressed
!CenterTossUp  = 1      ; Centers sprite's initial horizontal position when tossed up.
                        ;   0 = Vanilla (random)
                        ;   1 = Centered on the player
!ReverseOffset = 0      ; Reverses which side the sprite is offset to when !OffsetThrow is set to 2.
                        ;   0 = Normal
                        ;   1 = Reversed

org $01A068
  autoclean JSL TossUpCenter

org $01A079
  autoclean JSL ThrowOffset

org $01A087
  autoclean JSL ThrowDirection
  NOP

freecode

TossUpCenter:
if !CenterTossUp
  LDA $140D             ; \ Check if player is spinjumping or cape twirling.
  ORA $14A6             ; |
  BEQ .restore          ; /
  LDA $D1               ; \
  STA $E4,x             ; | Center the sprite on the player.
  LDA $D2               ; |
  STA $14E0,x           ; /
endif

  .restore
    JSL $01AB6F         ; Restore the original code.
    RTL


ThrowOffset:
if !OffsetThrow
  LDA $140D             ; \ Check if player is spinjumping or cape twirling.
  ORA $14A6             ; |
  BEQ .restore          ; /
  TXY
  LDX #$00
  LDA $15               ; \
  AND #$01              ; | Check to see if "right" is pressed.
  if !OffsetThrow == 1  ; |
    BNE .offsetSprite   ; |
  elseif !ReverseOffset ; |
    BNE .offsetLeft     ; |
  else                  ; |
    BNE .offsetRight    ; /
  endif
    LDA $15             ; \
    AND #$02            ; | Check to see if "left" is pressed.
  if !OffsetThrow == 1  ; |
    BNE .offsetSprite   ; |
  elseif !ReverseOffset ; |
    BNE .offsetRight    ; |
  else                  ; |
    BNE .offsetLeft     ; /
  endif
  TYX
  BRA .restore

  .offsetLeft
    INX

  .offsetRight
    INX

  .offsetSprite
    LDA $D1             ; \
    CLC                 ; | Offset sprite to the right or left of player.
    ADC.l OFFSET_LO,x   ; |
    STA.w $E4,y         ; |
    LDA $D2             ; |
    ADC.l OFFSET_HI,x   ; |
    STA $14E0,y         ; /
    TYX
endif

  .restore
    JSL $01AB6F         ; Restore the original code.
    RTL

OFFSET_LO:
  db $00,$0B,$F5

OFFSET_HI:
  db $00,$00,$FF


ThrowDirection:
  LDA $140D             ; \ Check if player is spinjumping or cape twirling.
  ORA $14A6             ; |
  BEQ .restore          ; /
  LDA $15               ; \
  AND #$01              ; | Check to see if "right" is pressed.
  BNE .throwRight       ; /
  LDA $15               ; \
  AND #$02              ; | Check to see if "left" is pressed.
  BNE .throwLeft        ; /

  .restore
    LDY $76             ; \ Restore the original code.
    LDA $187A           ; /
    RTL

  .throwRight
    LDY #$01            ; \ Throw the sprite right.
    LDA $187A           ; |
    RTL                 ; /

  .throwLeft
    LDY #$00            ; \ Throw the sprite left.
    LDA $187A           ; |
    RTL                 ; /
