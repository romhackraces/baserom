org $00CDF6

STZ $1401
BEQ +
RTL
+
Return:

org $00F2E2
db $80					;No Powerups from Midways

org $03989F
db $EA,$EA,$EA,$EA      ;will stop the bridge breaking in the Reznor fight