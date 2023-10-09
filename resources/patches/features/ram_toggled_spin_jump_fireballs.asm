incsrc "../../../shared/freeram.asm"

;=============================================;
; RAM-Toggled Spin Jump Fireballs by AmperSam ;
;=============================================;

; Instead of the tweak to disable this globally, this patch enables toggling that via FreeRAM instead.

; Change this depending on if you want spin jump fireball to be enabled or disabled by default.
!default = 1
; 0 = disable by default, enable it with RAM
; 1 = enable by default, disable it with RAM

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

!Freeram = !toggle_spinjump_fireball_freeram ;Set this to freeram

; check flag macro
macro check_flag()
    LDA !Freeram
if !default
    BEQ .enable
else
    BNE .enable
endif
endmacro

; Hijack
org $00D090
	autoclean JML ToggledFireballs
    NOP

freecode

ToggledFireballs:
    LDA $140D|!addr    ; original code
    BEQ .disable       ; check if spin jumping

    %check_flag()
.disable
	JML $00D0AD|!bank
.enable
	JML $00D095|!bank
