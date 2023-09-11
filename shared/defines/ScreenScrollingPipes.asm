incsrc "../freeram.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Simplified defines for GHB's screen scrolling pipes.
; see library/ScreenScrollingPipes.asm in UberASMTool's folder
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Freeram_SSP_PipeDir      = !screen_scrolling_pipes_freeram
!Freeram_SSP_PipeTmr      = !screen_scrolling_pipes_freeram+1
!Freeram_SSP_EntrExtFlg   = !screen_scrolling_pipes_freeram+2
!Freeram_SSP_CarrySpr     = !screen_scrolling_pipes_freeram+3
!Freeram_BlockedStatBkp   = !screen_scrolling_pipes_freeram+4

;Settings.
!Setting_SSP_PipeDebug     = 0
!Setting_SSP_YoshiAllowed  = 1
!Setting_SSP_CarryAllowed  = 1

; Pipe Timings
!SSP_PipeTimer_Enter_Leftwards           = $06
!SSP_PipeTimer_Enter_Rightwards          = $06
!SSP_PipeTimer_Enter_Upwards_OffYoshi        = $06
!SSP_PipeTimer_Enter_Upwards_OnYoshi         = $0A
!SSP_PipeTimer_Enter_Downwards_OffYoshi      = $08
!SSP_PipeTimer_Enter_Downwards_OnYoshi       = $0A
!SSP_PipeTimer_Enter_Downwards_SmallPipe     = $06

!SSP_PipeTimer_Exit_Leftwards            = $04
!SSP_PipeTimer_Exit_Rightwards           = $04
!SSP_PipeTimer_Exit_Upwards_OffYoshi         = $09
!SSP_PipeTimer_Exit_Upwards_OnYoshi          = $0A
!SSP_PipeTimer_Exit_Downwards_OffYoshi_SmallMario    = $06
!SSP_PipeTimer_Exit_Downwards_OffYoshi_BigMario  = $08
!SSP_PipeTimer_Exit_Downwards_OnYoshi_SmallMario = $07
!SSP_PipeTimer_Exit_Downwards_OnYoshi_BigMario   = $08