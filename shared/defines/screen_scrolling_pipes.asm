incsrc "callisto.asm"
%import_library("freeram.asm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Simplified defines for GHB's screen scrolling pipes.
; see library/screen_scrolling_pipes.asm in UberASMTool's folder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FreeRAM (5 bytes, cleared on level load)
!Freeram_SSP_PipeDir        = !scroll_pipes_freeram_bank
!Freeram_SSP_PipeTmr        = !scroll_pipes_freeram_bank+1
!Freeram_SSP_EntrExtFlg     = !scroll_pipes_freeram_bank+2
!Freeram_SSP_CarrySpr       = !scroll_pipes_freeram_bank+3
!Freeram_BlockedStatBkp     = !scroll_pipes_freeram_bank+4

; Settings
!Setting_SSP_ShowMario      = 0     ; set to 1 to enable seeing Mario in the pipe (useful for transparent pipes)
!Setting_SSP_YoshiAllowed   = 1     ; set to 1 to enable entering pipes on Yoshi
!Setting_SSP_CarryAllowed   = 1     ; set to 1 to enable entering pipes while holding an item
!Setting_SSP_FreezeTime	    = 0     ; set to 1 to freeze the game while in the pipe

; Pipe Speeds (00-7F)
!SSP_PipeSpeed_X = $40      ; speed travelling horizontally
!SSP_PipeSpeed_Y = $40      ; speed travelling vertically

; Pipe Timings (not recommended to change)
!SSP_PipeTimer_Enter_Leftwards              = $06
!SSP_PipeTimer_Enter_Rightwards             = $06
!SSP_PipeTimer_Enter_Upwards_OffYoshi       = $06
!SSP_PipeTimer_Enter_Upwards_OnYoshi        = $0A
!SSP_PipeTimer_Enter_Downwards_OffYoshi     = $08
!SSP_PipeTimer_Enter_Downwards_OnYoshi      = $0A
!SSP_PipeTimer_Enter_Downwards_SmallPipe    = $06

!SSP_PipeTimer_Exit_Leftwards                       = $04
!SSP_PipeTimer_Exit_Rightwards                      = $04
!SSP_PipeTimer_Exit_Upwards_OffYoshi                = $09
!SSP_PipeTimer_Exit_Upwards_OnYoshi                 = $0A
!SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario   = $06
!SSP_PipeTimer_Exit_Downwards_OffYoshi_BigMario     = $08
!SSP_PipeTimer_Exit_Downwards_OnYoshi_SmallMario    = $07
!SSP_PipeTimer_Exit_Downwards_OnYoshi_BigMario      = $08
