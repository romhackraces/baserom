; ---------------------------------------- ;
; Growing/Shrinking Pipe Exit on Extra Bit ;
;               By JamesD28                ;
; ---------------------------------------- ;

if read1($00FFD5) == $23
	sa1rom
	!sa1 = 1
	!dp = $3000
	!addr = $6000
	!bank = $000000
	!7FAB10 = $400040
	!1534 = $32B0
	!15F6 = $33B8
	!15EA = $33A2
	!D8 = $3216
	!E4 = $322C
	!14D4 = $3258
	!14E0 = $326E
else
	lorom
	!sa1 = 0
	!dp = $0000
	!addr = $0000
	!bank = $800000
	!7FAB10 = $7FAB10
	!1534 = $1534
	!15F6 = $15F6
	!15EA = $15EA
	!D8 = $D8
	!E4 = $E4
	!14D4 = $14D4
	!14E0 = $14E0
endif

; --------------------

;if read1($02FFE2) == $FF
;error "You must run PIXI on the ROM at least once for this patch to work!"
;endif

ORG $02E845|!bank
autoclean JML PipeExit		; Make the growing/shrinking pipe act as an exit pipe when the extra bit is set.

ORG $02E905|!bank
autoclean JML PipePriority		; Give the growing/shrinking pipe tiles priority if Mario is entering it.

; --------------------

freecode
prot Return,Next,Return2,Loop,Loop2,Found,DownPipe,Finish

PipeExit:

LDA !7FAB10,x		;
AND #$04		;
BEQ Return		; If the extra bit isn't set, return.
JSL $01A7DC|!bank		; Interact with Mario.
BCC Return		; Return if Mario is not on the pipe.

LDA !E4,x		;
SEC		;
SBC $D1		;
CLC		;
ADC #$0C		;
CMP #$08		;
BCS Return		; Return if Mario is not within the enterable region of the pipe.

LDA $15		;
AND #$04		;
BEQ Return		; Return if the player is not holding down.

PHX		; Preserve sprite slot.
JSR DownPipe		; Act like an exit pipe.
PLX		; Retrieve sprite slot.

Return:		; Restore original code.

LDA !1534,x		;
BMI Next		;
JML $02E84A|!bank		;
Next:		;
JML $02E872|!bank		;

; --------------------

Return2:		; Restore original graphics routine.

LDA $00		;
STA.W $0300|!addr,y		;
JML $02E90A|!bank		;

PipePriority:

LDA $71		; If Mario isn't entering a pipe,
CMP #$06
BNE Return2		; Don't give the pipe priority.

LDY #$00		; Find free slot in $0200.
Loop:		;
LDA $0201|!addr,y		;
CMP #$F0		;
BEQ Found		;
INY #4		;
CPY #$FC		;
BNE Loop		;
PLA		; We're skipping the rest of the vanilla routine, but it was called with JSR,
PLA		; so we need to nuke the return address.
JML $02E875|!bank		; Jump out of the routine.

Found:		; GFX routine that gives the pipe priority over Mario.
LDA $00		;
STA $0200|!addr,y		; Left tile X position.
CLC		;
ADC #$10		; Right tile X position.
STA $0204|!addr,y		;
LDA $01		; Y position.
DEC		; Shift up by one pixel. I think SMW does this to give the illusion that Mario's stood in the "middle" of the pipe top surface vertically.
STA $0201|!addr,y		;
STA $0205|!addr,y		; Both tiles at same Y position.
LDA #$A4		; Pipe left tile.
STA $0202|!addr,y		;
LDA #$A6		; Pipe right tile.
STA $0206|!addr,y		;
LDA !15F6,x		;
ORA $64		;
STA $0203|!addr,y		;
STA $0207|!addr,y		; Pipe YXPPCCCT properties.
TYA		;
STA !15EA,x		; Store to sprite OAM index.
LDY #$02		; 16x16 tiles.
LDA #$01		; 2 tiles drawn.
JSR Finish		; Modified OAM finisher routine.

PLA		;
PLA		; Nuke return address.
JML $02E875|!bank		; Jump out of routine.

Finish:		; OAM finisher routine modified for the $0200 region.

STY $0B
STA $08
LDY !15EA,x
LDA !D8,x
STA $00
SEC
SBC $1C
STA $06
LDA !14D4,x
STA $01
LDA !E4,x
STA $02
SEC
SBC $1A
STA $07
LDA !14E0,x
STA $03

Loop2:

TYA
LSR
LSR
TAX
LDA $0B
BPL +
LDA $0420|!addr,x
AND #$02
STA $0420|!addr,x
BRA ++
+
STA $0420|!addr,x
++
LDX.B #$00
LDA $0200|!addr,y
SEC
SBC $07
BPL +
DEX
+
CLC
ADC $02
STA $04
TXA
ADC $03
STA $05
REP #$20
LDA $04
SEC
SBC $1A
CMP #$0100
SEP #$20
BCC +
TYA
LSR
LSR
TAX
LDA $0420|!addr,x
ORA #$01
STA $0420|!addr,x
+
LDX.B #$00
LDA $0201|!addr,y
SEC
SBC $06
BPL +
DEX
+
CLC
ADC $00
STA $09
TXA
ADC $01
STA $0A
REP #$20
LDA $09
PHA
CLC
ADC #$0010
STA $09
SEC
SBC $1C
CMP #$0100
PLA
STA $09
SEP #$20
BCC +
LDA #$F0
STA $0201|!addr,y
+
INY #4
DEC $08
BPL Loop2

LDX $15E9|!addr
RTS

; --------------------

DownPipe:		; Pretty much the vanilla pipe routine, but tweaked to not check if Mario's entering since we already did that.

LDA #$04		; Initialize A to what it always seems to be on the frame Mario enters a pipe.
XBA		;
LDA #$03		;
TAX		;
LDA.B #$20		; Entering pipe timer.
LDY.W $187A|!addr		; Different timer value if Mario is riding Yoshi.
BEQ $02		;
LDA.B #$30		;
LDY.B #$06		; "Entering Vertical Pipe" animation trigger.
STA $88		;
STA $9D		; Lock animation and sprites flag.
AND.B #$01		;
STA $76		; Mario direction.
STX $89		; Pipe action.
TXA		;
LSR		;
TAX		;
BNE $10		;
LDA.W $148F|!addr		; If Mario is carrying something,
BEQ $0B		; affect direction.
LDA $76		;
EOR.B #$01		;
STA $76		;
LDA.B #$08		;
STA.W $1499|!addr		;
INX
STX.W $1419|!addr
STY $71		; Animation trigger.
STZ $15		;
STZ $16		;
STZ $17		;
STZ $18		; Disable controls.
LDA.B #$04		; Going into pipe SFX.
STA.W $1DF9|!addr		;
LDY.W $1693|!addr		; Not sure if this is needed.
RTS		; Return.