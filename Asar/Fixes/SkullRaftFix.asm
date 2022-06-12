lorom
!addr = $0000

if read1($00FFD5) == $23
	sa1rom
	!addr = $6000
endif

!Freeram = $57	;This address may be cleared whenever you want,
				;except when the sprite codes are running. When all sprite codes are done
				;(or if Mario isn't on a skull raft), feel free to use it for anything. The default is cleared on level load.
				
org $02EE96
	autoclean JML Main

freedata		; No changes in DB register, might as well toss this into the banks 40+
Main:
	LDA $14
	CMP !Freeram
	BEQ DontMove
	STA !Freeram

	LDY #$00
	LDA $1491|!addr
	JML $02EE9B

DontMove:
	JML $02EEA8