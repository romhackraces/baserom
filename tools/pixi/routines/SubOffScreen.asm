;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sub_Off_Screen_XA
; input A for which sub_off_screen to use (usually 0). Only last 3 bits are used.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

?main:
    AND #$07
    ASL A
    STA $03

?.start  
    LDA !15A0,x             ; if sprite is on screen, accumulator = 0 
    ORA !186C,x             ; return
    BNE ?.check_sub_off
    RTL
    
?.check_sub_off
    PHB
    PHK 
    PLB
    LDA $5B                 ; goto .vert_level if vertical level
    AND #$01
    BNE ?.vert_level
    LDA !D8,x
    
if !EXLEVEL == 1
    PHA
    LDA !14D4,x             ; taken from the exlevel patch
    XBA
    TAX
    PLA                     ; Get 16-bit Y position of sprite
    REP #$20
;calc screen size
    CMP.w $13D7|!Base2      ; If it's beyond level boundaries...
    BPL ?.check_erase 
    SEC                     ; ... more than 224 pixels *after* screen boundary...
    SBC $1C 
; y range max
    CMP.w $0BF2|!Base2
    BPL ?.check_erase
    SEC                     ; ... or more than 224 pixels *before* screen boundary...
; y range min
    SBC.w $0BF0|!Base2 
    EOR.w #$8000  
?.check_erase               ;  We will return with N clear which means delete the sprite!
    SEP #$20    
    PHP
    TXA
    XBA
    LDX $15E9|!Base2
    PLP

else

;not exlevel codes
    CLC
    ADC #$50                ; if the sprite has gone off the bottom of the level...
    LDA !14D4,x             ; (if adding 0x50 to the sprite y position would make the high byte >= 2)
    ADC #$00
    CMP #$02

endif

    BPL ?.erase              ;  ...erase the sprite
    LDA !167A,x             ; if "process offscreen" flag is set, return
    AND #$04
    BNE ?.return
    LDA $13
    AND #$01
    ORA $03
    STA $01
    TAY
    LDA $1A
    CLC
    ADC ?.spr_t14,y
    ROL $00
    CMP !E4,x
    PHP
    LDA $1B
    LSR $00
    ADC ?.spr_t15,y
    PLP
    SBC !14E0,x
    STA $00
    LSR $01
    BCC ?.spr_l31
    EOR #$80
    STA $00
?.spr_l31
    LDA $00
    BPL ?.return
?.erase
    LDA !14C8,x             ; \ if sprite status < 8, permanently erase sprite
    CMP #$08                ; |
    BCC ?.kill               ; /
    LDY !161A,x
    CPY #$FF
    BEQ ?.kill

    PHX                     ;BlindEdit: houston we have a problem (preserve X)
    PHY                     ;preserve Y
    TYX                     ;transfer Y to X
    LDA #$00 
if !Disable255SpritesPerLevel
    STA !1938,x
else
    STA.L !7FAF00,x         ;$41A800 in SA-1 ROM, so it can't be Y indexed!
endif
    PLY                     ;restore Y
    PLX                     ;BlindEdit: alright back to the planning phase (restore X)

?.kill    
    STZ !14C8,x             ; erase sprite
?.return
    PLB
    RTL                     ; return

?.vert_level
    LDA !167A,x             ; \ if "process offscreen" flag is set, return
    AND #$04                ; |
    BNE ?.return             ; /
    LDA $13                 ; \
    LSR A                   ; | 
    BCS ?.return             ; /
    LDA !E4,x               ; \ 
    CMP #$00                ;  | if the sprite has gone off the side of the level...
    LDA !14E0,x             ;  |
    SBC #$00                ;  |
    CMP #$02                ;  |
    BCS ?.erase              ; /  ...erase the sprite
    LDA $13
    LSR A
    AND #$01
    STA $01
    TAY 
    LDA $1C
    CLC
    ADC ?.spr_t12,y
    ROL $00
    CMP !D8,x
    PHP
    LDA $1D
    LSR $00
    ADC ?.spr_t13,y
    PLP
    SBC !14D4,x
    STA $00
    LDY $01
    BEQ ?.spr_l38
    EOR #$80
    STA $00
?.spr_l38
    LDA $00
    BPL ?.return
    BMI ?.erase

?.spr_t12
    db $40,$B0
?.spr_t13
    db $01,$FF
?.spr_t14
    db $30,$C0,$A0,$C0,$A0,$F0,$60,$90        ;bank 1 sizes
    db $30,$C0,$A0,$80,$A0,$40,$60,$B0        ;bank 3 sizes
?.spr_t15
    db $01,$FF,$01,$FF,$01,$FF,$01,$FF        ;bank 1 sizes
    db $01,$FF,$01,$FF,$01,$00,$01,$FF        ;bank 3 sizes