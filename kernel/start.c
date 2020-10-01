#include "include/riscv.h"
#define NCPU 8

// 4096 byte size stack for each CPU
__attribute__ ((aligned(16))) unsigned char stack[4096 * NCPU];


void start(){
    uint64 x = mhartid();

}
