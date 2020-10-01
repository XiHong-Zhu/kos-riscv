#include "types.h"

#ifndef _RISCV_H

#define _RISCV_H

static inline uint64 mhartid(){
    uint64 x;
    asm volatile("csrr %0, mhartid":"=r"(x));
    return x;
}


// MPP 
#define MSTATUS_MPP_MASK (3L << 11)     
#define MSTATUS_MPP_M    (3L << 11)     // Machine mode
#define MSTATUS_MPP_S    (1L << 11)     // Supervisor mode
#define MSTATUS_MPP_U    (0L << 11)     // User mode
#define MSTATUS_MIE      (1L << 3)      // Machine mode interrupt enable

#define MIE_MEIE         (1L << 11)     // Machine mode external interrupt enable
#define MIE_MTIE         (1L << 7)      // Machine mode time interrupt enable
#define MIE_MSIE         (1L << 3)      // Machine mode software interrupt enable

static inline uint64 r_mstatus(){
    uint64 x;
    asm volatile("csrr %0, mstatus":"=r"(x));
    return x;
}

static inline void w_mstatus(uint64 x){
    asm volatile("csrw mstatus, %0"::"r"(x));
}

// machine exception program counter
static inline void w_mepc(uint64 x){
    asm volatile("csrw mepc, %0"::"r"(x));
}

#define SSTATUS_SPP     (1L << 8)
#define SSTATUS_SPIE    (1L << 5)   // Supervisor previous interrupt enable
#define SSTATUS_UPIE    (1L << 4)   // User previous interrupt enable
#define SSTATUS_SIE     (1L << 1)   // Supervisor interrupt enable
#define SSTATUS_UIE     (1L << 0)   // User interrupt enable


#define SIE_SEIE        (1L << 9)
#define SIE_STIE        (1L << 5)
#define SIE_SSIE        (1L << 1)

#endif 