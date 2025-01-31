incsrc "callisto.asm"
%import_library("freeram.asm")

;
; Line-guided Rope Fixes by AmperSam (rework of Rope Fix patch by Alcaro)
;
; Fixes bug where Mario will remain in climb state if pushed off a line-guided rope by a wall.
; This fix has an optional FreeRAM toggle to disable this on a per-level basis.
;
; Also fixes a bug where Mario can be dragged along by around after coming in contact with the ground.
; NOT toggled by the FreeRAM flag (glitch has no practical use)
;

; Set to 1 if you would like the air climb fix to be RAM-toggleable
!is_toggleable = 1
; FreeRAM for toggle. 1 byte, cleared on level load
!FreeRAM_Toggle = !toggle_rope_glitch_freeram

; check if the rom is sa-1
if read1($00FFD5) == $23
    sa1rom
    !addr = $6000
    !bank = $000000
    !D8 = $3216
    !163E = $33FA
else
    lorom
    !addr = $0000
    !bank = $800000
    !D8 = $D8
    !163E = $163E
endif

; Fix ropes leaving Mario in "air climb" state if pushed off by a wall
; This can be toggled with FreeRAM
org $01D9E1
    autoclean JSL WallAirClimbFix

; Fix Mario clinging to ropes after coming in contact with the ground
org $01DA17
    autoclean JSL RopeClingFix
    NOP

freecode


WallAirClimbFix:

.check_rope_y_pos
    SBC !D8,x                       ;\ check rope y position
    EOR #$FF                        ;/
    PHA                             ; push accumulator

if !is_toggleable                   ; include toggle check if toggleable option is set
.check_toggle
    LDA !FreeRAM_Toggle             ;\ check FreeRAM toggle
    BNE .climb                      ;/ ...skip to setting climb state
endif

.no_climb
    LDA $77 : AND #$03 : BEQ .ret   ; check if Mario is blocked to the side
    STZ !163E,x                     ; clear flag for being in contact with the rope climb state
    STZ $18BE|!addr                 ; clear "on rope" flag
    BRA .ret

if !is_toggleable                   ; include climb routine if toggleable option is set
.climb
    LDA $18BE|!addr : CMP #$08      ;\ check if Mario is in on a rope
    BNE .ret                        ;/
    LDA #$01 : STA $18BE|!addr      ; set "on rope" flag to induce climbing
endif

.ret
    PLA                             ; pull accumulator
    RTL                             ; return


RopeClingFix:

.check_if_blocked
    LDA $77 : AND #$04              ;\ check if Mario is blocked from below
    BNE .remove_cling               ;/ ...if true make Mario not clingy
    LDA #$03 : STA !163E,x          ; otherwise set flag for being in contact with the rope
    RTL
.remove_cling
    STZ !163E,x                     ; clear flag for being in contact with the rope
    STZ $18BE|!addr                 ; clear "on-rope" flag for good measure
    RTL
