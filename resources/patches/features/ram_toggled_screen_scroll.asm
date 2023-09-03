incsrc "../../../shared/freeram.asm"

;RAM specific LR scroll disable
;Highly based off of Smallhacker's L/R Hook patch, not compatible with it though
;By: Chdata/Fakescaper

if read1($00FFD5) == $23
	sa1rom
endif

!Freeram = !toggle_lr_scroll_freeram ;Set this to freeram

org $00CDF6
	autoclean JML LRcheck

freecode
LRcheck:
	LDA !Freeram
	BEQ DisableLR
	LDA $17
	AND.b #$CF
	JML $00CDFA

DisableLR:
	JML $00CE49