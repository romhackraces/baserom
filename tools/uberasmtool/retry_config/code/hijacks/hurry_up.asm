pushpc

; We could probably handle this with UberASM alone,
; but the dcsave patch uses this jml to check if Retry is installed, so we'll replicate that.
org $008E5B
    jml hurry_flag

pullpc

hurry_flag:
if not(!disable_hurry_up)
    ; Restore original code.
    lda #$FF : sta $1DF9|!addr

    ; Set the hurry up flag.
    lda #$01 : sta !ram_hurry_up
endif

    ; Return to the original code.
    jml $008E60|!bank

if !disable_hurry_up
    ; The dcsave patch uses read3($008E5B)+8 to read the Retry freeram
    ; so we need to preserve that. 4 bytes already used for the JML.
    dd $69696969
    dl !ram_hurry_up
endif
