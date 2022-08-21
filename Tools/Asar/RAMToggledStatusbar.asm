; RAM-toggled Status Bar (& IRQ)
; by KevinM
;
; This patch allows you to enable/disable the status bar on a per-level basis.
; This will also affect the IRQ, so when it's disabled it allows the usage of full screen layer 3 BGs
; and of certain HDMA effects (like parallax) that usually conflict with the status bar.
; Note that the IRQ won't be actually disabled in vanilla mode 7 boss rooms, since
; it causes the mode 7 tilemap to disappear. The status bar will not show up as intended, though.

; 0 = disable the status bar by default, enable it with the RAM
; 1 = enable the status bar by default, disable it with the RAM
; Choose this depending on if you want it to be enabled or disabled more often.
!default = 1

; 1 byte of freeram. Must be reset on level load.
; To toggle the status bar, set this to 1 in UberASM level "load:" like this:
; load:
;   lda #$01
;   sta $79     ; Change this if you change !flag
;   rtl
; Doing so will enable or disable the status bar depending on !default.
!flag = $79

; Don't change from here!
if read1($00FFD5) == $23
    sa1rom
    !sa1  = 1
    !addr = $6000
    !bank = $000000
else
    lorom
    !sa1  = 0
    !addr = $0000
    !bank = $800000
endif

macro check_flag()
    lda !flag
if !default
    beq .enable
else
    bne .enable
endif
endmacro

; Status bar tilemap transfer from RAM
org $008DAC
    autoclean jml check_flag_1

; Status bar IRQ setup
org $008294
    autoclean jml check_flag_2

; Status bar tilemap transfer from ROM
org $008CFF
    autoclean jml check_flag_3

freecode

check_flag_1:
    %check_flag()
.disable:
    jml $008DE6|!bank
.enable:
    stz $2115
    lda #$42
    jml $008DB1|!bank

check_flag_2:
    ; Always enable the IRQ in mode 7 boss rooms.
    lda $0D9B|!addr : bmi .enable
    %check_flag()
.disable:
if !sa1
    ldx #$81
else
    lda #$81 : sta $4200
endif
    lda $22 : sta $2111
    lda $23 : sta $2111
    lda $24 : sta $2112
    lda $25 : sta $2112
    lda $3E : sta $2105
    lda $40 : sta $2131
    jml $0082B0|!bank
.enable:
    lda $4211
    sty $4209
    jml $00829A|!bank

check_flag_3:
    %check_flag()
.disable:
    jml $008D8F|!bank
.enable:
    lda #$80 : sta $2115
    jml $008D04|!bank
