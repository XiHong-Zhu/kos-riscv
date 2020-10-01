.section .text
.global _entry
_entry:
    la sp, stack
    csrr a0, mhartid
    li a1, 4096
    mul a0, a0, a1
    add a0, a0, a1
    add sp, sp, a0
    call start
spin:
    j spin