CommandDispatchTable:
dw cmdDA
dw cmdDB
dw cmdDC
dw $0000
dw cmdDE
dw cmdDF
dw cmdE0
dw cmdE1
dw cmdE2
dw cmdE3
dw cmdE4
dw cmdE5
dw cmdE6
dw cmdE7
dw cmdE8
dw cmdE9
dw cmdEA
dw cmdEB
dw cmdEC
dw cmdED
dw cmdEE
dw cmdEF
dw cmdF0
dw cmdF1
dw cmdF2
dw cmdF3
dw cmdF4
dw cmdF5
dw cmdF6
dw $0000 ;cmdF7
dw cmdF8
dw cmdF9
dw cmdFA
dw cmdFB
dw cmdFC
dw cmdFD
dw cmdFE
;dw cmdFF

CommandLengthTable:
db           $02, $02, $03, $04, $04, $01 ; DA-DF
db $02, $03, $02, $03, $02, $03, $02, $02 ; E0-E7
db $03, $04, $02, $04, $04, $03, $02, $04 ; E8-EF
db $01, $04, $04, $03, $02, $09, $03, $04 ; F0-F7
db $02, $03, $03, $03, $05, $01, $01, $00 ; F8-FF