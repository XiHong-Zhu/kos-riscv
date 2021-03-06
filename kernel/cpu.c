#include "include/cpu.h"
#include "include/riscv.h"
#include "defines.h"

struct cpu cpus[NCPU];

int cpuid(){
    int id = r_tp();
    return id;
}

struct cpu * mycpu(){
    int id = r_tp();
    struct cpu *c = &cpus[id];
    return c;
}