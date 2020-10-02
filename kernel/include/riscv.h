#include "types.h"

#ifndef _RISCV_H

#define _RISCV_H

// hatr id
static inline uint64 mhartid(){
    uint64 x;
    asm volatile("csrr %0, mhartid":"=r"(x));
    return x;
}

// Mechine status register
// MPP bits is set to the privilege mode at the time of the trap
#define MSTATUS_MPP_MASK (3L << 11)     // mstatus.SPP                      [11:12]
#define MSTATUS_MPP_M    (3L << 11)     // Machine mode                     11
#define MSTATUS_MPP_S    (1L << 11)     // Supervisor mode                  01
#define MSTATUS_MPP_U    (0L << 11)     // User mode                        00

// mstatus.MIE  [3]
#define MSTATUS_MIE      (1L << 3)      //Machine mode interrupt enable    

static inline void w_mstatus(uint64 x){
    asm volatile("csrw mstatus, %0"::"r"(x));
}

static inline uint64 r_mstatus(){
    uint64 x;
    asm volatile("csrr %0, mstatus":"=r"(x));
    return x;
}

// Machine exception program counter
// 发生异常，指向异常指令地址
// 对于中断，指向指向中断处理后应该恢复执行的位置
// mret 指令 将 pc 设置为 mepc ，通过将mpie 设置到 mie 来恢复中断使能，
// 并将权限模式设置为mstatus.MPP
static inline void w_mepc(uint64 x){
    asm volatile("csrw mepc, %0"::"r"(x));
}

// Machine Interrupt Enable
// 列出当前处理器能处理 和 必须忽略的中断
// mie.MEIE [11]                  
#define MIE_MEIE         (1L << 11)     // Machine mode external interrupt enable
// mie.MTIE [7]
#define MIE_MTIE         (1L << 7)      // Machine mode time interrupt enable
// mie.MSIE [3]
#define MIE_MSIE         (1L << 3)      // Machine mode software interrupt enable

static inline void w_mie(uint64 x){
    asm volatile("csrw mie, %0"::"r"(x));
}

static inline uint64 r_mie(){
    uint64 x;
    asm volatile("csrr %0, mie":"=r"(x));
    return x;
}

// Machine Exception Delegation
// 控制将哪些异常委托给 S 模式
static inline void w_medeleg(uint64 x){
    asm volatile("csrw medeleg, %0"::"r"(x));
}

static inline uint64 r_medeleg(){
    uint64 x;
    asm volatile("csrr %0, medeleg":"=r"(x));
    return x;
}

// Machine Interrupt Delegation
// 控制将哪些中断委托给 S 模式
static inline void w_mideleg(uint64 x){
    asm volatile("csrw mideleg, %0"::"r"(x));
}

static inline uint64 r_mideleg(){
    uint64 x;
    asm volatile("csrr %0, mideleg":"=r"(x));
    return x;
}

// Machine interrupt vector
// Machine mode中断处理程序地址
static inline void 
w_mtvec(uint64 x)
{
  asm volatile("csrw mtvec, %0":: "r" (x));
}

// Supervisor status register
#define SSTATUS_SPP     (1L << 8)   // sstatus.SPP 
#define SSTATUS_SPIE    (1L << 5)   // Supervisor previous interrupt enable
#define SSTATUS_UPIE    (1L << 4)   // User previous interrupt enable
#define SSTATUS_SIE     (1L << 1)   // Supervisor interrupt enable
#define SSTATUS_UIE     (1L << 0)   // User interrupt enable

static inline void w_sstatus(uint64 x){
    asm volatile("csrw sstatus, %0"::"r"(x));
}

static inline uint64 r_sstatus(){
    uint64 x;
    asm volatile("csrr %0, sstatus":"=r"(x));
    return x;
}

// Supervisor Interrupt Enable
#define SIE_SEIE        (1L << 9)   // sip.SEIE external interrupt enable
#define SIE_STIE        (1L << 5)   // sip.STIP timer interrupt enable
#define SIE_SSIE        (1L << 1)   // sip.SSIE software interrupt enable

static inline void w_sie(uint64 x){
    asm volatile("csrw sie, %0"::"r"(x));
}

static inline uint64 r_sie(){
    uint64 x;
    asm volatile("csrr %0, sie":"=r"(x));
    return x;
}

// Supervisor interrupt register 
// containing information on pending interrupts
static inline void w_sip(uint64 x){
    asm volatile("csrw sip, %0"::"r"(x));
}

static inline uint64 r_sip(){
    uint64 x;
    asm volatile("csrr %0, sip":"=r"(x));
    return x;
}

// Supervisor Exception Program Counter
static inline void w_sepc(uint64 x){
    asm volatile("csrw sepc, %0"::"r"(x));
}

static inline uint64 r_sepc(){
    uint64 x;
    asm volatile("csrr %0, sepc":"=r"(x));
    return x;
}

// Supervisor Trap Vector
static inline void w_stvec(uint64 x){
    asm volatile("csrw stvec, %0"::"r"(x));
}

static inline uint64 r_stvec(){
    uint64 x;
    asm volatile("csrr %0, stvec":"=r"(x));
    return x;
}

// Supervisor Trap Value
static inline uint64 r_stval()
{
  uint64 x;
  asm volatile("csrr %0, stval":"=r"(x));
  return x;
}

// Supervisor address translation and protection
static inline void w_satp(uint64 x){
    asm volatile("csrw satp, %0"::"r"(x));
}

static inline uint64 r_satp(){
    uint64 x;
    asm volatile("csrr %0, satp":"=r"(x));
    return x;
}

static inline void w_mscatch(uint64 x){
    asm volatile("csrw sscratch, %0"::"r"(x));
}

static inline uint64 r_mscratch(){
    uint64 x;
    asm volatile("csrr %0, sscratch":"=r"(x));
    return x;
}

static inline void w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
}

static inline uint64 r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
  return x;
}

static inline void intr_on()
{
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}

static inline int intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
}

#endif 