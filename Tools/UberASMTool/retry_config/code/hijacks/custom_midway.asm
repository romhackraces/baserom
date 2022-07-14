;=====================================
; This inserts the custom midway objects.
; Main custom object code taken from ObjecTool 0.5 by 0x400 and imamelia.
; Custom midway code by worldpeace.
;=====================================

if !use_custom_midway_bar

pushpc

org $0DA415
    jml new_norm_objects

pullpc

new_norm_objects:
    sep #$30

    ; Check if it's a custom normal object.
    lda $5A : cmp #$2D : beq .custom

.not_custom:
    lda $1931|!addr
    jml $0DA41A|!bank

.custom:
    ; Store the first new settings byte.
    ldy #$00
    lda [$65],y : sta $5A

    ; Store the second new settings byte.
    iny
    lda [$65],y : sta $58

    ; Add 2 to the pointer so it ends up in the correct place.
    ; SMW expects them to have 3 bytes but this has 5 bytes.
    iny
    tya : clc : adc $65 : sta $65
    lda $66 : adc #$00 : sta $66

if !object_tool
    ; If ObjecTool is inserted, we jump to its code
    ; if the custom object number is $42-$4F or $52-$FF.
    lda $5A : cmp #$42 : bcc +
              cmp #$50 : beq +
              cmp #$51 : beq +

    ; Jump to ObjecTool's custom normal objects code.
    ; This jumps in the middle of the NewNormObjects routine, right before PHB : PHK : PLB,
    ; assuming the code won't change in future updates.
    rep #$20
    lda.l $0DA107|!bank : clc : adc.w #68 : sta $00
    sep #$20
    lda.l $0DA109|!bank : sta $02
    jml [$0000|!dp]
+
endif

    ; We only care about object 2D.
    jsr custom_midway

    ; Jump back to an rts.
    jml $0DA53C|!bank

custom_midway:
    ; Backup $59 ($58-$59 used for entrance info).
    lda $59 : pha
    stz $59

    ; Check which type of entrance it's set in the extra bytes.
    lda $5A : cmp #$50 : bcs .midway_entrance
              cmp #$40 : bcs .main_entrance
              cmp #$20 : bcs .secondary_water_entrance

.secondary_entrance:
    and #$01 : ora #$02
    bra ++

.secondary_water_entrance:
    and #$01 : ora #$0A
++
    sta $59
    lda $5A : and #$1E : asl #3 : tsb $59
    bra .end

.main_entrance:
    and #$01 : sta $59
    bra .end

.midway_entrance:
    and #$01 : ora #$08 : sta $59

.end:
    ; If there's already enough custom midway objects, return.
    lda !ram_cust_obj_num : cmp.b #!max_custom_midway_num : bcs .return

    ; Update the custom midway objects counter.
    inc : sta !ram_cust_obj_num

    dec : asl : tax
    lda $57
    rep #$20
    and #$00FF : clc : adc $6B

    ; Store index to $7EC800.
    sec : sbc #$C800 : sta !ram_cust_obj_data,x

    ; Store entrance info.
    lda $58 : sta !ram_cust_obj_entr,x

    ; If this is the midway that triggered the current checkpoint, don't make it spawn.
    lda !ram_respawn : eor $58 : and #$FBFF
    sep #$20
    beq .return

.spawn_midway:
    ldy $57
    lda #$38 : sta [$6B],y
    lda #$00 : sta [$6E],y
    lda $57 : and #$0F : beq .return
    dey
    lda #$35 : sta [$6B],y
    lda #$00 : sta [$6E],y

.return
    ; Restore $59.
    pla : sta $59
    rts

else

; Restore code, in case settings are changed.
if read1($0DA415) == $5C && read1($0DA106) != $5C

pushpc

org $0DA415
    sep #$30
    lda $1931|!addr

pullpc

endif

endif
