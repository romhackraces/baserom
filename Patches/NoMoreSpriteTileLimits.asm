;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; No More Sprite Tile Limits v1.2.1
;; coded by Edit1754, macro'd by MathOnNapkins
;; improved by Arujus and optimized by VitorVilela.
;; ported from sa-1 to fastROM by Tattletale
;; small fix by KevinM
;;
;; Works with all sprites, including vanilla bosses
;; No need to change spread headers anymore, this is enabled for all sprite headers now
;; just like in sa-1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
!foundSlot = PickOAMSlot_foundSlot

!OldSpriteHeader = 0
!sprite_header = $10
!EnabledForOnlyOneHeader = 0

if !OldSpriteHeader == 0
	;This is solely to match max fastROM sprite slots with sa-1's
	;sprite header 8 is unused in this game
	!sprite_header = $08

	;Highest sprite slot to spawn normal sprites in for each sprite memory index.
	org $02A773+!sprite_header
		db $09

	;Highest sprite slot for reserved sprite 1 in for each sprite memory index.
	org $02A786+!sprite_header
		db $09

	;Highest sprite slot for reserved sprite 2 in for each sprite memory index.
	org $02A799+!sprite_header
		db $09
endif


macro speedup(offset)
	CMP.w $02FD+<offset>	; get Y position of PREVIOUS tile in OAM
	BEQ ?notFound		; \  if last isn't free
	LDA.b #<offset>		;  | (and this is), then
	JMP !foundSlot		; /  this is the index
?notFound:
endmacro
 
macro bulkSpeedup(arg)
	%speedup(<arg>+12)
	%speedup(<arg>+8)
	%speedup(<arg>+4)
	%speedup(<arg>)
endmacro
 
org $8180D2
 
SpriteOAMHook:            
	BRA .cutToTheChase      ; skip the NOP's
	NOP                     ; \
	NOP                     ;  | use NOP
	NOP                     ;  | to take
	NOP                     ;  | up space
	NOP                     ;  | to overwrite
	NOP                     ;  | old code
	NOP                     ;  |
	NOP                     ;  |
	NOP                     ;  |
	NOP                     ;  |
	NOP                     ;  |
	NOP                     ;  |
	NOP                     ; /
.cutToTheChase  autoclean JSL PickOAMSlot               ; JSL to new code

;with love from sa-1

; Don't want climbing net door setting it's own OAM index
org $81BB33
	JSL NetDoorFix
	NOP

org $81BBFD
	LDY $0F

; This table contains OAM indices for cluster sprites. Set them to use the highest indices so as not to conflict with ordinary sprites.
org $82FF50
	db $E0,$E4,$E8,$EC,$F0,$F4,$F8,$FC
	db $B0,$B4,$B8,$BC,$D0,$D4,$D8,$DC
	db $C0,$C4,$C8,$CC

; Lakitu should not use a hard-coded OAM index for the fishing line
org $82E6EC
	JSL FishingLineFix
	NOP

; I'm pretty sure that $140F was meant to be used a flag indicating that Reznor is on screen but SMW has a bug where it increments every frame in
; which Reznor is present instead of just once, which means it can wrap around to zero for one frame. This can cause tiles to disappear among other
; problems for this patch so it is best to fix the bug and set $140F to a fixed value so that it's always non-zero during a Reznor fight.
org $839890
	STA $140F

;Vitor Vilela: this screws up Roy/Morton/Ludwig, undo that.
;the hard-coded OAM index is only for their case anyways.
;vanilla code
;org $81C61F
;	LDA.w $140F				;$01C61F	|
;	BNE CODE_01C636				;$01C622	|
;	LDA.w $0D9B				;$01C624	|
;	CMP.b #$C1				;$01C627	|
;	BEQ CODE_01C636				;$01C629	|
;	BIT.w $0D9B				;$01C62B	|
;	BVC CODE_01C636				;$01C62E	|
;	LDA.b #$D8				;$01C630	|
;	STA.w $15EA,X				;$01C632	|
;	TAY					;$01C635	|
;CODE_01C636:

; The hammer brother graphics routine is called by the hammer brother's platform. The OAM index for the hammer brother might not be set correctly
; so hijack here to set it.
org $82DB82
	JSL HammerBroFix
	NOP
	NOP

; Move Lakitu Cloud's reserved slots to $28 and $2C.
org $01E8E1
	db $28

freecode 
reset bytes

HammerBroFix:
	LDA $14E0,x
	STA $14E0,y
	LDA $15EA,x
	CLC
	ADC #$10        ; Add #$10 because the platform wrote 4 tiles (#$10 bytes) to OAM.
	STA $15EA,y
	RTL

FishingLineFix:
	LDA $15EA,x
	CLC
	ADC #$08
	STA $15EA,x
	RTL

NetDoorFix:
	LDA $15EA,x
	LSR
	LSR
	STA $0F
	LDA $15EA,x
	RTL

PickOAMSlot:
if !EnabledForOnlyOneHeader
	LDA.w $1692             ; \  if sprite header
	CMP.b #!sprite_header              ;  | setting is not X,
	BNE .default            ; /  use the old code
endif
.notLastSpr
    LDA.w $14C8,x           ; \ it's not necessary to get an index
	BEQ .return             ; / if this sprite doesn't exist
	LDA.b $9E,x             ; \  give yoshi
	CMP.b #$35              ;  | the first
	BEQ .yoshi              ; /  two tiles
	BRA SearchAlgorithm     ; search for a slot
.foundSlot
	STA.w $15EA,x           ; set the index
.return
	RTL                    
 
.yoshi
	LDA.b #$28              ; \ Yoshi always gets
	STA.w $15EA,x           ; / first 2 tiles (28,2C)
	RTL

if !EnabledForOnlyOneHeader
.default
	PHX                     ; \
	TXA                     ;  | for when not using
	LDX.w $1692             ;  | custom OAM pointer
	CLC                     ;  | routine, this is
	ADC.l $87F0B4,x         ;  | the original SMW
	TAX                     ;  | code.
	LDA.l $87F000,x         ;  |
	PLX                     ;  |
	STA.w $15EA,x           ; /
	RTL
endif
   
SearchAlgorithm:
	LDA $13F9
	BEQ .DontJump
	JMP .BehindScenery
.DontJump
	LDA $0D9B
	CMP #$80
	BNE .DontJump2
	JMP .IggyLarryBowser
    ; $F8 and $FC reserved for lakitu's cloud
.DontJump2
	CMP #$C1
	BNE .DontJump3
	JMP .IggyLarryBowser
.DontJump3
	LDA #$F0
	%speedup($F4)
	%speedup($F0)
	%bulkSpeedup($E0)	;  | pre-defined
	%bulkSpeedup($D0)	;  | macros with
.BehindScenery
	LDA #$F0
	%bulkSpeedup($C0)
	%bulkSpeedup($B0)	;  | code for each
.IggyLarryBowser
	LDA #$F0
	%bulkSpeedup($A0)	;  | individual
	%bulkSpeedup($90)	;  | slot check
	%bulkSpeedup($80)	;  |
	%bulkSpeedup($70)	;  |
	%bulkSpeedup($60)	;  |
	%bulkSpeedup($50)	;  |
	%bulkSpeedup($40)	;  |
	%speedup($3C)		;  |
	LDA.w $18E2		; \ Yoshi?
	BNE .yoshiExists	; /
	; $30 and $34 are reserved for lakitu's cloud
	; Not anymore! Now it's $28 and $2C. We could check if there's a cloud spawned and search in $28,$2C if not, but it's probably not worth it ($18E1 contains a valid value only if the cloud is spawned by Lakitu).
	LDA #$F0
	%speedup($38)		; \ checks
	%speedup($34)		; /
	LDA.b #$30			; \ if none of the above yield which slot
	JMP !foundSlot		; / then use the slot at the beginning	

; If none of the above yield which slot, then use the slot at the beginning (after Yoshi). Normally we would be able to use slot $30 as a minimum but
; unfortunately smw has a bug where sometimes Yoshi can be rendered twice on one frame, in which the 2nd rendering uses slot $2C and $30 instead of
; $28 and $2C, this will cause whatever other sprite is using slot $30 to flicker which isn't good, so don't use slot $30.
.yoshiExists
		LDA.b #$38
		JMP !foundSlot

print bytes