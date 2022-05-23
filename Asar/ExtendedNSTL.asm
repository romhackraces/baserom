;===================================================================================================================================
; Extended No Sprite Tile Limits v3.1, by imamelia, improved by DiscoTheBat, extra code by Roy, additional fixes by KevinM
;
; This is similar to edit1754's famous No Sprite Tile Limits patch, except that
; this one is for sprites using the other half of OAM. That is, the patch makes it
; so that sprite tiles using OAM addresses $02xx (extended sprites, cluster sprites,
; minor extended sprites, block bounce sprites, smoke images, spinning coins
; from blocks, and Yoshi's tongue), use dynamic OAM indexes instead of hardcoded
; ones, just like normal sprites do when the normal No Sprite Tile Limits patch is
; used. This drastically reduces the risk of any sprite graphics glitching up because
; of an OAM conflict.
; (It also means that Sumo Brothers work properly with the original NSTL patch and sprite memory 10; they didn't before.)
;
;===================================================================================================================================
!FindFree = $04A1FC			; location of the jump to the OAM slot-finding routine (in case you want to use it for your own sprites)
!Default = $00				; the slot to overwrite when all are full
!RAM_ExtOAMIndex = $1869	; the free RAM address to use for the OAM index (must be $0000-$1FFF)
;===================================================================================================================================
	!base = $0000
	!base2 = $800000

if read1($00FFD5) == $23
	sa1rom
	!base = $6000
	!base2 = $000000
	!RAM_ExtOAMIndex #= !RAM_ExtOAMIndex|!base
endif

macro CheckSlot(offset)
LDA.w $0201|!base+<offset>
CMP.b #$F0
BNE ?NotFound
LDA.b #<offset>
JMP FoundSlot
?NotFound:
endmacro

macro Check4Slots(offset)
%CheckSlot(<offset>)
%CheckSlot(<offset>+$04)
%CheckSlot(<offset>+$08)
%CheckSlot(<offset>+$0C)
endmacro

org !FindFree|!base2				; find free oam routine
	autoclean JML GetExtOAMIndex	;
org $01F466							; Yoshi's tongue
	autoclean JML YoshiTongueOAM	;
org $02904D							; bounce blocks
	autoclean JML BounceBlockOAM	;
	NOP								;
org $02922D							;
	LDY !RAM_ExtOAMIndex			;
org $028B6C							; minor extended sprites
	autoclean JML MinorExtOAM		;
	NOP								;
org $028C6E							;
	LDY !RAM_ExtOAMIndex			;
org $028CFF							;
	LDY !RAM_ExtOAMIndex			;
org $028D8B							;
	LDY !RAM_ExtOAMIndex			;
org $028E20							;
	LDY !RAM_ExtOAMIndex			;
org $028E94							;
	LDY !RAM_ExtOAMIndex			;
org $028EE1							;
	LDY !RAM_ExtOAMIndex			;
org $028F4D							;
	LDY !RAM_ExtOAMIndex			;
org $028FDD							;
	LDY !RAM_ExtOAMIndex			;
org $0299D7							; spinning coins
	autoclean JML SpinningCoinOAM	;
	NOP								;
org $029A3D							;
	LDY !RAM_ExtOAMIndex			;
org $0296C3							; smoke images
	autoclean JML SmokeImageOAM		;
org $02974A							;
	LDY !RAM_ExtOAMIndex			;
org $02996C							;
	LDY !RAM_ExtOAMIndex			;
org $02ADBD							; score sprites
	autoclean JML ScoreSpriteOAM	;
org $02AE9B							;
	LDY !RAM_ExtOAMIndex			;
org $00907A							; item box item
	db $FC							; just move this one to the end
org $029B16							; extended sprites
	autoclean JML ExtendedSprOAM	;
	NOP								;
org $029B51							;
	LDY !RAM_ExtOAMIndex			;
org $029C41							;
	LDY !RAM_ExtOAMIndex			;
org $029C8B							;
	LDY !RAM_ExtOAMIndex			;
org $029D10							;
	LDY !RAM_ExtOAMIndex			;
org $029DDF							;
	LDY !RAM_ExtOAMIndex			;
org $029E5F							;
	LDY !RAM_ExtOAMIndex			;
org $029E9D							;
	LDY !RAM_ExtOAMIndex			;
org $029F46							;
	LDY !RAM_ExtOAMIndex			;
org $029F76							;
	LDY !RAM_ExtOAMIndex			;
org $02A180							;
	LDY !RAM_ExtOAMIndex			;
org $02A1A4							;
	LDY !RAM_ExtOAMIndex			;
org $02A235							;
	LDY !RAM_ExtOAMIndex			;
org $02A287							;
	LDY !RAM_ExtOAMIndex			;
org $02A31A							;
	LDY !RAM_ExtOAMIndex			;
org $02A362							;
	LDY !RAM_ExtOAMIndex			;
org $02FCCD							;
	LDA !RAM_ExtOAMIndex			;
org $02FCD9							;
	LDY !RAM_ExtOAMIndex			;
org $02FD4A							;
	LDY !RAM_ExtOAMIndex			;
org $02FD98							;
	LDY !RAM_ExtOAMIndex			;
org $02FA2B							;
	LDY !RAM_ExtOAMIndex			;
org $02FE48							;
	LDY !RAM_ExtOAMIndex			;
org $02DF6E							; patch Sumo Brother flame GFX routine
	NOP								; also, it fixes a couple of glitches regarding
org $02F9CF							; position of flames and "hitbox"
	autoclean JML FixSumoFlame1		;
org $02F937							;
	autoclean JML FixSumoFlame2		;
org $02FCD6							;
	dw $0420|!base					; use the first set of tiles
org $02FCDF							;
	dw $0201|!base					;
org $02FD54							;
	dw $0200|!base					;
org $02FD5D							;
	dw $0201|!base					;
org $02FD74							;
	dw $0202|!base					;
org $02FD86							;
	dw $0203|!base					;
org $02FD8F							;
	dw $0420|!base					;
org $02FDAF							;
	dw $0202|!base					;
org $02FDB4							;
	dw $0203|!base					;
org $02FA35							;
	dw $0200|!base					;
org $02FA3E							;
	dw $0201|!base					;
org $02FA4C							;
	dw $0202|!base					;
org $02FA52							;
	dw $0203|!base					;
org $02FA5C							;
	dw $0420|!base					;
org $02FA60							;
	dw $0200|!base					;

; Mario's fireballs
org $02A03B
	ldy !RAM_ExtOAMIndex

; Smoke puff generated by Mario's fireballs
org $02A369
	ldy !RAM_ExtOAMIndex

; Contact GFX
org $0297B2
	autoclean jml FixContactGFX

; Cluster sprites
org $02F812				; Hijack here so it doesn't conflict with PIXI
	jmp ClusterSpriteOAM

; Empty area in bank 2 ($02B5EC to $02B60E is used by PIXI)
org $02B61C
ClusterSpriteOAM:
	stx $15E9|!base		; Restore original code
	lda $1892|!base,x
	beq .Return
	pha
	autoclean jsl GetExtOAMIndex
	pla
	jmp $F815
.Return
	jmp $F81D

warnpc $02B630

freecode

GetExtOAMIndex:
	%Check4Slots($00)
	%Check4Slots($10)
	%Check4Slots($20)
	%Check4Slots($30)
	%Check4Slots($40)
	%Check4Slots($50)
	%Check4Slots($60)
	%Check4Slots($70)
	%Check4Slots($80)
	%Check4Slots($90)
	%Check4Slots($A0)
	%Check4Slots($B0)
	%Check4Slots($C0)
	%Check4Slots($D0)
	%Check4Slots($E0)
	%Check4Slots($F0)
	LDA #!Default
FoundSlot:
	STA !RAM_ExtOAMIndex
	RTL

YoshiTongueOAM:
	STA $06
	JSL GetExtOAMIndex
	LDY !RAM_ExtOAMIndex
	JML $01F46A|!base2

BounceBlockOAM:
	LDA $1699|!base,x
	BEQ .Return
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $029052|!base2
.Return
	JML $02904C|!base2

MinorExtOAM:
	BEQ .Return
	STX $1698|!base
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $028B71|!base2
.Return
	JML $028B74|!base2

SpinningCoinOAM:
	LDA $17D0|!base,x
	BEQ .Return
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $0299DC|!base2
.Return
	JML $0299DF|!base2

SmokeImageOAM:
	BEQ .Return
	AND #$7F
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $0296C7|!base2
.Return
	JML $0296D7|!base2

ScoreSpriteOAM:
	LDA $16E1|!base,x
	BEQ .Return
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $02ADC2|!base2
.Return
	JML $02ADC5|!base2

ExtendedSprOAM:
	LDA $170B|!base,x
	BEQ .Return
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $029B1B|!base2
.Return
	JML $029B15|!base2

FixSumoFlame1:
	LDA $185E|!base
	AND #$03
	TAY
	LDA $1E02|!base,x
	JML $02F9D6|!base2

FixSumoFlame2:
	LDA $1E16|!base,x
	SEC
	SBC $1A
	STA $00
	LDA $1E3E|!base,x
	SBC $1B
	BNE .End
	LDA $1E02|!base,x
	SEC
	SBC $1C
	STA $01
	LDY #$01
-	LDA $1E02|!base,x
	CLC
	ADC #$04
	CLC
	ADC $D374,y
	PHP
	CMP $1C
	ROL $02
	PLP
	LDA.w $1E2A|!base,x
	ADC #$00
	LSR $02
	SBC $1D
	BNE .End
	DEY
	BPL -
	JSL GetExtOAMIndex
	LDY !RAM_ExtOAMIndex
	PHX
	LDX #$01
.Loop
	PHX
	LDA $00
	STA $0200|!base,y
	TXA
	ORA $185E|!base
	TAX
	LDA $02F8FC,x
	BMI .Skip
	CLC
	ADC $01
	STA $0201|!base,y
	LDA $02F904,x
	STA $0202|!base,y
	LDA $14
	AND #$04
	ASL #4
	ORA $64
	ORA #$05
	STA $0203|!base,y 
	PHY
	TYA
	LSR #2
	TAY
	LDA #$02
	STA $0420|!base,y
	PLY
.Skip
	PLX
	INY #4
	DEX
	BPL .Loop
	PLX
.End
	PLX
	JML $02F93B|!base2

FixContactGFX:
	jsl GetExtOAMIndex
	ldy !RAM_ExtOAMIndex
	lda $17C8|!base,x
	jml $0297B7|!base2
