if not(defined("CALLISTO_HEADER_INCLUDED"))
    ; Marker define to mark that this file has been included
    !CALLISTO_HEADER_INCLUDED = 1

    ; Anything you place here will be included whenever you
    ; use `incsrc "callisto.asm"` in any resource

    ; Feel free to add macros, defines and functions here
    ; or `incsrc` files that contain them if you want
    ; easy access to them

    ; The following macro lets you easily `incsrc` files
    ; contained in this folder or subfolders, e.g.
    ; `%import("sa1def.asm")`

    macro import_library(path)
        %incsrc_file("shared/<path>")
    endmacro

endif