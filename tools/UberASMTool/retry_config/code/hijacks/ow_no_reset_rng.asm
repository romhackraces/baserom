; Normally Overworld and cutscene loading resets a bunch of RAM, including the
; RNG state. This hijack ensures that it won't be reset on Overworld load (since
; it is handled in the Retry code).

pushpc

org $00A1B2
    jml ow_no_reset_rng

org $00A1BB|!bank
    return:

pullpc

ow_no_reset_rng:
    ; Reset $13D3-$148A
    ldx.w #$148B-$13D3-1
-   stz $13D3|!addr,x
    dex : bpl -
    ; Reset $148F-$1BA1
    ldx.w #$07CE-($148B-$13D3)-4
-   stz $148F|!addr,x
    dex : bpl -
    jml return
