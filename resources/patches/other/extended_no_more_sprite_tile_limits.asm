incsrc "../../../shared/freeram.asm"

;===================================================================================================================================
; Extended No Sprite Tile Limits v4.0
;  by imamelia, improved by DiscoTheBat, extra code by Roy and worldpeace
;  + recent fixes and PIXI compatibility by Kevin (I guess I maintain this patch now :cry:)
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
; Now also fully compatible with PIXI v1.40. Patching this over v3.1/v3.2 should work fine.
;===================================================================================================================================
!FindFree = $04A1FC			; location of the jump to the OAM slot-finding routine (in case you want to use it for your own sprites)
!Default = $00				; the slot to overwrite when all are full
!RAM_ExtOAMIndex = !extended_nstl_freeram	; the free RAM address to use for the OAM index (must be $0000-$1FFF)
;===================================================================================================================================

if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!bank = $000000
	; !RAM_ExtOAMIndex #= !RAM_ExtOAMIndex|!addr
else
	lorom
	!addr = $0000
	!bank = $800000
endif

macro CheckSlot(offset)
	LDA.w $0201|!addr+<offset>
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

; Restore original BG candle flames OAM if repatching over previous version
; This fixes them going in front of normal sprites and Mario
if read1($02FA2B) == $AC ; Detect LDY.w $xxxx from previous version
	org $02FA2B
		ldy.w $02FA0A,x
	org $02FA35
		dw $0300|!addr
	org $02FA3E
		dw $0301|!addr
	org $02FA4C
		dw $0302|!addr
	org $02FA52
		dw $0303|!addr
	org $02FA5C
		dw $0460|!addr
	org $02FA60
		dw $0300|!addr
	; Apparently they forgot to remap the OAM tables used at $02FA66-$02FA82
	; which also made the flames not properly loop around the screen
endif

; Restore old minor extended sprite hijack
if read1($028B6C) == $5C && read1($028B6C+4) == $EA
	org $028B6C
		beq $06
		stx $1698|!addr
endif

; Restore old spinning coin sprite hijack
if read1($0299D7) == $5C && read1($0299D7+4) == $EA
	org $0299D7
		lda $17D0|!addr,x
		beq $03
endif

; Restore old smoke sprite hijack
if read1($0296C3) == $5C
	org $0296C3
		beq $12
endif

; Restore old score sprite hijack
if read1($02ADBD) == $5C
	org $02ADBD
		lda $16E1|!addr,x
		beq $03
endif

org !FindFree						; Find free oam routine
	autoclean JML GetExtOAMIndex	;

org $01F466							; Yoshi's tongue
	autoclean JML YoshiTongueOAM	;

org $02904D							; Bounce blocks
	autoclean JML BounceBlockOAM	;
	NOP								;
org $02922D							;
	LDY !RAM_ExtOAMIndex			;

org $028B05							; Minor extended sprites
	jsr MinorExtOAM1				;
org $028B74							;
	jmp MinorExtOAM2				;
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

org $028B11							; Spinning coins
	jsr SpinningCoinOAM1			;
org $0299DF							;
	jmp SpinningCoinOAM2			;
org $029A3D							;
	LDY !RAM_ExtOAMIndex			;

org $029046							; Smoke images
	jsr SmokeImageOAM				;
org $02974A							;
	LDY !RAM_ExtOAMIndex			;
org $02996C							;
	LDY !RAM_ExtOAMIndex			;
org $0297B2							; (contact GFX)
	autoclean jml FixContactGFX		;

org $02ADA4							; Score sprites
	autoclean jml ScoreSpriteRestore;
ScoreSpriteMain:					;
	ldx #$05 						; (This moves the loop a bit earlier
-	lda $16E1|!addr,x : beq ++		;  so we can add our routine)
	pha								;
	jsl GetExtOAMIndex				;
	pla								;
	bra +							; (continue with the normal code)
warnpc $02ADBA						;
org $02ADBA							;
	+								;
org $02ADC5							;
++	dex : bpl -						; (jump back to our new loop point)
org $02AE9B							;
	LDY !RAM_ExtOAMIndex			;

org $00907A							; Item box item
	db $FC							; (just move this one to the end)

org $029B16							; Extended sprites
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
org $02A03B							; (Mario's fireballs)
	ldy !RAM_ExtOAMIndex			;
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
org $02A369							; (Smoke puff generated by Mario's fireballs)
	ldy !RAM_ExtOAMIndex			;

org $02F812							; Cluster sprites
	jmp ClusterSpriteOAM			;
org $02FCCD							;
	LDA !RAM_ExtOAMIndex			;
org $02FCD9							;
	LDY !RAM_ExtOAMIndex			;
org $02FD4A							;
	LDY !RAM_ExtOAMIndex			;
org $02FD98							;
	LDY !RAM_ExtOAMIndex			;
org $02FE48							;
	LDY !RAM_ExtOAMIndex			;
org $02DF6E							; (patch Sumo Brother flame GFX routine)
	NOP								; (also, it fixes a couple of glitches regarding
org $02F9CF							;  position of flames and "hitbox")
	autoclean JML FixSumoFlame1		;
org $02F937							;
	autoclean JML FixSumoFlame2		;
org $02FCD6							;
	dw $0420|!addr					; (use the first set of tiles)
org $02FCDF							;
	dw $0201|!addr					;
org $02FD54							;
	dw $0200|!addr					;
org $02FD5D							;
	dw $0201|!addr					;
org $02FD74							;
	dw $0202|!addr					;
org $02FD86							;
	dw $0203|!addr					;
org $02FD8F							;
	dw $0420|!addr					;
org $02FDAF							;
	dw $0202|!addr					;
org $02FDB4							;
	dw $0203|!addr					;

org $07F1CD							; Goal Tape stars
	autoclean jsl GoalTapeStarsOAM	;
org $07F1E8							;
	nop #2 							;
org $07F1FA 						;
	nop #2 							;

; Empty area in bank 2 ($02B5EC to $02B60D is used by PIXI)
; Used for a bunch of JMP/JSR -> JML hijacks
org $02B60E
ClusterSpriteOAM:
	jml ClusterSpriteOAMFreespace
MinorExtOAM1:
	jml MinorExtOAMFreespace
MinorExtOAM2:
	jml MinorExtOAMFreespace_next
SpinningCoinOAM1:
	jml SpinningCoinOAMFreespace
SpinningCoinOAM2:
	jml SpinningCoinOAMFreespace_next
SmokeImageOAM:
	jml SmokeImageOAMFreespace
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
	JML $01F46A|!bank

BounceBlockOAM:
	LDA $1699|!addr,x
	BEQ .Return
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $029052|!bank
.Return
	JML $02904C|!bank

ExtendedSprOAM:
	LDA $170B|!addr,x
	BEQ .Return
	PHA
	JSL GetExtOAMIndex
	PLA
	JML $029B1B|!bank
.Return
	JML $029B15|!bank

FixSumoFlame1:
	LDA $185E|!addr
	AND #$03
	TAY
	LDA $1E02|!addr,x
	JML $02F9D6|!bank

FixSumoFlame2:
	LDA $1E16|!addr,x
	SEC
	SBC $1A
	STA $00
	LDA $1E3E|!addr,x
	SBC $1B
	BNE .End
	LDA $1E02|!addr,x
	SEC
	SBC $1C
	STA $01
	LDY #$01
-	LDA $1E02|!addr,x
	CLC
	ADC #$04
	CLC
	ADC $D374,y
	PHP
	CMP $1C
	ROL $02
	PLP
	LDA.w $1E2A|!addr,x
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
	STA $0200|!addr,y
	TXA
	ORA $185E|!addr
	TAX
	LDA $02F8FC,x
	BMI .Skip
	CLC
	ADC $01
	STA $0201|!addr,y
	LDA $02F904,x
	STA $0202|!addr,y
	LDA $14
	AND #$04
	ASL #4
	ORA $64
	ORA #$05
	STA $0203|!addr,y
	PHY
	TYA
	LSR #2
	TAY
	LDA #$02
	STA $0420|!addr,y
	PLY
.Skip
	PLX
	INY #4
	DEX
	BPL .Loop
	PLX
.End
	PLX
	JML $02F93B|!bank

FixContactGFX:
	ldy !RAM_ExtOAMIndex
	lda $17C8|!addr,x
	jml $0297B7|!bank

ClusterSpriteOAMFreespace:
	stx $15E9|!addr
	lda $1892|!addr,x : beq .Return
	pha
	jsl GetExtOAMIndex
	pla
	jml $02F815|!bank
.Return
	jml $02F81D|!bank

; Due to PIXI's hijack point being at the start of the loop
; we need to recreate the loop ourselves.
MinorExtOAMFreespace:
	ldx #$0B
.loop:
	lda $17F0|!addr,x : beq .next
	pha
	jsl GetExtOAMIndex
	pla
	jml $028B69|!bank
.next:
	dex : bpl .loop
	jml $028B77|!bank

; Due to PIXI's hijack point being at the start of the loop
; we need to recreate the loop ourselves.
SpinningCoinOAMFreespace:
	ldx #$03
.loop:
	lda $17D0|!addr,x : beq .next
	pha
	jsl GetExtOAMIndex
	pla
	jml $0299D4|!bank
.next:
	dex : bpl .loop
	jml $0299E2|!bank

SmokeImageOAMFreespace:
	lda $17C0|!addr,x : beq .return
	pha
	jsl GetExtOAMIndex
	pla
	jml $0296C0|!bank
.return:
	jml $0296D7|!bank

; This doesn't actually handle the smoke OAM but it restores some code
; replaced by us at the original hijack point
ScoreSpriteRestore:
	bit $0D9B|!addr : bvc .normal
	lda $0D9B|!addr : cmp #$C1 : beq .return
	; Epic SMW moment
	lda #$F0 : sta $0205|!addr : sta $0209|!addr
.normal:
	jml ScoreSpriteMain
.return:
	jml $02ADC8|!bank

GoalTapeStarsOAM:
	sta $04
	stz $02
	jsl GetExtOAMIndex
	ldy !RAM_ExtOAMIndex
	rtl
