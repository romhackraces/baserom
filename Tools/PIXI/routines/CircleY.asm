;Routine that gets the y distance when given an angle and a radius. For sprites
;That move in circles. 

;Input:  $04 = angle (16 bit) actually only 9 bit are used 000-1FF = 0°-359°
;        $06 = radius (8 bit)
;
;Output: $09 = Y displacement (16 bit)

	phx
	lda $05 : lsr
	ldx $04
	lda.l .sincostable,x
if !SA1 == 0
	sta $211B
	stz $211B
	lda $06
	sta $211C
	rep #$20
	lda $2135
else
	stz $2250
	sta $2251
	stz $2252
	lda $06
	sta $2253
	stz $2254
	rep #$20
	lda $2307
endif
	bcc ?+
	eor #$FFFF : inc
?+	
	sta $09
	sep #$20
	plx
	rtl


.sincostable:
db $00,$03,$06,$09,$0C,$0F,$12,$15,$19,$1C,$1F,$22,$25,$28,$2B,$2E
db $31,$35,$38,$3B,$3E,$41,$44,$47,$4A,$4D,$50,$53,$56,$59,$5C,$5F
db $61,$64,$67,$6A,$6D,$70,$73,$75,$78,$7B,$7E,$80,$83,$86,$88,$8B
db $8E,$90,$93,$95,$98,$9B,$9D,$9F,$A2,$A4,$A7,$A9,$AB,$AE,$B0,$B2
db $B5,$B7,$B9,$BB,$BD,$BF,$C1,$C3,$C5,$C7,$C9,$CB,$CD,$CF,$D1,$D3
db $D4,$D6,$D8,$D9,$DB,$DD,$DE,$E0,$E1,$E3,$E4,$E6,$E7,$E8,$EA,$EB
db $EC,$ED,$EE,$EF,$F1,$F2,$F3,$F4,$F4,$F5,$F6,$F7,$F8,$F9,$F9,$FA
db $FB,$FB,$FC,$FC,$FD,$FD,$FE,$FE,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF

db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FE,$FE,$FD,$FD,$FC,$FC,$FB
db $FB,$FA,$F9,$F9,$F8,$F7,$F6,$F5,$F4,$F4,$F3,$F2,$F1,$EF,$EE,$ED
db $EC,$EB,$EA,$E8,$E7,$E6,$E4,$E3,$E1,$E0,$DE,$DD,$DB,$D9,$D8,$D6
db $D4,$D3,$D1,$CF,$CD,$CB,$C9,$C7,$C5,$C3,$C1,$BF,$BD,$BB,$B9,$B7
db $B5,$B2,$B0,$AE,$AB,$A9,$A7,$A4,$A2,$9F,$9D,$9B,$98,$95,$93,$90
db $8E,$8B,$88,$86,$83,$80,$7E,$7B,$78,$75,$73,$70,$6D,$6A,$67,$64
db $61,$5F,$5C,$59,$56,$53,$50,$4D,$4A,$47,$44,$41,$3E,$3B,$38,$35
db $31,$2E,$2B,$28,$25,$22,$1F,$1C,$19,$15,$12,$0F,$0C,$09,$06,$03