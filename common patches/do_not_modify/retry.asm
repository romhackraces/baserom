
!use_custom_midway_bar = $01	; $00 = no, $01 = yes
				; if you are already using objectool, set this to $00

!intro_level	= $00C5		; must be $01C5 when lm's display message hack is applied (automaticallyd done btw)

;!freeram: timer1
;!freeram+1: timer2
;!freeram+2: timer3
;!freeram+3: respawn location1
;!freeram+4: respawn location2 + sprite lock($9D) bit
;!freeram+5: is respawning? (after death)
;!freeram+6: music that has to be reloaded after respawn, used for amk (when the value is #$FF, the sample will be always reloaded)
;!freeram+7: music sped up? (hurry up)
;!freeram+8: door dest1 (candidate of freeram+3, for door/pipe checkpoint)
;!freeram+9: door dest2 (candidate of freeram+4, for door/pipe checkpoint)
;!freeram+10: music played right before the death jingle
;!freeram+11: letter update request / layer 2 collision backup



!sa1	= 0
!dp	= $0000
!addr	= $0000
!bank	= $800000
!bank8	= $80
!7ED000 = $7ED000		; $7ED000 if LoROM, $40D000 if SA-1 ROM.

if read1($00FFD5) == $23
	sa1rom
	!sa1	= 1
	!dp	= $3000
	!addr	= $6000
	!bank	= $000000
	!bank8	= $00
	!7ED000 = $40D000		; $7ED000 if LoROM, $40D000 if SA-1 ROM.
endif


if read1($05DAA3) == $5C	; endif is at EOF
	print "Error: This patch is not compatible with the Multiple Midway Points patch any more. Insertion aborted. See the first note in README."
else
if read1($00A1DA) == $22	; endif is at EOF
	print "Error: This patch is not compatible with Lunar Magic's 'Title Moves Recording ASM'. After finishing inserting your titlescreen, uninstall the 'Title Moves Recording ASM' and try inserting this patch again. Insertion aborted."
else

if read1($0DA106) == $5C 
	print "Warning: The custom midway bar feature will not be inserted automatically due to ObjecTool in your ROM. See the first item of Compatibility Management in README."
	!use_custom_midway_bar = $00
endif

org $00A1DF
autoclean JSL Prompt

org $00A300
autoclean JML LoadLetter

if read1($0085D2) == $5C	; recover
	org $0085D2
	db $A4,$12,$B9,$D0
endif

org $00F5B2
autoclean JSL DeathSFX_pit

org $00F606
autoclean JML DeathSFX

org $008E5B
autoclean JML HurryFlag

org $00A28A
autoclean JML Request

; earlier than GeneralInit (between object & sprite)
org $05D8E6
autoclean JML GeneralInit0

org $0091A6
autoclean JML GeneralInit

org $02A768
autoclean JML YoshiInit

org $05D7BD
autoclean JML EntranceInit0

org $05D7D4
autoclean JML EntranceInit

org $00F2E8
autoclean JML MidbarHijack

org $0DA691
autoclean JML MidbarSpawn

org $05D9D7
autoclean JML CheckMidwayEntrance

org $0096CB
autoclean JML InitCheckpointRam

org $05D9EC
autoclean JML VanillaMidwayDestFix

org $00A261
autoclean JML StartSelectExit

org $058520
autoclean JML Layer2FirstFrameFix



; copy pasted from uberasm ($010B hack)
ORG $05D8B7
BRA +
NOP #3;the levelnum patch goes here in many ROMs, just skip over it
+
REP #$30
	LDA $0E		
	STA $010B|!addr
	ASL		
	CLC		
	ADC $0E		
	TAY		
	LDA.w $E000,Y
	STA $65		
	LDA.w $E001,Y
	STA $66		
	LDA.w $E600,Y
	STA $68		
	LDA.w $E601,Y
	STA $69		
	BRA +
ORG $05D8E0
	+


freecode

Table:
	incsrc retry_table.asm

if !sa1
	!freeram = !freeram_SA1
	!freeram_checkpoint = !freeram_checkpoint_SA1
	!freeram_custobjdata = !freeram_custobjdata_SA1
endif

!freeram_custobjnum = !freeram_custobjdata+(!max_custom_midway_num*4)

Prompt:
	; save prompt
	CMP #$08
	BEQ .3
	CMP #$0C
	BEQ .3
	CMP #$09
	BCS Retry
	JSL $05B10C|!bank
	RTL
.3
	INC $1426|!addr
	STZ $41
	STZ $42
	STZ $43
	LDA #$80
	TRB $0D9F|!addr
	RTL

FastRetry:
	CMP #$0E
	BEQ Retry_5
	LDX $1B88|!addr
	LDA.l Retry_dest,x
	CMP $1B89|!addr
	BEQ Retry_sub2
	STA $1B89|!addr
	JMP Retry_sub

Wait:
	SEC
	SBC #$10
	STA $1426|!addr
	JSR HDMA7sprite_recover2
	RTL


Retry:
	CMP #$10
	BCS Wait
	CMP #$0D
	BCS FastRetry
	CMP #$0A
	BNE .4

.5
;A
	LDA $1B87|!addr
	PHA
	JSR .choose
	PLA
	CMP $1B87|!addr
	BEQ +
	STA $1B87|!addr
	LDA $1426|!addr
	CLC
	ADC #$21
	STA $1426|!addr
	JSR HDMA7sprite_recover
	RTL
+
	JSR HDMA7sprite_update
	RTL

.dest
	db $48,$00
.spd
	db $06,$FA

.4
;9,B
	LDX $1B88|!addr
	LDA $1B89|!addr
	CMP.l .dest,x
	BNE ++
;box complete
.sub2
	INC $1426|!addr
	LDA $1426|!addr
	CMP #$0A
	BEQ +++
	CMP #$0E
	BNE +
+++
;9
	PHA
	JSR HDMA7sprite_set
	PLA
+
	AND #$03
	BEQ +
;9
	RTL
+
;B
	; terminate
	STZ $1426|!addr
	STZ $1B88|!addr
	STZ $41
	STZ $42
	STZ $43
	LDA #$80
	TRB $0D9F|!addr
	LDA #$02
	STA $44
	RTL
++
;box creating
	CLC
	ADC.l .spd,x
	STA $1B89|!addr
.sub
	CLC
	ADC #$80
	XBA
	REP #$10
	LDX #$016E
	LDA #$FF
-
	STA $04F0|!addr,x
	STZ $04F1|!addr,x
	DEX
	DEX
	BPL -
	SEP #$10
	LDA $1B89|!addr
	LSR
	ADC $1B89|!addr
	LSR
	AND #$FE
	TAX
	LDA #$80
	SEC
	SBC $1B89|!addr
	REP #$20
	LDY #$48
-
	CPY #$00
	BMI +
	STA $0548|!addr,y
+
	STA $0590|!addr,x
	DEY
	DEY
	DEX
	DEX
	BPL -
	SEP #$20
	LDA #$AA
	STA $41
	STA $42
	LDA #$22
	STA $43
	LDA #$22
	STA $44
	LDA #$80
	TSB $0D9F|!addr
	RTL

.choose
	;LDY #$00
	JSR .cursor
	TXA
	BEQ +

	; no is selected
	PHX
	JSR GetPromptType
	PLX
	CMP #$02
	BNE ++

	LDA !freeram+7
	BNE ++

	LDA.l $008075|!bank
	CMP #$5C
	BNE .no_amk
	if !death_jingle_alt == $FF
		BRA .van
	else
		LDA #!death_jingle_alt
		STA $1DFB|!addr
		BRA ++
	endif
.no_amk
	LDA #$FF
	STA $0DDA|!addr
.van
	LDA #$4E	; extra frames
	STA $1496|!addr
	LDA.l $00F60B|!bank
	STA $1DFB|!addr
++
	JSL $009C13|!bank
	RTS
+
	; yes is selected
	JSR ResetLevel
	JSL $009C13|!bank
	RTS

.cursor
	INC $1B91|!addr
	JSR .cursor_sub
	LDX $1B92|!addr
	LDA $16
	AND #$90
	BNE +
	LDA $18
	BPL ++
+
	LDA #$01
	STA $1DFC|!addr
	BRA +
++
	PLA
	PLA
	LDA $16
	AND #$20
	LSR
	LSR
	LSR
	ORA $16
	AND #$0C
	BEQ ++
	LDY #$06
	STY $1DFC|!addr
	STZ $1B91|!addr
	LSR
	LSR
	TAY

	PHB
	LDA #$00|!bank8
	PHA
	PLB
	TXA
	ADC $9AC7,y
	PLB
	CMP #$00

	BPL +++
	LDA $8A
	DEC
+++
	CMP $8A
	BCC ++++
+
	LDA #$00
++++
	STA $1B92|!addr
++
	RTS

.cursor_sub	; smw code at $009E82
	LDA.l $009E6A
	STA $8A
	RTS


ResetLevel:
	; 1) set screen exit
	LDA $0FF0B4
	CMP #$33	; check if LM 3.00+
	BCC .oldlm
	PHX
	JSL $03BCDC|!bank
	TXY
	PLX
	BRA +
.oldlm
	LDA $5B
	LSR
	BCC .horz
	LDY $97
	BRA +
.horz
	LDY $95
+
	CPY #$00
	BPL .positive
	LDY #$00
	BRA .ok
.positive
	CPY #$20
	BMI .ok
	LDY #$1F
.ok
	LDA !freeram+3
	STA $19B8|!addr,y
	LDA !freeram+4
	ORA #$04
	STA $19D8|!addr,y

	LDA #$01
	STA !freeram+5
	LDA #$00
	STA !freeram+7
	LDA #$06
	STA $71
	STZ $1496|!addr
	STZ $89
	STZ $88

	; 2) item memory & sprite reload
	LDX #$7F
-
	STZ $19F8|!addr,x
	STZ $1A78|!addr,x
	STZ $1AF8|!addr,x
	STZ $1938|!addr,x	; sprite reload
	DEX
	BPL -

	; 3) timer, music, lives, etc
	if !counterbreak_powerup
		STZ $0DC2|!addr
	endif
	if !counterbreak_coin
		STZ $0DBF|!addr
	endif
	if !reset_rng
		STZ $148B|!addr
		STZ $148C|!addr
		STZ $148D|!addr
		STZ $148E|!addr
	endif
	LDA #$1E
	STA $0DC0|!addr
	; dc
	STZ $1420|!addr
	STZ $1422|!addr
	LDA.l $05D7AB|!bank
	CMP #$5C
	BNE +
	; dcsave
	REP #$20
	LDA $0D
	PHA
	LDA.l $05D7AC|!bank
	CLC
	ADC #$0011
	STA $0D
	SEP #$20
	LDA $0F
	PHA
	LDA.l $05D7AE|!bank
	STA $0F
	JSL .dcsave_init_wrapper
	PLA
	STA $0F
	REP #$20
	PLA
	STA $0D
	SEP #$20
+
	; reset $1497-$14AB
	LDX #$14
-
	STZ $1497|!addr,x
	DEX
	BPL -
	STZ $1432|!addr	; directional coin from a question box
	STZ $14AF|!addr	; ON/OFF
	STZ $1B94|!addr	; bonus game sprite
	STZ $1B95|!addr	; yoshi wing
	STZ $1B96|!addr	; side exit
	STZ $1B9A|!addr	; flying turn blocks(forest of illusion)
	STZ $1B9F|!addr	; reznor bridge
	; mode 7 values for the boss
	; do it later
	;REP #$20
	;STZ $36
	;STZ $38
	;STZ $3A
	;STZ $3C
	;SEP #$20
	LDA !freeram
	STA $0F31|!addr
	LDA !freeram+1
	STA $0F32|!addr
	LDA !freeram+2
	STA $0F33|!addr

	; yoshi drum
	LDA #$03
	STA $1DFA|!addr

	LDA.l $008075|!bank
	CMP #$5C
	BEQ .amk

	; non addmusic (dont need to consider sample overhead)
	LDA $0DDA|!addr	; after the death jingle, this value will always be $FF
	BPL .musicend
	STZ $0DDA|!addr	; request to reset after death jingle, p-switch, march song, etc
	BRA .musicend
.amk
		LDA $13C6|!addr ; music has been changed by level ender (which doesn't update $0DDA properly) 
		BNE .forcereset
	LDA $0DDA|!addr
	CMP #$FF	; death, kaizo trap, etc
	BEQ .spec
	; normal case: $0DDA preserved
	LDA !freeram+6
	CMP $0DDA|!addr
	BNE .musicend
	BRA .bypass
.spec
	LDA $1DFB|!addr
	CMP #$01	; death
	BEQ +
.forcereset
	; kaizo trap -> order reload
	LDA #$00
	STA !addmusick_ram_addr
	STA $1DFB|!addr
	BRA .musicend	; maybe improve this later, but not major
+
	; death jingle
	LDA !freeram+6
	CMP !freeram+10
	BNE .musicend
.bypass
	LDA !freeram+6
	CMP #$FF	; always reload the sample (actually this wont be reached for the most cases)
	BEQ .musicend
	JSR GetPromptType
	CMP #$02
	BCS .musicend
	LDA #$01
	STA !addmusick_ram_addr+1
.musicend

	STZ $141A|!addr
	if !lose_lives
		DEC $0DBE|!addr
	endif

	PHP : PHB
	PHK : PLB
	JSR ResetExtra
	PLB : PLP

	RTS

.dcsave_init_wrapper
	JML [$000D|!dp]


incsrc retry_extra.asm


HDMA7sprite:
.set
	; init cursor counter
	STZ $1B91|!addr
	LDX #$08
	LDY #$00
-
	LDA.l .pos_x,x
	STA $0208|!addr,y
	LDA.l .pos_y,x
	STA $0209|!addr,y
	LDA.l .tile,x
	STA $020A|!addr,y
	LDA #$30
	STA $020B|!addr,y
	INY
	INY
	INY
	INY
	DEX
	BPL -
	LDA #$58
	STA $0200|!addr
	STA $0204|!addr
	LDA #$6F
	STA $0201|!addr
	LDA #$7F
	STA $0205|!addr
	LDA #$30
	STA $0203|!addr
	STA $0207|!addr

	; OAM tile sizes
	LDA #$02
	STA $0420|!addr ; cursor1
	STA $0421|!addr ; cursor2
	STA $0422|!addr ; blank
	STA $0423|!addr ; blank
	STA $0424|!addr ; blank
	STA $0425|!addr ; blank
	STA $0426|!addr ; IT
	STA $0427|!addr ; EX
	STZ $0428|!addr ; Y
	STA $0429|!addr ; TR
	STA $042A|!addr ; RE

	PHB
	LDA.b #$00|!bank8
	PHA
	PLB

	PHK
	PEA .pos-1
	PEA $9BAE
	JML $008494|!bank	; apply the modification of $0420-$042A
.pos
	PLB

.update
	; tile of the cursor
	LDA #$5A
	STA $0202|!addr
	STA $0206|!addr
	LDA $1B91|!addr
	EOR #$1F
	AND #$18
	BEQ +
	LDA $1B92|!addr
	ASL #2
	TAY
	LDA #$32
	STA $0202|!addr,y
+
	; hdma window
	LDA $1B91|!addr	; handle the delay
	BEQ .ret
	REP #$20
	LDA #$2604
	STA $4370
	LDA #.table
	STA $4372
	SEP #$20
	LDA.b #.table>>16
	STA $4374
.ret
	RTS
.table
		; all cover / layer123 cover
	db $5D : db $FF,$00,$FF,$00
	db $12 : db $38,$C8,$FF,$00
	db $08 : db $90,$C8,$38,$C8
	db $08 : db $38,$C8,$FF,$00
	db $08 : db $88,$C8,$38,$C8
	db $0D : db $38,$C8,$FF,$00
	db $4C : db $FF,$00,$FF,$00
	db $00
.recover
	LDA #$AA
	STA $43
	LDA #$F0
	STA $0201|!addr
	STA $0205|!addr
	STA $0209|!addr
	STA $020D|!addr
	STA $0211|!addr
	STA $0215|!addr
	STA $0219|!addr
	STA $021D|!addr
	STA $0221|!addr
	STA $0225|!addr
	STA $0229|!addr
	RTS
.recover2
	LDX #$04
-
	LDA.l $009277|!bank,x
	STA $4370,x
	DEX
	BPL -
	LDA #$00
	STA $4377
	RTS

.pos_x
	db $68,$78,$88,$68,$78,$38,$48,$38,$48
.pos_y
	db $6F,$6F,$6F,$7F,$7F,$6F,$6F,$7F,$7F
.tile
	db $22,$21,$4A,$30,$20,$5A,$5A,$5A,$5A
.size
	db $02,$02,$00,$02,$02,$02,$02,$02,$02


LoadLetter:
	LDA !freeram+11
	BPL .orig
	LDA $0100|!addr
	CMP #$14
	BNE .false
	LDA $71
	CMP #$09
	BNE .false
	; accept the request
	LDX #$04
-
	JSR .tile_update
	DEX
	BPL -
.false
	LDA !freeram+11
	AND #$7F
	STA !freeram+11
.orig
	REP #$20
	LDX #$04
	JML $00A304|!bank
.tile_update
	PHX
	TXA
	ASL
	TAX
	REP #$20

	; top
	LDY #$80
	STY $2115
	LDA #$1801
	STA $4320
	LDA.l .dest,x
	CLC
	ADC #$6000
	STA $2116
	LDA.w #.gfx
	CLC
	ADC.l .src,x
	STA $4322
	LDY.b #.gfx>>16
	STY $4324
	LDA.l .tile_num,x
	STA $4325
	LDY #$04
	STY $420B

	SEP #$20
	PLX
	RTS
.src	; *20
	dw $0000,$0060,$00E0,$00C0,$00C0
.dest	; *10
	dw $0200,$0300,$04A0,$05A0,$05B0
.tile_num	; *20
	dw $0080,$0080,$0020,$0020,$0020
.gfx
	incbin letters.bin


CalcEntrance:
	PHX
	LDA $13BF|!addr
		BNE +
		; assumption = level 0 <=> intro
		LDA.b #!intro_level
		STA !freeram+3
		LDA $01E762	;check if lm's shift+f8 hack is installed
		CMP #$EA
		BNE ++
		LDA #$01
		BRA +++
++
		LDA #$00	;LDA.b #!intro_level>>8
+++
		STA !freeram+4
		BRA ++
+
	CMP #$25
	BCC +
	CLC
	ADC #$DC
+
	STA !freeram+3
	LDA #$00
	ADC #$00
-
	STA !freeram+4
++
	LDX $13BF|!addr
	LDA $1EA2|!addr,x
	AND #$40
	BNE +
	LDA $13CE|!addr
	BEQ ++
+
	LDA !freeram+4
	ORA #$08
	STA !freeram+4
	BRA +++
++
	; only for the first entrance
	; do nothing
+++
	PLX
	RTS
.2
	PHX
	LDA $010B|!addr
	STA !freeram+3
	LDA $010C|!addr
	BRA -



HardSave:
		LDA $0109|!addr
		BEQ +
		CMP.b #!intro_level+$24	; intro
		BEQ +
		RTS		; filters titlescreen, etc
+
	PHX
	LDA $13BF|!addr
	ASL
	TAX
	REP #$20
	LDA.l !freeram+3
	STA.l !freeram_checkpoint,x
	SEP #$20

		; we won't rely on $13CE anymore (to support the intro level)
		LDX $13BF|!addr
		LDA $1EA2|!addr,x
		ORA #$40
		STA $1EA2|!addr,x

	PLX
	RTS


DeathSFX:
	; keep from repeating the death routine (fool proof; uberasm, death block activated by cape spin, etc.)
	LDA $71
	CMP #$09
	BNE +
	JML $00F628|!bank	;RTL
+
	LDA #$90
	STA $7D
.pit

	PHX : PHY : PHP : PHB
	PHK : PLB
	JSR DeathRoutine
	PLB : PLP : PLY : PLX

	LDA !freeram+7
	BNE .orig
	if !lose_lives
		LDA $0DBE|!addr
		BEQ .orig
	endif
	PHX
	JSR GetPromptType
	PLX
	CMP #$02
	BCC .orig
	CMP #$04
	BCS .orig
	LDA #!death_sfx
	STA !death_sfx_bank|!addr
	JML $00F614|!bank
.orig
	LDA $0DDA|!addr
	STA !freeram+10
	LDA.l $00F60B|!bank	; death jingle
	STA $1DFB|!addr
	JML $00F60F|!bank


HurryFlag:
	LDA #$FF
	STA $1DF9|!addr
	LDA #$01
	STA !freeram+7
	JML $008E60|!bank


Request:
	if !lose_lives
		LDA $0DBE|!addr
		BEQ .orig
	endif
	; make sure mario is dying
	LDA $71
	CMP #$09
	BNE .orig

	; skip the first frame
	LDA $1496|!addr
	CMP #$41
	BNE +
	; extra frames
	LDA #$22
	STA $1496|!addr
	BRA .orig
+
	CMP #$38
	BNE +
	LDA #$30
	STA $1496|!addr
+
	CMP #$30
	BCS .orig

	JSR GetPromptType
	CMP #$03
	BCC .prompt
	CMP #$04
	BCS .orig
	; automatically yes
	JSR .kaizo_trap
	JSR ResetLevel
	BRA .orig
.prompt
	; key press -> fast
	LDA $16
	ORA $18
	BPL ++
.fast
	LDA $1496|!addr
	CMP #$23
	BCC .orig
	LDA #$0C
	STA $1426|!addr	; request fast retry
	LDA #$22
	STA $1496|!addr
	BRA +++
++
	LDA $1496|!addr
	CMP #$23
	BNE .orig
	LDA #$08
	STA $1426|!addr	; request retry
	DEC $1496|!addr
+++
	JSR .settings
.orig
	LDA $0D9B|!addr
	BPL +
	JML $00A28F|!bank
+
	JML $00A295|!bank
.settings
	; request letter gfx update
	LDA !freeram+11
	ORA #$80
	STA !freeram+11

	LDA $0D9B|!addr
	BPL +
	; special mode (boss)
	; bg color to black
	STZ $0701|!addr
	STZ $0702|!addr
+
.kaizo_trap
	STZ $1492|!addr
	STZ $1493|!addr
	STZ $1494|!addr
	STZ $1495|!addr
	STZ $1B99|!addr
	RTS


GetPromptType:
		LDA $0109|!addr
		BEQ +
		CMP.b #!intro_level+$24	; intro
		BEQ +
		LDA #$04	; filters titlescreen, etc
		RTS
+
	LDX $13BF|!addr
;	BNE +
;	LDA #$04
;	RTS
;+
	LDA.l Table_effect,x
	CMP #$01
	BCS .not_default
	LDA.b #(!default_prompt_type+1)
.not_default
	RTS


GeneralInit0:		; earlier than GeneralInit
	PHY
	PHP
	SEP #$30

	; always reset
	STZ $13	; should not be #$02 (otherwise softlock when you die immediately after entering the level, due to incomplete initialization)
	LDA #$00
	STA !freeram_custobjnum

	LDA $141A|!addr
	BNE +
	; initialize this ram when entering from the map
	LDA #$00
	STA !freeram+5	; zero because we don't want to trigger yoshi init & initial facing init
	STA !freeram+7

	PHP : PHB
	PHK : PLB
	JSR ResetExtra
	PLB : PLP

	LDA $13BF|!addr
	ASL
	TAX
	REP #$20
	LDA.l !freeram_checkpoint,x
	STA.l !freeram+3
	SEP #$20
	BRA ++
+
	LDA !freeram+5
	BNE ++
	REP #$10
	LDX $010B|!addr
	LDA.l Table_checkpoint,x
	SEP #$10
	CMP #$02
	BCC ++
	; (activates the transition midway)
	LDA !freeram+8
	STA !freeram+3
	LDA !freeram+9
	AND #$FB
	LDX $9D
	BEQ +
	ORA #$04
+
	STA !freeram+4
	JSR HardSave
	; dcsave only if !Midpoint = 1
	LDA $00CA2B|!bank
	CMP #$22
	BNE .skip_save_buffer
	REP #$20
	LDA $0D
	PHA
	LDA.l $00CA2C|!bank
	STA $0D
	SEP #$20
	LDA $0F
	PHA
	LDA.l $00CA2E|!bank
	STA $0F
	JSL .jml
	PLA
	STA $0F
	REP #$20
	PLA
	STA $0D
	SEP #$20
.skip_save_buffer
	; too early for amk
	;LDA #$05
	;STA $1DF9|!addr
		; done by HardSave
		;LDX $13BF|!addr
		;LDA $1EA2|!addr,x
		;ORA #$40
		;STA $1EA2|!addr,x
++

	LDA !freeram+5
	BEQ +
	if !counterbreak_yoshi == 0
		LDA $1B9B|!addr	; do not touch if $1B9B is set already (hence no effect on parked yoshi)
		BNE +
		; only for respawning(after death just in case) && not a castle level
	endif
	STZ $0DC1|!addr
+

	PLP
	PLY
	LDA #$0000
	SEP #$20
	JML $05D8EB|!bank
.jml
	JML [$000D|!dp]



GeneralInit:
	; correct layer 2 interaction bit
	LDA !freeram+11
	AND #$01
	BEQ +
	LDA !freeram+11
	AND #$FE
	STA !freeram+11
	LDA #$80
	TSB $5B
+
	LDA $141A|!addr
	BNE +
	; first entrance (from ow)
	; save time (cant be done in GeneralInit0)
	LDA $0F31|!addr
	STA !freeram
	LDA $0F32|!addr
	STA !freeram+1
	LDA $0F33|!addr
	STA !freeram+2
	BRA ++
+
	LDA !freeram+5
	BNE ++

	; normal transition (door/pipe/etc)
	PHX
	REP #$10
	LDX $010B|!addr
	LDA.l Table_checkpoint,x
	SEP #$10
	PLX
	CMP #$02
	BCC .normal

++
	; (initial entrance from ow or after death or transition midpt)

	STZ $1493|!addr ; for the "level ender" custom sprite which is often used in boss battles
	STZ $13C6|!addr	; for the "level ender" custom sprite which is often used in boss battles

	; 1) reset mode 7 values for the boss (consistency)
	REP #$20
	STZ $36
;	STZ $38
;	STZ $3A
;	STZ $3C
	SEP #$20
	; recover the freeze state when you enter the level through a pipe
	LDA $71
	CMP #$05
	BEQ .pipe
	CMP #$06
	BNE +++
.pipe
	LDA !freeram+4
	AND #$04
	BEQ .no_freeze
	LDA #$01
	STA $9D
	BRA +++
.no_freeze
	STZ $9D
+++
	; 2) music backup
	LDA.l $008075|!bank
	CMP #$5C
	BEQ +
	; nonamk
	;LDA $0DDA|!addr
	;AND #$3F
	;STA !freeram+6
	BRA .normal
+
	; amk
	LDA $0DDA|!addr
	STA !freeram+6
.normal

	; common (orig)
	LDA #$00
	STA !freeram+5	; this flag is completely used -> reset
	LDA $141A|!addr
	BNE +
	JML $0091AB|!bank
+
	JML $0091B0|!bank


YoshiInit:
	LDA $1B9B|!addr
	ORA !freeram+5
	BNE +
	JML $02A76D|!bank
+
	JML $02A771|!bank


EntranceInit0:
	JSR ScreenIndexAdjust
	LDA $19B8|!addr,x
	STA $17BB|!addr
	JML $05D7C3|!bank


EntranceInit:		; activated by all kind of transitions (normal things like door/pipe, or the retry)
	LDA !freeram+5
	BNE .orig

	LDA $0FF0B4
	CMP #$33	; check if LM 3.00+
	BCC .oldlm
	PHY
	JSL $03BCDC|!bank
	PLY
	BRA +
.oldlm

	LDX $95
	LDA $5B
	AND #$01
	BEQ +
	LDX $97
+
	JSR ScreenIndexAdjust
	LDA $19B8|!addr,x
	STA !freeram+8
	LDA $19D8|!addr,x
	STA !freeram+9
.orig
	LDA $1B93|!addr
	BEQ +
	JML $05D7D9|!bank
+
	JML $05D83B|!bank


ScreenIndexAdjust:
	CPX #$00
	BPL .positive
	LDX #$00
	BRA .ok
.positive
	CPX #$20
	BMI .ok
	LDX #$1F
.ok
	RTS


MidbarHijack:
		LDA $0109|!addr
		BEQ +
		CMP.b #!intro_level+$24	; intro
		BNE .do_nothing ; filters titlescreen, etc
+
	PHX
	REP #$20
	LDA $04
	PHA

	JSR .get_tile_index
	SEP #$20
	LDA !freeram_custobjnum
	DEC
	BMI ++	; this sublevel doesnt have custom midway
	ASL
	TAX
	REP #$20
-
	LDA.l !freeram_custobjdata,x
	CMP $04
	BNE +
	JMP .custom
+
	DEX
	DEX
	BPL -
	; this midway is not custom

++
	REP #$20
	PLA
	STA $04
	SEP #$20

	; noncustom midway
	REP #$10
	LDX $010B|!addr
	LDA.l Table_checkpoint,x
	SEP #$10
	PLX
	CMP #$01
	BEQ +
	CMP #$03
	BCS +
	JSR CalcEntrance	; to the main level's midway
	BRA ++
+
	JSR CalcEntrance_2	; to the current sublevel's midway
++
	JSR HardSave

	; music backup
	LDA.l $008075|!bank
	CMP #$5C
	BEQ +
	; nonamk
	;LDA $0DDA|!addr
	;AND #$3F
	;STA !freeram+6
	BRA ++
+
	; amk
	LDA $0DDA|!addr
	STA !freeram+6
++
-
.do_nothing
	LDA #$05
	STA $1DF9|!addr
	JML $00F2ED|!bank

.custom
	PLA
	STA $04
	LDA.l !freeram_custobjdata+(!max_custom_midway_num*2),x
	STA !freeram+3
	SEP #$20
	PLX
	JSR HardSave
	; music backup
	LDA.l $008075|!bank
	CMP #$5C
	BEQ +
	; nonamk
	;LDA $0DDA|!addr
	;AND #$3F
	;STA !freeram+6
	BRA -
+
	; amk (always reload sample for safety)
	LDA #$FF
	STA !freeram+6
	BRA -


; output: $04 (16bit, index to $7EC800) should be run during the block interaction process
.get_tile_index
	PHY : PHX : PHP
	SEP #$30
	LDA $5B
	AND #$01
	BNE .vert
.horz
	LDA $1933|!addr
	BEQ +
	LDA $9B
	ORA #$10
	BRA ++
+
	LDA $9B
++
	TAX

	LDA $0FF0B4
	CMP #$33	; check if LM 3.00+
	BCC .oldlm
	REP #$20
	LDA $13D7|!addr
	BRA +
.oldlm
	REP #$20
	LDA #$01B0
+
	STA $04
	JSR .multiply

	LDA $9A
	AND #$00F0
	LSR
	LSR
	LSR
	LSR
	CLC
	ADC $04
	STA $04
	LDA $98
	AND #$FFF0
	CLC
	ADC $04
	STA $04

	PLP : PLX : PLY
	RTS
.vert
	LDA $1933|!addr
	BEQ +
	LDA $9B
	CLC
	ADC #$0E
	BRA ++
+
	LDA $9B
++
	ASL
	ORA $99
	STA $05

	LDA $9A
	LSR
	LSR
	LSR
	LSR
	STA $04
	LDA $98
	AND #$F0
	TSB $04

	PLP : PLX : PLY
	RTS


; input:
;	x: a, 8bit, unsigned
;	$04: b, 16bit, unsigned
; output:
;	$04: a*b, 16bit (least significant), unsigned
.multiply
	LDA $00 : PHA
	LDA $02 : PHA
	SEP #$20

	STZ $02

	STX $4202
	LDA $04
	STA $4203
	NOP #4		; waste 8 cycles for multiplication
	REP #$20
	LDA $4216
	STA $00
	SEP #$20

	STX $4202
	LDA $05
	STA $4203
	NOP #4		; waste 8 cycles for multiplication
	REP #$20
	LDA $4216
	CLC
	ADC $01
	STA $01

	LDA $00
	STA $04
	PLA : STA $02
	PLA : STA $00
	RTS



; always spawn the midway bar if another checkpoint is being activated (i.e. every checkpoint has the same priority) 
MidbarSpawn:
		LDA $0109|!addr
		BEQ +
		CMP.b #!intro_level+$24	; intro
		BNE .true	; filters titlescreen, etc
+
	LDA $1EA2|!addr,x
	AND #$40
	BNE +
	LDA $13CE|!addr
	BNE +
.true
	JML $0DA69E|!bank
+
	PHX
	PHP
	REP #$10
	LDX $010B|!addr
	LDA.l Table_checkpoint,x
	PLP
	PLX
	CMP #$01
	BCS +
	; main midway settings
	LDA $13BF|!addr
		BNE .cnt
		; assumption = level 0 <=> intro
		REP #$20
		LDA $01E762	;check if lm's shift+f8 hack is installed
		CMP #$EAEA
		BNE +++
		LDA.w #!intro_level|$0100
		BRA ++
+++
		LDA.w #!intro_level
		BRA ++
.cnt
	REP #$20
	AND #$00FF
	CMP #$0025
	BCC ++
	CLC
	ADC #$00DC
	BRA ++
+
	; sublevel midway settings
	REP #$20
	LDA $010B|!addr
++
	ORA #$0C00
	EOR !freeram+3
	AND #$FBFF
	;CMP !freeram+3
	SEP #$20
	BNE .true
	JML $0DA6B0|!bank


CheckMidwayEntrance:
	LDA $1EA2|!addr,x
	AND #$40
	STA $13CF|!addr	; for no yoshi intro
	BEQ .normal	; also if no checkpoint is obtained, midway entrances can never be the case (vanilla)
	PHX
	TXA
	ASL
	TAX
	LDA.l !freeram_checkpoint+1,x
	PLX		; fixed the bug after v2.03
	AND #$0A
	CMP #$08		; check the midway exit bit
	BEQ +
.normal
	; normal target
	JML $05D9EC|!bank
+
	; midway target
	LDA $1EA2|!addr,x
	AND #$40
	JML $05D9DE|!bank	; go to the routine called "secondary_exits"



InitCheckpointRam:
	LDX #$BE
	LDY #$5F
-
	TYA
	CMP #$25
	BCC +
	CLC
	ADC #$DC
+
	STA !freeram_checkpoint,x
	LDA #$00
	ADC #$00
	STA !freeram_checkpoint+1,x
	DEX
	DEX
	DEY
	BPL -

		; intro
		LDA.b #!intro_level
		STA !freeram_checkpoint
		LDA $01E762	;check if lm's shift+f8 hack is installed
		CMP #$EA
		BNE ++
		LDA #$01
		BRA +++
++
		LDA #$00	;LDA.b #!intro_level>>8
+++
		STA !freeram_checkpoint+1

	; orig
	LDA #$EB
	LDY #$00
	JML $0096CF|!bank



VanillaMidwayDestFix:
	LDA $141A|!addr		; first entrance -> vanilla ok
	BEQ .orig2
	LDA.l $05D9E3|!bank		; check if lm hack is applied
	CMP #$22
	BNE .orig2
	LDA.l !freeram+5	; only for respawning (when !freeram+3 is the target dest) ; todo? -> no (because doors in wing levels work differently)
	BEQ .orig2
	LDA.l !freeram+4
	AND #$0A
	CMP #$08		; check the midway exit bit
	BEQ .cnt
.orig2
	JMP .orig
.cnt
	LDA $03
	PHA
	LDA $04
	PHA
	LDA $05
	PHA

	LDA.l $05D9E6|!bank
	STA $05
	REP #$30
	LDA.l $05D9E4|!bank
	CLC
	ADC #$000A
	STA $03
	LDA [$03]
	PHA
	INC $03
	LDA [$03]
	STA $04
	PLA
	STA $03
	LDA !freeram+3
	AND #$01FF
	TAY
	SEP #$20

	; set the screen number of midway entrance
	LDA [$03],y
	AND #$10
	STA $01		; 5th bit

	LDA $F400,y
	LSR #4
	ORA $01
	STA $01		; 1-4th bit (0-F)

	LDA [$03],y
	BIT #$20
	BNE .ret	; separate midway -> already set correctly

	; correct the slippery/water for vanilla midway
	LDA #$C0
	TRB $192A|!addr
	LDA $DE00,y
	AND #$C0
	ORA $192A|!addr
	STA $192A|!addr

	; correct the camera position for vanilla midway
	LDA #$00
	XBA
	LDA $F400,y
	STA $02
	AND #$03
	TAX
	LDA $D70C,x
	STA $20
	LDA $02
	AND #$0C
	LSR #2
	TAX
	LDA $D708,x
	STA $1C

	; correct the position if x/y pos method 2 is used
	LDA $D97D
	CMP #$22
	BNE .ret

	; (now compatible with lm 3.00's routine at $05DD30)
	LDA $D980
	STA $05
	LDA $D97E
	CLC
	ADC #$04
	STA $03
	LDA $D97F
	ADC #$00
	STA $04
	JSL .jml
.ret
	PLA
	STA $05
	PLA
	STA $04
	PLA
	STA $03
.orig
	REP #$10
	LDA $01
	JML $05D9F0|!bank
.jml
	JML [$0003|!dp]



StartSelectExit:
		; assumption = level 0 <=> intro
		LDA $13BF|!addr
		BEQ ++
	PHX
	JSR GetPromptType
	PLX
	CMP #$03
	BEQ +
++
	LDY $13BF|!addr
	LDA $1EA2|!addr,y
	JML $00A267|!bank
+
	JML $00A269|!bank



Layer2FirstFrameFix:
	LDA.l $058417|!bank,x
	BPL +
	LDA #$01
	STA !freeram+11
	LDA.l $058417|!bank,x
	AND #$7F
	JML $058524|!bank
+
	LDA #$00
	STA !freeram+11
	LDA.l $058417|!bank,x
	JML $058524|!bank


org $00D0D8
if !lose_lives
	DEC $0DBE|!addr
else
	NOP #3
endif




; handling compatibility (sprite init facing fix)
if read1($05D971) == $22
	print "Warning: You already inserted Sprite Initial Facing patch. The setting in retry_table.asm will be ignored."
else
	org $05D971
	autoclean JML InitFace1

	org $05D9FC
	autoclean JML InitFace2

	org $05DA03
	autoclean JML InitFace3

	freecode
	InitFace1:
		if !sprite_initial_face_fix == 0
			PHX
			LDX $010B|!addr
			LDA.l Table_checkpoint,x
			PLX
			CMP #$02
			BCS ++
			LDA !freeram+5
			BEQ +
		++
		endif
		LDA $94
		STA $D1		; new
		LDA $96		; new
		STA $D3		; new
		LDA $97		; new
		STA $D4		; new
		LDA.l $05D758|!bank,x
		STA $D2		; new
		JML $05D975|!bank
	+
		LDA.l $05D758|!bank,x
		JML $05D975|!bank

	InitFace2:
		STA $95
		if !sprite_initial_face_fix == 0
			PHX
			LDX $010B|!addr
			LDA.l Table_checkpoint,x
			PLX
			CMP #$02
			BCS ++
			LDA !freeram+5
			BEQ +
		++
			LDA $95
		endif
		STA $D2		;new
	+
		JML $05DA17|!bank

	InitFace3:
		STA $97
		STA $1D
		if !sprite_initial_face_fix == 0
			PHX
			LDX $010B|!addr
			LDA.l Table_checkpoint,x
			PLX
			CMP #$02
			BCS ++
			LDA !freeram+5
			BEQ +
		++
		endif
		STA $D4		;new
	+
		LDA $97
		JML $05DA07|!bank
endif



org $05D842
	autoclean JML mmp_main

ORG $05D9DE
	autoclean JML secondary_exits	; additional code for secondary exits

org $048F74
	autoclean JML reset_midpoint	; hijack the code that resets the midway point

org $05DAA3
	autoclean JSL no_yoshi		; make secondary exits compatible with no yoshi intros

freecode

mmp_main:
	LDA $141A|!addr		; skip if not the opening level
	BNE .return
	LDA $1B93|!addr		; prevent infinite loop if using a secondary exit
	BNE .return
	LDA $0109|!addr
	BEQ +
	CMP.b #!intro_level+$24
	BNE .code_05D8A2	; filters titlescreen, etc
		; assumption = level 0 <=> intro
		LDA $1EA2|!addr		; check the midway flag
		AND #$40
		BNE ++
		LDA.b #!intro_level+$24
		BRA .code_05D8A2
	++
		LDX #$00
		LDY #$00
		BRA ++
+
	REP #$20
	STZ $1A
	STZ $1E
	SEP #$20
	JSR get_translevel
	TAY
	ASL
	TAX
	LDA $1EA2|!addr,y
	AND #$40
	BEQ .return		; check if any midway is activated previously
++
	LDA.l !freeram_checkpoint+1,x
	AND #$02		; check the 2ndary exit bit
	BNE .secondary_exit
	REP #$20
	LDA.l !freeram_checkpoint,x
	AND #$01FF
	STA $0E			; store level number
	JML $05D8B7|!bank		; no need to restore the processr mode
.return
	JML $05D847|!bank
.code_05D8A2
	JML $05D8A2|!bank
.secondary_exit
	LDA.l !freeram_checkpoint,x
	STA $19B8|!addr		; store secondary exit number (low)
	LDA.l !freeram_checkpoint+1,x
	ORA #$04
	STA $19D8|!addr		; store secondary exit number (high and properties)
	STZ $95			; set these to 0
	STZ $97
	JML $05D7B3|!bank		; return and load level at a secondary exit position

secondary_exits:
	LDX $1B93|!addr		; check if using a secondary exit for this
	BNE .return		; if so, skip the code that sets mario's x position to the midway entrance
	STA $13CF|!addr		; restore old code
	LDA $02			; restore old code
	JML $05D9E3|!bank		; return
.return	
	JML $05D9EC|!bank		; return without setting mario's x to the midway entrance

reset_midpoint:
	STA $1EA2|!addr,x		; restore old code
	INC $13D9|!addr
	TXA
	ASL
	TAX
	LSR
	CMP #$0025
	BCC +
	CLC
	ADC #$00DC
+
	STA !freeram_checkpoint,x
	JML $048F7A|!bank		; return

no_yoshi:
	STZ $1B93|!addr		; reset this (prevents glitch with no yoshi intros and secondary entrances)
	LDA $05D78A|!bank,x		; restore old code
	RTL

get_translevel:
	LDY $0DD6|!addr		;get current player*4
	LDA $1F17|!addr,y		;ow player X position low
	LSR #4
	STA $00
	LDA $1F19|!addr,y		;ow player y position low
	AND #$F0
	ORA $00
	STA $00
	LDA $1F1A|!addr,y		;ow player y position high
	ASL
	ORA $1F18|!addr,y		;ow player x position high
	LDY $0DB3|!addr		;get current player
	LDX $1F11|!addr,y		;get current map
	BEQ +
	CLC : ADC #$04		;if on submap, add $0400
+	STA $01
	REP #$10
	LDX $00
	LDA !7ED000,x		;load layer 1 tilemap, and thus current translevel number
	STA $13BF|!addr
	SEP #$10
	RTS


if !use_custom_midway_bar
	; copy pasted from objectool (object 2D) by imamelia
	org $0DA415		; x6A615 (hijack normal object loading routine)
		autoclean  JML NewNormObjects	; E2 30 AD 31 19
		NOP			;

	freecode
	NewNormObjects:	;
		SEP #$30		;
		LDA $5A		; check the object number
		CMP #$2D	; if it is equal to 2D...
		BEQ CustNormObjRt	; then it is a custom normal object

	NotCustomN:	;
		LDA $1931|!addr	; hijacked code
		JML $0DA41A|!bank	;

	CustNormObjRt:	;
		LDA $00
		PHA
		LDY #$00		; start Y at 00
		LDA [$65],y	; this should point to the next byte
		STA $5A		; the first new settings byte is the new object number
		INY		; increment Y to get to the next byte
		LDA [$65],y	;
		STA $00		; the second new settings byte
		INY		; increment Y again...
		TYA		;
		CLC		;
		ADC $65		; add 2 to $65 so that the pointer is in the right place,
		STA $65		; since this is a 5-byte object (and SMW's code expects them to be 3 bytes)
		LDA $66		; if the last byte overflowed...
		ADC #$00	; add 1 to it
		STA $66		;

		PHB		;
		PHK		;
		PLB		; change the data bank
		JSR Object2DRt	; execute codes for custom normal objects
		PLB		;
	ReturnCustomN:	;
		PLA
		STA $00
		JML $0DA53C|!bank	; jump to an RTS in bank 0D

	Object2DRt:
		; convert the value to the corresponding entrance
		LDA $01
		PHA
		STZ $01
		LDA $5A
		CMP #$50
		BCS .mident
		CMP #$40
		BCS .main
		CMP #$20
		BCS +
		AND #$01
		ORA #$02	; secondary
		BRA ++
	+
		AND #$01
		ORA #$0A	; secondary + water
	++
		STA $01
		LDA $5A
		AND #$1E
		ASL #3
		TSB $01
		BRA .conv_end
	.main
		AND #$01
		STA $01
		BRA .conv_end
	.mident
		AND #$01
		ORA #$08	; midway
		STA $01
	.conv_end
		LDA !freeram_custobjnum
		CMP #!max_custom_midway_num	; custom midways more than allowed wont be generated
		BCS .end
		INC
		STA !freeram_custobjnum
		DEC
		ASL
		TAX
		LDA $57
		REP #$20
		AND #$00FF
		CLC
		ADC $6B
		SEC
		SBC #$C800
		STA.l !freeram_custobjdata,x	; pos (index to $7EC800)
		LDA $00
		STA.l !freeram_custobjdata+(!max_custom_midway_num*2),x	; entrance info
		SEP #$20

		; spawn check
		REP #$20
		LDA !freeram+3
		EOR $00
		AND #$FBFF
		SEP #$20
		BEQ .end

		; spawn midway
		LDY $57
		LDA #$38
		STA [$6B],y
		LDA #$00
		STA [$6E],y
		; spawn the left tile
		LDA $57
		AND #$0F
		BEQ .end	; skip if it's on the screen border to prevent underflow
		DEY
		LDA #$35
		STA [$6B],y
		LDA #$00
		STA [$6E],y
	.end
		PLA
		STA $01
		RTS
endif



; initial lives
if !initial_lives < 1
	!initial_lives = 1
endif
if !initial_lives > 99
	!initial_lives = 99
endif
org $009E25
	db !initial_lives-1


; midway powerup
org $00F2E2
if !midway_powerup
	db $D0
else
	db $80
endif


; counterbreak
org $00A0CA
	if !counterbreak_powerup
		STZ $19
		STZ $0DB8|!addr,x
	else
		LDA $19
		STA $0DB8|!addr,x
	endif
	if !counterbreak_coin
		STZ $0DBF|!addr
		STZ $0DB6|!addr,x
	else
		LDA $0DBF|!addr
		STA $0DB6|!addr,x
	endif
	if !counterbreak_yoshi
		STZ $0DBA|!addr,x
		BRA +
		NOP #6
	+
	else
		LDA $0DC1|!addr
		BEQ +
		LDA $13C7|!addr
	+
		STA $0DBA|!addr,x
	endif
	if !counterbreak_powerup
		STZ $0DC2|!addr
		STZ $0DBC|!addr,x
	else
		LDA $0DC2|!addr
		STA $0DBC|!addr,x
	endif
	;print pc
org $0491B8
	if !counterbreak_coin
		STZ $0DB6|!addr,x
		STZ $0DBF|!addr
	else
		LDA $0DB6|!addr,x
		STA $0DBF|!addr
	endif
	;print pc
org $0491C4
	if !counterbreak_powerup
		STZ $0DB8|!addr,x
		STZ $19
	else
		LDA $0DB8|!addr,x
		STA $19
	endif
	if !counterbreak_yoshi
		STZ $0DBA|!addr,x
		STZ $0DC1|!addr
		STZ $13C7|!addr
		STZ $187A|!addr
	else
		LDA $0DBA|!addr,x
		STA $0DC1|!addr
		STA $13C7|!addr
		STA $187A|!addr
	endif
	if !counterbreak_powerup
		STZ $0DBC|!addr,x
		STZ $0DC2|!addr
	else
		LDA $0DBC|!addr,x
		STA $0DC2|!addr
	endif
	;print pc



; small sram patch
if !sa1
	; do nothing
	print "Warning: SA-1 detected. Use the BW-RAM plus patch to make the midway state saved to SRAM. See the second item of Compatibility Management in README."
else
	if read1($009B42) == $04
		; sram_plus
		; recover
		org $009B3F
			db $D0,$2C
		org $009E13
			db $22,$AD,$DA,$84
		org $00A101
			db $22,$AD,$DA,$84
		print "Warning: SRAM Plus detected. Use that patch to make the midway state saved to SRAM. See the third item of Compatibility Management in README."
	else
		if !midway_sram
			!SRAMSize = #$02

			macro LoadIfStarted()
				LDA $8A
				PHA
				; vanilla
				SEP #$30
				PHB

				LDX $010A
				LDA #$00
				PHA
				PLB
				PHK
				PEA .pos-1
				PEA $84CE
				JML $809DB5
			.pos
				PLB
				REP #$30
				LDX $8A
				PLA
				STA $8A
				CPX #$5A5A
				BNE INITSRAM
			endmacro

			org $00FFD8
				db !SRAMSize	

			org $009BC9
				autoclean JML SaveGame

			org $009E13
				autoclean JSL LoadGame
			org $00A101
				autoclean JSL LoadGame

			org $009B3F
				autoclean JML EraseGame

			freecode
			SAVETable:					;Amount of bytes to save : Address to save : SRAM address to save to
				dw $00C0 : dl !freeram_checkpoint : dl $700400
				dw $0000	; End
			INC:
				dw $0000 : dw $0400 : dw $0800		;Amount of bytes to increase by when using a different file (1-3)
			BINC:
				db $00 : db $00 : db $00			;Amount of bytes to increase by when using a different file (1-3)

			macro GetReady()
				LDA SAVETable+2,x	;\ Get RAM address
				STA $00			;/
				LDA SAVETable+5,x	;\
				CLC			; | Get SRAM address
				ADC $0B			; |
				STA $03			;/
				SEP #$20		;
				LDA SAVETable+4,x	;\ Get bank byte for RAM
				STA $02			;/
				LDA SAVETable+7,x	;\
				CLC			; | Get the bank byte for SRAM
				ADC $0D			; |
				STA $05			;/
				REP #$20		;
				LDY #$0000		; Y = #$0000
			endmacro

			SaveGame:
				PHK			;\ Set DBR
				PLB			;/
				LDY $010A		; Get game file 
				LDA BINC,y		;\ Get bank byte to increase by
				STA $0D			;/
				TYA			;\
				ASL A			; | Y*2
				TAY			;/
				REP #$30		; A, X, Y = 16-bit
				LDA INC,y		;\ Read low and high byte to increase by
				STA $0B			;/
				LDX #$0000		; X = #$0000
			.setup
				LDA SAVETable,x		;\ Get amount of bytes to write
				BEQ .end		;/
				STA $0E			; Store to scratch RAM
			%GetReady()
			.loop
				SEP #$20		;
				LDA [$00],y		; Load RAM
				STA [$03],y		; Store to SRAM
				REP #$20		;
				INY			; Y+1
				DEC $0E			; Check if we wrote to all SRAM
				BNE .loop		; Back if we haven't
				TXA			; X->A
				CLC			;\
				ADC #$0008		;/
				TAX			; A->X
				BRA .setup		; Back we go

			.end
				SEP #$30		;
				PHB			;\
				PHA			; | Set DBR
				PLB			;/
				LDX $010A		; Get game file
				JML $809BCF		;


			LoadGame:
				;STZ $0DD5		;\ Restore old code
				;STZ $0DB3		;/
				PHB			;
				PHK			;
				PLB			;
				LDY $010A		; Get game file 
				LDA BINC,y		; Get bank byte to increase by
				STA $0D			;
				TYA			;\
				ASL A			; | Y*2
				TAY			;/
				REP #$30		; A, X, Y = 16-bit
				LDA INC,y		;\ Read low and high byte to increase by
				STA $0B			;/
			%LoadIfStarted()
				LDX #$0000
			.setup
				LDA SAVETable,x
				BEQ .end
				STA $0E
			%GetReady()
			.loop
				SEP #$20
				LDA [$03],y
				STA [$00],y
				REP #$20
				INY
				DEC $0E
				BNE .loop
				TXA
				CLC
				ADC #$0008
				TAX
				BRA .setup

			.end
			EndLoad:
				SEP #$30
				PLB
				;JML $809E62
				; orig
				JSL $84DAAD
				RTL


			EraseGame:
				BEQ +
				JML $809B6D           

			INITSRAM_BIT:		; FIXED
				db $04,$02,$01
			INITSRAM:
				SEP #$30
				LDX $010A
				LDA.l INITSRAM_BIT,x
				BRA INITIT

				+
				PHB			;\
				PHK			; | Set DBR
				PLB			;/
				LDA $0DDE		;\ If we don't want to erase any file, don't even waste time
				BEQ EndIt		;/
			INITIT:				;
				STA $0D			; Store the files we want to erase in $0D
				REP #$10		;
			Redo:				;
				SEP #$20		;
				LDY #$0002		;\
				LDX #$0000		; |
				LDA $0D			; |
				BEQ EndIt		; |
				AND #$01		; |
				BNE Clear		; |
				DEY			; | Erase the correct SRAM addr.
				LDA $0D			; |
				AND #$02		; |
				BNE Clear		; |
				DEY			; |
				LDA $0D			; |
				AND #$04		; |
				BNE Clear		;/
			EndIt:
				SEP #$20		;
				LDA $0DDE		;\
				CMP #$0F		; | If this is not the erase game mode, branch
				BEQ EndLoad		;/
				PLB			;
				SEP #$10		;
				LDY #$02		; Old code
				JML $809B43  		; Return

			Clear:
				TRB $0D
				LDA SAVETable+7,x	;\
				CLC			; | Get the bank byte for SRAM
				ADC BINC,y		; |
				STA $05			;/
				REP #$20		; A, X, Y = 16-bit
				LDA SAVETable,x		;\ 
				BEQ Redo		; | Read size
				STA $0E			;/
				PHY			; FIXED
				TYA			;\
				AND #$00FF		; |
				ASL A			; | Y*2
				TAY			;/
				LDA SAVETable+5,x	;\
				CLC			; | Get SRAM address
				ADC INC,y		; |
				STA $03			;/
				LDY #$0000		; Y = #$0000
			.loop
				SEP #$20		;
				LDA #$00		;\ Write zero to SRAM
				STA [$03],y		;/
				REP #$20		;
				INY			; Y+1
				DEC $0E			;\ Loop until we wrote everything
				BNE .loop		;/
				TXA			;\
				CLC			; |
				ADC #$0008		; | Get the next table entry
				TAX			; |
				PLY			; FIXED
				SEP #$20		;/
				BRA Clear+2		;

		else
			org $00FFD8
				db $01

			org $009BC9
				db $8B,$4B,$AB,$AE

			org $009E13
				autoclean JSL LoadGame
			org $00A101
				autoclean JSL LoadGame

			org $009B3F
				db $D0,$2C,$A0,$02
			
			freecode
			LoadGame:
				JSL $84DAAD
				RTL
		endif
	endif
endif



;HDMA off
org $0081AA
autoclean JML HDMA_off

freecode
HDMA_off:
	LDA $0100|!addr
	CMP #$10
	BEQ +
	CMP #$11
	BEQ +
	CMP #$16
	BCC ++
	CMP #$1A
	BCS ++
+
	STZ $0D9F|!addr
++
	LDA #$80
	STA $2100
	JML $0081AF



endif
endif
