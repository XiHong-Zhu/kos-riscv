#include "cpu.h"

static int started = 0;

void main(){
    if(cpuid() == 0){
        started = 1;
    }else{
        while(started == 0);
        __sync_synchronize();
    }
}