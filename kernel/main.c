#include "include/cpu.h"
#include "include/kalloc.h"
#include "include/vm.h"

static int started = 0;

void main(){
    if(cpuid() == 0){
        kinit();
        kvminit();
        kvminithart();
        started = 1;
    }else{
        while(started == 0);
        __sync_synchronize();
    }
}