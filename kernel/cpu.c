#include "include/cpu.h"
#include "include/riscv.h"

int cpuid(){
    int id = r_tp();
    return id;
}

struct cpu * mycpu(){
    int id = r_tp();
    struct cpu *c = &cpus[id];
    return c;
}