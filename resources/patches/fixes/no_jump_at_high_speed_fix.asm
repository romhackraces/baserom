; No Jump at High Speed Fix
; based on "Player X Speed" Fix by GreenHammerBro and tjb

; Fixes when Mario is unable to jump when being pushed very fast either from an autoscroll or other means.

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


org $00D663
    autoclean JML FixNoJump
    nop #1

freecode

FixNoJump:
    LDA.l JumpYSpeeds,x     ;>New table
    STA $7D             	;>And done.
    JML $00D668|!bank


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; How X speed affects your jump. This table contains a list of values to be used on how high mario
; jumps. Valid values are #$80~#$FF. The lower the value, the higher mario jumps.
;
; Table format:
;   db $xx,$yy
;
; $xx is the normal jump speed.
; $yy is the spin jump speed.
;
; As you go down the list, that value is used for faster speeds (so the faster you run, the lower down the
; list it'll uses). Here's the formula:

;   LDA $7B     ;\X speed absolute value (if negative, flip to positive to find distance from zero)
;   BPL +       ;|
;   EOR #$FF    ;|
;   INC A       ;|
;   +           ;/
;   LSR #2      ;>Divide by 4 (76543210 turns into --765432)
;   AND #$FE    ;>Clear bit 1 (--76543-)
;   TAX         ;>Transfer to X
;   LDA $140D   ;\If spinjumping, INX to make bit 0 set to use spin jump values
;   BEQ +       ;|
;   INX         ;/
;   +
;   LDA $00D2BD,x   ;>This table location will not be used if you patch this.
;   STA $7D     ;>And set Y speed.
;
; The maximum index is #$20 (if you going a speed of #$80).

JumpYSpeeds:    ; X speed
    db $B0,$B6  ; ±00-07 speed
    db $AE,$B4  ; ±08-0F speed
    db $AB,$B2  ; ±10-17 speed
    db $A9,$B0  ; ±18-1F speed
    db $A6,$AE  ; ±20-27 speed - running speed
    db $A4,$AB  ; ±28-2F speed - (possible p-speed/flight oscillation if oscillation is unpatched)
    db $A1,$A9  ; ±30-37 speed - p-speed/flight speed
    db $9F,$A6  ; ±38-3F speed
    db $9C,$A3  ; ±40-47 speed - diagonal pipe speed
    db $9A,$A1  ; ±48-4F speed
    db $97,$9F  ; ±50-57 speed
    db $95,$9C  ; ±58-5F speed
    db $92,$9A  ; ±60-67 speed
    db $90,$98  ; ±68-6F speed
    db $8E,$96  ; ±70-77 speed
    db $8B,$93  ; ±78-7F speed
    db $89,$91  ; -80 speed