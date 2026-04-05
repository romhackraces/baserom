incsrc "callisto.asm"
%import_library("freeram.asm")

;===================================================
; RAM-Toggled Score by AmperSam
;===================================================

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

;1 byte of freeram, cleared on level load
!Freeram = !toggle_score_sprites_freeram

org $02ADC9
    autoclean JML ToggleScore

freecode

ToggleScore:
    ; skip if game frozen
	LDA $9D : BEQ .skip_gfx
    ; jump to score gfx routine
	JML $02AE5B|!bank
.skip_gfx
    ; skip if freeram set
    LDA !Freeram : BNE .skip_main
    ; jump to running main routine
    JML $02ADD0|!bank
.skip_main
    JML $02ADD8|!bank ; return
