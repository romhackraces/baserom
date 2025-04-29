;;;
;;; Release Item Fix Bulk Patch:
;;;     Spinjump Carry Fix
;;;     Easy / Disable Mid-air Patch
;;;     Release-into-Solid Fix
;;; > by Beta Logic
;;;

; Hey you! Read the README.txt!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SA-1 support
!dp = $0000
!addr = $0000
!sa1 = 0
!bank = $800000
if read1($00FFD5) == $23
    if !assembler_ver < 10700
        sa1rom
        if read1($007FD7) > $0C
        print "Pssst, you're using an expanded SA-1 rom but you haven't ",
            "updated ASAR to version 1.70 or later."
        print "ASAR v1.70 allows mapping mode 'fullsa1rom' which means you ",
            "don't have to worry about switching banks!"
        endif
    else
        fullsa1rom
    endif
    !dp = $3000
    !addr = $6000
    !sa1 = 1
    !bank = $000000
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Customizable variables

!spinDrop       = 1 ; Prefer controller direction for drops-- center otherwise
!spinUp         = 1 ; Center item if spinning when up-throw
!spinKick       = 1 ; Prefer controller direction for kicking
!spinKickCenter = 1 ; Center item if spinning when kick

!dropDirection  = 1 ; Prefer controller direction for drops
!mmThrow        = 0 ; When you kick an item, you stop spin-jumping

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ez / No mid-air:
; 0 is disabled, 1 is enabled
!ezMidair = 0

!speedModifer  = $04 ; How much to reduce the shell's speed by
!disableFrames = $0E ; Originally $10, or 16, frames
!speedSafety   = 2 ; How high the minimum speed should be (0 is disabled)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Release-into-Solid Fix:
!releaseFix = 0
!popFix     = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; If you have the previous version of my patch inserted, the first time you run
;   this version of the patch, set this to 1.
!prevVersionCleanup = 0
!verbose            = 1
!individualFreeCode = 0
!fullRestore        = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RAM addresses, for ease of understanding
!controller     = $15

!spriteYLo      = $D8
!spriteXLo      = $E4
!spriteYHi      = $14D4
!spriteXHi      = $14E0
!spriteXSp      = $B6
!spriteYSp      = $AA
!spriteStatus   = $14C8
!spriteDisable  = $154C
!spriteBlocked  = $1588
!spriteProp1656 = $1656

!marioXLo       = $D1
!marioXHi       = !marioXLo+1
!marioDir       = $76
!marioXSp       = $7B

!isDucking      = $73
!isOnGround     = $13EF|!addr
!isSpinning     = $140D|!addr
!isCaping       = $14A6|!addr
!isTurning      = $1499|!addr
!hasYoshi       = $187A|!addr

; Address of the "make the kick splat" routine
org $01AB6F
    KickSplat:
; Address to recover code in the kick routine
org $01A0A6
    StartKickPose:

; SA-1 support for sprite tables
if !sa1
    !spriteYSp = $9E

    !spriteXLo = $322C
    !spriteXHi = $326E
    !spriteYLo = $3216
    !spriteYHi = $3258

    !spriteStatus  = $3242
    !spriteDisable = $32DC

    !spriteBlocked  = $334A
    !spriteProp1656 = $75D0
endif

; Prevent unnecessary code
if !fullRestore
    !spinDrop           = 0
    !spinUp             = 0
    !spinKick           = 0
    !spinKickCenter     = 0
    !ezMidair           = 0
    !releaseFix         = 0
    !prevVersionCleanup = 1
endif

if !speedModifer == 0 && !disableFrames == $10
    !ezMidair = 0
endif
if !spinKick == 0
    !mmThrow = 0
endif
if !spinDrop == 0
    !dropDirection = 0
endif
if !ezMidair == 0
    !speedSafety = 0
endif
if !releaseFix == 0
    !popFix = 0
endif

; Internal variables
if !speedSafety
    !posSpeed     #= $1F+!speedSafety ; The minimum positive speed of a shell
    !negSpeed     #= $E0-!speedSafety ; The minimum negative speed of a shell
    !compareValue #= 2*!posSpeed      ; Used to test if the shell is too slow
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hijacking item release routines

;; Macros to clean up jumps to freespace when overwriting them with code
; If the old code is also a long jump
macro cleanJump(addr, label)
    if read1(<addr>) == $5C || read1(<addr>) == $22
    if read1(<addr>+1) >= $10
        if !sa1 || read1(<addr>+1) <= $80
        autoclean read3(<addr>+1)
        endif
    endif
    endif
    org <addr>+1
    if read1(<addr>) == $5C || read1(<addr>) == $22
        dl <label>
    endif
endmacro
; If the old code isn't a long jump
macro cleanCode(addr)
    if read1(<addr>) == $5C || read1(<addr>) == $22
    if read1(<addr>+1) >= $10
        if !sa1 || read1(<addr>+1) <= $80
        autoclean read3(<addr>+1)
        endif
    endif
    endif
    org <addr>
endmacro

if !prevVersionCleanup ; Previous version recovery
    ; Clean up dat free space
    %cleanCode($01A087)
    %cleanCode($01A06C)

    org $01A06C
        LDA #$90         ; \ Restore overwritten code:
        STA !spriteYSp,X ; /   Set sprite y velocity to -112.

    org $01A04B
        CLC : ADC $9F67,Y ; > Sprite X position = Mario's x position +/- 13
        if !sa1
            STA ($EE)
        else
            STA !spriteXLo,X
        endif
        LDA !marioXHi     ; \ The sign of 13 is determined by the direction
        ADC $9F69,Y       ; |   mario is dropping it
        STA !spriteXHi,X  ; /
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !spinDrop
    org $01A047
        autoclean JML SpinDropFix
    DropRecover:
else
    %cleanCode($01A047)
        LDY !marioDir
        LDA !marioXLo
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !spinUp
    org $01A068
        autoclean JSL SpinUpFix
else
    %cleanJump($01A068, KickSplat|!bank)
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !spinKickCenter
    org $01A079
        autoclean JSL SpinUpFix
else
    %cleanJump($01A079, KickSplat|!bank)
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Here we optimize some of Nintendo's silly code
if !ezMidair
    if !spinKick
        ; Clean mid-air hijack jump
        if read1($01A0A4) != $EA
            %cleanCode($01A0A1)
        endif

        org $01A082
            INC !spriteStatus,X ; saves 2 bytes
            autoclean JSL SpinKickFix
            ; saves 1 byte
        KickRecover:
            BEQ +
                INY #2
            +
            LDA $9F6B,Y ; > Data table for shell speed
            STA !spriteXSp,X
            EOR !marioXSp
            BMI +
                LDA !marioXSp
                CMP #$80 : ROR ; Signed division by 2 (saves 2 bytes)
                CLC : ADC !spriteXSp,X ; (saves 1 byte)
                STA !spriteXSp,X
            +
            autoclean JML SpeedChange
            NOP #2
    else
        ; Clean mid-air hijack jump
        if read1($01A0A4) == $EA
            %cleanCode($01A0A0)
        endif

        org $01A082
            INC !spriteStatus,X ; saves 2 bytes
        %cleanCode($01A085)
            LDY !marioDir
            LDA !hasYoshi
            BEQ +
                INY #2
            +
            LDA $9F6B,Y ; > Data table for shell speed
            STA !spriteXSp,X
            EOR !marioXSp
            BMI +
                LDA !marioXSp
                CMP #$80 : ROR ; Signed division by 2 (saves 2 bytes)
                CLC : ADC !spriteXSp,X ; (saves 1 byte)
                STA !spriteXSp,X
            +
            autoclean JML SpeedChange
            NOP
    endif
else
    ; Clear potential positions that contain the mid-air patch
    %cleanCode($01A0A0) : %cleanCode($01A0A1)

    if !spinKick
        org $01A082
            INC !spriteStatus,X ; saves 2 bytes
            autoclean JSL SpinKickFix
            ; saves 1 byte
        KickRecover:
            BEQ +
                INY #2
            +
            LDA $9F6B,Y ; > Data table for shell speed
            STA !spriteXSp,X
            EOR !marioXSp
            BMI StartKickPose
                LDA !marioXSp
                CMP #$80 : ROR ; Signed division by 2 (saves 2 bytes)
                CLC : ADC !spriteXSp,X ; (saves 1 byte)
                STA !spriteXSp,X
            BRA StartKickPose
            NOP #4
    elseif !fullRestore == 0
        ; F*** this, I'm still gonna optimize your code, Nintendo
        org $01A082
            INC !spriteStatus,X ; saves 2 bytes, 0 cycle difference

        %cleanCode($01A085)
            LDY !marioDir
            LDA !hasYoshi
            BEQ +
                INY #2
            +
            LDA $9F6B,Y ; > Data table for shell speed
            STA !spriteXSp,X
            EOR !marioXSp
            BMI StartKickPose
                LDA !marioXSp
                CMP #$80 : ROR ; Signed division by 2 (saves 2 bytes, 6 cycles)
                CLC : ADC !spriteXSp,X ; saves 1 byte, 1 cycle
                STA !spriteXSp,X
            BRA StartKickPose
            ; Save 3 bytes, 4 cycles
            NOP #3
    else
        ; Ok if you really need the original code back, here it is
        %cleanCode($01A085)
        org $01A082
            LDA #$0A
            STA !spriteStatus,X
            LDY !marioDir
            LDA !hasYoshi
            BEQ +
                INY #2
            +
            LDA $9F6B,Y ; > Data table for shell speed
            STA !spriteXSp,X
            EOR !marioXSp
            BMI StartKickPose
                LDA !marioXSp
                STA $00 ; \
                ASL $00 ; / ...Why Nintendo??
                ROR
                CLC : ADC $9F6B,Y
                STA !spriteXSp,X
    endif
endif

if !releaseFix
    org $01A0AD
        autoclean JML ReleaseFix
else
    %cleanCode($01A0AD)
        STA $149A
        RTS
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !verbose
    print "Bytes altered: ", bytes
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Free code

if !individualFreeCode == 0
    if !spinDrop+!spinUp+!spinKickCenter+!spinKick+!ezMidair+!releaseFix > 0
        freecode
    endif
endif

if !spinDrop
    if !individualFreeCode != 0
        freecode
    endif
    ; For the drop routine, we want to do two things:
    ;   1. If the player is pressing a direction, drop items in that direction
    ;   2. Otherwise, if the player is spinning, center the shell
    SpinDropFix:
        if !dropDirection
            LDA !isOnGround      ; \ If the player is on the ground...
            BEQ +                ; |
                LDA !isDucking   ; | And ducking...
                BNE .default     ; | > Do the default
            +                    ; /
            LDA !controller      ; \
            AND #$03             ; | If the player is holding left or right...
            BEQ .default         ; |
                AND #$01         ; | \ Set Y to be the held direction
                TAY              ; | /   Priority goes to right if both are held
                BRA +            ; /
            .default             ;
        endif
            LDY !marioDir        ; \ Else set Y to mario's facing direction
            LDA !isSpinning      ; | \
            ORA !isCaping        ; | | If the player is spinning...
            BEQ +                ; | /
                LDA !marioXLo    ; | \
                STA !spriteXLo,X ; | | Set the sprite's x position to be mario's
                LDA !marioXHi    ; | |   x position. This centers it.
                STA !spriteXHi,X ; | /
            LDA #$00             ; | \ Set up the next part of the routine
            JML $01A05F|!bank    ; / / JML back to code
        +                        ; If the player isn't spinning...
        LDA !marioXLo            ; \ Restore overwritten code
    JML DropRecover|!bank        ; / JML back to original code
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !spinUp || !spinKickCenter
    if !individualFreeCode != 0
        freecode
    endif
    ; For the up-throw and possibly the kick routine, we want to center the
    ;   sprite if you are spinning when you throw it
    SpinUpFix:
        LDA !isSpinning      ; \ \
        ORA !isCaping        ; | | If the player is spinning...
        BEQ .default         ; | /
            LDA !marioXLo    ; | \
            STA !spriteXLo,X ; | | Set the sprite's x position to be mario's x
            LDA !marioXHi    ; | |   position. This centers it.
            STA !spriteXHi,X ; | /
        .default             ; /
    JML KickSplat|!bank      ; Show the kick splat (Restore overwritten code)
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !spinKick
    if !individualFreeCode != 0
        freecode
    endif
    ; For the kick routine, we want to prioritize the direction held
    ; Here Y is the direction to throw the shell
    SpinKickFix:
        LDA !isOnGround    ; \ If the player is on the ground...
        BEQ +              ; |
            LDA !isDucking ; | And ducking...
            BNE .default   ; | > Do the default
        +                  ; /
        LDA !controller    ; \
        BIT #$03           ; | If the player is holding left or right...
        BEQ .default       ; |
            AND #$01       ; | \ Set Y to be the held direction
            TAY            ; | /   (Priority goes to right if both are held)
            if !mmThrow && !ezMidair == 0
                LDA !isSpinning
                BEQ +
                STY !marioDir
                STZ !isSpinning
                STZ !isTurning
            endif
        BRA +              ; /
        .default           ; \ Else...
            LDY !marioDir  ; | > Set Y to mario's facing direction
        +                  ; /
        LDA !hasYoshi      ; \ Restore overwritten code
    RTL                    ; / Return to kick routine
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !ezMidair
    if !individualFreeCode != 0
        freecode
    endif
    ; Here we check if the player is turning when an item is kicked
    ;   If they are, adjust the speed of the item
    SpeedChange:
        LDA !isSpinning
        if !mmThrow
            BNE .predefault
        else
            BNE .default
        endif
        LDA !isTurning             ; \ If the player is turning around...
        BEQ .default               ; /
            if !speedModifer != 0
                TYA : LSR          ; > Set the carry if Y is odd, i.e. if the
                LDA #!speedModifer ; \     shell is thrown right
                BCC +              ; |
                    EOR #$FF       ; | > (Carry is set so the INC is in the next
                +                  ; /     ADC)
                ADC !spriteXSp,X   ; \ Subtract !speedModifer from shell speed
                STA !spriteXSp,X   ; /
                if !speedSafety > 0
                    CLC : ADC.B #!posSpeed   ; \ If the shell speed is too
                    CMP.B #!compareValue     ; /   slow...
                    BCS +                    ; \ Set the carry if shell is
                        TYA : LSR            ; |    kicked right
                        LDA.B #!negSpeed     ; | \
                        BCC ++               ; | |
                            LDA.B #!posSpeed ; | |
                        ++                   ; | | Set the shell speed to the
                        STA !spriteXSp,X     ; | /   minimum speed
                    +                        ; /
                endif
            endif
            if !disableFrames != $10
                LDA #!disableFrames  ; \ Set the shell's disable frames
                STA !spriteDisable,X ; /
            JML $01A0AB              ; > Return later in the routine
            endif
        if !mmThrow
            .predefault
            STZ !isSpinning
            STZ !isTurning
            TYA : AND #$01
            STA !marioDir
        endif
        .default
    JML StartKickPose|!bank ; > Return
endif

if !releaseFix
    if !individualFreeCode != 0
        freecode
    endif
    ; Here we check if the sprite is being released into a block, and adjust its
    ;   position to be next to the block instead
    ReleaseFix:
        STA $149A|!addr ; Recover original code

        LDA !isSpinning
        ORA !isCaping
        BNE .return
            LDA !spriteYLo,X : PHA ; \ Store the position of the sprite and its
            LDA !spriteYHi,X : PHA ; |   speed on the stack
            LDA !spriteXLo,X : PHA ; |   (Yes, we need all of these)
            LDA !spriteXHi,X : PHA ; |
            LDA !spriteYSp,X : PHA ; |
            LDA !spriteXSp,X : PHA ; /
            ; This is to make sure we check if the sprite is blocked
            ;   horizontally
            LDY !marioDir                  ; \ Set x speed to be going towards
            LDA $8CBC,Y : STA !spriteXSp,X ; /   Mario's facing direction

            JSL $019138|!bank ; > Run the Sprite-Block interaction routine
            if !popFix
                LDA !spriteYLo,X : STA $00 ; > Store the altered Y position
            endif
            PLA : STA !spriteXSp,X ; \ Restore the saved variables
            PLA : STA !spriteYSp,X ; |
            PLA : STA !spriteXHi,X ; |
            PLA : STA !spriteXLo,X ; |
            PLA : STA !spriteYHi,X ; |
            PLA : STA !spriteYLo,X ; /


            LDY !marioDir ; > Load Mario's facing direction into Y
            if !popFix
                SEC : SBC $00        ; \ If the difference between the y
                BPL +                ; |   position before and after the
                    EOR #$FF : INC A ; |   interaction routine is more than 8,
                +                    ; |
                CMP #$08             ; /
                BCS .fix             ; > Apply the fix
            endif

            LDA !spriteBlocked,X ; \ If the sprite is blocked where mario faces
            AND $A35D,Y          ; |  > 2-byte table in bank 1 "$02,$01"
            BEQ .return          ; / Apply the fix

        .fix
            ; Get object clipping index
            LDA !spriteProp1656,X ; \ Get object clipping index
            AND #$0F : ASL #2     ; |
            ADC $AB2D,Y           ; | \ Data table "$01,$00"; Carry's clear here
            TAY                   ; / / If mario faces left, get the left side

            ; Get the position of the block the sprite should be in / next to
            ; and subtract so the object clipping is next to the solid block
            LDA !spriteXLo,X     ; \
            AND #$F0 : ADC #$10  ; | (Carry is clear here)
            BCC +                ; | If this crosses a screen border...
                INC !spriteXHi,X ; | > Increment the hi byte
            +                    ; |
            SEC : SBC $90BA,Y    ; | > Sprite clipping table, x positions
            STA !spriteXLo,X     ; / Sets the position to be next to the block

            LDA !spriteXHi,X ; \ Adjust the Hi byte accordingly
            ADC #$FF         ; |
            STA !spriteXHi,X ; /
        .return
        STZ !spriteBlocked,X
    JML $01A12E|!bank ; Jump to an RTS
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if !verbose
    print "Bytes inserted: ", freespaceuse
    if !spinDrop
        print "SpinDropFix inserted at $", hex(SpinDropFix)
    endif
    if !spinUp || !spinKickCenter
        print "  SpinUpFix inserted at $", hex(SpinUpFix)
    endif
    if !spinKick
        print "SpinKickFix inserted at $", hex(SpinKickFix)
    endif
    if !ezMidair
        print "SpeedChange inserted at $", hex(SpeedChange)
    endif
    if !releaseFix
        print " ReleaseFix inserted at $", hex(ReleaseFix)
    endif
endif
