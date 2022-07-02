; Block that removes any powerup from Mario

print "Block that removes any powerup or item from Mario as well as flight state"

db $42
JMP Mario : JMP Mario : JMP Mario : JMP Return : JMP Return : JMP Return : JMP Return
JMP Mario : JMP Mario : JMP Mario

Mario:
	STZ $19			; remove player's powerup
	STZ $0DC2 		; remove player's item
	STZ $1407		; remove cape flight
	LDA $13ED		;\
	AND #%01111111	;| remove slide state
	STA $13ED		;/
	
Return:
	RTL