;macro comment()
;hi, this is my first patch lmao
;
;Some sprites do not have any sprite interaction within their own code,
;which means they ignore lower priority sprites that are loaded in.
;
;so here we are
;
;endmacro
;===================================================================
;detectors
;===================================================================
	!dp = $0000
	!addr = $0000
	!sa1 = 0
	!gsu = 0

if read1($00FFD6) == $15
	sfxrom
	!dp = $6000
	!addr = !dp
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!sa1 = 1
endif

; table
if !sa1
    !basef = $000000
    !C2 = $30D8
    !14C8 = $3242
else
	; Non SA-1 base addresses
    !basef = $800000
    !C2 = $C2
    !14C8 = $14C8
endif

;======================================================

org $01AEB4
autoclean JSL Thwomp
NOP

org $01AF9F
autoclean JSL Thwimp
NOP

;======================================================
;Fire Snake
;======================================================
;recoded to not be skipped, but still have more compatibility

org $018F0D
autoclean JML fiyasnek

freecode

;======================================================

Thwomp:
JSL $018032|!basef ;interact with sprites
JSL $01A7DC|!basef ;interact with mario (restored code)
LDA !C2,X ;restored code
RTL

Thwimp:
JSL $018032|!basef ;interact with sprites
LDA !14C8,X ; >
CMP #$08    ; > restored code
RTL

fiyasnek:
LDA $9D  ; >
BNE skip ; > restored code
JSL $018032|!basef ;interact with sprites
JML $018F11|!basef ;return to original code

skip:
JML $018F49|!basef ;return to original code

print "Freespace used: ",bytes," bytes."
;print "Thank you for using my patch! :3"
;print "ChillyFox~"
