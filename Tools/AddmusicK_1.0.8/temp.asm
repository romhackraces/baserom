arch spc700-raw

org $000000
incsrc "asm/main.asm"
base $1ED3

org $008000


	mov a, !SpeedUpBackUp	
	mov $0387, a			
	
	mov a, #$01			
	mov !PauseMusic, a	
	
	mov $f2, #$5c		
	mov $f3, #$ff		
	
	mov $f2, #$6c		
	and $f3, #$bf		

	mov $f2, #$2c		
	mov $f3, #$00		
	mov $f2, #$3c		
	mov $f3, #$00		
	ret
