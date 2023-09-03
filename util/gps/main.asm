; GPS 1.4.4
!version = 3

incsrc "defines.asm"			; global defines
incsrc "__temp_settings.asm"	; settings set by GPS

macro offset(id, addr)          ; > Hijack LM map16 code to run custom blocks. 
	org <addr>
		PHB : PHX
		REP #$30
		LDA.w <id>*3+1
		autoclean JSL block_execute
		PLX : PLB
		JMP $F602
endmacro

%offset(#$00, $06F690) : %offset(#$01, $06F6A0) : %offset(#$02, $06F6B0) : %offset(#$07, $06F6C0)	; > Below, Above, Side, Topcorner
%offset(#$08, $06F6D0) : %offset(#$09, $06F6E0) : %offset(#$03, $06F720) : %offset(#$04, $06F730)	; > Body, Head, SpriteV, SpriteH
%offset(#$05, $06F780) : %offset(#$06, $06F7C0) : %offset(#$0A, $06F7D0) : %offset(#$0B, $06F7E0)	; > Cape, Fireball, WallFeet, WallBody

macro replace(a, b, c)
<a><b><c>
endmacro
macro bad_freedata_workaround(attributes)
	!INT_attr = ""
	if not(stringsequal("<attributes>", ""))
		!INT_attr = "<attributes>,"
	endif
	if !fullsa1
		freedata <attributes>
	else
		%replace("freedata ", "!INT_attr", "align")
	endif
endmacro

org $06F624
	autoclean dl acts_likes_1	; > Table containing all the acts like of the blocks in range 0000-3FFF

org $06F67B			; > Add another offset check for wallrun in the CMP-BEQ list
	autoclean JML WallRun

org $06F717			; > Fix spriteH bug that there is another value being used in the stack.
	autoclean JML FixSpriteH


%bad_freedata_workaround("")
print "acts like at 0x", pc
acts_likes_1:
	incbin "__acts_likes_1.bin"

if !__insert_pages_40_plus == 1
	autoclean read3($06F63A)+$8000
	org $06F63A
		dl acts_likes_2-$8000	; > Table containing all the acts like of the blocks in range 4000-7FFF
	%bad_freedata_workaround("cleaned")
acts_likes_2:
		incbin "__acts_likes_2.bin"
endif

freecode
print "main code at 0x", pc
WallRun:
	CMP #$39		; > JSR [($00EB3A-1)&$0000FF]
	BEQ .RunBlockCode
	CMP #$EA
	BEQ .RunBlockCode2 ; Wall feet

	JML $06F602|!bank		; > Ignore custom block code.
.RunBlockCode
	JML $06F7D0|!bank
.RunBlockCode2
	JML $06F7E0|!bank

FixSpriteH:
	CMP #$82		; > This was also used for spriteH.
	BEQ .RunBlockCode
	JML $06F602|!bank		; > Ignore custom block code.
.RunBlockCode
	JML $06F730|!bank
;32
block_execute:
	STA $05
	if !__insert_pages_40_plus == 0
		BIT $03
		BVS .return
	endif
	LDX $03
	LDA.l block_bank_byte,x
	AND #$00FF
	BEQ .return
	XBA
	STA $01
	PHA
	TXA
	ASL
	TAX
	if !__insert_pages_40_plus == 1
		BPL .normal_range
		LDA.l block_pointers_2-$8000,x
		BRA .continue
.normal_range
	endif
	LDA.l block_pointers_1,x
.continue
	STA $00
	LDA $05
	;1F
	CMP #$001E
	BCC .RunBlockCodeNormal
	LDA [$00]
	AND #$00FF
	CMP #$0037
	BEQ .RunBlockCodeNormal2
	PLA
.return
	SEP #$30
	RTL
.RunBlockCodeNormal2
	CLC
.RunBlockCodeNormal
	LDA $00
	ADC $05
	STA $00
	SEP #$30
	PLX			; destroy extra bank byte
	PLB			; bank byte of block
	LDX $15E9|!addr
	JML [$0000|!dp]

if !__insert_pages_40_plus == 0		; Yeah, too lazy to think of a better method so just throw it in here if it's not 32KB
	block_bank_byte:			; bank byte of each block 00 means "not inserted"
		incbin "__banks.bin"	; 16KB -- can be made into a incsrc for manual use
	.end
endif

	db "GPS_VeRsIoN"
	db !version
	db !__insert_pages_40_plus
	dl block_bank_byte
	dl block_pointers_1
	dw block_bank_byte_end-block_bank_byte
	dw block_pointers_1_end-block_pointers_1
	if !__insert_pages_40_plus == 1
		dl block_pointers_2
		dw block_pointers_2_end-block_pointers_2
	endif

%bad_freedata_workaround("cleaned")
block_pointers_1:				; two byte pointer per block -- little endian as expected.
	incbin "__pointers_1.bin"	; 32KB -- can also be made to be incsrced
.end

if !__insert_pages_40_plus == 1
	%bad_freedata_workaround("cleaned")
	block_pointers_2:
		incbin "__pointers_2.bin"; 32KB -- can also be made to be incsrced
	.end
	%bad_freedata_workaround("cleaned")
	block_bank_byte:			; bank byte of each block 00 means "not inserted"
		incbin "__banks.bin"	; 32KB -- can be made into a incsrc for manual use
	.end
endif
