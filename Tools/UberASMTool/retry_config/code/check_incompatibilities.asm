;if read1($05D9E3) != $5C
;    error "You must save a level in Lunar Magic with the \"Separate midway entrance\" option checked before applying this. Insertion aborted."
;endif

if read1($0FF0A0) == $FF
    error "You must save at least one level in Lunar Magic before inserting this patch. Insertion aborted."
endif

if read1($00A28A) == $5C && read1($05D8E6) == $5C
    error "This patch is not compatible with worldpeace's retry patch. Insertion aborted."
endif

if read1($05DAA3) == $5C
    error "This patch is not compatible with the Multiple Midway Points patch. Insertion aborted."
endif
