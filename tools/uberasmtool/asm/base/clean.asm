; This will clean out the freecode blocks pointed to by the tables immediately preceding the level, gamemode, overworld, and global hijack routines
; First, for level, gamemode, and overworld resources (for 1.x....these are unused as of 2.0)
; Then for the table preceeding the global code hijack (used for "prot"ed items in 1.x, used for everything in 2.0+)

; Other freecode blocks related to the hijacks themselves aren't cleaned here, but rather when the hijacks are reapplied
; Applying this patch without following it up with the main patch can leave a ROM in a bad state

; gamemode  - $009322 (256 gamemodes * 2 or 3 entries per gamemode)
; levelASM  - $00A242 (512 * 2, 3, or 4)
; overworld - $00A1C3 (7 * 2 or 3)
; global    - $00804E (arbitrary)

; if a bogus section is found, it's just skipped silently

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

!text_tool = $6C6F6F74      ; "tool", used as an end marker for the tables
!text_uber = $72656275      ; "uber", used as a start marker
!text_UBER = $52454255      ; "UBER", used in 2.0+ to identify a header with version info

!gamemode_hijack  = $009322
!level_hijack     = $00A242
!overworld_hijack = $00A1C3
!global_hijack    = $00804E
!uber_header      = $01CD1E

!OldVersionOverride = 0     ; set to 1 to force UberASM Tool to run on a ROM that's had a later version applied (not recommended!)

; This generates an actual list of autoclean statements

macro Clean(hijack)
    !ptr #= read3(<hijack>+1)-4
    if canread4(!ptr) && read4(!ptr) == !text_tool
        while read4(!ptr-4) != !text_uber
            !ptr #= !ptr-3
            autoclean read3(!ptr)
        endif
    endif
endmacro

; This shouldn't really be necessary, but 1.x includes this check (beyond just checking for "uber"..."tool")
; to make sure the size of the level/ow/gamemode pointer tables are a valid size (2-3 ptrs per thing for ow/gamemode, and 2-4 per thing for level)

macro CleanOld(hijack, size, ext)
    !ptr #= read3(<hijack>+1)-4
    if not(canread4(!ptr)) || read4(!ptr) != !text_tool
        !valid = 0
    else
        !ptr #= !ptr-4
        !ptr #= !ptr-(6*<size>)
        if read4(!ptr) == !text_uber
            !valid = 1
        else
            !ptr #= !ptr-(3*<size>)
            if read4(!ptr) == !text_uber
                !valid = 1
            else
                if not(<ext>)
                    !valid = 0
                else
                    !ptr #= !ptr-(3*<size>)
                    !valid #= equal(read4(!ptr), !text_uber)
                endif
            endif
        endif
    endif

    if !valid
        %Clean(<hijack>)
    endif
endmacro

; Detect UAT 1.x's presence by looking for the level pointer table
!uber1 = 0
if read1(!level_hijack) == $5C                ; JML ____
    !ptr #= read3(!level_hijack+1)-4
    if read4(!ptr) == !text_tool
        !uber1 = 1
    endif
endif

; Detect UAT 2.0+'s presence by looking for the header
!uber2 = 0
if read4(!uber_header) == !text_UBER
    !uber2 = 1
endif

if !uber2
    if not(!OldVersionOverride)
        if (read1(!uber_header+4)<<8)+read1(!uber_header+5) > (!UberMajorVersion<<8)+!UberMinorVersion
            error "You are attempting to run an older version of UberASM Tool than was used on your ROM."
        endif
    endif
endif

; Clean pointer table info if 1.x detected
if !uber1
    %CleanOld(!gamemode_hijack, 256, 0)    ; these only need to be checked if 2.0+ hasn't been run yet
    %CleanOld(!level_hijack, 512, 1)
    %CleanOld(!overworld_hijack, 7, 0)
endif

; Global pointer table used for both
%Clean(!global_hijack)

; Restore code from hijack that ran main: for the global code file, which is no longer used
if !uber1
    if !sa1
        org $00806B
            jmp $1E8E
            nop
    else
        org $00806B
        -
            lda $10
            beq -      ; restores original code
    endif
endif
