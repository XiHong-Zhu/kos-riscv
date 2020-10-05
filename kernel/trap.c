#include "include/spinlock.h"
#include "include/types.h"
#include "include/riscv.h"

struct spinlock tickslock;
uint ticks;

extern void kernelvec();

void trapinit(){
    initlock(&tickslock, "ticks");
}

void trapinithart(void)
{
    w_stvec((uint64)kernelvec);
}

void kerneltrap(){

}

