;P-balloon/Cloud Fix patch by lolcats439
;Fixes the glitch that lets you go though blocks while using a P-balloon or Lakitu cloud.

if read1($00FFD5) == $23
    sa1rom
else
    lorom
endif


org $02D214               ;\ Hijack code and JSL to custom code
autoclean JSL CodeStart   ;/


freecode


CodeStart:
LDA $15      ;\ restore overwritten code
AND.b #$03   ;/
CMP #$03
BNE .Skip
LDA #$01
.Skip
CMP #$00
RTL