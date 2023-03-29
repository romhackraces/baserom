;Player X Speed Fix v3.0 by GreenHammerBro and tjb
!FixOscillation = 1		;Fix the speed oscillation bug
!FixDeceleration = 0	;Fix behavior where holding forward can slow you down if you're over the max speed
						;  (requires !FixOscillation)
!GroundDecel = 0 		;If 1, !FixDeceleration only applies in the air, not on the ground.
						;  Setting this to 0 allows you to keep extra speed even on the ground, unlike vanilla.
						;(the "No Jump" fix is always applied.)

	!dp = $0000
	!addr = $0000
	!bank = $800000
	!sa1 = 0
	!gsu = 0

if read1($00FFD6) == $15
	sfxrom
	!dp = $6000
	!addr = !dp
	!bank = $000000
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!sa1 = 1
endif

org $00D663
	autoclean JML FixNoJump
	nop #1

org $00D742
if !FixOscillation != 0
		autoclean JML FixSpeed
else
		LDA $7B								;>Restore
		SEC									;
		SBC $D535,y							;
endif

freecode

FixNoJump:
	LDA.l JumpYSpeeds,x		;>New table
	STA $7D				;>And done.
	JML $00D668|!bank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;How X speed affects your jump. This table contains a list of values to be used on how high mario
;jumps. Valid values are #$80~#$FF. The lower the value, the higher mario jumps.
;
;Table format:
;	db $xx,$yy
;
;$xx is the normal jump speed.
;$yy is the spin jump speed.
;
;As you go down the list, that value is used for faster speeds (so the faster you run, the lower down the
;list it'll uses). Here's the formula:

;	LDA $7B		;\X speed absolute value (if negative, flip to positive to find distance from zero)
;	BPL +		;|
;	EOR #$FF	;|
;	INC A		;|
;	+		;/
;	LSR #2		;>Divide by 4 (76543210 turns into --765432)
;	AND #$FE	;>Clear bit 1 (--76543-)
;	TAX		;>Transfer to X
;	LDA $140D	;\If spinjumping, INX to make bit 0 set to use spin jump values
;	BEQ +		;|
;	INX		;/
;	+
;	LDA $00D2BD,x	;>This table location will not be used if you patch this.
;	STA $7D		;>And set Y speed.
;The maximum index is #$20 (if you going a speed of #$80).

JumpYSpeeds:		; X speed
	db $B0,$B6	; ±00-07 speed
	db $AE,$B4	; ±08-0F speed
	db $AB,$B2	; ±10-17 speed
	db $A9,$B0	; ±18-1F speed
	db $A6,$AE	; ±20-27 speed - running speed
	db $A4,$AB	; ±28-2F speed - (possible p-speed/flight oscillation if oscillation is unpatched)
	db $A1,$A9	; ±30-37 speed - p-speed/flight speed
	db $9F,$A6	; ±38-3F speed
	db $9C,$A3	; ±40-47 speed - diagonal pipe speed
	db $9A,$A1	; ±48-4F speed
	db $97,$9F	; ±50-57 speed
	db $95,$9C	; ±58-5F speed
	db $92,$9A	; ±60-67 speed
	db $90,$98	; ±68-6F speed
	db $8E,$96	; ±70-77 speed
	db $8B,$93	; ±78-7F speed
	db $89,$91	; -80 speed

if !FixOscillation != 0
	FixSpeed:
		LDA $7B			;>load mario's current speed
		SEC			;\subtract it from mario's max speed
		SBC $D535,y		;/
		BEQ .resetfraction	;>branch if equal to max speed
		EOR $D535,y		;>flip +/- bit based on direction
		BMI +			;>branch if below max speed
		; if exceeding max speed:
	if !FixDeceleration != 0
		if !GroundDecel != 0
			LDA $72		;\branch to deceleration routine if on ground
			BEQ +++		;/
		endif
					;Load Yth bit from DecelTable to see if we should run deceleration code or not:
		TYA			;\\X = Y / 8
		LSR #3			;||
		TAX			;|/
		LDA.l DecelTable,x	;|\load full byte from decel table into register B
		XBA			;|/
		TYA			;|\X = Y % 8
		AND #$07		;||
		TAX			;|/
		XBA			;|>B to A
		AND.l Bit,x		;/>filter only the one bit we want

		BEQ ++			;>branch to decelerate if bit from table == 0
		JML $00D7A4|!bank	;>else, jump to RTS and maintain current speed
		++
		+++
	endif
		JML $00D76B|!bank	;>jump to decelerate routine
		+
					;below max speed, accelerate:
		PHY			;>preserve Y for later so we can do another max speed check after
		REP #$20		;>16-bit A register
		LDA $D345,x		;>load acceleration tables based on slope
		LDY $86			;\if not slippery, branch to the acceleration code
		BEQ .accel		;/
		LDY $72			;\if you're in the air, branch to the acceleration code
		BNE .accel		;/
		LDA $D43D,x		;> mario is on a slippery floor. load the slippery accel table instead

	.accel
		CLC			;\accelerate mario
		ADC $7A			;/
		STA $7A			;>and store new speed
		SEP #$20		;>8-bit A register
		PLY			;>pull Y for max speed check
		XBA			;do another check for max speed, same as before:
		SEC			;\\ subtract current speed from max speed
		SBC $D535,y		;|/
		BEQ .resetfraction	;|> branch if equal to max speed
		EOR $D535,y		;|> flip +/- bit based on direction
		BPL .clamp		;/> branch if we just pushed it over the max speed
		JML $00D7A4|!bank	;>jump to RTS

	.clamp
		LDA $D535,y		;>clamp speed to exactly the maximum
		STA $7B			;>store new speed
	.resetfraction
		STZ $7A			;>and reset fraction bits
		JML $00D7A4|!bank	;>jump to RTS

	if !FixDeceleration
		DecelTable:
			; There are many different things that call this acceleration routine, and we only want to fix deceleration with some of them.
			; 0 = jump to deceleration routine
			; 1 = skip deceleration, allow mario to keep higher-than-max speed
			; same indexing as the max speeds table at $00D535, but 8x smaller (bits instead of bytes)
			;   wwrrRRpp - w=walk, r=run, R=run-fast, p=p-speed
			;   <><><><> - <=left, >=right
			db %00111111		;00 No slope
			db %00101010		;08 Gradual slope left
			db %00010101		;10 Gradual slope right
			db %00101010		;18 Normal slope left
			db %00010101		;20 Normal slope right
			db %00101010		;28 Steep slope left
			db %00010101		;30 Steep slope right
			db %00000000		;38 Left facing up conveyor
			db %00101010		;40 Left facing down conveyor
			db %00000000		;48 Right facing up conveyor
			db %00010101		;50 Right facing down conveyor
			db %00000000		;58 Very steep slope left
			db %00000000		;60 Very steep slope right
			db %11111111		;68 Flying left while holding left, or holding right and tapping B
			db %11111111		;70 Flying right while holding right, or holding left and tapping B
			db %00000000		;78 Swimming
			db %00000000		;80 Item Swimming
			db %00000000,%00000000	;88 Sliding on slopes
			; basically, keep mario's higher-than-max speed, unless:
			; - you're walking without holding X/Y
			; - you're going uphill
			; - it's a facing up conveyor
			; - you're swimming
			; - you're sliding on a slope (therefore not holding left/right)
			; - you're on a very steep slope (those are janky enough as is, adding more speed would definitely eat more of your jumps)
		Bit:
			db %10000000,%01000000,%00100000,%00010000,%00001000,%00000100,%00000010,%00000001
	endif
endif