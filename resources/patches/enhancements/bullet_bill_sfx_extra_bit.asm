;==================================================================;
; Bullet Bill Sound Effect on Extra bit patch by AmperSam          ;
;                                                                  ;
; This patch will enable placed Bullet Bills to play a sound effect;
; when spawned, if their extra bit is set in Lunar Magic.          ;
;==================================================================;

; SA-1 Check
if read1($00FFD5) == $23
    sa1rom
    !sa1 = 1
    !addr = $6000
    !bank = $000000
    !1540 = $32C6
else
    lorom
    !sa1 = 0
    !addr = $0000
    !bank = $800000
    !1540 = $1540
endif

; set up macro for sprite tables
macro define_sprite_table(name, addr, addr_sa1)
    if !sa1 == 0
        !<name> = <addr>
    else
        !<name> = <addr_sa1>
    endif
endmacro

; define extra bits
%define_sprite_table("extra_bits",$7FAB10,$400040)

; Sound effect defines
!SFX = $09                  ; the SFX number of the Bullet Bill
!SFXBank = $1DFC|!addr      ; the bank from which the SFX is gotten

; Hijack of the Bullet Bill's init code
org $0184E3|!bank : autoclean jml BulletSFXExtraBit

freedata

BulletSFXExtraBit:
    lda !extra_bits,x       ;\ check if extra bit is set
    and #$04                ;|
    beq .Return             ;/
.PlaySFX
    lda #!SFX               ;\ play SFX
    sta !SFXBank            ;/
.Return
    lda.b #$10              ;\ restore Hijacked Code
    sta.w !1540,x           ;/
    jml $0184E8|!bank       ;> return