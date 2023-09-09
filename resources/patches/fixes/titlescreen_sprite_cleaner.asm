; Removes the overworld sprites from the title screen

if read1($00FFD5) == $23
	sa1rom
	!sa1 = 1
	!addr = $6000
	!bank = $000000
else
	lorom
	!sa1 = 0
	!addr = $0000
	!bank = $800000
endif


org $009AA4
autoclean JSL Clean

freespace noram
Clean:
JSL $04F675|!bank
JML $7F8000
