;Routine that spawns a smoke sprite with a position (+offset) and timer and returns
;the sprite index in Y

;Input:  A   = number of sprite to spawn
;        $00 = x offset  \
;        $01 = y offset  | you could also just ignore these and set them later
;        $02 = timer     /
;
;Output: Y   = index to spawned sprite (#$FF means no sprite spawned)
;        C   = Carry Set = spawn failed, Carry Clear = spawn successful.
;
;Number cheatsheet:
;		#$01 = Puff of smoke.
; 		#$02 = Contact graphic.
;		#$03 = Smoke when the player turns around abruptly.
;		#$04 = Unused/None.
;		#$05 = Glitter sprite. 
;
;Common combination:
;		STZ $00 : STZ $01
;		LDA #$1B : STA $02
;		LDA #$01
;		%SpawnSmoke()


		LDY #$03                ; \ find a free slot to display effect
		XBA
.loop
		LDA $17C0|!Base2,y      ; |
		BEQ ?+                   ; |
		DEY                     ; |
		BPL .loop               ; |
		SEC                     ; |
		RTL                     ; /  RETURN if no slots open

?+		XBA                     ; \ set effect graphic to smoke graphic
		STA $17C0|!Base2,y      ; /
		LDA $02                 ; \ set time to show smoke
		STA $17CC|!Base2,y      ; /

		LDA !D8,x               ; \
		CLC                     ; | set smoke y position based on direction of shot
		ADC $01                 ; |
		STA $17C4|!Base2,y      ; /

		LDA !E4,x               ; \
		CLC                     ; | set smoke x position based on direction of shot
		ADC $00                 ; |
		STA $17C8|!Base2,y      ; /
		CLC
		RTL
