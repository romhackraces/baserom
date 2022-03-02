pushpc

; We could probably handle this with UberASM alone,
; but the dcsave patch uses this jml to check if retry is installed, so we'll replicate that.
org $008E5B
    jml hurry_flag

pullpc

hurry_flag:
    ; Restore original code.
    lda #$FF : sta $1DF9|!addr

    ; Set the hurry up flag.
    lda #$01 : sta !ram_hurry_up

    ; Return to the original code.
    jml $008E60|!bank
