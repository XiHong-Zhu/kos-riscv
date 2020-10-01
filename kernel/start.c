#include "include/riscv.h"
#define NCPU 8

__attribute__ ((aligned(16))) unsigned char stack[4096 * NCPU];

void bp(){

}

void start(){
    uint64 x = mhartid();
    w_tp(x);

    bp();
}
