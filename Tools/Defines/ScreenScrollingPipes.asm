;If you make changes here, make sure you apply the changes to all the copies of this define files
;elsewhere by simply copying the folder containing this file.

;If you're using notepad++, the tab size is 8 in case if you don't like the text vertical misalignment.

;Places to put this define file to:
;-In GPS's main directory (same where the exe is in, not in the sub-folder/subdirectory)
;-In uberasm tool's main directory, same style as above.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SA1 detector:
;Place this at the very top of gamemode_code.asm.
;Do not change anything here unless you know what are you doing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if defined("sa1") == 0
    !dp = $0000
    !addr = $0000
    !sa1 = 0
    !gsu = 0

    if read1($00FFD6) == $15
        sfxrom
        !dp = $6000
        !addr = !dp
        !gsu = 1
    elseif read1($00FFD5) == $23
        sa1rom
        !dp = $3000
        !addr = $6000
        !sa1 = 1
    endif
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;uberasm code for GHB's screen scrolling pipes.
;Do not insert this as blocks, paste this code in "gamemode_code.asm"
;labeled "gamemode_14:" so blocks works in all levels.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

!Freeram_SSP_PipeDir      = $18C5|!addr
!Freeram_SSP_PipeTmr      = $18C6|!addr
!Freeram_SSP_EntrExtFlg   = $18C7|!addr
!Freeram_SSP_CarrySpr     = $18C8|!addr
!Freeram_BlockedStatBkp   = $18C9|!addr

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