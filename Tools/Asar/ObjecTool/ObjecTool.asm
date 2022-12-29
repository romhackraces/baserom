;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; ObjecTool v. 0.5, by imamelia
;
; This patch allows you to insert custom extended objects, which will go in as
; extended objects 98-FF), and custom normal objects, which are all variants
; of normal object 2D (which is unused in the original game but, in Lunar Magic
; 1.8 onward, is usable for custom objects and has been expanded to 5 bytes).
;
; Credit to 1024 (aka 0x400) for the original ObjecTool.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;header
lorom

!dp = $0000
!addr = $0000
!bank = $800000
!map16 = $7E
!sa1 = 0

if read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!map16 = $40
	!sa1 = 1
endif

; 80+ bytes used for scratch RAM in some routines to build tables
; the address doesn't particularly matter as long as anything else that would need it
; reloads it before using it but after object code runs
!ObjScratch = $0910|!addr

org $0DA106|!bank				; x6A306 (hijack extended object loading routine)
	autoclean JML NewExObjects		; E2 30 A5 59

; commented out for Retry Compatibility
;org $0DA415|!bank				; x6A615 (hijack normal object loading routine)
;	autoclean JML NewNormObjects	; E2 30 AD 31 19
;	NOP						;

freecode

NewExObjects:
	SEP #$30				; restore hijacked code
	LDA $59				; and load extended object number (was done in the original code anyway)
	CMP #$98			; if the extended object number is equal to or greater than 98...
	BCS CustExObjRt		; then it is a custom extended object
	JML $0DA10A|!bank	;
CustExObjRt:				;
	PHB					;
	PHK					;
	PLB					; change the data bank
	SEC					;
	SBC #$98				;
	ASL					; (no need for 16-bit mode because A can never be greater than #$D0 here)
	TAX					;
	LSR					; keep the extended object number in A (in case it needs to be checked)
	JSR (ExtendedObjPtrs,x)	;
	PLB					;
	JML $0DA53C|!bank	; jump to an RTS in bank 0D

NewNormObjects:
	SEP #$30				;
	LDA $5A				; check the object number
	CMP #$2D			; if it is equal to 2D...
	BEQ CustNormObjRt	; then it is a custom normal object
NotCustomN:				;
	LDA $1931|!addr		; hijacked code
	JML $0DA41A|!bank	;
CustNormObjRt:			;
	LDY #$00				; start Y at 00
	LDA [$65],y			; this should point to the next byte
	STA $5A				; the first new settings byte is the new object number
	INY					; increment Y to get to the next byte
	LDA [$65],y			;
	STA $58				; the second new settings byte
	INY					; increment Y again...
	TYA					;
	CLC					;
	ADC $65				; add 2 to $65 so that the pointer is in the right place,
	STA $65				; since this is a 5-byte object (and SMW's code expects them to be 3 bytes)
	LDA $66				; if the last byte overflowed...
	ADC #$00			; add 1 to it
	STA $66				;
	PHB					;
	PHK					;
	PLB					; change the data bank
	LDA $5A				;
	REP #$30				;
	AND #$00FF			;
	ASL					;
	TAX					;
	LDA NormalObjPtrs,x	; the system needs to be different for these since numbers 00-FF are
	STA $00				; used, making the index go up to #$01FE
	SEP #$30				;
	LDA $5A				; keep the extended object number in A (in case it needs to be checked)
	LDX #$00				;
	JSR ($0000|!dp,x)		;
	PLB					;
	JML $0DA53C|!bank	; jump to an RTS in bank 0D

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; These are pointers to extended objects 98-FF.  Don't change them.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ExtendedObjPtrs:
	dw CustExObj98
	dw CustExObj99
	dw CustExObj9A
	dw CustExObj9B
	dw CustExObj9C
	dw CustExObj9D
	dw CustExObj9E
	dw CustExObj9F
	dw CustExObjA0
	dw CustExObjA1
	dw CustExObjA2
	dw CustExObjA3
	dw CustExObjA4
	dw CustExObjA5
	dw CustExObjA6
	dw CustExObjA7
	dw CustExObjA8
	dw CustExObjA9
	dw CustExObjAA
	dw CustExObjAB
	dw CustExObjAC
	dw CustExObjAD
	dw CustExObjAE
	dw CustExObjAF
	dw CustExObjB0
	dw CustExObjB1
	dw CustExObjB2
	dw CustExObjB3
	dw CustExObjB4
	dw CustExObjB5
	dw CustExObjB6
	dw CustExObjB7
	dw CustExObjB8
	dw CustExObjB9
	dw CustExObjBA
	dw CustExObjBB
	dw CustExObjBC
	dw CustExObjBD
	dw CustExObjBE
	dw CustExObjBF
	dw CustExObjC0
	dw CustExObjC1
	dw CustExObjC2
	dw CustExObjC3
	dw CustExObjC4
	dw CustExObjC5
	dw CustExObjC6
	dw CustExObjC7
	dw CustExObjC8
	dw CustExObjC9
	dw CustExObjCA
	dw CustExObjCB
	dw CustExObjCC
	dw CustExObjCD
	dw CustExObjCE
	dw CustExObjCF
	dw CustExObjD0
	dw CustExObjD1
	dw CustExObjD2
	dw CustExObjD3
	dw CustExObjD4
	dw CustExObjD5
	dw CustExObjD6
	dw CustExObjD7
	dw CustExObjD8
	dw CustExObjD9
	dw CustExObjDA
	dw CustExObjDB
	dw CustExObjDC
	dw CustExObjDD
	dw CustExObjDE
	dw CustExObjDF
	dw CustExObjE0
	dw CustExObjE1
	dw CustExObjE2
	dw CustExObjE3
	dw CustExObjE4
	dw CustExObjE5
	dw CustExObjE6
	dw CustExObjE7
	dw CustExObjE8
	dw CustExObjE9
	dw CustExObjEA
	dw CustExObjEB
	dw CustExObjEC
	dw CustExObjED
	dw CustExObjEE
	dw CustExObjEF
	dw CustExObjF0
	dw CustExObjF1
	dw CustExObjF2
	dw CustExObjF3
	dw CustExObjF4
	dw CustExObjF5
	dw CustExObjF6
	dw CustExObjF7
	dw CustExObjF8
	dw CustExObjF9
	dw CustExObjFA
	dw CustExObjFB
	dw CustExObjFC
	dw CustExObjFD
	dw CustExObjFE
	dw CustExObjFF

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; These are pointers to the different forms of normal object 2D.  Don't change them.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NormalObjPtrs:
	dw CustObj00
	dw CustObj01
	dw CustObj02
	dw CustObj03
	dw CustObj04
	dw CustObj05
	dw CustObj06
	dw CustObj07
	dw CustObj08
	dw CustObj09
	dw CustObj0A
	dw CustObj0B
	dw CustObj0C
	dw CustObj0D
	dw CustObj0E
	dw CustObj0F
	dw CustObj10
	dw CustObj11
	dw CustObj12
	dw CustObj13
	dw CustObj14
	dw CustObj15
	dw CustObj16
	dw CustObj17
	dw CustObj18
	dw CustObj19
	dw CustObj1A
	dw CustObj1B
	dw CustObj1C
	dw CustObj1D
	dw CustObj1E
	dw CustObj1F
	dw CustObj20
	dw CustObj21
	dw CustObj22
	dw CustObj23
	dw CustObj24
	dw CustObj25
	dw CustObj26
	dw CustObj27
	dw CustObj28
	dw CustObj29
	dw CustObj2A
	dw CustObj2B
	dw CustObj2C
	dw CustObj2D
	dw CustObj2E
	dw CustObj2F
	dw CustObj30
	dw CustObj31
	dw CustObj32
	dw CustObj33
	dw CustObj34
	dw CustObj35
	dw CustObj36
	dw CustObj37
	dw CustObj38
	dw CustObj39
	dw CustObj3A
	dw CustObj3B
	dw CustObj3C
	dw CustObj3D
	dw CustObj3E
	dw CustObj3F
	dw CustObj40
	dw CustObj41
	dw CustObj42
	dw CustObj43
	dw CustObj44
	dw CustObj45
	dw CustObj46
	dw CustObj47
	dw CustObj48
	dw CustObj49
	dw CustObj4A
	dw CustObj4B
	dw CustObj4C
	dw CustObj4D
	dw CustObj4E
	dw CustObj4F
	dw CustObj50
	dw CustObj51
	dw CustObj52
	dw CustObj53
	dw CustObj54
	dw CustObj55
	dw CustObj56
	dw CustObj57
	dw CustObj58
	dw CustObj59
	dw CustObj5A
	dw CustObj5B
	dw CustObj5C
	dw CustObj5D
	dw CustObj5E
	dw CustObj5F
	dw CustObj60
	dw CustObj61
	dw CustObj62
	dw CustObj63
	dw CustObj64
	dw CustObj65
	dw CustObj66
	dw CustObj67
	dw CustObj68
	dw CustObj69
	dw CustObj6A
	dw CustObj6B
	dw CustObj6C
	dw CustObj6D
	dw CustObj6E
	dw CustObj6F
	dw CustObj70
	dw CustObj71
	dw CustObj72
	dw CustObj73
	dw CustObj74
	dw CustObj75
	dw CustObj76
	dw CustObj77
	dw CustObj78
	dw CustObj79
	dw CustObj7A
	dw CustObj7B
	dw CustObj7C
	dw CustObj7D
	dw CustObj7E
	dw CustObj7F
	dw CustObj80
	dw CustObj81
	dw CustObj82
	dw CustObj83
	dw CustObj84
	dw CustObj85
	dw CustObj86
	dw CustObj87
	dw CustObj88
	dw CustObj89
	dw CustObj8A
	dw CustObj8B
	dw CustObj8C
	dw CustObj8D
	dw CustObj8E
	dw CustObj8F
	dw CustObj90
	dw CustObj91
	dw CustObj92
	dw CustObj93
	dw CustObj94
	dw CustObj95
	dw CustObj96
	dw CustObj97
	dw CustObj98
	dw CustObj99
	dw CustObj9A
	dw CustObj9B
	dw CustObj9C
	dw CustObj9D
	dw CustObj9E
	dw CustObj9F
	dw CustObjA0
	dw CustObjA1
	dw CustObjA2
	dw CustObjA3
	dw CustObjA4
	dw CustObjA5
	dw CustObjA6
	dw CustObjA7
	dw CustObjA8
	dw CustObjA9
	dw CustObjAA
	dw CustObjAB
	dw CustObjAC
	dw CustObjAD
	dw CustObjAE
	dw CustObjAF
	dw CustObjB0
	dw CustObjB1
	dw CustObjB2
	dw CustObjB3
	dw CustObjB4
	dw CustObjB5
	dw CustObjB6
	dw CustObjB7
	dw CustObjB8
	dw CustObjB9
	dw CustObjBA
	dw CustObjBB
	dw CustObjBC
	dw CustObjBD
	dw CustObjBE
	dw CustObjBF
	dw CustObjC0
	dw CustObjC1
	dw CustObjC2
	dw CustObjC3
	dw CustObjC4
	dw CustObjC5
	dw CustObjC6
	dw CustObjC7
	dw CustObjC8
	dw CustObjC9
	dw CustObjCA
	dw CustObjCB
	dw CustObjCC
	dw CustObjCD
	dw CustObjCE
	dw CustObjCF
	dw CustObjD0
	dw CustObjD1
	dw CustObjD2
	dw CustObjD3
	dw CustObjD4
	dw CustObjD5
	dw CustObjD6
	dw CustObjD7
	dw CustObjD8
	dw CustObjD9
	dw CustObjDA
	dw CustObjDB
	dw CustObjDC
	dw CustObjDD
	dw CustObjDE
	dw CustObjDF
	dw CustObjE0
	dw CustObjE1
	dw CustObjE2
	dw CustObjE3
	dw CustObjE4
	dw CustObjE5
	dw CustObjE6
	dw CustObjE7
	dw CustObjE8
	dw CustObjE9
	dw CustObjEA
	dw CustObjEB
	dw CustObjEC
	dw CustObjED
	dw CustObjEE
	dw CustObjEF
	dw CustObjF0
	dw CustObjF1
	dw CustObjF2
	dw CustObjF3
	dw CustObjF4
	dw CustObjF5
	dw CustObjF6
	dw CustObjF7
	dw CustObjF8
	dw CustObjF9
	dw CustObjFA
	dw CustObjFB
	dw CustObjFC
	dw CustObjFD
	dw CustObjFE
	dw CustObjFF

incsrc CustomObjCode.asm
