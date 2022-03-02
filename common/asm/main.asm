incsrc "sa1def.asm"		;sa-1 defines
incsrc "pointer_caller.asm"
; ---------------------------------------------------
; tool relevant information.
; I'd advice against changing stuff in this hijack unless
; you also plan to update the tool itself
; ---------------------------------------------------
org $02FFE2
	db "STSD"						;header!
	incbin "_versionflag.bin"	;byte 1 is version number 1.xx
										;byte 2 are flags ---- ---l
                              ; l = per level sprites code inserted
                              ;byte 3,4 reserved
                              
;$02FFEA
TableLoc:
   	db $FF,$FF,$FF,$FF
	                    
;$02FFEE
	autoclean dl TableStart
	
	; yeah, kinda wasting 4 byte here by having the tables twice.
	; but the above makes access easier and these are for cleanup.
   if !PerLevel = 1
        autoclean dl PerLevelLvlPtrs
		dl $FFFFFF
		dl $FFFFFF
		dl $FFFFFF
   else
        dl $FFFFFF
		dl $FFFFFF
		dl $FFFFFF
		dl $FFFFFF
   endif
	
	; Use this for custom status pointer tables
	autoclean dl CustomStatusPtr
	
;I think asar warns you for bank crossing anyway, but no harm done.
warnpc $038000

InitSpriteTables = $07F7D2|!BankB

org $0FFFE0|!BankB
!SprCountWarnMsg = read1($0FFFE0)
	if !Disable255SpritesPerLevel == 0
		db !SprCountWarnMsg&$FE		;clear the lowest bit at PC 0x801E0 to disable the sprite count warning message as per LM's help file
	elseif !SprCountWarnMsg&$01 == $00
		db !SprCountWarnMsg|$01		;or set it if it was unset before and we're disabling 255 sprites per level
	endif


; make it so the full level number can be read from $010B
; this part will not be removed on cleanup since other
; level based tools may also use this hijack
org $05D8B9|!BankB
	JSR Levelnum 
org $05DC46|!BankB
	Levelnum:
	LDA $0E
	STA $010B|!Base2
	ASL A
	RTS
	
; ---------------------------------------------------
; original sprite_tool hijacks, credit to roy.	
; ---------------------------------------------------


; patch goal tape init to get extra bits in $187B
if !EXLEVEL
	org $01C089|!BankB
		LDA !extra_bits,x
		STA !187B,x
		LDA !14D4,x
		if !SA1
			NOP #2		; extra_bits should use absolute addressing instead of long if on sa-1, therefore 1 more NOP is needed
		else
			NOP			
		endif
else
	org $01C089|!BankB
		LDA !extra_bits,x
		if !SA1
			BRA + : NOP #3 : +		; same as above
		else
			BRA + : NOP #2 : +
		endif
		STA !187B,x
endif

; RPG Hacker: Fixes a soft-lock related to shooters by replacing a
; a JSR with a JMP (solution proposed by MarioFanGamer)
org $02A8D8|!BankB
	JMP $AB78
	
;hammer bro init pointer to null if it's using its original pointer
if read2($0182B3) == $87A7
	org $0182B3|!BankB
		db $C2,$85
endif
;status routine wrapper
org $01D43E|!BankB
	JSR $8133		;goto execute pointer for sprite status ($14C8)
	RTL

; store extra bits separate from $14D4
org $02A963|!BankB
	JML SubLoadHack
	NOP
org $02A94B|!BankB
	JML SubLoadHack2
	NOP

; sprite init call subroutine
org $018172|!BankB
	JSL SubInitHack
	NOP

; sprite code call subroutine					
org $0185C3|!BankB
	JSL SubCodeHack
	NOP

; clear init bit when changing sprites
org $07F785|!BankB
	JML EraserHack
	NOP

org $018151|!BankB
	JML EraserHack2
	NOP
	
org $02A866|!BankB
	JML SubGenLoad

if !SA1 = 0
	org $02ABA0|!BankB
		JML SubShootLoad
		NOP
	SubShootLoadReturn:
else
	org $02ABA2
		JML SubShootLoad
		NOP #2
	SubShootLoadReturn:
endif

org $02B395|!BankB
	JML SubShootExec
	NOP
	
org $02AFFE|!BankB
	JSL SubGenExec
	NOP
	
org $0187A7|!BankB
	JML SetSpriteTables
	
org $018127|!BankB
	JML SubHandleStatus
	
org $02A9C9|!BankB
	JML InitKeepextra_bits
	
org $02A9A6|!BankB
	JML TestSilverCoinBit
	NOP
; ---------------------------------------------------
; dev stuff / LM Hijacks
; ---------------------------------------------------

; Starting in version 1.80, Lunar Magic allows sprites to have a user-defined size for the number of bytes
; they take up in the sprite list for the level. These extra bytes can be set when adding a sprite manually.

; Typically the sizes would be set by a 3rd party utility. To set them yourself, you must create and store a
; 0x400 byte table containing the sprite sizes somewhere inside the ROM (first 0x100 bytes are for sprites
; 00-FF that use an extra bit of 0, next 0x100 are for sprites 00-FF that use an extra bit of 1, etc).
; Place the SNES address for this table at 0x7750C PC. Then put 0x42 at 0x7750F to enable use of the table by Lunar Magic.

org $0EF30C					;
	autoclean dl Size		; pointer to sprite size table
	db $42					; enable LM custom sprite size 
		
	
freedata
Size:
	incbin "DefaultSize.bin"
	incbin "_CustomSize.bin"
	

org $02A846|!BankB
	JML SprtOffset
	NOP						; not necessary but still...

; 16bit sprite data pointer / 8bits with pagination
; stuff by Telinc1, Super Maks 64 and boldowa
if !SA1 == 0
	org $028B1D|!BankB
		JMP LoadSpriteInLevel

	; From Giepy
	org $02AC7A|!BankB
		JSR	LoadSpriteInInit
		JSR	LoadSpriteInInit

	; From Giepy
	org $02ACBA|!BankB
		JSR	LoadSpriteInInit
		JSR	LoadSpriteInInit
		
	; Empty bank2 area, same used in the fastROM hijack
	; 1F bytes used
	org $02B5EC|!BankB
	; From Giepy
	LoadSpriteInInit:
		PEI ($CE)
		JSR $A802
		PLA
		STA $CE
		PLA
		STA $CF
		RTS
	LoadSpriteInLevel:			;extended sprite data
		PEI ($CE)
		JSR $A7FC
		PLA
		STA $CE
		PLA
		STA $CF
		; return
		JMP $8B20

	DisplaceIndex:
		DEX
		DEY
		DEY
		JML SprtOffset
	warnpc $02B60E|!BankB

	org $02ABEF|!BankB
		JMP DisplaceIndex
		
	org $02A9DB|!BankB
		JMP DisplaceIndex
		
	if !EXLEVEL == 0		
		org $02ABF3|!BankB
			db $7F	;be able to load 128 sprites without issue
	endif

	if !Disable255SpritesPerLevel == 0
		; sa1 already fixes these
		macro remap1938(addr, nop_count)
			l_<addr>:
				pushpc
				
				org $<addr>
					JML .remap
					rep <nop_count> : NOP
					.back
				pullpc
				
				.remap
					PHX
					TYX
					LDA #$00
					STA.l !7FAF00,x
					PLX
					JML .back
		endmacro
			
		org $02A856|!BankB
			autoclean JML CODE_02A856
			NOP #6
		
		org $02A936|!BankB
			autoclean JML NSprite_FixY2 : NOP
		
		org $02A8BB|!BankB
			autoclean JML CODE_02A8BB : NOP
			
		org $02FAE9|!BankB
			autoclean JML CODE_02FAE9
			
		org $02ABF2|!BankB
			autoclean JML ClearIt
	endif
else
	; I could fit this inside the sa1 hijack, but I don't think that's a good idea
	; So I got a few bytes more to fix this in and left that untouched
	; only 3 bytes left that don't touch sprite tables
	org $02A9D7|!BankB
		JMP NSprite_FixY3_Displacement
	
	; Empty bank2 area, same used in the fastROM hijack
	; 15 bytes used
	org $02B5EC|!BankB
		NSprite_FixY3_Displacement:
			; restore
			; notice I didn't restore INY, that's so I don't have to DEY twice, SprtOffset needs it at the beginning
			LDX $02
			
			; sa1 restore
			; notice I didn't restore INX, that's because SprtOffset will do that
			PHY
			SEP #$10
			REP #$10
			PLY
			PLA
			PLA
			
			; displacement back to the beginning
			DEY
			JML SprtOffset
	warnpc $02B5FB|!BankB
endif
 
; ---------------------------------------------------
; 80% original sprite_tool code, credit to roy.	
; 20% edits by Jack for sprites B0-BF being on
;     individual levels.
; --------------------------------------------------- 
freecode
	print "Freecode at ",pc	

if !SA1 == 0 && !Disable255SpritesPerLevel == 0
	%remap1938(01AC9C,1)
	%remap1938(02AB99,1)
	%remap1938(02D088,1)
	%remap1938(02FF15,1)
	%remap1938(038712,1)
	%remap1938(03B8BA,1)

	NSprite_FixY2:
		LDX $02
		LDA #$00
		STA.l !7FAF00,x
		JML $02A93B|!BankB ; rts

	ClearIt:
		LDX #$FF
		LDA #$00
		STA.l !7FAF00,x
	-	STA.l !7FAF00-1,x
		DEX
		BNE -
		JML $02ABFA|!BankB

	CODE_02FAE9:
		LDA #$00
		STA.l !7FAF00,x
		PLX
		JML $02FAED|!BankB

	CODE_02A856:
		LDA.l !7FAF00,x
		BNE +
		INC
		STA.l !7FAF00,x
		STX $02
		JML $02A860|!BankB
	+
		BRA SprtOffset
	
	CODE_02A8BB:
		LDA #$00
		STA.l !7FAF00,x
		;BRA SprtOffset
endif

SprtOffset:
	; move index to sprite data 0
	; builds size index as 000000EE NNNNNNNN
	DEY
	; byte 0 format YYYYEEsy, EE = Extra Bits
	LDA [$CE],y
	LSR #2
	AND #$03
	XBA
	; sprite number byte shift
	INY #2
	LDA [$CE],y
	; restore
	DEY #2

	PHP
if !SA1
	REP #$30
else
	REP #$10
endif
	PHX
	TAX
	TYA
	; size table is 8-bits
	; basically sprite data index + Size shift
	; then shifts 24bit pointers at CE, so y is always 0
if !SA1
	SEP #$20
endif
	CLC
	ADC.L Size,x
if !SA1
	XBA
	ADC #$00
	XBA
	REP #$30
else
	; pagination at 80 so we don't have to deal with
	; in place shifts like iny / etc on the rest of the code
	; could be higher than 80, could be FF-(max LM supported sprite data)
	; but it doesn't matter and dealing with 80 is easier because N flag
	BPL +
	CLC
	ADC $CE
	STA $CE
	
	LDA #$00
	ADC $CF
	STA $CF
	
	LDA #$00
	XBA
	LDA #$00
+
endif
	TAY
	PLX
	PLP
	
	; restore code
	INX
	JML $02A82E|!BankB			; return to loop

SubLoadHack:
	%debugmsg("SubLoadHack")
	PHA
	AND #$0D
	STA !extra_bits,x
	AND #$01
	STA !14D4,x
	; extra bits parts, format: YYYYEEsy, EE = Extra bits
	; loaded for Size table indexing format
	LDA $01,s
	LSR #2
	AND #$03
	XBA
	; A = 000000EE NNNNNNNN (index to size table)
	; EE = extra bits
	; NNNNNNNN = sprite num
	LDA $05
	STA !new_sprite_num,x
	
	; if size >= 8 (3 usual bytes + 5 extra bytes) then it should the new extra byte system
	; processor flag X untoggled here (16bits mode) for sa1
if !SA1 == 0
	REP #$10
endif
	PHX
	TAX
	LDA.l Size,x
	PLX
if !SA1 == 0
	SEP #$10
endif
	; < 4 no extra byte
	CMP #$04
	BCC .skipExtraByte
	CMP #$08
	BCS .setSpriteDataPointer
	
	PHY
	; move sprite data pointer to extra bytes
	INY #3
	LDA [$CE],y
	STA !extra_byte_1,x
	INY
	LDA [$CE],y
	STA !extra_byte_2,x
	INY
	LDA [$CE],y
	STA !extra_byte_3,x
	INY
	LDA [$CE],y
	STA !extra_byte_4,x
	; move sprite data pointer back to the start
	PLY
	PLA
	JML $02A968|!BankB
.setSpriteDataPointer
	PHY
	
	; move to sprite data's extra byte portion
	INY #3
	TYA
	CLC
	ADC $CE
	STA !extra_byte_1,x
	LDA #$00
	ADC $CF
	STA !extra_byte_2,x
	; bank
	LDA #$00
	ADC $D0
	STA !extra_byte_3,x
	
	PLY
.skipExtraByte 
	PLA
	JML $02A968|!BankB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; convert regular sprite to custom sprite and call initialization
; routine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubInitHack:
	%debugmsg("SubInitHack")

	LDA #$08
	STA !14C8,x

if !EXLEVEL
	LDA !9E,x
	CMP.b #$7B
	BEQ .R
endif
	
	LDA !extra_bits,x
	AND #!CustomBit
	BNE .IsCustom
.R		
	RTL
.IsCustom
	JSL SetSpriteTables
	LDA !new_code_flag
	BEQ .R

	PLA	;pull lower 16-bit address
	PLA

	PEA $85C1
	LDA #$01
	JML [!Base1]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; call main code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


SubCodeHack:
	%debugmsg("SubCodeHack")
	STZ $1491|!Base2
	
if !EXLEVEL
	LDA !9E,x
	CMP #$7B
	BEQ .returnNormal
endif

	LDA !extra_bits,x
	AND #!CustomBit
	BNE .IsCustom
	LDA !9E,x
.returnNormal
	RTL
.IsCustom
	LDA !new_sprite_num,x
	JSR GetMainPtr

	PLA
	PLA

	PEA $85C1
	LDA !14C8,x
	JML [!Base1]

GetMainPtr:
	%debugmsg("GetMainPtr")
	PHB
	PHK
	PLB
	PHP
	REP #$30
	AND #$00FF
	
   if !PerLevel = 1
      CMP #$00B0
      BCC .normal
      CMP #$00C0
      BCC .perlevel
   .normal
   endif
   
	ASL A
-	ASL #3
	TAY

	LDA TableStart+$0B,y
	STA $00
	LDA TableStart+$0C,y
	STA $01
	PLP
	PLB
	RTS

	
   if !PerLevel = 1
	.perlevel
		JSR GetPerLevelAddr
		BNE +
		PHK
		PLB
		LDA $00
		BRA -
	+	PEA.w PerLevelTable>>8
		PLB
		PLB
		LDA.w PerLevelTable+$0B,y			; load low-high byte of pointer
		STA $00									; 00=low, 01=high, 02=x
		LDA.w PerLevelTable+$0C,y			; load high-bank byte of pointer
		STA $01									; 00=low, 01=high, 02=bank
		PLP
		PLB
		RTS
   endif

	
   
if !PerLevel = 1
	; Input, A=Sprite number (inbetween B0-BF)
	GetPerLevelAddr:
		ASL
		STA $00
		LDA $010B|!Base2
		ASL
		TAY
		PEA.w ((PerLevelLvlPtrs>>16)<<8)|(PerLevelSprPtrs>>16)
		PLB
		; now in PerLevelLvlPtrs bank
		LDA.w PerLevelLvlPtrs,y
		BEQ .return
		PLB
		; now in PerLevelSprPtrs bank
		ADC $00 ; carry cleared by ASL earlier
		TAY
		LDA.w PerLevelSprPtrs-($B0*2),y
		TAY
		RTS
	.return
		PLB
		TAY
		RTS
endif
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; clear init bit when changing sprites
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraserHack:
	%debugmsg("EraserHack")
	STZ !15AC,x
	LDA #$01
	STA !15A0,x
	DEC A
	STA !extra_bits,x
	RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; clear init bit when changing sprites
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EraserHack2:
	%debugmsg("EraserHack2")
	LDA #$FF
	STA !161A,x
	INC A
	STA !extra_bits,x
	JML $018156|!BankB


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; store extra bits - vertical level
; ROM 0x12B4B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubLoadHack2:
	%debugmsg("SubLoadHack2")
	PHA
	AND #$0D
	STA !extra_bits,x
	AND #$01
	; vanilla extra bit
	STA !14E0,x
	; extra bits parts, format: YYYYEEsy, EE = Extra bits
	; loaded for Size table indexing format
	LDA $01,s
	LSR #2
	AND #$03
	XBA
	; A = 000000EE NNNNNNNN (index to size table)
	; EE = extra bits
	; NNNNNNNN = sprite num
	LDA $05
	STA !new_sprite_num,x
	
	; if size >= 8 (3 usual bytes + 5 extra bytes) then it should the new extra byte system
	; processor flag X untoggled here (16bits mode) for sa1
if !SA1 == 0
	REP #$10
endif
	PHX
	TAX
	LDA.l Size,x
	PLX
if !SA1 == 0
	SEP #$10
endif
	; < 4 no extra byte
	CMP #$04
	BCC .skipExtraByte
	CMP #$08
	BCS .setSpriteDataPointer
	
	PHY
	; move sprite data pointer to extra bytes
	INY #3
	LDA [$CE],y
	STA !extra_byte_1,x
	INY
	LDA [$CE],y
	STA !extra_byte_2,x
	INY
	LDA [$CE],y
	STA !extra_byte_3,x
	INY
	LDA [$CE],y
	STA !extra_byte_4,x
	; move sprite data pointer back to the start
	PLY
	PLA
	JML $02A950|!BankB
.setSpriteDataPointer
	PHY
	
	; move to sprite data's extra byte portion
	INY #3
	TYA
	CLC
	ADC $CE
	STA !extra_byte_1,x
	LDA #$00
	ADC $CF
	STA !extra_byte_2,x
	; bank
	LDA #$00
	ADC $D0
	STA !extra_byte_3,x
	
	PLY
.skipExtraByte 
	PLA
	JML $02A950|!BankB


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hijack main sprite loader to handle custom gens and shooters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubGenLoad:
	%debugmsg("SubGenLoad")
	PHA
	LDA #$00
	STA !new_code_flag
	PLA      
      
	CMP #$C0
	BCC .NotGen
	CMP #$E0
	BCS .NotGen

;TestExtraBit:

	DEY
	LDA [$CE],y
	AND #$08
	BEQ .NotCustom

;GetType:
	LDA [$CE],y
	AND #$0C
	ASL #$04
	STA !new_code_flag
	INY

	LDA $05
	CMP #!GenStart
	BCS .IsCustomGen

.IsCustomShooter
	JML $02A8D8|!BankB

.IsCustomGen
	LDA !new_code_flag
	STA $18B9|!Base2
	LDA $05
	SEC
	SBC #!GenStart-1
	ORA $18B9|!Base2
	JML $02A8B8|!BankB

.NotCustom
	INY
	LDA $05
.NotGen		
	CMP #$E7
	BCC .Loc2
	JML $02A86A|!BankB
.Loc2		
	JML $02A88C|!BankB


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hijack shooter table setter to insert extra bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubShootLoad:
	%debugmsg("SubShootLoad")
	LDA !new_code_flag
	BNE .IsCustom
	LDA $04
	SEC
	SBC #$C8	
	if !SA1
		STA $7783,x
	endif	
	JML SubShootLoadReturn
.IsCustom
	STA $1783|!Base2,x
	LDA $04
	SEC
	SBC #$BF
	ORA $1783|!Base2,x
	STA $1783|!Base2,x
	PHA
	
	; A = 000000EE NNNNNNNN (index to size table)
	; EE = extra bits
	; NNNNNNNN = sprite num
	LDA [$CE],y
	LSR #2
	AND #$03
	XBA
	LDA $04
	
	; if size >= 7 (3 usual bytes + 4 extra bytes) then it should the new extra byte system
	; processor flag X untoggled here (16bits mode) for sa1
if !SA1 == 0
	REP #$10
endif
	PHX
	TAX
	LDA.l Size,x
	PLX
if !SA1 == 0
	SEP #$10
endif
	; < 4 no extra byte
	CMP #$04
	BCC .skipExtraByte
	CMP #$07
	BCS .setSpriteDataPointer
	
	PHY
	; move sprite data pointer to extra bytes
	INY #3
	LDA [$CE],y
	STA !shooter_extra_byte_1,x
	INY
	LDA [$CE],y
	STA !shooter_extra_byte_2,x
	INY
	LDA [$CE],y
	STA !shooter_extra_byte_3,x
	; moves sprite data pointer back to the start
	PLY
	PLA
	JML SubShootLoadReturn
.setSpriteDataPointer
	PHY
	
	; move to sprite data's extra byte portion
	INY #3
	TYA
	CLC
	ADC $CE
	STA !shooter_extra_byte_1,x
	LDA #$00
	ADC $CF
	STA !shooter_extra_byte_2,x
	; bank
	LDA #$00
	ADC $D0
	STA !shooter_extra_byte_3,x
	
	PLY
.skipExtraByte
	PLA
	JML SubShootLoadReturn
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubShootExec:
	%debugmsg("SubShootExec")
	LDY $1783|!Base2,x
	BMI .IsCustom
	LDY $17AB|!Base2,x
	BEQ .Loc2
	JML $02B39A|!BankB
.Loc2		
	JML $02B3A4|!BankB

.IsCustom	
	LDY $17AB|!Base2,x
	BEQ .CallSprite
	PHA
	LDA $13
	LSR A
	BCC .NoDecTimer
	DEC $17AB|!Base2,x
.NoDecTimer	
	PLA
.CallSprite	
	AND #$3F
	CLC
	ADC #$BF

	JSR GetMainPtr

	LDA.b #$02|(!BankB>>16)
	PHA
	PEA $B3A6
	JML [!Base1]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubGenExec:
	%debugmsg("SubGenExec")
	LDA $18B9|!Base2
	BMI .IsCustom
	PLA
	PLA
	PLA
	LDA $18B9|!Base2
	BEQ .Loc2
	JML $02B003|!BankB
.Loc2		
	JML $02B02A|!BankB

.IsCustom	
	AND #$3F
	CLC
	ADC #!GenStart-1

	JSR GetMainPtr

	PLA
	PLA
	PEA $B029
	JML [!Base1]


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set sprite tables from main table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetSpriteTables:
	%debugmsg("SetSpriteTables")
	PHY
	PHB
	PHK
	PLB
	PHP

	LDA !new_sprite_num,x
	REP #$30
	AND #$00FF
	
	
   if !PerLevel = 1
      CMP #$00B0
      BCC .normal	
      CMP #$00C0
      BCC .perlevel
   .normal
   endif
	
	ASL A
-	ASL #3
	TAY
	SEP #$20

	LDA TableStart,y
	STA !new_code_flag
	LDA TableStart+$01,y
	STA !9E,x
	LDA TableStart+$02,y
	STA !1656,x
	LDA TableStart+$03,y
	STA !1662,x
	LDA TableStart+$04,y
	STA !166E,x
	AND #$0F
	STA !15F6,x
	LDA TableStart+$05,y
	STA !167A,x
	LDA TableStart+$06,y
	STA !1686,x
	LDA TableStart+$07,y
	STA !190F,x

.join
	
	LDA !new_code_flag
	BNE .IsCustomNormal
.notCustom
	PLP
	PLB
	PLY
	LDA #$00
	STA !extra_bits,x
	RTL

.IsCustomNormal
	REP #$20
	LDA TableStart+$08,y
	STA $00
	SEP #$20
	LDA TableStart+$0A,y
	STA $02
	LDA TableStart+$0E,y
	STA !extra_prop_1,x
	LDA TableStart+$0F,y
	STA !extra_prop_2,x

.ret
	PLP
	PLB
	PLY
	RTL
	
   if !PerLevel = 1
	.perlevel
		JSR GetPerLevelAddr
		BNE +
		PHK
		PLB
		LDA $00
		BRA -
	+	PEA.w PerLevelTable>>8
		PLB
		PLB
		SEP #$20
		LDA.w PerLevelTable+$01,y
		STA !9E,x
		LDA.w PerLevelTable+$02,y
		STA !1656,x
		LDA.w PerLevelTable+$03,y
		STA !1662,x
		LDA.w PerLevelTable+$04,y
		STA !166E,x
		AND #$0F
		STA !15F6,x
		LDA.w PerLevelTable+$05,y
		STA !167A,x
		LDA.w PerLevelTable+$06,y
		STA !1686,x
		LDA.w PerLevelTable+$07,y
		STA !190F,x
		LDA.w PerLevelTable+$00,y
		STA !new_code_flag
		BEQ .notCustom
		LDA.w PerLevelTable+$0E,y
		STA !extra_prop_1,x
		LDA.w PerLevelTable+$0F,y
		STA !extra_prop_2,x
		LDA.w PerLevelTable+$0A,y
		STA $02
		REP #$20
		LDA.w PerLevelTable+$08,y
		STA $00					; INIT pointer to [$00]
		BRA .ret
   endif
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Call Main after handling status > 9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SubHandleStatus:
	%debugmsg("SubHandleStatus")
	LDA !14C8,x					; restore code
	CMP #$02						;
	BCC .CallDefault			; always default handle status 0 and 1
.NoEraseOrInit					; any other stuats...
	CMP #$08						
	BNE .NoMainRoutine		; if status = 8
	JML $0185C3|!BankB		; call main routine of sprite
.NoMainRoutine
	PHA
	LDA !extra_bits,x
	AND #!CustomBit
	BNE .HandleCustomSprite	; if custom sprite, handle with care ^^
	PLA
.CallDefault
	JML $018133|!BankB		;call regular status handler

.HandleCustomSprite
	LDA !extra_prop_2,x
	BMI CallMain				;check bit 7, if set call main
	PHA
	LDA $02,s					;load sprite status
	CMP #$07
	BCC vanillaHandler
	JMP ExecuteCustomPtr		;execute custom ptr for states 07-09-0A-0B-0C
	vanillaHandler:
	JSL $01D43E|!BankB			;run vanilla code for states 02-06
	PLA							;extra_prop_2
	ASL A						;\ check bit 6
	BMI CallMain				;/
	PLA							;sprite status
	CMP #$09
	BCS CallMain2				;restored for backwards compatibility with sprites
	CMP #$03					;run main for state 03 (smushed)
	BEQ CallMain2
	JML $0185C2|!BankB		;goto RTL
CallMain2:
	PHA
CallMain:
	LDA !new_sprite_num,x
	JSR GetMainPtr
	PLA

	LDY.b #$01|(!BankB>>16)	;\
	PHY							;| setup stack so that RTL will goto $0185C2
	PEA $85C1					;/
	JML [!Base1]				; goto sprite main code.

ExecuteCustomPtr:
.CustomStatus
	STA $03					; load status in $03 and number in A
	LDA !new_sprite_num,x
	if !PerLevel = 1
		REP #$30
		AND #$00FF
		CMP #$00B0
        BCC .normal	
        CMP #$00BF
        BCS .normal
		JSR GetPerLevelAddr
		BNE +
		SEP #$30
		LDA #$01
		PHA : PLB 		; restore bank that got destroyed by GetPerLevelAddr
		LDA !new_sprite_num,x
		BRA .normal
	+	; execute per-level custom pointers here
		%CallPerLevelStatusPtr(PerLevelCustomPtrTable, IndexPtrTable, vanillaHandler)
		SEP #$30
		BRA .return			; once done with per-level custom pointers, just return
		.normal
		SEP #$30
	endif
	%CallStatusPtr(CustomStatusPtr, IndexPtrTable, vanillaHandler)
	.return
	PLA : PLA		; destroy the previous 2 PHAs
	JML $0185C2|!BankB		; goto RTL
	
	IndexPtrTable:
		db $09, $FF, $00, $03, $06, $0C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Keep extra bits around when setting the sprite tables during
; level loading
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitKeepextra_bits:
	%debugmsg("InitKeepextra_bits")
	LDA !extra_bits,x
	PHA
	
	if !SA1
		PHX
		PHY
		SEP #$10
	endif
	
	JSL InitSpriteTables	
	
	if !SA1
		REP #$10
		PLY
		PLX
	endif
	
	PLA
	STA !extra_bits,x
	JML $02A9CD|!BankB
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Test a custom sprite's an ACTUAL bit so that the sprite ALWAYS won't be
; transformed to a silver coin.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TestSilverCoinBit:
	%debugmsg("TestSilverCoinBit")
	PHA
	LDA !extra_bits,x
	AND #!CustomBit
	BNE .Custom
	
	if !SA1 = 0
		PLX
	else
		LDA #$00
		XBA
		PLA
		TAX
	endif
	
	LDA $07F659|!BankB,x	;SMW sprite's $190F,x table
	JML $02A9AB|!BankB

.Custom
	PLA
	LDA !new_sprite_num,x
	PHP
	REP #$30
	AND #$00FF


   if !PerLevel = 1	
      CMP #$00B0
      BCC .normal
      CMP #$00C0
      BCC .perlevel	
   .normal
   endif

	ASL A
-	ASL #3
	TAX
	LDA.l TableStart+$07,x
	PLP
	JML $02A9AB|!BankB
	
   if !PerLevel = 1
   .perlevel
      JSR GetPerLevelAddr
	  BNE +
	  PHK
	  PLB
	  LDA $00
	  BRA -
	+ SEP #$20
	  PHX
	  TYX
      LDA.l PerLevelTable+$07,x
	  PLX
      PLP
      JML $02A9AB|!BankB
   endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Custom sprites' table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TableStart:
	print "Global Table at ",pc
	incbin "_DefaultTables.bin"
CustomStatusPtr:
	print "Custom status pointers at", pc
	incbin "_CustomStatusPtr.bin"

; ---------------------------------------------------
; per-level tables for sprite B0-BF 0x8000 bytes each.
; ---------------------------------------------------

if !PerLevel = 1
	freedata
	prot PerLevelSprPtrs_data
	prot PerLevelTable_data
	prot PerLevelCustomPtrTable_data
	PerLevelLvlPtrs:
		print "Per-level sprite level pointers at ", pc
		incbin "_PerLevelLvlPtrs.bin"
	freedata
        ; i have no idea how to explain why i did it like this but trust me it works, and it's necessary to allow the full 0x800 per-level sprites
        skip -1
	PerLevelTable:
        skip 1
        .data:
		print "Level Table at ", pc
		incbin "_PerLevelT.bin"
	freedata
        skip -1
	PerLevelCustomPtrTable:
        skip 1
        .data:
		print "Level Pointers Table at ", pc
		incbin "_PerLevelCustomPtrTable.bin"
	freedata
        skip -1
	PerLevelSprPtrs:
        skip 1
        .data:
		print "Per-level sprite pointers at ", pc
		incbin "_PerLevelSprPtrs.bin"
endif
