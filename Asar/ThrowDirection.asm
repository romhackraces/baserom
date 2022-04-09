!OffsetThrow   = 1      ; Set to 1 to offset a carried sprite in the direction pressed when thrown while spinjumping. Set to 0 for vanilla behavior.
!ReverseOffset = 0      ; Switch which side the sprite is offset to (for some reason...)
!CenterTossUp  = 1      ; Set to 1 to center a carried sprite on mario when tossed up while spinjumping. Set to 0 for vanilla behavior.

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
  if !ReverseOffset     ; |
    BNE .offsetLeft     ; |
  else                  ; |
    BNE .offsetSprite   ; /
  endif
    LDA $15             ; \
    AND #$02            ; | Check to see if "left" is pressed.
  if !ReverseOffset     ; |
    BNE .offsetSprite   ; |
  else                  ; |
    BNE .offsetLeft     ; /
  endif
  TYX
  BRA .restore

  .offsetLeft
    INX

  .offsetSprite
    LDA $D1             ; \
    CLC                 ; | Offset sprite to the right or left of player.
    ADC.l OFFSET_LO,x   ; | 
    STA $E4,y           ; |
    LDA $D2             ; |
    ADC.l OFFSET_HI,x   ; |
    STA $14E0,y         ; /
    TYX
endif

  .restore
    JSL $01AB6F         ; Restore the original code.
    RTL

OFFSET_LO:
  db $0B,$F5

OFFSET_HI:
  db $00,$FF


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