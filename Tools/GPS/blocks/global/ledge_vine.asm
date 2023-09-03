;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Vine Ledge - Acts like a ledge when standing on it, press down and acts like a vine.
;Unlike VineCloud, the climbing value is automatically set so Mario doesn't just fall
;if down isn't being pressed. When climbing up, it pops Mario up above the ledge so he
;doesn't stick at the top.
;
;An ASM Hax™
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
db $42
JMP Mario : JMP Mario : JMP Ledge : JMP Ledge : JMP Ledge : JMP Ledge : JMP Ledge : JMP Mario : JMP Mario : JMP Mario 
JMP Mario : JMP Ledge : JMP Ledge


Mario:
LDA $74			;\If already climbing
BNE Climbing	;/Branch to climbing code
LDA $15			;\If not pressing
AND #$04		;|down
BEQ Ledge		;/then branch to act like a ledge
SetClimb:
LDA #$1F		;\Set the climbing RAM
STA $8B			;/to "climbing up or down" value (I still haven't documented all the values yet)
RTL				;Return

Climbing:
LDA $15			;\If not pressing
AND #$08		;|up
BEQ SetClimb	;/branch back up to set the climb value
LDA $8B			;\If climbing RAM value
AND #$1D		;|isn't "Top of vine"
BEQ Return		;|then return
STZ $74			;|otherwise, zero climbing flag
LDA #$A8		;|Pop Mario up
STA $7D			;/about one Tile
;LDA #$01		;\Uncomment this
;STA $1DFA|!addr;/for jump sound
BRA Ledge		;Branch to ledge so the vine code stops completely
Return:
RTL

MarioSide:
Ledge:
LDY #$01		;\Acts like tile 100 if Mario isn't pressing down
LDA #$00		;/Or if a sprite is touching it.
STA $1693|!addr
RTL				;Return

print "A ledge vine that the player automatically hops above."