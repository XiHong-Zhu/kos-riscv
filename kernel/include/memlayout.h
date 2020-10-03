#ifndef _MEMLAYOUT_H

#define _MEMLAYOUT_H

// Core Local Interrupt 
#define CLINT 0x2000000L
// Core Local Interrupt TIMECMP
#define CLINT_MTIMECMP(hartid) (CLINT + 0x4000 + 8*(hartid))
// Core Local Interrupt Machine Time
#define CLINT_MTIME (CLINT + 0xBFF8) // cycles since boot.

#define KERNBASE 0x80000000L
#define PHYSTOP (KERNBASE + 128*1024*1024)

#endif