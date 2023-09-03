arch spc700-raw

org $000000
incsrc "asm/main.asm"
base $1EEB

org $008000


	jmp UnpauseMusic_silent
