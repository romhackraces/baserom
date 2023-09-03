@includefrom objectool.asm

incsrc "../../../shared/freeram.asm"

!level_flags = !objectool_level_flags_freeram ; FreeRAM to activate certain UberASM code (cleared at level load)

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; code for extended objects 98-FF
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Toggle status bar
CustExObj98:
	LDA #$01 : STA !toggle_statusbar_freeram
	RTS

; Enable L/R scroll
CustExObj99:
	LDA #$01 : STA !toggle_lr_scroll_freeram
	RTS

; Lock horizontal scroll
CustExObj9A:
	STZ $1411|!addr
	RTS

; Free vertical scroll
CustExObj9B:
	REP #$20
	LDA.w #$0001 : TSB !level_flags
	SEP #$20
	RTS

; Set ON/OFF state to OFF
CustExObj9C:
	lda #$01 : sta $14AF|!addr
	RTS

; Enable SFX Echo
CustExObj9D:
	REP #$20
	LDA.w #$0002 : TSB !level_flags
	SEP #$20
	RTS

; Enable 8 frame float
CustExObj9E:
	REP #$20
	LDA.w #$0004 : TSB !level_flags
	SEP #$20
	RTS

; Vanilla Cape Turn-around
CustExObj9F:
	REP #$20
	LDA.w #$0008 : TSB !level_flags
	SEP #$20
	RTS

; Toggleable block dupes
CustExObjA0:
	REP #$20
	LDA.w #$0016 : TSB !level_flags
	SEP #$20
	RTS

CustExObjA1:
CustExObjA2:
CustExObjA3:
CustExObjA4:
CustExObjA5:
CustExObjA6:
CustExObjA7:
CustExObjA8:
CustExObjA9:
CustExObjAA:
CustExObjAB:
CustExObjAC:
CustExObjAD:
CustExObjAE:
CustExObjAF:
	RTS

CustExObjB0:
	; Instant Retry
	LDA #$03 : sta !retry_freeram+$11
	RTS

CustExObjB1:
	; Prompt Retry
	LDA #$02 : sta !retry_freeram+$11
	RTS

CustExObjB2:
	; Bottom left retry prompt
	lda #$09 : sta !retry_freeram+$15
	lda #$D0 : sta !retry_freeram+$16
	RTS

CustExObjB3:
	; No powerup from Midway
	lda #$00 : sta !retry_freeram+$10
	RTS

CustExObjB4:
CustExObjB5:
CustExObjB6:
CustExObjB7:
CustExObjB8:
CustExObjB9:
CustExObjBA:
CustExObjBB:
CustExObjBC:
CustExObjBD:
CustExObjBE:
CustExObjBF:
CustExObjC0:
CustExObjC1:
CustExObjC2:
CustExObjC3:
CustExObjC4:
CustExObjC5:
CustExObjC6:
CustExObjC7:
CustExObjC8:
CustExObjC9:
CustExObjCA:
CustExObjCB:
CustExObjCC:
CustExObjCD:
CustExObjCE:
CustExObjCF:
CustExObjD0:
CustExObjD1:
CustExObjD2:
CustExObjD3:
CustExObjD4:
CustExObjD5:
CustExObjD6:
CustExObjD7:
CustExObjD8:
CustExObjD9:
CustExObjDA:
CustExObjDB:
CustExObjDC:
CustExObjDD:
CustExObjDE:
CustExObjDF:
CustExObjE0:
CustExObjE1:
CustExObjE2:
CustExObjE3:
CustExObjE4:
CustExObjE5:
CustExObjE6:
CustExObjE7:
CustExObjE8:
CustExObjE9:
CustExObjEA:
CustExObjEB:
CustExObjEC:
CustExObjED:
CustExObjEE:
CustExObjEF:
CustExObjF0:
CustExObjF1:
CustExObjF2:
CustExObjF3:
CustExObjF4:
CustExObjF5:
CustExObjF6:
CustExObjF7:
CustExObjF8:
CustExObjF9:
CustExObjFA:
CustExObjFB:
CustExObjFC:
CustExObjFD:
CustExObjFE:
CustExObjFF:
		RTS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; code for normal objects 00-FF (actually object 2D in the editor)
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CustObj00:
CustObj01:
CustObj02:
CustObj03:
CustObj04:
CustObj05:
CustObj06:
CustObj07:
CustObj08:
CustObj09:
CustObj0A:
CustObj0B:
CustObj0C:
CustObj0D:
CustObj0E:
CustObj0F:
CustObj10:
CustObj11:
CustObj12:
CustObj13:
CustObj14:
CustObj15:
CustObj16:
CustObj17:
CustObj18:
CustObj19:
CustObj1A:
CustObj1B:
CustObj1C:
CustObj1D:
CustObj1E:
CustObj1F:
CustObj20:
CustObj21:
CustObj22:
CustObj23:
CustObj24:
CustObj25:
CustObj26:
CustObj27:
CustObj28:
CustObj29:
CustObj2A:
CustObj2B:
CustObj2C:
CustObj2D:
CustObj2E:
CustObj2F:
CustObj30:
CustObj31:
CustObj32:
CustObj33:
CustObj34:
CustObj35:
CustObj36:
CustObj37:
CustObj38:
CustObj39:
CustObj3A:
CustObj3B:
CustObj3C:
CustObj3D:
CustObj3E:
CustObj3F:
CustObj40:
CustObj41:
CustObj42:
CustObj43:
CustObj44:
CustObj45:
CustObj46:
CustObj47:
CustObj48:
CustObj49:
CustObj4A:
CustObj4B:
CustObj4C:
CustObj4D:
CustObj4E:
CustObj4F:
CustObj50:
CustObj51:
CustObj52:
CustObj53:
CustObj54:
CustObj55:
CustObj56:
CustObj57:
CustObj58:
CustObj59:
CustObj5A:
CustObj5B:
CustObj5C:
CustObj5D:
CustObj5E:
CustObj5F:
CustObj60:
CustObj61:
CustObj62:
CustObj63:
CustObj64:
CustObj65:
CustObj66:
CustObj67:
CustObj68:
CustObj69:
CustObj6A:
CustObj6B:
CustObj6C:
CustObj6D:
CustObj6E:
CustObj6F:
CustObj70:
CustObj71:
CustObj72:
CustObj73:
CustObj74:
CustObj75:
CustObj76:
CustObj77:
CustObj78:
CustObj79:
CustObj7A:
CustObj7B:
CustObj7C:
CustObj7D:
CustObj7E:
CustObj7F:
CustObj80:
CustObj81:
CustObj82:
CustObj83:
CustObj84:
CustObj85:
CustObj86:
CustObj87:
CustObj88:
CustObj89:
CustObj8A:
CustObj8B:
CustObj8C:
CustObj8D:
CustObj8E:
CustObj8F:
CustObj90:
CustObj91:
CustObj92:
CustObj93:
CustObj94:
CustObj95:
CustObj96:
CustObj97:
CustObj98:
CustObj99:
CustObj9A:
CustObj9B:
CustObj9C:
CustObj9D:
CustObj9E:
CustObj9F:
CustObjA0:
CustObjA1:
CustObjA2:
CustObjA3:
CustObjA4:
CustObjA5:
CustObjA6:
CustObjA7:
CustObjA8:
CustObjA9:
CustObjAA:
CustObjAB:
CustObjAC:
CustObjAD:
CustObjAE:
CustObjAF:
CustObjB0:
CustObjB1:
CustObjB2:
CustObjB3:
CustObjB4:
CustObjB5:
CustObjB6:
CustObjB7:
CustObjB8:
CustObjB9:
CustObjBA:
CustObjBB:
CustObjBC:
CustObjBD:
CustObjBE:
CustObjBF:
CustObjC0:
CustObjC1:
CustObjC2:
CustObjC3:
CustObjC4:
CustObjC5:
CustObjC6:
CustObjC7:
CustObjC8:
CustObjC9:
CustObjCA:
CustObjCB:
CustObjCC:
CustObjCD:
CustObjCE:
CustObjCF:
CustObjD0:
CustObjD1:
CustObjD2:
CustObjD3:
CustObjD4:
CustObjD5:
CustObjD6:
CustObjD7:
CustObjD8:
CustObjD9:
CustObjDA:
CustObjDB:
CustObjDC:
CustObjDD:
CustObjDE:
CustObjDF:
CustObjE0:
CustObjE1:
CustObjE2:
CustObjE3:
CustObjE4:
CustObjE5:
CustObjE6:
CustObjE7:
CustObjE8:
CustObjE9:
CustObjEA:
CustObjEB:
CustObjEC:
CustObjED:
CustObjEE:
CustObjEF:
CustObjF0:
CustObjF1:
CustObjF2:
CustObjF3:
CustObjF4:
CustObjF5:
CustObjF6:
CustObjF7:
CustObjF8:
CustObjF9:
CustObjFA:
CustObjFB:
CustObjFC:
CustObjFD:
CustObjFE:
CustObjFF:
		RTS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; defines and tables
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

BitTable:
	db $01,$02,$04,$08,$10,$20,$40,$80

Obj2x2Tiles:
	dw $0000,$0000,$0000,$0000

Obj1x1Tiles:
	dw $0000

Obj2x1Tiles:
	dw $0000,$0000

Obj1x2Tiles:
	dw $0000,$0000

; 9 tiles for MxN objects where M >= 2 and N >= 2: top-left corner, top ledge, top-right corner, left edge, middle, right edge, bottom-left corner, bottom edge, bottom right corner
; 3 tiles for Nx1 objects: left end, middle, right end
; 3 tiles for 1xN objects: top end, middle, bottom end
; 1 tile for 1x1 objects
SquareObjTiles:
	dw $0200,$0201,$0202,$0210,$0211,$0212,$0220,$0221,$0222 : dw $0230,$0231,$0232 : dw $0203,$0213,$0223 : dw $0233

SquareObjTiles2A:
	dw $0200,$0201,$0202,$0210,$0211,$0212,$0220,$0221,$0222 : dw $0230,$0231,$0232 : dw $0203,$0213,$0223 : dw $0233

SquareObjTiles2B:
	dw $0204,$0201,$0205,$0210,$0211,$0212,$0214,$0221,$0215 : dw $0224,$0231,$0225 : dw $0206,$0213,$0216 : dw $0226

; 9 tiles with air background: top-left corner, ledge, top-right corner, left side, middle, right side, bottom-left corner, ceiling, bottom-right corner
; 8 tiles with filled background: top-left corner, ledge, top-right corner, left side, right side, bottom-left corner, ceiling, bottom-right corner
; 4 inside corner tiles: bottom-left, bottom-right, top-left, top-right
; 2 tiles for when one edge overlaps another edge: left, right
LedgeTiles:
	dw $0200,$0201,$0202,$0210,$0211,$0212,$0220,$0221,$0222 : dw $0204,$0201,$0205,$0210,$0212,$0214,$0221,$0215 : dw $0229,$022A,$0219,$021A : dw $0211,$0211
	dw $0207,$0201,$0208,$0217,$0211,$0218,$0217,$0211,$0218 : dw $0209,$0201,$020A,$0217,$0218,$0217,$0211,$0218 : dw $0229,$022A,$0219,$021A : dw $0217,$0218

; dimensions of extended objects consisting of a large group of tiles (index 00 will use the specified scratch RAM address)
ClusterExObjSize:
	dw $FF,$21

; pointers to the tilemaps of extended objects consisting of a large group of tiles (index 00 will use a table starting at the specified scratch RAM address plus 1)
ClusterExObjPtrs:
	dw !ObjScratch+1
	dw .ClusterObjExample

.ClusterObjExample
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000

UnidimensionalObjTiles:
	dw $020B,$021B,$022B : dw $020F

UnidimensionalObjTiles2:
	dw $020C,$020D,$020E : dw $021F

UnidimensionalObjCheckTiles:
	dw $0000,$021B,$0000 : dw $0000

UnidimensionalObjReplaceTiles:
	dw $0000,$021E,$0000 : dw $0000

UnidimensionalObjTilesWide:
	dw $0000,$0000,$0000,$0000,$0000,$0000

Horiz2EndTiles:
	dw $0000,$0000,$0000 : dw $0000

Vert2EndTiles:
	dw $0000,$0000,$0000 : dw $0000

SlopeTypePointers:
	dw SlopeSteepL
	dw SlopeSteepR
	dw SlopeNormalL
	dw SlopeNormalR
	dw SlopeGradualL
	dw SlopeGradualR
	dw SlopeUpsideDownSteepL
	dw SlopeUpsideDownSteepR
	dw SlopeUpsideDownNormalL
	dw SlopeUpsideDownNormalR

SlopeDataSize:
	db $06,$06,$0C,$0C,$18,$18,$06,$06,$0C,$0C

; fill tile, steep left, steep right, normal left, normal right, gradual left, gradual right, upside-down steep left, upside-down steep right, upside-down normal left, upside-down normal right
; also filled-in tiles at the end of each row
SlopeTilemapData:
	dw .00,.01,.02,.03
.00
	db $0B,$0D,$13,$19,$25,$31,$49,$61,$67,$6D,$79
	dw $003F
	dw $01AA,$01E2,$01AB
	dw $01AF,$01E4,$01B0
	dw $0196,$019B,$01DE,$003F,$0197,$019C
	dw $01A0,$01A5,$003F,$01E0,$01A1,$01A6
	dw $016E,$0173,$0178,$017D,$01D8,$01DA,$01E6,$01E6,$016F,$0174,$0179,$017E
	dw $0182,$0187,$018C,$0191,$01E6,$01E6,$01DB,$01DC,$0183,$0188,$018D,$0192
	dw $01EC,$01C4,$0000
	dw $01ED,$01C5,$0000
	dw $01EE,$003F,$01C6,$01C7,$0000,$0000
	dw $003F,$01EF,$01C8,$01C9,$0000,$0000
.01
	db $0B,$0D,$13,$19,$25,$FF,$FF,$31,$37,$3D,$49
	dw $0000
	dw $0000,$0000,$0000
	dw $0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000
	dw $0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000
.02
	db $05,$07,$0D,$13,$1F
	dw $0000
	dw $0000,$0000,$0000
	dw $0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000,$0000,$0000
.03
	db $05,$07,$0B,$0F,$17
	dw $0000
	dw $0000,$0000
	dw $0000,$0000
	dw $0000,$0000,$0000,$0000
	dw $0000,$0000,$0000,$0000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; template subroutines
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;------------------------------------------------
; make an object consisting of a 2x2 square
;------------------------------------------------

Objects2x2:
	ASL #3
	TAX
	JSR BackUpPtrs
	LDY $57
	LDA.w Obj2x2Tiles,x
	STA [$6B],y
	LDA.w Obj2x2Tiles+1,x
	STA [$6E],y
	INX #2
	JSR ShiftObjRight
	LDA.w Obj2x2Tiles,x
	STA [$6B],y
	LDA.w Obj2x2Tiles+1,x
	STA [$6E],y
	JSR RestorePtrs
	JSR ShiftObjDown
	INX #2
	LDA.w Obj2x2Tiles,x
	STA [$6B],y
	LDA.w Obj2x2Tiles+1,x
	STA [$6E],y
	INX #2
	JSR ShiftObjRight
	LDA.w Obj2x2Tiles,x
	STA [$6B],y
	LDA.w Obj2x2Tiles+1,x
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object consisting of a single block
;------------------------------------------------

Objects1x1:
	ASL
	TAX
	LDY $57
	LDA.w Obj1x1Tiles,x
	STA [$6B],y
	LDA.w Obj1x1Tiles+1,x
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object consisting of a 2x1 rectangle
;------------------------------------------------

Objects2x1:
	ASL #2
	TAX
	LDY $57
	LDA.w Obj2x1Tiles,x
	STA [$6B],y
	LDA.w Obj2x1Tiles+1,x
	STA [$6E],y
	INX #2
	JSR ShiftObjRight
	LDA.w Obj2x1Tiles,x
	STA [$6B],y
	LDA.w Obj2x1Tiles+1,x
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object consisting of a 1x2 rectangle
;------------------------------------------------

Objects1x2:
	ASL #2
	TAX
	LDY $57
	LDA.w Obj1x2Tiles,x
	STA [$6B],y
	LDA.w Obj1x2Tiles+1,x
	STA [$6E],y
	INX #2
	JSR ShiftObjDown
	LDA.w Obj1x2Tiles,x
	STA [$6B],y
	LDA.w Obj1x2Tiles+1,x
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object consisting of 9 blocks that can be stretched
;------------------------------------------------
; for the "BigSquareObjects" routine, $58 is used for 8 extra size bits (yyyyxxxx)
;------------------------------------------------

BigSquareObjects:
	JSR SquareObjectsInit
	JSR StoreNybbles
	LDA $58
	ASL #4
	TSB $08
	LDA $58
	AND #$F0
	TSB $09
	BRA SquareObjectsSub
SquareObjects:
	JSR SquareObjectsInit
	JSR StoreNybbles
SquareObjectsSub:
	LDY $57
	LDA $08
	STA $00
	LDA $09
	STA $01
	JSR BackUpPtrs
	LDA $09
	BEQ .NoVert
	LDA $08
	BEQ .VertOnly
	JMP .StartObjLoop
.VertOnly
	REP #$30
	LDA $0C
	CLC
	ADC #$000C
	STA $0C
	SEP #$20
.LoopV
	LDX $0C
	LDA $01
	CMP $09
	BEQ .SetTileIndexV
	INX
	CMP #$00
	BNE .SetTileIndexV
	INX
.SetTileIndexV
	REP #$20
	TXA
	ASL
	TAX
	LDA.w SquareObjTiles,x
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjDown
	DEC $01
	BPL .LoopV
		RTS
.NoVert
	LDA $08
	BEQ .SingleTile
.HorizOnly
	REP #$30
	LDA $0C
	CLC
	ADC #$0009
	STA $0C
	SEP #$20
.LoopH
	LDX $0C
	LDA $00
	CMP $08
	BEQ .SetTileIndexH
	INX
	CMP #$00
	BNE .SetTileIndexH
	INX
.SetTileIndexH
	REP #$20
	TXA
	ASL
	TAX
	LDA.w SquareObjTiles,x
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjRight
	DEC $00
	BPL .LoopH
		RTS
.SingleTile
	REP #$30
	LDA $0C
	CLC
	ADC #$000F
	ASL
	TAX
	LDA.w SquareObjTiles,x
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
		RTS
.StartObjLoop
	REP #$10
	LDX $0C
	LDA $01
	CMP $09
	BEQ .NoInc1
	INX #3
	CMP #$00
	BNE .NoInc1
	INX #3
.NoInc1
	LDA $00
	CMP $08
	BEQ .SetTileIndex
	INX
	CMP #$00
	BNE .SetTileIndex
	INX
.SetTileIndex
	REP #$20
	TXA
	ASL
	TAX
	LDA.w SquareObjTiles,x
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjRight
.DecAndLoop
	DEC $00
	BPL .StartObjLoop
	JSR RestorePtrs
	JSR ShiftObjDown
	LDA $08
	STA $00
	DEC $01
	BMI .EndObjLoop
	JMP .StartObjLoop
.EndObjLoop
.Return
		RTS

SquareObjectsInit:
	REP #$20
	AND.w #$00FF
	ASL #4
	STA $0C
	SEP #$20
.Return
		RTS

;------------------------------------------------
; make an object consisting of 9 blocks that can be stretched and uses different blocks if placed over non-blank tiles
;------------------------------------------------

BigSquareObjects2:
	JSR SquareObjectsInit
	JSR StoreNybbles
	LDA $58
	ASL #4
	TSB $08
	LDA $58
	AND #$F0
	TSB $09
	BRA SquareObjects2Sub
SquareObjects2:
	JSR SquareObjectsInit
	JSR StoreNybbles
SquareObjects2Sub:
	LDY $57
	LDA $08
	STA $00
	LDA $09
	STA $01
	JSR BackUpPtrs
	LDA $09
	BEQ .NoVert
	LDA $08
	BEQ .VertOnly
	JMP .StartObjLoop
.VertOnly
	REP #$30
	LDA $0C
	CLC
	ADC #$000C
	STA $0C
	SEP #$20
.LoopV
	LDX $0C
	LDA $01
	CMP $09
	BEQ .SetTileIndexV
	INX
	CMP #$00
	BNE .SetTileIndexV
	INX
.SetTileIndexV
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$21
	ADC #$7FDA
	REP #$41
	ADC #$0001
	TXA
	ASL
	TAX
	LDA.w SquareObjTiles2A,x
	BVS .NoAltV
	LDA.w SquareObjTiles2B,x
.NoAltV
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjDown
	DEC $01
	BPL .LoopV
		RTS
.NoVert
	LDA $08
	BEQ .SingleTile
.HorizOnly
	REP #$30
	LDA $0C
	CLC
	ADC #$0009
	STA $0C
	SEP #$20
.LoopH
	LDX $0C
	LDA $00
	CMP $08
	BEQ .SetTileIndexH
	INX
	CMP #$00
	BNE .SetTileIndexH
	INX
.SetTileIndexH
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$21
	ADC #$7FDA
	REP #$41
	ADC #$0001
	TXA
	ASL
	TAX
	LDA.w SquareObjTiles2A,x
	BVS .NoAltH
	LDA.w SquareObjTiles2B,x
.NoAltH
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjRight
	DEC $00
	BPL .LoopH
		RTS
.SingleTile
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$30
	SEC
	SBC #$0025
	PHP
	LDA $0C
	CLC
	ADC #$000F
	ASL
	TAX
	LDA.w SquareObjTiles2A,x
	PLP
	BEQ .NoAltS
	LDA.w SquareObjTiles2B,x
.NoAltS
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
		RTS
.StartObjLoop
	REP #$10
	LDX $0C
	LDA $01
	CMP $09
	BEQ .NoInc1
	INX #3
	CMP #$00
	BNE .NoInc1
	INX #3
.NoInc1
	LDA $00
	CMP $08
	BEQ .SetTileIndex
	INX
	CMP #$00
	BNE .SetTileIndex
	INX
.SetTileIndex
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$21
	ADC #$7FDA
	REP #$41
	ADC #$0001
	TXA
	ASL
	TAX
	LDA.w SquareObjTiles2A,x
	BVS .NoAlt
	LDA.w SquareObjTiles2B,x
.NoAlt
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjRight
.DecAndLoop
	DEC $00
	BPL .StartObjLoop
	JSR RestorePtrs
	JSR ShiftObjDown
	LDA $08
	STA $00
	DEC $01
	BMI .EndObjLoop
	JMP .StartObjLoop
.EndObjLoop
.Return
		RTS

;------------------------------------------------
; make a non-rectangular arrangement of blocks
;------------------------------------------------

ClusterExObjectsEntry1:
	TAY
	LDA !ObjScratch
	BRA ClusterExObjects_NotCustSize
ClusterExObjects:
	TAY
	LDA ClusterExObjSize,y
	CPY #$00
	BNE .NotCustSize
	LDA !ObjScratch
.NotCustSize
	PHA
	AND #$0F
	STA $00
	STA $02
	PLA
	LSR #4
	STA $01
	TYA
	ASL
	TAY
	REP #$20
	LDA ClusterExObjPtrs,y
	STA $0A
	SEP #$20
	LDY $57
	JSR BackUpPtrs
.Loop
	REP #$20
	LDA ($0A)
	CMP #$FFFF
	SEP #$20
	BEQ .SkipTile
	STA [$6B],y
	XBA
	STA [$6E],y
.SkipTile
	JSR ShiftObjRight
	REP #$20
	INC $0A
	INC $0A
	SEP #$20
	DEC $00
	BPL .Loop
	JSR RestorePtrs
	JSR ShiftObjDown
	LDA $02
	STA $00
	DEC $01
	BPL .Loop
		RTS

;------------------------------------------------
; make an object consisting of 3 blocks that can be stretched horizontally only
;------------------------------------------------

Horiz2EndObjects:
	LDY $57
	REP #$30
	AND.w #$00FF
	ASL #3
	TAX
	LDA $08
	AND #$00FF
	BNE .NotSingleTile
	LDA.w Horiz2EndTiles+6,x
	STA $0E
	SEP #$30
	BRA .StoreOnlyOne
.NotSingleTile
	LDA.w Horiz2EndTiles+4,x
	STA $0E
	LDA.w Horiz2EndTiles+2,x
	STA $0C
	LDA.w Horiz2EndTiles,x
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	LDX $08
	BRA .End
.Loop
	LDA $0C
	STA [$6B],y
	LDA $0D
	STA [$6E],y
.End
	JSR ShiftObjRight
	DEX
	BNE .Loop
	LDA $0E
.StoreOnlyOne
	STA [$6B],y
	LDA $0F
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object consisting of 3 blocks that can be stretched vertically only
;------------------------------------------------

Vert2EndObjects:
	LDY $57
	REP #$30
	AND.w #$00FF
	ASL #3
	TAX
	LDA $09
	AND #$00FF
	BNE .NotSingleTile
	LDA.w Vert2EndTiles+6,x
	STA $0E
	SEP #$30
	BRA .StoreOnlyOne
.NotSingleTile
	LDA.w Vert2EndTiles+4,x
	STA $0E
	LDA.w Vert2EndTiles+2,x
	STA $0C
	LDA.w Vert2EndTiles,x
	SEP #$30
	STA [$6B],y
	XBA
	STA [$6E],y
	LDX $09
	BRA .End
.Loop
	LDA $0C
	STA [$6B],y
	LDA $0D
	STA [$6E],y
.End
	JSR ShiftObjDown
	DEX
	BNE .Loop
	LDA $0E
.StoreOnlyOne
	STA [$6B],y
	LDA $0F
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object that can be stretched in one direction only and checks which direction that is
;------------------------------------------------
; Note: Currently, stretching it in both directions will just cause it to return without creating any tiles, because I'm not sure what those cases should do.
;------------------------------------------------

UnidimensionalObjects:
	REP #$30
	AND #$00FF
	ASL #3
	TAX
	LDA.w UnidimensionalObjTiles,x
	STA $0A
	LDA.w UnidimensionalObjTiles+2,x
	STA $0C
	LDA.w UnidimensionalObjTiles+4,x
	STA $0E
	SEP #$30
	JSR StoreNybbles
	LDY $57
	LDA $09
	BEQ .Horiz
	LDA $08
	BEQ .Vert
; both H and V?
		RTS
.Zero
	LDA.w UnidimensionalObjTiles+6,x
	STA [$6B],y
	LDA.w UnidimensionalObjTiles+7,x
	STA [$6E],y
		RTS
.Horiz
	LDA $08
	BEQ .Zero
	LDA $0A
	STA [$6B],y
	LDA $0B
	STA [$6E],y
	LDX $08
	BRA .EndH
.LoopH
	LDA $0C
	STA [$6B],y
	LDA $0D
	STA [$6E],y
.EndH
	JSR ShiftObjRight
	DEX
	BNE .LoopH
	LDA $0E
	STA [$6B],y
	LDA $0F
	STA [$6E],y
		RTS
.Vert
	LDA $09
	BEQ .Zero
	LDA $0A
	STA [$6B],y
	LDA $0B
	STA [$6E],y
	LDX $09
	BRA .EndV
.LoopV
	LDA $0C
	STA [$6B],y
	LDA $0D
	STA [$6E],y
.EndV
	JSR ShiftObjDown
	DEX
	BNE .LoopV
	LDA $0E
	STA [$6B],y
	LDA $0F
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object that can be stretched in one direction only and checks which direction that is; also checks for overlap with specific other tiles and changes the spawned tile accordingly
;------------------------------------------------
; Note: Currently, stretching it in both directions will just cause it to return without creating any tiles, because I'm not sure what those cases should do.
;------------------------------------------------

UnidimensionalObjects2:
	REP #$30
	AND #$00FF
	ASL #3
	TAX
	LDA.w UnidimensionalObjTiles2,x
	STA $0A
	LDA.w UnidimensionalObjTiles2+2,x
	STA $0C
	LDA.w UnidimensionalObjTiles2+4,x
	STA $0E
	LDA.w UnidimensionalObjCheckTiles,x
	STA $45
	LDA.w UnidimensionalObjCheckTiles+2,x
	STA $47
	LDA.w UnidimensionalObjCheckTiles+4,x
	STA $49
	LDA.w UnidimensionalObjReplaceTiles,x
	STA !ObjScratch
	LDA.w UnidimensionalObjReplaceTiles+2,x
	STA !ObjScratch+2
	LDA.w UnidimensionalObjReplaceTiles+4,x
	STA !ObjScratch+4
	LDA.w UnidimensionalObjTiles2+6,x
	STA !ObjScratch+6
	LDA.w UnidimensionalObjCheckTiles+6,x
	STA !ObjScratch+8
	LDA.w UnidimensionalObjReplaceTiles+6,x
	STA !ObjScratch+10
	SEP #$30
	JSR StoreNybbles
	LDY $57
	LDA $09
	BEQ .Horiz
	LDA $08
	BEQ .Vert
; both H and V?
		RTS
.Zero
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP !ObjScratch+8
	BEQ .ReplaceZero
	LDA !ObjScratch+6
	BRA .StoreTileZero
.ReplaceZero
	LDA !ObjScratch+10
.StoreTileZero
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
		RTS
.Horiz
	LDA $08
	BEQ .Zero
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP $45
	BEQ .Replace1H
	LDA $0A
	BRA .SetTile1H
.Replace1H
	LDA !ObjScratch
.SetTile1H
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	LDX $08
	BRA .EndH
.LoopH
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP $47
	BEQ .Replace2H
	LDA $0C
	BRA .SetTile2H
.Replace2H
	LDA !ObjScratch+2
.SetTile2H
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
.EndH
	JSR ShiftObjRight
	DEX
	BNE .LoopH
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP $49
	BEQ .Replace3H
	LDA $0E
	BRA .SetTile3H
.Replace3H
	LDA !ObjScratch+4
.SetTile3H
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
		RTS
.Vert
	LDA $09
	BEQ .Zero
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP $45
	BEQ .Replace1V
	LDA $0A
	BRA .SetTile1V
.Replace1V
	LDA !ObjScratch
.SetTile1V
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	LDX $09
	BRA .EndV
.LoopV
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP $47
	BEQ .Replace2V
	LDA $0C
	BRA .SetTile2V
.Replace2V
	LDA !ObjScratch+2
.SetTile2V
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
.EndV
	JSR ShiftObjDown
	DEX
	BNE .LoopV
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP $49
	BEQ .Replace3V
	LDA $0E
	BRA .SetTile3V
.Replace3V
	LDA !ObjScratch+4
.SetTile3V
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object that can be stretched in one direction only and checks which direction that is
;------------------------------------------------
; Note: Currently, stretching it in both directions or not at all will just cause it to return without creating any tiles, because I'm not sure what those cases should do.
;------------------------------------------------

UnidimensionalObjectsWide:
	REP #$30
	AND #$00FF
	ASL
	STA $00
	ASL
	ADC $00
	ASL
	TAX
	LDA.w UnidimensionalObjTilesWide,x
	STA !ObjScratch
	LDA.w UnidimensionalObjTilesWide+2,x
	STA !ObjScratch+$02
	LDA.w UnidimensionalObjTilesWide+4,x
	STA !ObjScratch+$04
	LDA.w UnidimensionalObjTilesWide+6,x
	STA !ObjScratch+$06
	LDA.w UnidimensionalObjTilesWide+8,x
	STA !ObjScratch+$08
	LDA.w UnidimensionalObjTilesWide+10,x
	STA !ObjScratch+$0A
	SEP #$30
	JSR StoreNybbles
	LDY $57
	LDA $08
	STA $00
	STA $02
	LDA $09
	STA $01
	JSR BackUpPtrs
	LDA $09
	BEQ .Horiz
	LDA $08
	BEQ .Vert
; both H and V?
		RTS
.Zero
; neither H nor V?
		RTS
.Horiz
	LDA $08
	BEQ .Zero
	STZ !ObjScratch+$0C
.LoopH2
	LDX !ObjScratch+$0C
	REP #$20
	LDA !ObjScratch,x
	STA $0A
	LDA !ObjScratch+$02,x
	STA $0C
	LDA !ObjScratch+$04,x
	STA $0E
	SEP #$20
	LDA $0A
	STA [$6B],y
	LDA $0B
	STA [$6E],y
	LDX $08
	BRA .EndH
.LoopH
	LDA $0C
	STA [$6B],y
	LDA $0D
	STA [$6E],y
.EndH
	JSR ShiftObjRight
	DEX
	BNE .LoopH
	LDA $0E
	STA [$6B],y
	LDA $0F
	STA [$6E],y
	LDA !ObjScratch+$0C
	BNE .ReturnH
	CLC
	ADC #$06
	STA !ObjScratch+$0C
	JSR RestorePtrs
	JSR ShiftObjDown
	BRA .LoopH2
.ReturnH
		RTS
.Vert
	LDA $09
	BEQ .Zero
	LDA !ObjScratch
	STA [$6B],y
	LDA !ObjScratch+$01
	STA [$6E],y
	JSR ShiftObjRight
	LDA !ObjScratch+$02
	STA [$6B],y
	LDA !ObjScratch+$03
	STA [$6E],y
	LDX $09
	BRA .EndV
.LoopV
	LDA !ObjScratch+$04
	STA [$6B],y
	LDA !ObjScratch+$05
	STA [$6E],y
	JSR ShiftObjRight
	LDA !ObjScratch+$06
	STA [$6B],y
	LDA !ObjScratch+$07
	STA [$6E],y
.EndV
	JSR ShiftObjDown
	DEX
	BNE .LoopV
	LDA !ObjScratch+$08
	STA [$6B],y
	LDA !ObjScratch+$09
	STA [$6E],y
	JSR ShiftObjRight
	LDA !ObjScratch+$0A
	STA [$6B],y
	LDA !ObjScratch+$0B
	STA [$6E],y
		RTS

;------------------------------------------------
; make an object composed of a single Map16 tile that can be set to use item memory
;------------------------------------------------
; Input:
; - $0C-$0D = tile number
; - X: 0 not to use item memory, any non-zero value to use it
;------------------------------------------------

SingleBlockObjects:
	LDY $57
	LDA $59
	AND #$0F
	STA $00
	STA $02
	LDA $59
	LSR #4
	STA $01
	JSR BackUpPtrs
.StartObjLoop0
	CPX #$00
	BEQ .SetTileNumber
	JSR GetItemMemoryBit
	BEQ .SetTileNumber
	JSR ShiftObjRight
	BRA .DecAndLoop0
.SetTileNumber
	LDA $0C
	STA [$6B],y
	LDA $0D
	STA [$6E],y
	JSR ShiftObjRight
.DecAndLoop0
	DEC $00
	BPL .StartObjLoop0
	JSR RestorePtrs
	JSR ShiftObjDown
	LDA $02
	STA $00
	DEC $01
	BMI .EndObjLoop0
	JMP .StartObjLoop0
.EndObjLoop0
		RTS

;------------------------------------------------
; make a ledge or block object, which can be specified to have various edges or not
;------------------------------------------------
; Input:
; - A is used as an index to the tile data table.
; - X indicates which corners and edges will be used.
;	00 = top
;	01 = top with left corner
;	02 = top with right corner
;	03 = top with left and right corners
;	04 = bottom
;	05 = bottom with left corner
;	06 = bottom with right corner
;	07 = bottom with left and right corners
;	08 = left edge
;	09 = right edge
;	0A = left edge with top and bottom corners
;	0B = right edge with top and bottom corners
;	0C = top and bottom edges
;	0D = left and right edges
;	0E = all 4 edges and corners
;	0F = 4 inside corners
;------------------------------------------------

LedgeObjects:
if !sa1
	STZ $2250
endif
	REP #$30
	STX $45
	AND #$00FF
if !sa1
	STA $2251
	LDA #$002E
	STA $2253
	NOP
	LDX $2306
else
	ORA #$2E00
	STA $4202
	PHA
	PLA
	LDX $4216
endif
	LDA.w LedgeTiles,x
	STA !ObjScratch
	LDA.w LedgeTiles+$02,x
	STA !ObjScratch+$02
	LDA.w LedgeTiles+$04,x
	STA !ObjScratch+$04
	LDA.w LedgeTiles+$06,x
	STA !ObjScratch+$06
	STA !ObjScratch+$2E
	LDA.w LedgeTiles+$08,x
	STA !ObjScratch+$08
	LDA.w LedgeTiles+$0A,x
	STA !ObjScratch+$0A
	STA !ObjScratch+$30
	LDA.w LedgeTiles+$0C,x
	STA !ObjScratch+$0C
	LDA.w LedgeTiles+$0E,x
	STA !ObjScratch+$0E
	LDA.w LedgeTiles+$10,x
	STA !ObjScratch+$10
	LDA.w LedgeTiles+$12,x
	STA !ObjScratch+$12
	LDA.w LedgeTiles+$14,x
	STA !ObjScratch+$14
	LDA.w LedgeTiles+$16,x
	STA !ObjScratch+$16
	LDA.w LedgeTiles+$18,x
	STA !ObjScratch+$18
	LDA.w LedgeTiles+$1A,x
	STA !ObjScratch+$1A
	LDA.w LedgeTiles+$1C,x
	STA !ObjScratch+$1C
	LDA.w LedgeTiles+$1E,x
	STA !ObjScratch+$1E
	LDA.w LedgeTiles+$20,x
	STA !ObjScratch+$20
	LDA.w LedgeTiles+$22,x
	STA !ObjScratch+$22
	LDA.w LedgeTiles+$24,x
	STA !ObjScratch+$24
	LDA.w LedgeTiles+$26,x
	STA !ObjScratch+$26
	LDA.w LedgeTiles+$28,x
	STA !ObjScratch+$28
	LDA.w LedgeTiles+$2A,x
	STA !ObjScratch+$2A
	LDA.w LedgeTiles+$2C,x
	STA !ObjScratch+$2C
	PHY
	LDA $45
	ASL #4
	TAX
	LDY .TileIndexLookup,x
	LDA !ObjScratch,y
	STA !ObjScratch
	TYA
	LSR
	STA !ObjScratch+$40
	LDY .TileIndexLookup+2,x
	LDA !ObjScratch,y
	STA !ObjScratch+$02
	TYA
	LSR
	STA !ObjScratch+$41
	LDY .TileIndexLookup+4,x
	LDA !ObjScratch,y
	STA !ObjScratch+$04
	TYA
	LSR
	STA !ObjScratch+$42
	LDY .TileIndexLookup+6,x
	LDA !ObjScratch,y
	STA !ObjScratch+$06
	TYA
	LSR
	STA !ObjScratch+$43
	LDY .TileIndexLookup+8,x
	LDA !ObjScratch,y
	STA !ObjScratch+$0A
	TYA
	LSR
	STA !ObjScratch+$45
	LDY .TileIndexLookup+10,x
	LDA !ObjScratch,y
	STA !ObjScratch+$0C
	TYA
	LSR
	STA !ObjScratch+$46
	LDY .TileIndexLookup+12,x
	LDA !ObjScratch,y
	STA !ObjScratch+$0E
	TYA
	LSR
	STA !ObjScratch+$47
	LDY .TileIndexLookup+14,x
	LDA !ObjScratch,y
	STA !ObjScratch+$10
	TYA
	LSR
	STA !ObjScratch+$48
	PLY
	SEP #$30
	LDA #$04
	STA !ObjScratch+$44
	JSR StoreNybbles
	LDY $57
	LDA $08
	STA $00
	LDA $09
	STA $01
	JSR BackUpPtrs
.StartObjLoop
	LDX #$00
	LDA $01
	CMP $09
	BEQ .NoInc1
	INX #3
	CMP #$00
	BNE .NoInc1
	INX #3
.NoInc1
	LDA $00
	CMP $08
	BEQ .NoInc2
	INX
	CMP #$00
	BNE .NoInc2
	INX
.NoInc2
	LDA !ObjScratch+$40,x
	TAX
; if the current tile is the middle or is over top of a blank tile, then use the specified tile number
; if it's over top of the middle fill tile, then use the "filled-in" versions of the tiles
; if it's a corner tile and is over top of a matching edge, change it into an inside corner (or just the filled-in corner for passable ledges)
; if it's an edge tile and is over top of a matching edge, change it into the "overlapping edge" tile (usually identical to either the normal filled-in edge tile for passable edges or the middle tile for solid ones)
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CPX #$04
	BEQ .SetBlockIndex
	CMP #$0025
	BEQ .SetBlockIndex
	CMP !ObjScratch+$08
	BEQ .FilledInTile
	CMP !ObjScratch+$2E
	BEQ .OverlappingEdge
	CMP !ObjScratch+$30
	BEQ .OverlappingEdge
.FilledInTile
	TXA
	CLC
	ADC #$0009
	TAX
	CPX #$0D
	BCC .SetBlockIndex
	DEX
	BRA .SetBlockIndex
.OverlappingEdge
	LDA .OverlapTileType,x
	TAX
.SetBlockIndex
	TXA
	ASL
	TAX
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	JSR ShiftObjRight
.DecAndLoop
	DEC $00
	BPL .StartObjLoop
	JSR RestorePtrs
	JSR ShiftObjDown
	LDA $08
	STA $00
	DEC $01
	BMI .EndObjLoop
	JMP .StartObjLoop
.EndObjLoop
.Return
		RTS

.TileIndexLookup
	dw $0002,$0002,$0002,$0008,$0008,$0008,$0008,$0008
	dw $0000,$0002,$0002,$0006,$0008,$0006,$0008,$0008
	dw $0002,$0002,$0004,$0008,$000A,$0008,$0008,$000A
	dw $0000,$0002,$0004,$0006,$000A,$0006,$0008,$000A
	dw $0008,$0008,$0008,$0008,$0008,$000E,$000E,$000E
	dw $0006,$0008,$0008,$0006,$0008,$000C,$000E,$000E
	dw $0008,$0008,$000A,$0008,$000A,$000E,$000E,$0010
	dw $0006,$0008,$000A,$0006,$000A,$000C,$000E,$0010
	dw $0006,$0008,$0008,$0006,$0008,$0006,$0008,$0008
	dw $0008,$0008,$000A,$0008,$000A,$0008,$0008,$000A
	dw $0000,$0002,$0002,$0006,$0008,$000C,$000E,$000E
	dw $0002,$0002,$0004,$0008,$000A,$000E,$000E,$0010
	dw $0002,$0002,$0002,$0008,$0008,$000E,$000E,$000E
	dw $0006,$0008,$000A,$0006,$000A,$0006,$0008,$000A
	dw $0000,$0002,$0004,$0006,$000A,$000C,$000E,$0010
	dw $0024,$0008,$0022,$0008,$0008,$0028,$0008,$0026

.OverlapTileType
	db $11,$0A,$12,$15,$FF,$16,$13,$0F,$14

;------------------------------------------------
; make a slope object (this routine handles all of the different slopes)
;------------------------------------------------
; Input:
; - A indicates the slope type.  This can be 00-09.  In order, the types are steep left, steep right,
; normal left, normal right, gradual left, gradual right, upside-down steep left, upside-down
; steep right, upside-down normal left, upside-down normal right.
; - Y indicates the tilemap data index (basically, think of this as the tileset number).
; This is normally the value of $58.
;------------------------------------------------

SlopeObjects:
	STA $00
	TYA
	ASL
	TAY
	REP #$20
	LDA SlopeTilemapData,y
	STA $01
	LDY $00
	INY
	LDA ($01),y
	STA $03
	LDA SlopeDataSize-1,y
	AND #$00FF
	STA $04
	LDA ($01)
	TAY
	LDA ($01),y
	STA !ObjScratch
	LDY $03
	LDX #$02
.Loop
	LDA ($01),y
	STA !ObjScratch,x
	INY #2
	INX #2
	DEC $04
	BNE .Loop
	ASL $00
	LDY $00
	LDA SlopeTypePointers,y
	DEC
	PHA
	SEP #$30
	JMP CustObjInitStd

; $45 = number of tiles to draw on the current line
; $47 = number of tiles drawn on the current line
SlopeSteepL:
	STZ $45
.LoopTop
	STZ $47
	LDA $08
	BEQ .NoShift
	JSR CustObjShiftRX
.NoShift
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0002
	CMP #$0025
	BEQ $03
	LDX #$0006
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	LDA $47
	CMP $45
	BEQ .TopNextLine
	INC $47
	JSR CustObjShiftR1
	LDA !ObjScratch+$04
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	LDA $47
	CMP $45
	BEQ .TopNextLine
	INC $47
.SubLoopTop
	JSR CustObjShiftR1
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	LDA $47
	CMP $45
	BCS .TopNextLine
	INC $47
	BRA .SubLoopTop
.TopNextLine
	DEC $08
	BMI .EndTop
	JSR CustObjShiftR1
	JSR CustObjShiftD1
	INC $45
	BRA .LoopTop
.EndTop
	JSR CustObjShiftR1
	JSR CustObjShiftD1
	LDA !ObjScratch+$04
.LoopBottom
	LDX $04
	STX $08
.SubLoopBottom
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopBottom
	JSR CustObjShiftD1
	LDA !ObjScratch
	DEC $0A
	BPL .LoopBottom
	SEP #$30
		RTS

SlopeSteepR:
	STZ $45
.LoopTop
	STZ $47
.SubLoopTop
	LDA $47
	INC
	CMP $45
	BCS .ContinueTop
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	INC $47
	BRA .SubLoopTop
.ContinueTop
	BNE .SkipCorner
	LDA !ObjScratch+$04
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
.SkipCorner
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0002
	CMP #$0025
	BEQ $03
	LDX #$0006
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
.TopNextLine
	DEC $08
	BMI .EndTop
	JSR CustObjShiftD1NoReset
	LDA $45
	JSR CustObjShiftLX
	INC $45
	BRA .LoopTop
.EndTop
	JSR CustObjShiftD1NoReset
	LDA !ObjScratch+$04
.LoopBottom
	LDX $04
	STX $08
.SubLoopBottom
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftL1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopBottom
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	JSR CustObjShiftRX
	LDA !ObjScratch
	DEC $0A
	BPL .LoopBottom
	SEP #$30
		RTS

SlopeNormalL:
	STZ $45
.LoopTop
	STZ $47
	LDA $08
	BEQ .NoShift
	ASL
	JSR CustObjShiftRX
.NoShift
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0002
	CMP #$0025
	BEQ $03
	LDX #$000A
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0004
	CMP #$0025
	BEQ $03
	LDX #$000C
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA $47
	CMP $45
	BEQ .TopNextLine
	INC $47
	LDA !ObjScratch+$06
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$08
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA $47
	CMP $45
	BEQ .TopNextLine
	INC $47
.SubLoopTop
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftR1
	LDA $47
	CMP $45
	BCS .TopNextLine
	INC $47
	BRA .SubLoopTop
.TopNextLine
	DEC $08
	BMI .EndTop
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL
	JSR CustObjShiftLX
	INC $45
	JMP .LoopTop
.EndTop
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL
	JSR CustObjShiftLX
	LDA !ObjScratch+$06
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$08
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA $04
	STA $08
	BRA .SubLoopBottomEntry1
.LoopBottom
	LDX $04
	STX $08
.SubLoopBottom
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftR1
.SubLoopBottomEntry1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopBottom
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL
	JSR CustObjShiftLX
	LDA !ObjScratch
	DEC $0A
	BPL .LoopBottom
	SEP #$30
		RTS

SlopeNormalR:
	STZ $45
.LoopTop
	STZ $47
.SubLoopTop
	LDA $47
	INC
	CMP $45
	BCS .ContinueTop
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftR1
	INC $47
	BRA .SubLoopTop
.ContinueTop
	BNE .SkipCorner
	LDA !ObjScratch+$06
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$08
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
.SkipCorner
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0002
	CMP #$0025
	BEQ $03
	LDX #$000A
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0004
	CMP #$0025
	BEQ $03
	LDX #$000C
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
.TopNextLine
	DEC $08
	BMI .EndTop
	JSR CustObjShiftD1NoReset
	LDA $45
	INC
	ASL
	JSR CustObjShiftLX
	INC $45
	JMP .LoopTop
.EndTop
	JSR CustObjShiftD1NoReset
	JSR CustObjShiftL1
	LDA !ObjScratch+$08
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftL1
	LDA !ObjScratch+$06
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftL1
	LDA $04
	STA $08
	BRA .SubLoopBottomEntry1
.LoopBottom
	LDX $04
	STX $08
.SubLoopBottom
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftL1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftL1
.SubLoopBottomEntry1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopBottom
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL
	JSR CustObjShiftRX
	LDA !ObjScratch
	DEC $0A
	BPL .LoopBottom
	SEP #$30
		RTS

SlopeGradualL:
	STZ $45
.LoopTop
	STZ $47
	LDA $08
	BEQ .NoShift
	ASL #2
	JSR CustObjShiftRX
.NoShift
	LDX #$0002
.Loop1
	PHX
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	CMP #$0025
	BEQ .NoFill
	TXA
	CLC
	ADC #$0010
	TAX
.NoFill
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	PLX
	INX #2
	CPX #$000A
	BCC .Loop1
	LDA $47
	CMP $45
	BNE .Continue
	JMP .TopNextLine
.Continue
	INC $47
	LDX #$000A
.Loop2
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	INX #2
	CPX #$0012
	BCC .Loop2
	LDA $47
	CMP $45
	BEQ .TopNextLine
	INC $47
.SubLoopTop
	LDX #$0000
	LDA !ObjScratch
.Loop3
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	XBA
	INX
	CPX #$0004
	BCC .Loop3
	LDA $47
	CMP $45
	BCS .TopNextLine
	INC $47
	BRA .SubLoopTop
.TopNextLine
	DEC $08
	BMI .EndTop
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL #2
	JSR CustObjShiftLX
	INC $45
	JMP .LoopTop
.EndTop
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL #2
	JSR CustObjShiftLX
	LDX #$000A
.Loop4
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	INX #2
	CPX #$0012
	BCC .Loop4
	LDA $04
	STA $08
	BRA .SubLoopBottomEntry1
.LoopBottom
	LDX $04
	STX $08
.SubLoopBottom
	LDX #$0000
.Loop5
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	XBA
	INX #2
	CPX #$0008
	BCC .Loop5
.SubLoopBottomEntry1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopBottom
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL #2
	JSR CustObjShiftLX
	LDA !ObjScratch
	DEC $0A
	BPL .LoopBottom
	SEP #$30
		RTS

SlopeGradualR:
	STZ $45
.LoopTop
	STZ $47
.SubLoopTop
	LDA $47
	INC
	CMP $45
	BCS .ContinueTop
	LDX #$0000
	LDA !ObjScratch
.Loop1
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	XBA
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	INX #2
	CPX #$0008
	BCC .Loop1
	INC $47
	BRA .SubLoopTop
.ContinueTop
	BNE .SkipCorner
	LDX #$000A
.Loop2
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	INX #2
	CPX #$0012
	BCC .Loop2
.SkipCorner
	LDX #$0002
.Loop3
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	PHX
	CMP #$0025
	BEQ .NoFill
	TXA
	CLC
	ADC #$0010
	TAX
.NoFill
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	PLX
	INX #2
	CPX #$000A
	BCC .Loop3
.TopNextLine
	DEC $08
	BMI .EndTop
	JSR CustObjShiftD1NoReset
	LDA $45
	INC
	ASL #2
	JSR CustObjShiftLX
	INC $45
	JMP .LoopTop
.EndTop
	JSR CustObjShiftD1NoReset
	LDX #$0010
.Loop4
	JSR CustObjShiftL1
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	DEX #2
	CPX #$000A
	BCS .Loop4
	LDA $04
	STA $08
	BRA .SubLoopBottomEntry1
.LoopBottom
	LDX $04
	STX $08
.SubLoopBottom
	LDX #$0000
.Loop5
	PHA
	JSR CustObjShiftL1
	PLA
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	XBA
	INX #2
	CPX #$0008
	BCC .Loop5
.SubLoopBottomEntry1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopBottom
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL #2
	JSR CustObjShiftRX
	LDA !ObjScratch
	DEC $0A
	BPL .LoopBottom
	SEP #$30
		RTS

SlopeUpsideDownSteepL:
	LDA !ObjScratch
	PEI ($08)
.LoopTop
	LDX $04
	STX $08
.SubLoopTop
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopTop
	JSR CustObjShiftD1
	LDA !ObjScratch
	DEC $0A
	BPL .LoopTop
	PLA
	STA $08
	JSR CustObjShiftU1NoReset
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftD1NoReset
	LDA $04
	STA $45
	STZ $08
.LoopBottom
	STZ $47
	LDA $08
	BEQ .NoShift
	JSR CustObjShiftRX
.NoShift
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0004
	CMP #$0025
	BEQ $03
	LDX #$0008
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	LDA $47
	CMP $45
	BEQ .BottomNextLine
	INC $47
	JSR CustObjShiftR1
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	LDA $47
	CMP $45
	BEQ .BottomNextLine
	INC $47
.SubLoopBottom
	JSR CustObjShiftR1
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	LDA $47
	CMP $45
	BCS .BottomNextLine
	INC $47
	BRA .SubLoopBottom
.BottomNextLine
	INC $08
	LDA $08
	DEC
	CMP $04
	BEQ .EndBottom
	JSR CustObjShiftR1
	JSR CustObjShiftD1
	DEC $45
	BRA .LoopBottom
.EndBottom
		RTS

SlopeUpsideDownSteepR:
	LDA !ObjScratch
.LoopTop
	LDX $04
	STX $08
.SubLoopTop
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopTop
	DEC $0A
	BMI .Break
	JSR CustObjShiftD1
	LDA !ObjScratch
	BRA .LoopTop
.Break
	JSR CustObjShiftL1
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	JSR CustObjShiftD1
	LDA $04
	STA $45
	STA $08
.LoopBottom
	STZ $47
.SubLoopBottom
	LDA $47
	INC
	CMP $45
	BCS .ContinueBottom
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	INC $47
	BRA .SubLoopBottom
.ContinueBottom
	BNE .SkipCorner
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
.SkipCorner
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0004
	CMP #$0025
	BEQ $03
	LDX #$0006
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
.BottomNextLine
	DEC $08
	BMI .EndBottom
	DEC $04
	JSR CustObjShiftD1
	DEC $45
	BRA .LoopBottom
.EndBottom
		RTS

SlopeUpsideDownNormalL:
	LDA !ObjScratch
	PEI ($08)
.LoopTop
	LDX $04
	STX $08
.SubLoopTop
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopTop
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL
	JSR CustObjShiftLX
	LDA !ObjScratch
	DEC $0A
	BPL .LoopTop
	PLA
	STA $08
	JSR CustObjShiftU1NoReset
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$04
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftD1NoReset
	JSR CustObjShiftL1
	LDA $04
	STA $45
	STZ $08
.LoopBottom
	STZ $47
	LDA $08
	BEQ .NoShift
	ASL
	JSR CustObjShiftRX
.NoShift
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0006
	CMP #$0025
	BEQ $03
	LDX #$000A
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0008
	CMP #$0025
	BEQ $03
	LDX #$000C
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA $47
	CMP $45
	BEQ .BottomNextLine
	INC $47
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$04
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA $47
	CMP $45
	BEQ .BottomNextLine
	INC $47
.SubLoopBottom
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftR1
	LDA $47
	CMP $45
	BCS .BottomNextLine
	INC $47
	BRA .SubLoopBottom
.BottomNextLine
	INC $08
	LDA $08
	DEC
	CMP $04
	BEQ .EndBottom
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	ASL
	JSR CustObjShiftLX
	DEC $45
	JMP .LoopBottom
.EndBottom
		RTS

SlopeUpsideDownNormalR:
	LDA !ObjScratch
	PEI ($08)
.LoopTop
	LDX $04
	STX $08
.SubLoopTop
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	PHA
	JSR CustObjShiftR1
	PLA
	SEP #$20
	STA [$6E],y
	XBA
	STA [$6B],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch
	DEC $08
	BPL .SubLoopTop
	JSR CustObjShiftD1NoReset
	DEC $0A
	BMI .Break
	LDA $04
	INC
	ASL
	JSR CustObjShiftLX
	LDA !ObjScratch
	BRA .LoopTop
.Break
	PLA
	STA $08
	JSR CustObjShiftU1NoReset
	LDA #$0002
	JSR CustObjShiftLX
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$04
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftD1NoReset
	LDA $04
	ASL
	INC
	JSR CustObjShiftLX
	LDA $04
	STA $45
	STA $08
.LoopBottom
	STZ $47
.SubLoopBottom
	LDA $47
	INC
	CMP $45
	BCS .ContinueBottom
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	INC $47
	BRA .SubLoopBottom
.ContinueBottom
	BNE .SkipCorner
	LDA !ObjScratch+$02
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	LDA !ObjScratch+$04
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
.SkipCorner
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0006
	CMP #$0025
	BEQ $03
	LDX #$000A
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
	REP #$20
	LDX #$0008
	CMP #$0025
	BEQ $03
	LDX #$000C
	LDA !ObjScratch,x
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	REP #$20
	JSR CustObjShiftR1
.BottomNextLine
	DEC $08
	BMI .EndBottom
	DEC $04
	JSR CustObjShiftD1NoReset
	LDA $04
	INC
	INC
	ASL
	JSR CustObjShiftLX
	DEC $45
	JMP .LoopBottom
.EndBottom
		RTS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; other subroutines (many of them ripped or adapted directly from SMW)
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;------------------------------------------------
; allow an object to go across screen boundaries horizontally (adapted from $0DA95B)
;------------------------------------------------

ShiftObjRight:
	INY
	TYA
	AND #$0F
	BNE .NoScreenChange
	LDA $5B
	LSR
	BCS .VertLvl
	REP #$21
	LDA $6B
	ADC $13D7|!addr
	STA $6B
	STA $6E
	LDA #$0000
	SEP #$20
	INC $1BA1|!addr
	LDA $57
	AND #$F0
	TAY
.NoScreenChange
		RTS
.VertLvl
	INC $6C
	INC $6F
	LDA $57
	AND #$F0
	TAY
		RTS

;------------------------------------------------
; allow an object to go across subscreen boundaries vertically (adapted from $0DA97D)
;------------------------------------------------

ShiftObjDown:
	LDA $57
.Sub
	CLC
	ADC #$10
	STA $57
	TAY
	BCC .NoScreenChange
	LDA $5B
	AND #$01
	BNE .VertLvl
	LDA $6C
	ADC #$00
	STA $6C
	STA $6F
	STA $05
.NoScreenChange
		RTS
.VertLvl
	LDA $6C
	ADC #$01
	STA $6C
	STA $6F
	INC $1BA1|!addr
		RTS

;------------------------------------------------
; allow an object to go across subscreen boundaries vertically; will not reset the X position (adapted from $0DA97D)
;------------------------------------------------

ShiftObjDownAlt:
	TYA
	BRA ShiftObjDown_Sub

;------------------------------------------------
; allow an object to go across screen boundaries backward horizontally
;------------------------------------------------

ShiftObjLeft:
	DEY
	TYA
	AND #$0F
	CMP #$0F
	BNE .NoScreenChange
	LDA $5B
	LSR
	BCS .VertLvl
	REP #$20
	LDA $6B
	SEC
	SBC $13D7|!addr
	STA $6B
	STA $6E
	SEP #$20
	DEC $1BA1|!addr
	LDA $57
	AND #$F0
	ORA #$0F
	TAY
.NoScreenChange
		RTS
.VertLvl
	DEC $6C
	DEC $6F
	LDA $57
	AND #$F0
	ORA #$0F
	TAY
		RTS

;------------------------------------------------
; allow an object to go across subscreen boundaries backward vertically
;------------------------------------------------

ShiftObjUp:
	LDA $57
.Sub
	SEC
	SBC #$10
	STA $57
	TAY
	BCS .NoScreenChange
	LDA $5B
	AND #$01
	BNE .VertLvl
	LDA $6C
	SBC #$00
	STA $6C
	STA $6F
	STA $05
.NoScreenChange
		RTS
.VertLvl
	LDA $6C
	SBC #$01
	STA $6C
	STA $6F
	DEC $1BA1|!addr
		RTS

;------------------------------------------------
; allow an object to go across subscreen boundaries backward vertically; will not reset the X position
;------------------------------------------------

ShiftObjUpAlt:
	TYA
	BRA ShiftObjUp_Sub

;------------------------------------------------
; allow an object to go across screen boundaries horizontally; shifts a customizable number of tiles (input in A)
;------------------------------------------------

ShiftObjRight2:
	STA $0E
.Check
	CMP #$11
	BCC .Run
	PHA
	REP #$20
	LDA $6B
	CLC
	ADC $13D7|!addr
	STA $6B
	STA $6E
	SEP #$20
	INC $1BA1|!addr
	PLA
	SEC
	SBC #$10
	STA $0E
	BRA .Check
.Run
	LDA $57
	AND #$0F
	STA $0F
	CLC
	ADC $0E
	CMP #$10
	AND #$0F
	STA $0F
	BCC .NoScreenChange
	LDA $5B
	AND #$01
	BNE .VertLvl
	REP #$20
	LDA $6B
	ADC $13D7|!addr
	STA $6B
	STA $6E
	SEP #$20
	INC $1BA1|!addr
.NoScreenChange
	LDA $57
	AND #$F0
	ORA $0F
	STA $57
	TAY
		RTS
.VertLvl
	INC $6C
	INC $6F
	LDA $57
	AND #$F0
	ORA $0F
	TAY
		RTS

;------------------------------------------------
; allow an object to go across subscreen boundaries vertically; shifts a customizable number of tiles (input in A)
;------------------------------------------------

ShiftObjDown2:
	ASL #4
	STA $0E
	LDA $57
	CLC
	ADC $0E
	STA $57
	TAY
	BCC .NoScreenChange
	LDA $5B
	AND #$01
	BNE .VertLvl
	LDA $6C
	ADC #$00
	STA $6C
	STA $6F
	STA $05
.NoScreenChange
		RTS
.VertLvl
	LDA $6C
	CLC
	ADC #$02
	STA $6C
	STA $6F
	INC $1BA1|!addr
		RTS

;------------------------------------------------
; allow an object to go across screen boundaries backward horizontally; shifts a customizable number of tiles (input in A)
;------------------------------------------------

ShiftObjLeft2:
	STA $0E
	LDA $57
	AND #$0F
	STA $0F
	SEC
	SBC $0E
	CMP #$10
	AND #$0F
	STA $0F
	BCC .NoScreenChange
	LDA $5B
	LSR
	BCS .VertLvl
	REP #$20
	LDA $6B
	SEC
	SBC $13D7|!addr
	STA $6B
	STA $6E
	SEP #$20
	DEC $1BA1|!addr
.NoScreenChange
	LDA $57
	AND #$F0
	ORA $0F
	STA $57
		RTS
.VertLvl
	DEC $6C
	DEC $6F
	LDA $57
	AND #$F0
	ORA #$0F
	TAY
		RTS

;------------------------------------------------
; allow an object to go across subscreen boundaries backward vertically; shifts a customizable number of tiles (input in A)
;------------------------------------------------

ShiftObjUp2:
	LDA $57
.Sub
	SEC
	SBC #$10
	STA $57
	TAY
	BCS .NoScreenChange
	LDA $5B
	AND #$01
	BNE .VertLvl
	LDA $6C
	SBC #$00
	STA $6C
	STA $6F
	STA $05
.NoScreenChange
		RTS
.VertLvl
	LDA $6C
	SEC
	SBC #$02
	STA $6C
	STA $6F
	DEC $1BA1|!addr
		RTS

;------------------------------------------------
; back up the low and high byte of the Map16 pointers in scratch RAM (ripped from $0DA6B1)
;------------------------------------------------
; also includes a call point for a typical object initialization routine
;------------------------------------------------

ObjectInitStd:
	JSR StoreNybbles
	LDY $57
	LDA $08
	STA $00
	STA $02
	LDA $09
	STA $01
BackUpPtrs:
	LDA $6B
	STA $04
	LDA $6C
	STA $05
		RTS

;------------------------------------------------
; restore the low and high byte of the Map16 pointers from scratch RAM (ripped from $0DA6BA)
;------------------------------------------------

RestorePtrs:
	LDA $04
	STA $6B
	STA $6E
	LDA $05
	STA $6C
	STA $6F
	LDA $1928|!addr
	STA $1BA1|!addr
		RTS

;------------------------------------------------
; check item memory for a particular block position (ripped from $0DA8DC)
;------------------------------------------------
; Output: A will be 0 if the item memory bit is not set and nonzero if it is set.
;------------------------------------------------

GetItemMemoryBit:
	PHX
	PHY
	LDX $13BE|!addr
	LDA #$F8
	CLC
	ADC $0DA8AE|!bank,x
	STA $08
	LDA.b #$19|(!addr>>8)
	ADC $0DA8B1|!bank,x
	STA $09
	LDA $1BA1|!addr
	ASL #2
	STA $0E
	LDA $0A
	AND #$10
	BEQ .UpperSubscreen
	LDA $0E
	ORA #$02
	STA $0E
.UpperSubscreen
	TYA
	AND #$08
	BEQ .LeftHalfOfScreen
	LDA $0E
	ORA #$01
	STA $0E
.LeftHalfOfScreen
	TYA
	AND #$07
	TAX
	LDY $0E
	LDA ($08),y
	AND $0DA8A6|!bank,x
	PLY
	PLX
	CMP #$00
		RTS

;------------------------------------------------
; store object variables to scratch RAM (X position to $06, Y position to $07, width to $08, and height to $09)
;------------------------------------------------

StoreNybbles:
	LDA $57
	AND #$0F
	STA $06
	LDA $57
	LSR #4
	STA $07
	LDA $59
	AND #$0F
	STA $08
	LDA $59
	LSR #4
	STA $09
		RTS

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; custom variants of some of the base subroutines
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; For this system:
; - 16-bit AXY most of the time (A can be switched to 8-bit mode, but XY should ALWAYS be left as 16-bit because Y indexes the Map16 pointers)
; - Y = index to Map16 data (is a multiple of $13D7|!addr or #$0200 plus an object's position within a screen or column of screens)
; $57: unused? (originally object position within the subscreen (yyyyxxxx))
; $58: normal object extra settings byte
; $59: normal object size/extended object number
; $5A: normal object number
; $00-$01: screen height (is the value of $13D7|!addr for horizontal levels and #$0100 for vertical ones)
; $02-$03: object initial position index
; $04-$05: object width
; $06-$07: object height
; $08-$09: counter for object width
; $0A-$0B: counter for object height
; $0C-$0F: scratch

CustObjInitStd:
	LDA $59
	AND #$0F
	STA $04
	STZ $05
	LDA $59
	LSR #4
	STA $06
	STZ $07
	LDA $0A
	AND #$10
	LSR #4
	STA $0F
	LDA $5B
	LSR
	BCS .Vertical
	LDA $8B
	ORA $0F
	STA $09
	LDA $57
	STA $08
	if !sa1
		STZ $2250
	endif
	REP #$30
	LDA $13D7|!addr
	CMP #$0FF0
	BCC .MultiplyScreen
	LDY $08
	CMP #$12A0
	BEQ .Mode1A
	CMP #$1C00
	BNE .Shared
.Mode1B
	LDA $1BA1|!addr
	AND #$00FF
	BEQ .Shared
	TYA
	CLC
	ADC #$1C00
	TAY
	BRA .Shared
.Mode1A
	LDA $1BA1|!addr
	AND #$00FF
	DEC
	BMI .Shared
	BNE .Mode1AScreen02
.Mode1AScreen01
	TYA
	CLC
	ADC #$12A0
	TAY
	BRA .Shared
.Mode1AScreen02
	TYA
	CLC
	ADC #$2540
	TAY
	BRA .Shared
.MultiplyScreen
	LSR #4
	if !sa1
		AND #$00FF
		STA $2251
		LDA $1BA1|!addr
		AND #$00FF
		STA $2253
		NOP
		LDA $2306
	else
		SEP #$20
		STA $4202
		LDA $1BA1|!addr
		STA $4203
		PHA
		PLA
		REP #$30
		LDA $4216
	endif
	ASL #4
	ADC $08
	TAY
	BRA .Shared
.Vertical
	LDA $57
	STA $0E
	LDA $1BA1|!addr
	if !sa1
		REP #$30
		AND #$00FF
		STA $2251
		LDA #$0020
		STA $2253
		NOP
		LDA $2306
	else
		STA $4202
		LDA #$20
		STA $4203
		REP #$30
		LDA #$0100
		STA $00
		LDA $4216
	endif
	ASL #4
	ADC $0E
	TAY
.Shared
	STA $02
	LDA #$C800
	STA $6B
	LDA #$0000|!map16
	STA $6D
	LDA #$00C8|((!map16|$01)<<8)
	STA $6F
	LDA $04
	STA $08
	LDA $06
	STA $0A
	LDA $13D7|!addr
	STA $00
		RTS

;------------------------------------------------
; shift the current tile position index right
;------------------------------------------------

CustObjShiftR1:
	LDA #$0001
CustObjShiftRX:
	STA $0E
.Check
	CMP #$0011
	BCC .Run
	PHA
	TYA
	CLC
	ADC $00
	TAY
	PLA
	SEC
	SBC #$0010
	STA $0E
	BRA .Check
.Run
	LDA $5B
	LSR
	BCS .Vertical
	TYA
	PHA
	CLC
	ADC $0E
	TAY
	PLA
	AND #$000F
	CLC
	ADC $0E
	CMP #$0010
	BCC .NoScreenChange
	TYA
	SEC
	SBC #$0010
	CLC
	ADC $00
	TAY
.NoScreenChange
		RTS
.Vertical
	TYA
	PHA
	CLC
	ADC $0E
	TAY
	PLA
	AND #$000F
	CLC
	ADC $0E
	CMP #$0010
	BCC .NoScreenChange
	TYA
	CLC
	ADC #$00F0
	TAY
		RTS

;------------------------------------------------
; shift the current tile position index left
;------------------------------------------------

CustObjShiftL1:
	LDA #$0001
CustObjShiftLX:
	STA $0E
.Check
	CMP #$0011
	BCC .Run
	PHA
	TYA
	SEC
	SBC $00
	TAY
	PLA
	SEC
	SBC #$0010
	STA $0E
	BRA .Check
.Run
	LDA $5B
	LSR
	BCS .Vertical
	TYA
	PHA
	SEC
	SBC $0E
	TAY
	PLA
	AND #$000F
	SEC
	SBC $0E
	BPL .NoScreenChange
	TYA
	CLC
	ADC #$0010
	SEC
	SBC $00
	TAY
.NoScreenChange
		RTS
.Vertical
	TYA
	PHA
	SEC
	SBC $0E
	TAY
	PLA
	AND #$000F
	SEC
	SBC $0E
	BPL .NoScreenChange
	TYA
	SEC
	SBC #$00F0
	TAY
		RTS

;------------------------------------------------
; shift the current tile position index down; reset the X position
;------------------------------------------------

CustObjShiftD1:
	LDA #$0001
CustObjShiftDX:
	ASL #4
	STA $0E
	LDA $5B
	LSR
	BCS .Vertical
	TYA
	CLC
	ADC $0E
	TAY
	LDA $04
	INC
	JMP CustObjShiftLX
.Vertical
	PHY
	TYA
	CLC
	ADC $0E
	TAY
	EOR $01,s
	AND #$0100
	BEQ .NoScreenChange
	TYA
	CLC
	ADC #$0100
	TAY
.NoScreenChange
	PLA
	LDA $04
	INC
	JMP CustObjShiftLX

;------------------------------------------------
; shift the current tile position index down; do not reset the X position
;------------------------------------------------

CustObjShiftD1NoReset:
	LDA #$0001
CustObjShiftDXNoReset:
	ASL #4
	STA $0E
	LDA $5B
	LSR
	BCS .Vertical
	TYA
	CLC
	ADC $0E
	TAY
		RTS
.Vertical
	PHY
	TYA
	CLC
	ADC $0E
	TAY
	EOR $01,s
	AND #$0100
	BEQ .NoScreenChange
	TYA
	CLC
	ADC #$0100
	TAY
.NoScreenChange
	PLA
		RTS

;------------------------------------------------
; shift the current tile position index up; reset the X position
;------------------------------------------------

CustObjShiftU1:
	LDA #$0001
CustObjShiftUX:
	AND #$00FF
	ASL #4
	STA $0E
	LDA $5B
	LSR
	BCS .Vertical
	TYA
	SEC
	SBC $0E
	TAY
	LDA $04
	INC
	JMP CustObjShiftLX
.Vertical
	PHY
	TYA
	SEC
	SBC $0E
	TAY
	EOR $01,s
	AND #$0100
	BEQ .NoScreenChange
	TYA
	SEC
	SBC #$0100
	TAY
.NoScreenChange
	PLA
	LDA $04
	INC
	JMP CustObjShiftLX

;------------------------------------------------
; shift the current tile position index up; do not reset the X position
;------------------------------------------------

CustObjShiftU1NoReset:
	LDA #$0001
CustObjShiftUXNoReset:
	ASL #4
	STA $0E
	LDA $5B
	LSR
	BCS .Vertical
	TYA
	SEC
	SBC $0E
	TAY
		RTS
.Vertical
	PHY
	TYA
	SEC
	SBC $0E
	TAY
	EOR $01,s
	AND #$0100
	BEQ .NoScreenChange
	TYA
	SEC
	SBC #$0100
	TAY
.NoScreenChange
	PLA
		RTS

;------------------------------------------------
; find the acts-like setting of the tile at the current position (or a specified tile number)
;------------------------------------------------

FindMap16ActsLike:
	PHP
	SEP #$20
	LDA [$6E],y
	XBA
	LDA [$6B],y
FindMap16ActsLikeEntry1:
	REP #$20
.Loop
	ASL
	ADC $06F624|!bank
	STA $0D
	SEP #$20
	LDA $06F626|!bank
	STA $0F
	REP #$20
	LDA [$0D]
	CMP #$0200
	BCS .Loop
	PLP
		RTS









