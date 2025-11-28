;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; No More Sprite Tile Limits v1.2.2
;; coded by Edit1754, macro'd by MathOnNapkins
;; improved by Arujus and optimized by VitorVilela.
;; ported from sa-1 to fastROM by Tattletale
;; small fix by KevinM
;; Yoshi+Cloud+Feather fixes by Arinsu
;; wiggler fix by yoshifanatic
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
	org $82A773+!sprite_header
		db $09

	;Highest sprite slot for reserved sprite 1 in for each sprite memory index.
	org $82A786+!sprite_header
		db $09

	;Highest sprite slot for reserved sprite 2 in for each sprite memory index.
	org $82A799+!sprite_header
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

assert read1($00FFD5) != $23,	"This patch isn't meant for SA-1."

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
	BRA $00

; Move Lakitu Cloud's reserved slots to $30 and $34.
org $81E8E1
	db $30

; Make Yoshi's head appear while turning when riding a cloud, feather or no.
org $80E3DE
	JSL LakituCloudYoshiFix_Fix1
	BRA $00
org $80E448
	JML LakituCloudYoshiFix_Fix2
org $81EF62
	db $08

; Change how the wiggler gets its index for $7F9A7B so it no longer depends on sprite memory setting 0A to cap its spawn.
; Otherwise, wigglers can potentially share $7F9A7B indexes, which cause a unique type of sprite memory error specific to them.
org $82EFF2
    JML WigglerInitFix
    NOP #2
WigglerInitReturn:

org $82F011
    LDY $1594,x               ; $1594 is not used by the wiggler in vanilla, so we'll use that as the $7F9A7B index
    NOP

;---

freecode
reset bytes

WigglerInitFix:
    TXY
    STZ $00
    LDX #$0B
-:
    CPX $15E9                 ; \ Ignore the currently processed wiggler and branch if another wiggler exists.
    BEQ .NextSpriteNum        ; |
    LDA $9E,x                 ; |
    CMP #$86                  ; |
    BEQ .AnotherWigglerExists ; /
.NextSpriteNum:
    DEX
    BPL -
    TYX
    LDY #$FF                  ; \ Loop through the scratch RAM to determine what bits were stored into it
-:                            ; | during the sprite check loop. Exit on the first cleared bit, as that will be
    INY                       ; | used as the $7F9A7B index. Only the first 4 bits will be checked, as the loop
    LSR $00                   ; | ends early if all 4 were set within the loop
    BCS -                     ; /
    TYA
    STA $1594,x
    PHB                       ; \ Restore the original code hijacked in the wiggler init routine
    PEA.w $82EFF2>>8          ; |
    PLB                       ; |
    PLB                       ; |
    PHK                       ; |
    PEA .Return-1             ; |
    PEA $B889-1               ; |
    JML $82F011               ; |
.Return:                      ; /
    JML WigglerInitReturn

.AnotherWigglerExists:
    LDA $14C8,x               ; \ Ignore non-existent wigglers and wigglers in their init
    CMP #$02                  ; | status (if multiple wigglers spawn at the same time, note that
    BCC .NextSpriteNum        ; / normal sprites set their status to 08 during init)
    PHY                       ; \ Since the $7F9A7B index will be 00-03, use those values
    LDY $1594,x               ; | as an index into a bit table so it's easy to track which
    LDA $9134,y               ; | of the 4 $7F9A7B indexes are being used.
    TSB $00                   ; |
    PLY                       ; /
    LDA $00                   ; \ If all 4 indexes are used, then we should exit the loop
    AND #$0F                  ; | early. Otherwise, keep going
    CMP #$0F                  ; |
    BNE .NextSpriteNum        ; /
    TYX
    PHK                       ; \ Jump to the erase sprite code in the bank 1 SubOffscreen
    PEA .Return2-1            ; | This is so the wiggler can respawn. Doing it this way also
    PEA $80CA-1               ; | allows this patch to account for PIXI even if you apply this first
    JML $81AC95               ; / since PIXI remaps $1938 to $7FAF00.
.Return2
    LDA #$04                  ; \ Make the current wiggler disappear in a puff of smoke
    STA $14C8,x               ; | if 4 already exist.
    LDA #$1F                  ; |
    STA $1540,x               ; /
    RTL

LakituCloudYoshiFix:
.Fix1
	PHX
	LDX $18E2
	BEQ +
	PHA
	LDA $15AB,x
	ORA $1419
	CMP #$01
	PLA
	BCS ..Return

+	STA $02FB,y
..Return
	STA $02FF,y
	PLX
	RTL

.Fix2
	LDX $18E2
	BEQ ..Normal
	LDA $15AB,x
	ORA $1419
	BEQ ..Normal
	JML $80E458

..Normal
	LDX $13F9
	LDY $E2B6,x
	JML $80E44E

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