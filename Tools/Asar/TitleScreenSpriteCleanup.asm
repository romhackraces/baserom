; Removes the overworld sprites from the title screen

if read1($00FFD5) == $23
    sa1rom
else
    lorom
endif

org $009AA4
autoclean JSL Clean

freespace noram
Clean:
JSL $04F675
JML $7F8000
