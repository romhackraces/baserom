;===================================================================================================
;Red Stem Piranha Plants on Extra Bit + Stem Fix, by Koopster
;
;With this patch, the classic and upside down piranha plant stems will be red and they will ignore
;player proximity if the extra bit is set (to 1). Naturally, the classic piranha plant's stem bug
;will be fixed and they will be normally green.
;
;NOTE: The extra bit functionality requires PIXI to be installed in your ROM to function.
;===================================================================================================

;You may remap the stems of the classic and upside down piranhas with the defines below.
;They must use the same tile. This could be circumvented with extra code but try to work with this.

	!stem_tile = $CE

	!classic_stem_page = 0
	!ud_stem_page = 0

;===================================================================================================
;DO NOT MODIFY
;===================================================================================================

;=================================================
;sa1 blabber
;=================================================

!addr = $0000
!bank = $800000
!9E = $9E
!7FAB10 = $7FAB10

if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
	!9E = $3200
	!7FAB10 = $6040
endif

;=================================================
;hijacks
;=================================================

;stem color and page setting

org $018E8D
	autoclean JML stem_fix
	NOP
stem_return:
	ORA $00
	STA $030B|!addr,y	;here for restoration from the old piranha fix patch (hopefully it works)

;proximity hack

org $018ECC
	autoclean JML red_plants

;stem tile remaps

org $019BBE : db !stem_tile
org $019BC0 : db !stem_tile

;=================================================
;free zone
;=================================================

freecode

;stem fix

properties:
	db $0A+!ud_stem_page,$0A+!classic_stem_page,$08+!ud_stem_page,$08+!classic_stem_page

stem_fix:
	LDA !9E,x
	STA $01
	LDA !7FAB10,x
	AND #$04
	BEQ +
	LSR					;+2 index if red
+	TAX					;x clobbered by table index
	LDA $01
	CMP #$1A
	BNE +
	DEY #4				;classic piranha fix
	INX					;+1 index if classic
+	LDA.l properties,x	;just one long is fine
	STA $00				;store the properties we want
	LDX $15E9|!addr		;x restored
	LDA $030B|!addr,y
	AND #$F1
	JML stem_return

freedata

;red stem plants

red_plants:
	STA $00
	BNE .ignore
	LDA !7FAB10,x		;\
	AND #$04			;|red skips over proximity check
	BNE .ignore			;/
	JML $018ED0|!bank
.ignore
	JML $018EE1|!bank