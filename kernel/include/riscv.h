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
#define MSTATUS_MPP_M    (3L << 11)
#define MSTATUS_MPP_S    (1L << 11)
#define MSTATUS_MPP_U    (0L << 11)
#define MSTATUS_MIE      (1L << 3)

#define MIE_MEIE         (1L << 11)
#define MIE_MTIE         (1L << 7)
#define MIE_MSIE         (1L << 3)

static inline uint64 r_mstatus(){
    uint64 x;
    asm volatile("csrr %0, mstatus":"=r"(x));
    return x;
}

static inline void w_mstatus(uint64 x){
    asm volatile("csrw mstatus"::"r"(x));
}


#define SSTATUS_SPP     (1L << 8)
#define SSTATUS_SPIE    (1L << 5)
#define SSTATUS_UPIE    (1L << 4)
#define SSTATUS_SIE     (1L << 1)
#define SSTATUS_UIE     (1L << 0)


#define SIE_SEIE        (1L << 9)
#define SIE_STIE        (1L << 5)
#define SIE_SSIE        (1L << 1)

#endif 