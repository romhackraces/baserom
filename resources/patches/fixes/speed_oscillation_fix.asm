; Speed Oscillication Fix
; based on "Player X Speed Fix" by GreenHammerBro and tjb

if read1($00FFD5) == $23
    ; SA-1 base addresses
    sa1rom
    !SA1  = 1
    !addr = $6000
    !bank = $000000
else
    ; Non SA-1 base addresses
    lorom
    !SA1  = 0
    !addr = $0000
    !bank = $800000
endif


org $00D742
	autoclean JML FixSpeed

freecode
FixSpeed:
	LDA $7B                 ;>load mario's current speed
	SEC                     ;\subtract it from mario's max speed
	SBC $D535,y             ;/
	BEQ .resetfraction      ;>branch if equal to max speed
	EOR $D535,y             ;>flip +/- bit based on direction
	BMI .below_max          ;>branch if below max speed
	JML $00D76B|!bank       ;>jump to decelerate routine

.below_max
	PHY                     ;>preserve Y for later so we can do another max speed check after
	REP #$20                ;>16-bit A register
	LDA $D345,x             ;>load acceleration tables based on slope
	LDY $86 : BEQ .accel    ;>if not slippery, branch to the acceleration code
	LDY $72 : BNE .accel 	;>if you're in the air, branch to the acceleration code
	LDA $D43D,x             ;> mario is on a slippery floor. load the slippery accel table instead

.accel
	CLC                     ;\accelerate mario
	ADC $7A                 ;/
	STA $7A                 ;>and store new speed
	SEP #$20                ;>8-bit A register
	PLY                     ;>pull Y for max speed check
	XBA                     ;do another check for max speed, same as before:
	SEC                     ;\\ subtract current speed from max speed
	SBC $D535,y             ;|/
	BEQ .resetfraction      ;|> branch if equal to max speed
	EOR $D535,y             ;|> flip +/- bit based on direction
	BPL .clamp              ;/> branch if we just pushed it over the max speed
	JML $00D7A4|!bank       ;>jump to RTS

.clamp
	LDA $D535,y             ;>clamp speed to exactly the maximum
	STA $7B                 ;>store new speed
.resetfraction
	STZ $7A                 ;>and reset fraction bits
	JML $00D7A4|!bank       ;>jump to RTS