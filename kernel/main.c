#include "include/cpu.h"
#include "include/kalloc.h"

static int started = 0;

void main(){
    while (1)
    {
        /* code */
    }
    
    if(cpuid() == 0){
        kinit();
        started = 1;
    }else{
        while(started == 0);
        __sync_synchronize();
    }
}