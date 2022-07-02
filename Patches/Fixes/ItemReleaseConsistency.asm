; code by katun24, based on code by tjb0607
;
; This patch alters some of the physics of item releases while spinning or climbing:
;	> when spinning:
;		> horizontal throws:
;			- when holding left or right on the dpad, always throw left or right respectively
;			- otherwise, throw in the direction you're moving (throw right if x speed is 0)
;		> upthrows:
;			- when holding up-left or up-right on the dpad, always throw up from Mario's left or right side respectively
;			- otherwise, throw up from the side Mario is moving in (from the right if x speed is 0)
;		> drops:
;			- when holding down-left or down-right on the dpad, always drop left or right respectively
;			- otherwise, drop from the side Mario is moving in (from the right if x speed is 0)
;	> when climbing:
;		> horizontal throws:
;			- when holding left on the dpad, always throw left; otherwise, always throw right
;		> drops:
;			- always drop the item straight below Mario (similar to always uptossing an item straight above Mario, which is vanilla behavior)

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

macro define_sprite_table(name, addr, addr_sa1)
    if !SA1 == 0
        !<name> = <addr>
    else
        !<name> = <addr_sa1>
    endif
endmacro

%define_sprite_table("B6", $B6, $B6)
%define_sprite_table("E4", $E4, $322C)
%define_sprite_table("AA", $AA, $9E)
%define_sprite_table("14E0", $14E0, $326E)

org $01A087
autoclean JML ThrowHorizFix		; when throwing an item horizontally, offset the item from Mario based on the dpad inputs or Mario's x speed

org $01A068
autoclean JML ThrowUpFix		; when upthrowing an item, offset the item from Mario based on the dpad inputs or Mario's x speed

org $01A047
autoclean JML DropFix			; when dropping an item, offset the item from Mario based on the dpad inputs or Mario's x speed

freecode


ThrowHorizFix:
	LDA $74					; if climbing, throw the item left if holding left on the dpad, otherwise throw right
	BEQ +
	LDY #$01
	LDA $15
	BIT #$02
	BEQ .returnThrow
	LDY #$00
	BRA .returnThrow
	+

	LDA $140D|!addr				; else if not spinning...
	BNE .nospin

	LDA $15					; if right is pressed, go to .throwRight_nospin
	BIT #$01
	BEQ +
	LDY #$01
	BRA .returnThrow
	+
	BIT #$02				; else if left is pressed, go to .throwLeft_nospin
	BEQ +
	LDY #$00
	BRA .returnThrow
	+
	LDY $76					; else throw the item into Mario's face direction
	BRA .returnThrow

.nospin
	LDA $15					; else (spinning) if right is pressed, go to .throwRight_spin
	BIT #$01
	BNE .throwRight_spin
	BIT #$02				; else if left is pressed, go to .throwLeft_spin
	BNE .throwLeft_spin
	LDA $7B					; if positive or 0 x speed, go to .throwRight_spin, otherwise go to .throwLeft_spin
	BPL .throwRight_spin

.throwLeft_spin
	LDA $D2					; load Mario's x position, high byte
	XBA
	LDA $D1					; load Mario's x position, low byte
	REP #$20				; subtract 11 pixels
	SEC : SBC #$000B
	SEP #$20
	LDY #$00				; throw the item left
	JMP .storeSpritePos

.throwRight_spin
	LDA $D2					; load Mario's x position, high byte
	XBA
	LDA $D1					; load Mario's x position, low byte
	REP #$20				; add 11 pixels
	CLC : ADC #$000B
	SEP #$20
	LDY #$01				; throw the item right

.storeSpritePos
	STA !E4,X				; store to sprite's x position, low byte
	XBA
	STA !14E0,X				; store to sprite's x position, high byte
	BRA .returnThrow

.returnThrow
	JSL $01AB6F|!bank				; display 'hit' graphic at sprite's position
	LDA $187A|!addr
	JML $01A08C|!bank


ThrowUpFix:
	LDA $140D|!addr				; if not spinning, return
	BEQ .returnThrow

	LDA $15					; if right is pressed, go to .throwRight
	BIT #$01
	BNE .throwRight
	BIT #$02				; else if left is pressed, go to .throwLeft
	BNE .throwLeft
	LDA $7B					; else (if neutral dpad) if positive or 0 x speed, go to .throwRight, otherwise go to .throwLeft
	BPL .throwRight

.throwLeft:
	LDA $D2					; load Mario's x position, high byte
	XBA
	LDA $D1					; load Mario's x position, low byte

	REP #$20				; subtract 11 pixels
	SEC : SBC #$000B
	SEP #$20

	JMP .storeSpritePos

.throwRight:
	LDA $D2					; load Mario's x position, high byte
	XBA
	LDA $D1					; load Mario's x position, low byte

	REP #$20				; add 11 pixels
	CLC : ADC #$000B
	SEP #$20

.storeSpritePos:
	STA !E4,X				; store to sprite's x position, low byte
	XBA
	STA !14E0,X				; store to sprite's x position, high byte

.returnThrow:
	JSL $01AB6F|!bank				; display 'hit' graphic at sprite's position (vanilla code)
	JML $01A06C|!bank


DropFix:
	LDA $74					; if climbing, don't offset the item's position, and set the item's x and y speeds equal to Mario's
	BEQ +
	LDA $7B
	STA !B6,X
	LDA $7D
	STA !AA,X
	JML $01A0A6|!bank
	+

	LDA $140D|!addr				; else, if not spinning, return
	BEQ .returnThrow

	LDA $15					; if right is pressed, go to .throwRight
	BIT #$01
	BNE .throwRight
	BIT #$02				; else if left is pressed, go to .throwLeft
	BNE .throwLeft
	LDA $7B					; else (if neutral dpad) if positive or 0 x speed, go to .throwRight, otherwise go to .throwLeft
	BPL .throwRight

.throwLeft:
	LDA $D2					; load Mario's x position, high byte
	XBA
	LDA $D1					; load Mario's x position, low byte

	REP #$20				; subtract 13 pixels
	SEC : SBC #$000D
	SEP #$20

	JMP .storeSpritePos

.throwRight:
	LDA $D2					; load Mario's x position, high byte
	XBA
	LDA $D1					; load Mario's x position, low byte

	REP #$20				; add 13 pixels
	CLC : ADC #$000D
	SEP #$20

.storeSpritePos:
	STA !E4,X				; store to sprite's x position, low byte
	XBA
	STA !14E0,X				; store to sprite's x position, high byte
	JML $01A059|!bank

.returnThrow:
	LDY $76					; $01A047		restore vanilla code
	LDA $D1					; $01A049
	CLC						; $01A04B
	JML $01A04C|!bank