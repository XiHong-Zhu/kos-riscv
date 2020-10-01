// Core Local Interrupt 
#define CLINT 0x2000000L
// Core Local Interrupt TIMECMP
#define CLINT_MTIMECMP(hartid) (CLINT + 0x4000 + 8*(hartid))
// Core Local Interrupt Machine Time
#define CLINT_MTIME (CLINT + 0xBFF8) // cycles since boot.
