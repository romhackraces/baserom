; TODO: look into usefulness of keeping levelnum patch since LM now does it too

;--------------------------------------------------------------------------------------

namespace nested on

incsrc "uber_defines.asm"
incsrc "!MacrolibFile"
incsrc "../work/library_labels.asm"
incsrc "../work/resource_labels.asm"

!level         = $010B|!addr    ;Patches rely on this, changing this is bad.
!previous_mode = !UberFreeram

ORG $05D8B7
    BRA +
    NOP #3        ;the levelnum patch goes here in many ROMs, just skip over it
+
    REP #$30
    LDA $0E        
    STA !level
    ASL        
    CLC        
    ADC $0E        
    TAY        
    LDA.w $E000,Y
    STA $65        
    LDA.w $E001,Y
    STA $66        
    LDA.w $E600,Y
    STA $68        
    LDA.w $E601,Y
    STA $69        
    BRA +
ORG $05D8E0
    +


; 12 bytes of free unused space
org $01CD1E
    db "UBER"
    db !UberMajorVersion     ; major ver
    db !UberMinorVersion     ; minor ver
    db 0, 0, 0, 0, 0, 0      ; 6 bytes reserved for future use

; this also used to call load: for the global code file, but this is no longer used
; can simply have a load label under a * file for levels
org $05808C
    autoclean jml CallLevelLoad
    nop

org $00A5EE
    autoclean jml CallLevelInit
    nop                             ; this nop wasn't in 1.x, but it's a leftover byte of an instruction that can't get called anyway

org $00A242
    autoclean jml CallLevelMain
    nop

; clear out call to clear OAM routine...this is done earlier (but called in mode 7 rooms now)
org $00A295
    nop #4

; new to 2.0
org $00A2EE
    autoclean jml CallLevelEnd
    nop

org $00A1C3
    autoclean jml CallOverworldMainEnd
	
org $00A18F
    autoclean jml CallOverworldInit
    nop #2

; handles all of main, init, end
org $009322
    autoclean jml CallGamemode

; this is new as of 2.0, so we can return here after gamemode end:, maintaining compatibility with kevin's vram optimization patch
    rts
    nop #2

; this handles both uberasm initializaiton, as well as calling the init: label for the global code file
org $00804E
    autoclean JML GlobalInit

; this handles the nmi: label for level, overworld, and gamemode resources
; it also used to call nmi: for the global code file, but this is no longer used
org $008176
    if !UberUseNMI == 1
        autoclean jml NMIHijack
        nop #2
    else
        lda $4210
        lda $1DFB|!addr
    endif
	
org $008E1A
    autoclean JML CallStatusbar
    nop

; these should maybe be included from something else...
; this seems like overkill
macro CallUberResource(num, nmi)
    if <nmi>
        jsl UberResource<num>_NMI
    else
        jsl UberResource<num>_ResourceEntry
    endif
endmacro

; num - resource number
; nmi - 1 if this is an NMI call, 0 if not
; type - "Level", "Gamemode", "Overworld"
; which - which level, gamemode, or overworld number
; no reason not to concat <type><which> I guess
macro CallUberResourceWithBytes(num, nmi, type, which)
    !tmp := UberResource<num>_ExtraBytes_<type><which>
    if <nmi> && !sa1
        lda.b #!tmp>>8 : pha
        lda.b #!tmp : pha
    else
        lda.b #!tmp : sta $00
        lda.b #!tmp>>8 : sta $01
    endif
    if <nmi>
        jsl UberResource<num>_NMI
    else
        jsl UberResource<num>_ResourceEntry
    endif
endmacro

freecode

print "_startl ", pc
incsrc "../work/resource_calls.asm"

incsrc "level.asm"
incsrc "overworld.asm"
incsrc "gamemode.asm"
if !UberUseNMI == 1
    incsrc "nmi.asm"
endif

incsrc "global.asm"
incsrc "statusbar.asm"

incsrc "resource_pointers.asm"

print "_endl ", pc
