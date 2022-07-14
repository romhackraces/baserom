;THIS ROUTINE SHOULD ONLY BE CALLED BY A SHOOTER!!!
;Routine to check if a shooter should fire or not.
;Checks if the shooter is offscreen and if the timer has run out and sets it if so.
;
;Input:  A   = timer value (what the timer should be set to if needed)
;			C   = Carry Set = Check if Mario is next to the shooter (Carry clear = ignore Mario)
;
;Output: Y   = index for sprite create (#$FF means no sprite spawned)
;        C   = Carry Set = don't shoot (return), Carry Clear = shoot (generate sprite)

	XBA							; 
	LDA !shoot_timer,x      ; \ RETURN if it's not time to generate
	BNE .Return             ; /
	XBA                     ; \ set time till next generation = 60
	STA !shoot_timer,x      ; /
	
	BCC ?+							; skip Mario check if carry set.
	LDA $94                 ; \ don't fire if mario is next to generator
	SBC !shoot_x_low,x      ;  |
	CLC                     ;  |
	ADC #$11                ;  |
	CMP #$22                ;  |
	BCC .Return             ; /
?+
	
	LDA !shoot_y_low,x      ; \ don't generate if off screen vertically
	CMP $1C                 ;  |
	LDA !shoot_y_high,x     ;  |
	SBC $1D                 ;  |
	BNE .Return             ; /
	
	LDA !shoot_x_low,x      ; \ don't generate if off screen horizontally
	CMP $1A                 ;  |
	LDA !shoot_x_high,x     ;  |
	SBC $1B                 ;  |
	BNE .Return             ; / 
	
	LDA !shoot_x_low,x      ; \ don't generate if close to right edge of screen
	SEC                     ;  | probably so generated sprite is fully on screen
	SBC $1A                 ;  |
	CLC                     ;  |
	ADC #$10                ;  |
	CMP #$10                ;  |
	BCC .Return             ; /
	JSL $02A9DE|!BankB      ; \ get an index to an unused sprite slot, RETURN if all slots full
	BMI .Return             ; / after: Y has index of sprite being generated
	CLC : RTL		
.Return
	SEC : RTL
