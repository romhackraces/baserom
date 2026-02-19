incsrc "callisto.asm"
%import_library("freeram.asm")

;===============================================
; "RAM-Toggled Spin Jump" by AmperSam
;-----------------------------------------------
; Use a FreeRAM flag to toggle OFF spin jumps,
; all jumps will be forced normal.
;===============================================

; SA-1 Check
if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1 = 0
    !addr = $0000
    !bank = $800000
endif

; FreeRAM flag, 1 byte, clears on level load
!FreeRAM = !toggle_spin_jump_freeram

; Spin jumping hijack
org $00D63C
    autoclean jml EnforcedNormalJump
    NOP #4

; Water jumping hijack
org $00EA84
    autoclean jml SpinOutOfWater
    NOP

; Spring jumping hijack
org $01E695
    autoclean jml SpinOffSprings
    NOP
SpinOffSprings_return:

freecode

EnforcedNormalJump:
    ; check if A pressed
    LDA $18 : BPL .normal_jump
    ; check our FreeRAM flag
    LDA !FreeRAM : BNE .normal_jump

    ; check if holding item
    LDA $148F|!addr : BNE .normal_jump
.spin_jump
    ; set spin jump flag
    LDA #$01 : STA $140D|!addr
    ; continue
    JML $00D649|!bank

.normal_jump
    JML $00D65E|!bank


; Handle spin jumping off of springs
SpinOffSprings:
    LDA !FreeRAM : BNE .normal_jump
.spin_jump
    ; set spin jump flag
    LDA #$01 : STA $140D|!addr
.normal_jump
    JML SpinOffSprings_return


; Handle spin jumping out of water
SpinOutOfWater:
    LDA !FreeRAM : BNE .normal_jump
    ; check if holding item
    LDA $148F|!addr : BNE .normal_jump
.spin_jump
    ; set spin jump flag
    LDA #$01 : STA $140D|!addr
    ; continue
    JML $00EA8D|!bank

.normal_jump
    JML $00EA92|!bank