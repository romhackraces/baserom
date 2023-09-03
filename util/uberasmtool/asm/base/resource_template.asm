; This file is included by a working copy in asm/work, once for each resource
;
; Note this sets the DBR (if specified), but doesn't restore it...should be fine as long as the DBR never gets set a bank without low ram mirrors,
;    which would only happen by a misbehaving bit of code in a high bank or something.
; It will be explicitly restored after all resources are called
;
;---------------------------------------

incsrc "uber_defines.asm"
incsrc "!MacrolibFile"
incsrc "../work/library_labels.asm"

namespace nested on

macro UberResource(filename, setdbr)
    freecode cleaned

    print "_startl ", pc

    init:
    main:
    end:
    load:
        rtl

    namespace Inner

    if !sa1
            
        ResourceEntry:
            lda $06,S
            tax
            lda.l SA1Labels,x
            beq .NotSA1
            stx $03
            %invoke_sa1(.SA1)
            rtl

        .SA1:
            if <setdbr>
                phk
                plb
            endif
            ldx $03
            jmp (ResourceLabels,x)

        .NotSA1:
            if <setdbr>
                phk
                plb
            endif
            jmp (ResourceLabels,x)

    else

        ResourceEntry:
            if <setdbr>
                phk
                plb
            endif
            lda $06,S
            tax
            jmp (ResourceLabels,x)

    endif

    ResourceLabels:
        dw init
        dw main
        dw end
        dw load

    if !sa1
        SA1Labels:
            dw !InvokeSA1init
            dw !InvokeSA1main
            dw !InvokeSA1end
            dw !InvokeSA1load
    endif

    incsrc "<filename>"

    ExtraBytes:
    incsrc "../work/extra_bytes.asm"

    print "_endl ", pc
    namespace off
endmacro
