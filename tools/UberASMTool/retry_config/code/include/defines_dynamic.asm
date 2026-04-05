; Dynamic defines for miscellaneous values used by Retry
; These are calculated at compile time depending on some other define

; Address for the custom midway amount.
!ram_cust_obj_num = !ram_cust_obj_data+(!max_custom_midway_num*4)

; Address for the custom midway entrance value.
!ram_cust_obj_entr = !ram_cust_obj_data+(!max_custom_midway_num*2)

; SRAM bank for convenience
!sram_bank = bank(!sram_addr)

; Macro to set !define to the number of values in the variadic argument
macro _count_args(define, ...)
    !<define> #= sizeof(...)
endmacro

; Macro to set !count_define to the number of values in the !vararg_define list
; If !vararg_define is not defined, the count is set to 0
macro count_args(count_define, vararg_define)
    if defined("<vararg_define>")
        %_count_args(<count_define>, !<vararg_define>)
    else ; if not(defined("<vararg_define>"))
        !<count_define> = 0
    endif ; defined("<vararg_define>")
endmacro

; Export !prompt_line1_length = number of letters in the first prompt line
%count_args(prompt_line1_length,prompt_tile_index_line1)

; Export !prompt_line2_length = number of letters in the second prompt line
%count_args(prompt_line2_length,prompt_tile_index_line2)
