;Hammer Bro Fix by yoshifanatic
;This patch will allow you to have more than 2 occupied hammer bro platforms at the same time.
;It also fixes the oddity where the bounce animation only plays once when you hit the platform from below.
;Credit is not necessary, but would be appreciated
;
; Couple lil' fixes by Tattletale

if read1($00FFD5) == $23
	sa1rom
	!RAM_SpriteTable7E009E = $3200
	!RAM_SpriteTable7E00C2 = $30D8
	!RAM_SpriteTable7E14C8 = $3242
	!RAM_SpriteTable7E1558 = $32F2
	!RAM_SpriteTable7E1594 = $3360
	!num_sprites = $16
	!bank = $000000
else
	!RAM_SpriteTable7E009E = $9E
	!RAM_SpriteTable7E00C2 = $C2
	!RAM_SpriteTable7E14C8 = $14C8
	!RAM_SpriteTable7E1558 = $1558
	!RAM_SpriteTable7E1594 = $1594
	!num_sprites = $0C
	!bank = $800000
endif

; Unused ROM area
org $01AD54|!bank
HammerBroInit:					;| This will serve as the sprite slot of the platform the hammer bro is bound to.
	DEC !RAM_SpriteTable7E1594,x		;|
	RTS					;|

org ($01817D+($9B*2))|!bank
	dw HammerBroInit	
;Set sprite 9C to have the same init routine as sprite 9B	
org ($01817D+($9C*2))|!bank
	dw HammerBroInit

org $02DB5F|!bank
autoclean JML HammerBroFix

freecode
HammerBroFix:
	LDA !RAM_SpriteTable7E1558,x
	BNE .DontResetHitFlag
	STZ !RAM_SpriteTable7E00C2,x
.DontResetHitFlag
	LDY !RAM_SpriteTable7E1594,x
	CPY #$FE
	BEQ .DeadHammerBro
	BCC .HammerBroAlreadyOnPlatform
	LDY.b #!num_sprites-$03
.Loop
	LDA !RAM_SpriteTable7E14C8,y
	CMP #$08
	BNE .NotValidHammerBro
	LDA.w !RAM_SpriteTable7E009E,y
	CMP #$9B
	BNE .NotValidHammerBro
	LDA !RAM_SpriteTable7E1594,y
	CMP #$FF
	BEQ .PutHammerBroOnPlatform
.NotValidHammerBro
	DEY
	BPL .Loop
.DeadHammerBro
	JML $02DB9E|!bank

.PutHammerBroOnPlatform
	TYA
	STA !RAM_SpriteTable7E1594,x
	STA !RAM_SpriteTable7E1594,y
.KeepHammerBroAttached
	JML $02DB7D|!bank

.HammerBroAlreadyOnPlatform
; this prevents shenanigans with hammerbro turning into coins
	LDA.w !RAM_SpriteTable7E009E,y
	CMP #$9B
	BNE .dettachHammerBro
	
	LDA !RAM_SpriteTable7E14C8,y
	CMP #$08
	BEQ .KeepHammerBroAttached
.dettachHammerBro
	LDA #$FE
	STA !RAM_SpriteTable7E1594,x
	BRA .DeadHammerBro

	
