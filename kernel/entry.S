.section .text
.global _entry
_entry:
    la sp, stack            # prepare stack, declared in start.c 
    csrr a0, mhartid        # hartid
    li a1, 4096             # stack size
    mul a0, a0, a1          # calc stack top
    add a0, a0, a1          # calc stack bottom
    add sp, sp, a0          
    call start              # jump to start
spin:
    j spin