; Walljump/Note Block Glitch Fix by lolcats439 (SA-1/SuperFX hybrid by LDA)
; fixes the wall jumping glitch and the note block-wall death glitch

; This patch moves some of SMW's anti-wall-clipping code to freespace, and calls it from different hijacks,
; so it runs before the "Mario is on ground" bit of $77 would get set, so that the bit doesn't get set
; when jumping at a wall. Then when trying to walljump, you can't "catch" the block anymore, because you
; don't clip inside the block for one frame.

; It fixes the note block clipping glitch by changing the blocked bits that will be set to $77 to 12
; (blocked from up and right) if it is 11 (blocked from up and left) and Mario is moving to the left.
; This would be a separate patch, but it needs to use the same hijack used to fix the walljumping glitch.


!addr = $0000
!sa1 = 0
!gsu = 0
if read1($00FFD6) == $15
	sa1rom ; sfxrom doesn't work because asar is drunk
	!addr = $6000
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!addr = $6000
	!sa1 = 1
endif

org $00E9F6	; this hijack runs when Mario is against the side of the screen
	autoclean JSL SideScreen
	NOP

org $00EA16			;\ NOP out the anti-clipping routine here
	BRA Skip1		;| 
	NOP #10			;|
Skip1:				;/

org $00EC7E ; this hijack runs when Mario is against a block
	autoclean JSL Block
	NOP

org $00ED1C
	autoclean JSL BigMarioStuckInOneBlockHighSpace
	NOP #4

freecode
Block:
	CMP #$11		;\ fix note block clipping glitch by changing the blocked bits
	BNE Skip6		;| to be set depending on Mario's direction
	PHX				;| 
	LDX $7B			;|
	BPL Skip7		;|
	LDA #$12		;|
Skip7:				;|
	PLX				;|
Skip6:				;/
	TSB $77			;\ restore old code
	AND #$03		;|
	TAY				;/
	LDA $00			;\ Use $00 as temporary freeRAM, restoring its value at the end
	PHA				;/
	LDA $96			;\ Don't move Mario outside the block instantly if his head is in the block
	AND #$F0		;|
	STA $00			;|
	LDA $98			;|
	AND #$F0		;|
	CMP $00			;|
	BNE Skip2		;|
	JSR NoClipping	;|
	BRA Skip3		;|
Skip2:				;/
	PHX				;\ Put blocked bits into X to select side of block to move Mario to
	LDA $77			;|
	AND #$03		;|
	LSR A			;|
	TAX				;/
	LDA $1933|!addr	;\ If layer 1 interaction is being processed, Mario is being crushed horizontally
	CMP #$00		;| between layer 1 and layer 2, and the layer 1 block is on the right, set X to 00
	BNE Skip5		;| to avoid a glitch where Mario clips in and out of the block really fast before dying
	LDA $77			;|
	AND #$03		;|
	CMP #$03		;|
	BNE Skip5		;|
	CPY #$01		;|
	BNE Skip5		;|
	LDX #$00		;|
Skip5:				;/
	LDA $94			;\ Move Mario outside the block instantly
	AND #$F0		;|
	ORA $00E911,x	;|
	STA $94			;|
	PLX				;/
Skip3:
	PLA
	STA $00
	RTL

SideScreen:
	PHX
	TYX
	LDA $00E90A,x	;\ restore old code
	TSB $77			;/
	PLX
	JSR NoClipping
	RTL

BigMarioStuckInOneBlockHighSpace:
	LDA $77			;\ If blocked from the right, do nothing
	AND #$01		;| If not blocked from the left, subtract 1 from Mario's x position
	BNE Skip4		;| If blocked from the left, subtract 2 from Mario's x position
	REP #$20		;|
	DEC $94			;| 
	SEP #$20		;|
	LDA $77			;|
	AND #$02		;|
	BEQ Skip4		;|
	REP #$20		;|
	DEC $94			;|
	SEP #$20		;/
Skip4:
	LDA $77			;\ restore old code
	AND #$FC		;|
	ORA #$09		;|
	STA $77			;/
	RTL

NoClipping:
	LDA $77			;\ anti-clipping routine moved here
	AND #$03		;|
	BEQ Return		;|
	AND #$02		;|
	PHX				;|
	TAX				;|
	REP #$20		;|
	LDA $94			;|
	CLC				;|
	ADC $00E90D,x	;| ADC.L doesn't work with y, so this uses x
	STA $94			;|
	SEP #$20		;|
	PLX				;/
Return:
	RTS
	