#include "include/riscv.h"
#include "include/memlayout.h"

#define NCPU 8

// 4096 byte size stack for each CPU
__attribute__ ((aligned(16))) unsigned char stack[4096 * NCPU];

// 时钟中断缓存区域
uint64 mscratch[NCPU * 32];

extern void main();

// 初始化时钟中断
void timerinit();
// machine timer interrupt handler
extern void timervec();

void start(){
    // 设置mstatus.MPP位域，最后执行mret指令，设置权限模式为S并跳转到mepc指向地址执行
    uint64 x = r_mstatus();
    x &= ~MSTATUS_MPP_MASK;
    x |= MSTATUS_MPP_S;
    w_mstatus(x);

    w_mepc((uint64)main);

    // 关分页
    w_satp(0);

    // 设置M模式异常 中断代理到S模式
    w_medeleg(0xffff);
    w_mideleg(0xffff);
    // S模式开中断
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);

    timerinit();

    int id = mhartid();
    w_tp((uint64)id);
    asm volatile("mret");
}

void timerinit(){
    // 获取 hartid
    int id = mhartid();

    // 时间片长度为1/10秒
    int interval = 1000000;
    // 设置时钟比较器
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    
    // 获取hart对应缓存区域地址
    uint64 * scratch = &mscratch[32*id];
    // 设置时钟比较器缓存
    scratch[0] = CLINT_MTIMECMP(id);
    // 设置时间片缓存
    scratch[1] = interval;

    // 设置mscratch寄存器
    w_mscratch((uint64)scratch);
    
    // 设置M模式中断处理程序
    w_mtvec((uint64)timervec);

    // M模式开中断
    w_mstatus(r_mstatus() | MSTATUS_MIE);
    w_mie(r_mie() | MIE_MTIE);
}
