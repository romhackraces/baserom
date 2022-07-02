if read1($00FFD5) == $23
	sa1rom
	!14C8 = $3242
	!14D4 = $3258
	!14E0 = $326E
	!166E = $7600
	!187B = $3410
	!1FE2 = $7FD6
else
	lorom
	!14C8 = $14C8
	!14D4 = $14D4
	!14E0 = $14E0
	!166E = $166E
	!187B = $187B
	!1FE2 = $1FE2
endif

!EXLEVEL = 0
if (((read1($0FF0B4)-'0')*100)+((read1($0FF0B4+2)-'0')*10)+(read1($0FF0B4+3)-'0')) > 253
	!EXLEVEL = 1
endif

org $02A9D2
	autoclean jsl Main
	nop

freedata

Main:
	lda #$04	;\ Restore original code.
	sta !1FE2,x	;/
	lda !14C8,x	;\ If not in "stationary" state, return.
	cmp #$09	;|
	bne .Return2	;/
	dey #2		; Get index to first byte of sprite data
	lda [$CE],y	;\ If the extra bit is not 1 (or 3), return.
	and #$04	;|
	beq .Return	;/
	lda $5B		;\ Store X high position if the level is vertical.
	lsr		;|
	bcc .Horz	;|
.Vert			;|
	lda [$CE],y	;|
	and #$01	;|
	sta !14E0,x	;/
if !EXLEVEL == 1
.Horz
else	
	bra +		;\ If LM version <= 2.53, also store Y high position in horizontal levels.
.Horz			;|
	lda [$CE],y	;|
	and #$01	;|
	sta !14D4,x	;/
endif
+	lda #$01	;\ Enable bounce interaction with Mario.
	sta !187B,x	;/
	inc !14C8,x	; Set state as "kicked".
	lda !166E,x	;\ Make immune to cape/fireball (thanks to Maarfy).
	ora #$30	;|
	sta !166E,x	;/
.Return
	iny #2		; Restore y.
.Return2
	rtl		; Return.
