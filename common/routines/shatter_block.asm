;The origional one had a bug where if you place this in a vertical level, the shatter
;pieces are in the wrong location. Paste this in GPS's "routines" folder.

    PHY        ;>Protect tile behavor
    LDA #$02    ;\generate blank tile.
    STA $9C        ;|
    JSL $00BEB0|!bank    ;/

    LDA $5B        ;\If vertical level, then swap the X and Y high bytes due to level
    AND #$01    ;|format. This is because the tile change routine (both GPS and SMW's
    BEQ ?+        ;/left them swapped).
    LDA $99        ;\Fix the $99 and $9B from glitching up if placed
    LDY $9B        ;|other than top-left subscreen boundaries of vertical
    STY $99        ;|levels!!!!! (barrowed from the map16 change routine of GPS).
    STA $9B        ;/
?+
    PHB        ;\Spawn shatter pieces (using position based on
    LDA #$02    ;|$98~9B)
    PHA        ;|
    PLB        ;|
    LDA #$00    ;|
    JSL $028663|!bank    ;|
    PLB        ;/

    PLY        ;>End protect tile behavor
    RTL
