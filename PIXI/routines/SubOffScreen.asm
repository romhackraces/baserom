;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sub_Off_Screen_XA
; input A for which sub_off_screen to use (usually 0). Only last 3 bits are used.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

			AND #$07
			ASL A
			STA $03

.start:			
			LDA !15A0,x             ; \ if sprite is on screen, accumulator = 0 
			ORA !186C,x             ; | return
			BNE .checkSubOff
			RTL
			
.checkSubOff			
			PHB : PHK : PLB
			LDA $5B                 ; \ goto .vert_level if vertical level
			AND #$01                ; |
			BNE .vert_level         ; /
			LDA !D8,x
			
		if !EXLEVEL
			PHA
			; from the exsprite patch
			LDA !14D4,x
			XBA
			TAX
			PLA				; \ Get 16-bit Y position of sprite
			REP #$20				; /
			; screen size
			CMP.w $13D7|!Base2			; \ If it's beyond level boundaries...
			BPL .checkErase				; /
			SEC					; \ More than 224 pixels *after* screen
			SBC $1C					;  | boundary...
			; y range max
			CMP.w $0BF2|!Base2			;  |
			BPL .checkErase				; /
			SEC					; \ Or more than 224 pixels *before*
			; y range min
			SBC.w $0BF0|!Base2			;  | screen boundary...
			EOR.w #$8000				; /
		.checkErase						; \ We will return with N clear which means
			SEP #$20				;  | delete the sprite!
			PHP
			TXA
			XBA
			LDX $15E9|!Base2
			PLP
		else
			CLC                     ; | 
			ADC #$50                ; | if the sprite has gone off the bottom of the level...
			LDA !14D4,x             ; | (if adding 0x50 to the sprite y position would make the high byte >= 2)
			ADC #$00                ; | 
			CMP #$02                ; | 
		endif

			BPL .erase              ; / ...erase the sprite
			LDA !167A,x             ; \ if "process offscreen" flag is set, return
			AND #$04                ; |
			BNE .return             ; /
			LDA $13                 ;A:8A00 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdiZcHC:0756 VC:176 00 FL:205
			AND #$01                ;A:8A01 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizcHC:0780 VC:176 00 FL:205
			ORA $03                 ;A:8A01 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizcHC:0796 VC:176 00 FL:205
			STA $01                 ;A:8A01 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizcHC:0820 VC:176 00 FL:205
			TAY                     ;A:8A01 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizcHC:0844 VC:176 00 FL:205
			LDA $1A                 ;A:8A01 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizcHC:0858 VC:176 00 FL:205
			CLC                     ;A:8A00 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdiZcHC:0882 VC:176 00 FL:205
			ADC .spr_t14,y          ;A:8A00 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdiZcHC:0896 VC:176 00 FL:205
			ROL $00                 ;A:8AC0 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:eNvMXdizcHC:0928 VC:176 00 FL:205
			CMP !E4,x               ;A:8AC0 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:eNvMXdizCHC:0966 VC:176 00 FL:205
			PHP                     ;A:8AC0 X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizCHC:0996 VC:176 00 FL:205
			LDA $1B                 ;A:8AC0 X:0009 Y:0001 D:0000 DB:01 S:01F0 P:envMXdizCHC:1018 VC:176 00 FL:205
			LSR $00                 ;A:8A00 X:0009 Y:0001 D:0000 DB:01 S:01F0 P:envMXdiZCHC:1042 VC:176 00 FL:205
			ADC .spr_t15,y          ;A:8A00 X:0009 Y:0001 D:0000 DB:01 S:01F0 P:envMXdizcHC:1080 VC:176 00 FL:205
			PLP                     ;A:8AFF X:0009 Y:0001 D:0000 DB:01 S:01F0 P:eNvMXdizcHC:1112 VC:176 00 FL:205
			SBC !14E0,x             ;A:8AFF X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizCHC:1140 VC:176 00 FL:205
			STA $00                 ;A:8AFF X:0009 Y:0001 D:0000 DB:01 S:01F1 P:eNvMXdizCHC:1172 VC:176 00 FL:205
			LSR $01                 ;A:8AFF X:0009 Y:0001 D:0000 DB:01 S:01F1 P:eNvMXdizCHC:1196 VC:176 00 FL:205
			BCC .spr_l31            ;A:8AFF X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdiZCHC:1234 VC:176 00 FL:205
			EOR #$80                ;A:8AFF X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdiZCHC:1250 VC:176 00 FL:205
			STA $00                 ;A:8A7F X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizCHC:1266 VC:176 00 FL:205
.spr_l31:		LDA $00                 ;A:8A7F X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizCHC:1290 VC:176 00 FL:205
			BPL .return             ;A:8A7F X:0009 Y:0001 D:0000 DB:01 S:01F1 P:envMXdizCHC:1314 VC:176 00 FL:205
.erase:			LDA !14C8,x             ; \ if sprite status < 8, permanently erase sprite
			CMP #$08                ; |
			BCC .kill               ; /
			LDY !161A,x             ;A:FF08 X:0007 Y:0001 D:0000 DB:01 S:01F3 P:envMXdiZCHC:1108 VC:059 00 FL:2878
			CPY #$FF                ;A:FF08 X:0007 Y:0000 D:0000 DB:01 S:01F3 P:envMXdiZCHC:1140 VC:059 00 FL:2878
			BEQ .kill               ;A:FF08 X:0007 Y:0000 D:0000 DB:01 S:01F3 P:envMXdizcHC:1156 VC:059 00 FL:2878

			PHX			;BlindEdit: houston we have a problem (preserve X)
			PHY			;preserve Y
			TYX			;transfer Y to X
			LDA #$00                ;A:FF08 X:0007 Y:0000 D:0000 DB:01 S:01F3 P:envMXdizcHC:1172 VC:059 00 FL:2878
		if !Disable255SpritesPerLevel
			STA !1938,x
		else
			STA.L !7FAF00,x             ;$41A800 in SA-1 ROM, so it can't be Y indexed!
		endif			
			PLY			;restore Y
			PLX			;BlindEdit: alright back to the planning phase (restore X)

.kill:			STZ !14C8,x             ; erase sprite
.return:		PLB
			RTL                     ; return

.vert_level:
			LDA !167A,x             ; \ if "process offscreen" flag is set, return
			AND #$04                ; |
			BNE .return             ; /
			LDA $13                 ; \
			LSR A                   ; | 
			BCS .return             ; /
			LDA !E4,x               ; \ 
			CMP #$00                ;  | if the sprite has gone off the side of the level...
			LDA !14E0,x             ;  |
			SBC #$00                ;  |
			CMP #$02                ;  |
			BCS .erase              ; /  ...erase the sprite
			LDA $13                 ;A:0000 X:0009 Y:00E4 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:1218 VC:250 00 FL:5379
			LSR A                   ;A:0016 X:0009 Y:00E4 D:0000 DB:01 S:01F3 P:envMXdizcHC:1242 VC:250 00 FL:5379
			AND #$01                ;A:000B X:0009 Y:00E4 D:0000 DB:01 S:01F3 P:envMXdizcHC:1256 VC:250 00 FL:5379
			STA $01                 ;A:0001 X:0009 Y:00E4 D:0000 DB:01 S:01F3 P:envMXdizcHC:1272 VC:250 00 FL:5379
			TAY                     ;A:0001 X:0009 Y:00E4 D:0000 DB:01 S:01F3 P:envMXdizcHC:1296 VC:250 00 FL:5379
			LDA $1C                 ;A:001A X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:0052 VC:251 00 FL:5379
			CLC                     ;A:00BD X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:0076 VC:251 00 FL:5379
			ADC .spr_t12,y          ;A:00BD X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:0090 VC:251 00 FL:5379
			ROL $00                 ;A:006D X:0009 Y:0001 D:0000 DB:01 S:01F3 P:enVMXdizCHC:0122 VC:251 00 FL:5379
			CMP !D8,x               ;A:006D X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNVMXdizcHC:0160 VC:251 00 FL:5379
			PHP                     ;A:006D X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNVMXdizcHC:0190 VC:251 00 FL:5379
			LDA $1D			;A:006D X:0009 Y:0001 D:0000 DB:01 S:01F2 P:eNVMXdizcHC:0212 VC:251 00 FL:5379
			LSR $00                 ;A:0000 X:0009 Y:0001 D:0000 DB:01 S:01F2 P:enVMXdiZcHC:0244 VC:251 00 FL:5379
			ADC .spr_t13,y          ;A:0000 X:0009 Y:0001 D:0000 DB:01 S:01F2 P:enVMXdizCHC:0282 VC:251 00 FL:5379
			PLP                     ;A:0000 X:0009 Y:0001 D:0000 DB:01 S:01F2 P:envMXdiZCHC:0314 VC:251 00 FL:5379
			SBC !14D4,x             ;A:0000 X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNVMXdizcHC:0342 VC:251 00 FL:5379
			STA $00                 ;A:00FF X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:0374 VC:251 00 FL:5379
			LDY $01                 ;A:00FF X:0009 Y:0001 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:0398 VC:251 00 FL:5379
			BEQ .spr_l38            ;A:00FF X:0009 Y:0001 D:0000 DB:01 S:01F3 P:envMXdizcHC:0422 VC:251 00 FL:5379
			EOR #$80                ;A:00FF X:0009 Y:0001 D:0000 DB:01 S:01F3 P:envMXdizcHC:0438 VC:251 00 FL:5379
			STA $00                 ;A:007F X:0009 Y:0001 D:0000 DB:01 S:01F3 P:envMXdizcHC:0454 VC:251 00 FL:5379
.spr_l38:	LDA $00                 ;A:007F X:0009 Y:0001 D:0000 DB:01 S:01F3 P:envMXdizcHC:0478 VC:251 00 FL:5379
			BPL .return             ;A:007F X:0009 Y:0001 D:0000 DB:01 S:01F3 P:envMXdizcHC:0502 VC:251 00 FL:5379
			BMI .erase              ;A:8AFF X:0002 Y:0000 D:0000 DB:01 S:01F3 P:eNvMXdizcHC:0704 VC:184 00 FL:5490

.spr_t12:	db $40,$B0
.spr_t13:	db $01,$FF
.spr_t14:	db $30,$C0,$A0,$C0,$A0,$F0,$60,$90		;bank 1 sizes
			db $30,$C0,$A0,$80,$A0,$40,$60,$B0		;bank 3 sizes
.spr_t15:	db $01,$FF,$01,$FF,$01,$FF,$01,$FF		;bank 1 sizes
			db $01,$FF,$01,$FF,$01,$00,$01,$FF		;bank 3 sizes