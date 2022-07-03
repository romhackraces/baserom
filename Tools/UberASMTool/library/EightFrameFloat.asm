;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Consistent Cape Float Framerule 
; Original code by xHF01x (please credit him).
; SA-1 conversion DJLocks (you don't have to credit me).
; Special thanks to NewPointless for help with SA-1 testing.
; 
; This patch aims to simulate the vanilla float framerule, which can be between 0 and 16 frames, in a more consistent way. By waiting 8 frames after the input is registered to adjust Mario's falling speed. 
;
; So! What does this mean for you and when should you use this patch?
;
; If you have very long falling sections, or just want the falling speed to be based on player input timing and not the float framerule, this patch will make those setups more consistent. 
; But keep in mind the vanilla float framerule is consistent based on when you jump. This means most kaizo setups will be perfectly consistent with the vanilla framerule... 
;
; ~If you don't have the player floating/falling for extended periods of time you probably don't need this patch!~
;
; Can be inserted per-level or globally via Gamemode 14.
;
; *In practice, the actual time between doing the input and the speed adjusting will be between 12-14 frames depending on console vs emulator lag (smw adds 2 frames on it's own). But, the timer itself starts at 8 so and everyone already knows it as 'The 8 Frame Patch' so... meh.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


main:
	LDA $15 : AND #$80 : BEQ +
	LDA #$08 : STA $14A5|!addr            
	+
	RTL