#include "include/cpu.h"
#include "include/kalloc.h"
#include "include/vm.h"
#include "include/trap.h"
#include "include/riscv.h"

static int started = 0;

void scheduler(){
    intr_on();
    while (1);
}

void main(){
    if(cpuid() == 0){
        kinit();
        kvminit();
        kvminithart();
        trapinit();
        trapinithart();
        started = 1;
    }else{
        while(started == 0);
        __sync_synchronize();
    }
    // nerver return placehold
    scheduler();
}