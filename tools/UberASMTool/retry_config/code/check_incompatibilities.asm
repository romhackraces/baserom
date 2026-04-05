; Asar 1.90+ is required
asar 1.90

; UberASM Tool 2.1+ is required
; (technically 2.0 is fine but it ships with Asar 1.81)
%require_uber_ver(2,1)

assert read1($0FF0A0) != $FF,\
    "You must save at least one level in Lunar Magic before inserting this patch. Insertion aborted."

assert read1($00A28A) != $5C || read1($05D8E6) != $5C,\
    "This patch is not compatible with worldpeace's retry patch. Insertion aborted."

assert read1($05DAA3) != $5C,\
    "This patch is not compatible with the Multiple Midway Points patch. Insertion aborted."

; Warn if SRAM/BW-RAM plus are patched in already and !sram_feature = 1 (also force it to 0).
if !sram_feature && not(!sa1) && !sram_plus
    print "Warning: SRAM Plus was detected in your ROM. Retry's save feature won't be inserted."
    !sram_feature = 0
endif ; !sram_feature && not(!sa1) && !sram_plus

if !sram_feature && !sa1 && !bwram_plus
    print "Warning: BW-RAM Plus was detected in your ROM. Retry's save feature won't be inserted."
    !sram_feature = 0
endif ; !sram_feature && !sa1 && !bwram_plus
