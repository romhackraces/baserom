
;;;;;;;;;;;;;;;;; DEFINITIONS ;;;;;;;;;;;;;;;;;

; 1) map16 numbers of collected DC
; Set these to $0025 if you want just blank tiles.
; NOTE: The behavior of line guided sprites depends on the map16 number of tiles, not the act-like number. The consequence of using a number over 0x200 may seem random.
; If your definition screws up line guides, use this patch: http://www.smwcentral.net/?p=section&a=details&id=8811

	!uppertile = #$02EF
	!lowertile = #$02FF


; 2) ram for saving info of each individual dc, 0x300(=768) bytes.
; make sure they are NOT already used in your hack.
; NOTE: To make the DC progress saved to SRAM, use a patch customizing SRAM like this: http://www.smwcentral.net/?p=section&a=details&id=8904
;       Refer to sram_instruction.txt for details.
; Vitor Vilela's note: If you are using SA-1, please edit !FreeRAM_SA1 instead.

	!FreeRAM	= $7FA660		; 0x300 bytes, $7FA660-$7FA95F
	!FreeRAM_SA1	= $40A660	; 0x300 bytes, $40A660-$40A95F
	!buffer = $7FA960			; 0x08 bytes. Only used if !Midpoint is set to 1
	!buffer_SA1 = $40A960


; 3) Options for saving and stuff
; Set to 1 for yes and 0 for no. Midpoint means the dragon coins will only be saved when passing the midpoint. When set to 0, it will always save
; as soon as they are collected. Replace means it will draw the "empty" tile. If set to 0, it will simple not appear at all. The difference is that
; setting it to 0 means whatever is behind it will appear instead, whereas setting !uppertile and !lowertile to 025 would overwrite whatever is behind it.

	!Midpoint = 1
	!Replace = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; FINAL NOTE: Like original SMW, each dragon coin is identified by the pair of its x pos, and sublevel's item memory index.
;             Be aware that different dragon coins in different sublevels can be treated as the same one so you cannot obtain one of them.
;             Dragon coins won't be saved in a sublevel whose item memory index is 3, unless you get 5 of them in a single try.
;
;             Make a backup of your ROM before applying this just in case.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;despite what I said above, these are still used when collecting the dragon coin.
if !Replace = 0
	!uppertile = #$0025
	!lowertile = #$0025
endif

lorom

!SA1   = 0
!base2 = $0000
!base3 = $800000

if read1($00ffd5) == $23
	sa1rom
	!SA1		= 1
	!base2		= $6000
	!base3		= $000000
	!FreeRAM	= !FreeRAM_SA1
	!buffer = !buffer_SA1
endif

!table1 = !FreeRAM
!table2 = !FreeRAM+$C0
!table3 = !FreeRAM+$180
!table4 = !FreeRAM+$240


org $0096B4	; titlescreen
autoclean JML InitDCRAM

org $05D7AB	; entering a level from the map
autoclean JML CalcDCNum_wrapper
NOP

org $05D8AC
	; recover from old ver
	STA $0E
	LDA $1F11|!base2,y

org $0DB2D7
autoclean JML DCgen

org $00F35D
autoclean JML DCget


org $00CA2B
	if !Midpoint = 1
		autoclean JSL SaveBuffer
		NOP
	else
		LDA #$01 : STA $13CE|!base2
	endif


freecode
InitDCRAM:
	LDA #$C0
	LDX #$BE
-
	STA !table1,x
	STA !table2,x
	STA !table3,x
	STA !table4,x
	DEX
	DEX
	CPX #$FE
	BNE -

if !Midpoint = 1
	LDX #$06
-
	STA !buffer,x
	DEX
	DEX
	BPL -
endif

;orig
	LDX #$07
	LDA #$FF
	JML $0096B8|!base3



Calc13BF:
	LDA $0109|!base2
	BEQ +
	STZ $13BF|!base2	; just making sure the translevel number is zero for titlescreen or intro level
	RTS
+
	PHY
	; copy pasted from smwdisc
	LDX $0DD6|!base2
	LDA $1F17|!base2,x
	LSR #4
	STA $00
	LDA $1F19|!base2,x
	AND #$F0
	ORA $00
	STA $00
	LDA $1F1A|!base2,x
	ASL
	ORA $1F18|!base2,x
	LDX $0DB3|!base2
	LDY $1F11|!base2,x
	BEQ +
	CLC : ADC #$04
+
	STA $01
	REP #$10
	LDX $00
	if !SA1
		LDA $40D000,x
	else
		LDA $7ED000,x
	endif
	STA $13BF|!base2
	SEP #$10
	PLY
	RTS

CalcDCNum_wrapper:
	LDA $141A|!base2
	BNE +
	JSL CalcDCNum
	JML $05D83E|!base3
+
	JML $05D7B3|!base3
CalcDCNum:	; the retry patch may also call this routine
	PHY
	PHX
	PHP

	SEP #$30

	; check if retry is installed (hurryflag in retry)
	LDA.l $008E5B|!base3
	CMP #$5C
	BNE +
	; check if the level is being reset by the retry
	REP #$20
	LDA.l $008E5C|!base3
	CLC
	ADC #$0008
	STA $00
	SEP #$20
	LDA.l $008E5E|!base3
	STA $02
	LDY #$02
	LDA [$00],y
	PHA
	LDY #$00
	REP #$20
	LDA [$00],y
	SEC
	SBC #$0002
	STA $00
	SEP #$20
	PLA
	STA $02		; !freeram+5 in retry has been stored at $00
	LDA [$00]
	BNE ++		; do nothing if the level is being reset
+
	LDA $141A|!base2
	BNE ++
	JSR Calc13BF	; I know $13BF can be computed twice when you enter the level from the map, but it's not a big deal
++

	if !Midpoint = 1
		SEP #$10
		LDA $13BF|!base2
		ASL
		TAX
		REP #$20

		LDA !table1,x
		STA !buffer

		LDA !table2,x
		STA !buffer+2

		LDA !table3,x
		STA !buffer+4

		LDA !table4,x
		STA !buffer+6
	endif

	SEP #$30

	STZ $1420|!base2

	LDA $13BF|!base2
	LSR
	LSR
	LSR
	TAY
	LDA $13BF|!base2
	AND #$07
	TAX
	LDA $1F2F|!base2,y
	AND.l $0DA8A6|!base3,x
	BNE ++


if !Midpoint = 1
	LDX #$06
-
	LDA !buffer,x
	AND #$C0
	CMP #$C0
	BEQ +
	INC $1420|!base2
+
	DEX : DEX
	BPL -
else
	LDA $13BF|!base2
	ASL
	TAX

	LDA !table1,x
	AND #$C0
	CMP #$C0
	BEQ +
	INC $1420|!base2
+

	LDA !table2,x
	AND #$C0
	CMP #$C0
	BEQ +
	INC $1420|!base2
+

	LDA !table3,x
	AND #$C0
	CMP #$C0
	BEQ +
	INC $1420|!base2
+

	LDA !table4,x
	AND #$C0
	CMP #$C0
	BEQ +
	INC $1420|!base2
+
endif

++
	LDA $1420|!base2
	STA $1422|!base2

	PLP
	PLX
	PLY
	RTL


DCgen:
	LDA $1F2F|!base2,y
	AND.l $0DA8A6|!base3,x
	BEQ +
	JMP .dot_gen
+
	REP #$20
	PHA
	SEP #$20

	LDX $13BE|!base2
	LDA.l .item_memory,x
	STA $08

if !SA1
	lda $5B
	lsr
	bcs .oldlm_1	; vertical level
	lda $0FF0B4|!base3
	cmp #$33	; check if LM 3.00+
	bcc .oldlm_1	; old LM
	bra +
.oldlm_1
	jmp .oldlm
+
	lda $13D8|!base2
	cmp #$10
	rep #$20
	bcc .8bit

	phx
	ldx #$00
	lda $6B
	sec
	sbc #$C800
-
	cmp $13D7|!base2
	bmi +
	inx
	sec
	sbc $13D7|!base2
	bra -
+
	sep #$20
	xba
	stz $2250
	sta $2251
	txa
	tsb $08
	bra +

.8bit
	lda #$0001
	sta $2250
	lda $6B
	sec
	sbc #$C800
	lsr #4
	sta $2251
	lda $13D7|!base2
	lsr #4
	sep #$20
	sta $2253
	stz $2254
	nop #3
	lda $2306
	tsb $08
	lda $2308
	lsr #4
	stz $2250
	sta $2251
	stz $2252
	phx
+
	lda $0BF5|!base2
	and #$1F
	tax
	lda.l .max_h,x
	sta $2253
	stz $2254
	plx
	lda $08
	clc
	adc $2306
	sta $08
else
	LDA $5B
	LSR
	BCS .oldlm	; vertical level
	LDA $0FF0B4|!base3
	CMP #$33	; check if LM 3.00+
	BCC .oldlm	; old LM

	LDA $13D8|!base2
	CMP #$10
	REP #$20
	BCC .8bit	; can use 8bit snes divisor

	PHX
	LDX #$00
	LDA $6B
	SEC
	SBC #$C800
-
	CMP $13D7|!base2
	BMI +
	INX
	SEC
	SBC $13D7|!base2
	BRA -
+
	SEP #$20
	XBA
	STA $4202
	TXA
	TSB $08
	BRA +
.8bit
	LDA $6B
	SEC
	SBC #$C800
	LSR #4
	STA $4204
	LDA $13D7|!base2
	LSR #4
	SEP #$20
	STA $4206
	NOP #8	; 16 cycles
	LDA $4214
	TSB $08
	LDA $4216
	LSR #4
	STA $4202
	PHX
+
	LDA $0BF5|!base2
	AND #$1F
	TAX
	LDA.l .max_h,x
	STA $4203
	PLX	; 4 cycles
	NOP #2	; 4 cycles
	LDA $08
	CLC
	ADC $4216
	STA $08
endif
	BRA +
.oldlm
	LDA $0A
	AND #$10
	ASL
	ORA $1BA1|!base2
	TSB $08
	LDA $1933|!base2
	BEQ +
	LDA #$10
	TSB $08
+
	LDA $57
	STA $09

; $08~$09 = iissssss yyyyxxxx

if !Midpoint = 1
	REP #$20
	LDA $08

	CMP.l !buffer
	BEQ .not_gen
	CMP.l !buffer+$2
	BEQ .not_gen
	CMP.l !buffer+$4
	BEQ .not_gen
	CMP.l !buffer+$6
	BEQ .not_gen

else
	LDA $13BF|!base2
	ASL
	TAX

	REP #$20
	LDA $08
	CMP.l !table1,x
	BEQ .not_gen
	CMP.l !table2,x
	BEQ .not_gen
	CMP.l !table3,x
	BEQ .not_gen
	CMP.l !table4,x
	BEQ .not_gen
endif

	PLA
	SEP #$20
	JML $0DB322|!base3
.not_gen
	PLA
	SEP #$20
.dot_gen
	LDY $57
if !Replace = 1
	LDA.b !uppertile>>8
	STA [$6E],y
	LDA.b !uppertile
	STA [$6B],y
	JSR CODE_0DA97D
	LDA.b !lowertile>>8
	STA [$6E],y
	LDA.b !lowertile
	STA [$6B],y
endif
	JML $0DB335|!base3
.item_memory
	db $00,$40,$80,$C0
.max_h
	db $20,$20,$1E,$1C,$1A,$18,$17,$16,$15,$14,$13,$12,$11,$10,$0F,$0E
	db $0D,$0C,$0B,$0A,$09,$08,$07,$06,$05,$04,$03,$02,$01

if !Replace = 1	;routine is not needed if no replace occures.
CODE_0DA97D:
	LDA $57
	CLC
	ADC #$10
	STA $57
	TAY
	BCC +
	LDA $6C
	ADC #$00
	STA $6C
	STA $6F
	STA $05
+
	RTS
endif


DCget_orig2:
	JMP DCget_orig
DCget:
	LDA $0109|!base2
	BNE .orig2	; do nothing for the titlescreen/intro

	LDA $13BE|!base2
	CMP #$03
	BEQ .orig2	; also do nothing if item memory index == 3

	LDA $08
	PHA
	LDA $09
	PHA
	PHX

	LDA $98
	AND #$F0
	STA $09
	LDA $9A
	AND #$F0
	LSR
	LSR
	LSR
	LSR
	ORA $09
	STA $09

	LDX $13BE|!base2
	LDA.l DCgen_item_memory,x
	STA $08

	LDA $5B
	AND #$01
	BEQ .horz
.vert
	LDA $99
	LDX $9B
	BEQ +
	ORA #$20
+
	LDX $1933|!base2
	BEQ +
	ORA #$10
+
	TSB $08
	BRA ++
.horz
	LDA $0FF0B4
	CMP #$33	; check if LM 3.00+
	BCC .oldlm

	LDA $9B
	TSB $08
	LDA $99
if !SA1
	stz $2250
	sta $2251
	stz $2252
	lda $0BF5|!base2
	and #$1F
	tax
	lda.l DCgen_max_h,x
	sta $2253
	stz $2254
	lda $08
	clc
	adc $2306
	sta $08
else
	STA $4202
	LDA $0BF5|!base2
	AND #$1F
	TAX
	LDA.l DCgen_max_h,x
	STA $4203
	NOP #4	; 8 cycles
	LDA $08
	CLC
	ADC $4216
	STA $08
endif

	LDA $1933|!base2
	BEQ ++
	LDA.l DCgen_max_h,x
	LSR
	ADC #$00	; layer2 h scr offset = ceil(max_h/2)
	CLC
	ADC $08
	STA $08
	BRA ++
.oldlm
	LDA $9B
	LDX $99
	BEQ +
	ORA #$20
+
	LDX $1933|!base2
	BEQ +
	ORA #$10
+
	TSB $08
++

	LDA $13BF|!base2
	ASL
	TAX

if !Midpoint = 1
	LDX #$06
-
	LDA !buffer,x
	AND #$C0
	CMP #$C0
	BNE +
	LDA $08
	STA !buffer,x
	LDA $09
	STA !buffer+1,x
	BRA ++
+
	DEX : DEX
	BPL -

else
	LDA !table1,x
	AND #$C0
	CMP #$C0
	BNE +
	LDA $08
	STA !table1,x
	LDA $09
	STA !table1+1,x
	BRA ++
+

	LDA !table2,x
	AND #$C0
	CMP #$C0
	BNE +
	LDA $08
	STA !table2,x
	LDA $09
	STA !table2+1,x
	BRA ++
+

	LDA !table3,x
	AND #$C0
	CMP #$C0
	BNE +
	LDA $08
	STA !table3,x
	LDA $09
	STA !table3+1,x
	BRA ++
+

	LDA !table4,x
	AND #$C0
	CMP #$C0
	BNE +
	LDA $08
	STA !table4,x
	LDA $09
	STA !table4+1,x
+
endif
++

	PLX
	PLA
	STA $09
	PLA
	STA $08
.orig
	LDA #$01
	JSL $05B330|!base3

	PHX : REP #$30
	LDX !uppertile
	JSR SUBL_SET_MAP16
	LDA $98
	CLC
	ADC #$0010
	STA $98
	LDX !lowertile
	JSR SUBL_SET_MAP16
	SEP #$30 : PLX
	JML $00F373|!base3



if !Midpoint = 1
SaveBuffer:
	PHX

	LDA $13BF|!base2
	ASL
	TAX
	REP #$20

	LDA !buffer
	STA !table1,x

	LDA !buffer+2
	STA !table2,x

	LDA !buffer+4
	STA !table3,x

	LDA !buffer+6
	STA !table4,x

	SEP #$20
	PLX

	;orig
	LDA #$01
	STA $13CE|!base2
	RTL

endif



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;X = map16
;$9A = pos_x
;$98 = pos_y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; routine from GPS 1.4.0/routines/change_map16.asm
SUBL_SET_MAP16:
	LDA $0F : PHA
	LDA $98 : PHA : LDA $9A : PHA
	PHP
	PHY
	PHX
	LDY $98
	STY $0E
	LDY $9A
	STY $0C
	SEP #$30
	LDA $5B
	LDX $1933|!base2
	BEQ .Layer1
	LSR A
.Layer1
	STA $0A
	LSR A
	BCC .Horz
	LDA $9B
	LDY $99
	STY $9B
	STA $99
	BRA .oldlm
.Horz
	LDA $0FF0B4|!base3
	CMP #$33	; check if LM 3.00+
	BCC .oldlm

	REP #$20
		LDA $98
		CMP $13D7|!base2
	SEP #$20
	BRA +
.oldlm
	LDA $99
	CMP #$02
+
	BCS .End
	LDA $9B
	CMP $5D
	BCC .NoEnd
.End
	REP #$10
	PLX
	PLY
	PLP
	JMP .returnasdf

.NoEnd
	STA $0B
	ASL A
	ADC $0B
	TAY
	REP #$20
	LDA $98
	AND.w #$FFF0
	STA $08
	AND.w #$00F0
	ASL #2			; 0000 00YY YY00 0000
	XBA			; YY00 0000 0000 00YY
	STA $06
	TXA
	SEP #$20
	ASL A
	TAX

	LDA $0D
	LSR A
	LDA $0F
	AND #$01		; 0000 000y
	ROL A			; 0000 00yx
	ASL #2			; 0000 yx00
	ORA.l .LayerData,x	; 001l yx00
	TSB $06			; $06 : 001l yxYY
	LDA $9A			; X LowByte
	AND #$F0		; XXXX 0000
	LSR #3			; 000X XXX0
	TSB $07			; $07 : YY0X XXX0
	LSR A
	TSB $08

	LDA $1925|!base2
	ASL A
	REP #$31
	ADC $00BEA8|!base3,x
	TAX
	TYA
	if !SA1
		ADC $000000,x
		TAX
		LDA $08
		ADC $000000,x
	else
		ADC $00,x
		TAX
		LDA $08
		ADC $00,x
	endif
	TAX
	PLA
	ASL A
	TAY
	LSR A
	SEP #$20
	if !SA1
		STA $400000,x
		XBA
		STA $410000,x
	else
		STA $7E0000,x
		XBA
		STA $7F0000,x
	endif
	LSR $0A
	LDA $1933|!base2
	REP #$20
	BCS .Vert
	BNE .HorzL2
.HorzL1
	LDA $1A			;\
	SBC #$007F		; |$08 : Layer1X - 0x80
	STA $08			;/
	LDA $1C			;  $0A : Layer1Y
	BRA .Common
.HorzL2
	LDA $1E			;\ $08 : Layer2X
	STA $08			;/
	LDA $20			;\ $0A : Layer2Y - 0x80
	SBC #$007F		;/
	BRA .Common

.Vert
	BNE .VertL2
	LDA $1A			;\ $08 : Layer1X
	STA $08			;/
	LDA $1C			;\ $0A : Layer1Y - 0x80
	SBC #$0080		;/
	BRA .Common
.VertL2
	LDA $1E			;\
	SBC #$0080		; |$08 : Layer2X - 0x80
	STA $08			;/
	LDA $20			;  $0A : Layer2Y
.Common
	STA $0A
	PHB
	PHK
;	PER $0006
	PEA .return-1
	PEA $804C
	JML $00C0FB|!base3
.return
	PLB
	PLY
	PLP
.returnasdf
	PLA : STA $9A : PLA : STA $98
	PLA : STA $0F
	RTS

.LayerData	db $20,$00,$30
