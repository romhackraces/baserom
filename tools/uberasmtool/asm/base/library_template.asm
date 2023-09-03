incsrc "uber_defines.asm"
incsrc "!MacrolibFile"   ; global defines file

macro UberLibrary(filename, binary)
    if <binary>
        freedata cleaned
        print "_startl ", pc
        incbin "../../library/<filename>"
    else
        freecode cleaned
        print "_startl ", pc
        incsrc "../../library/<filename>"
    endif

    print "_endl ", pc
endmacro
