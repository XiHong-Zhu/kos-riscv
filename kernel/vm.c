#include "include/vm.h"
#include "include/riscv.h"
#include "include/kalloc.h"
#include "include/string.h"
#include "include/memlayout.h"


pagetable_t kernel_pagetable;

extern char etext[];

extern char trampoline[];

void kvmmap(uint64 va, uint64 pa, uint64 sz, int permision);

void kvminit(){
    // 分配页表页
    kernel_pagetable = (pagetable_t) kalloc();
    memset(kernel_pagetable, 0 , PGSIZE);
    kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
}

void kvminithart(){
    // 设置页表
    w_satp(MAKE_SATP(kernel_pagetable));
    // 刷新页表缓存
    sfence_vma();
}

// 根据虚拟地址遍历页表
// alloc != 0 时 分配页表
pte_t * walk(pagetable_t pagetable, uint64 va, int alloc){
    // 先求二级页表 页表项
    // 再求一级页表 页表项
    for(int level = 2; level > 0; level--){
        // 移位运算求虚拟号，虚拟号对应页表序号
        pte_t * pte = &pagetable[PX(level, va)];
        if(*pte & PTE_V){
            // 页表项求下一级页表
            pagetable = (pagetable_t)PTE2PA(*pte);
        }else{
            // 页表项不存在，分配页表
            if(!alloc || (pagetable = (pde_t *)kalloc()) == 0){
                return 0;
            }
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    // 返回0级页表项
    return &pagetable[PX(0,va)];
}

uint64 walkaddr(pagetable_t pagetable, uint64 va){
    pte_t * pte;
    uint64 pa;

    pte = walk(pagetable, va, 0);
    pa = PTE2PA(*pte);
    return pa;
}

uint64 kvmpa(uint64 va){
    uint64 offset = va % PGSIZE;
    pte_t *pte;
    uint64 pa;

    pte = walk(kernel_pagetable, va, 0);
    pa = PTE2PA(*pte);
    return pa + offset;
}

int mappages(pagetable_t pagetable, uint64 va, uint64 pa, uint64 sz, int permision){
    uint64 address, last;
    pte_t * pte;

    // 按PGSIZE对齐 
    // 首地址
    address = PGROUNDDOWN(va);
    // 最后一页地址
    last = PGROUNDDOWN(va + sz - 1);
    while(1){
        if((pte = walk(pagetable, address, 1)) == 0){
            return -1;
        }
        if(*pte & PTE_V){
            // remap error
        }
        *pte = PA2PTE(pa) | permision | PTE_V;
        if(address == last){
            break;
        }
        address += PGSIZE;
        pa += PGSIZE;
    }
    return 0;
}

void kvmmap(uint64 va, uint64 pa, uint64 sz, int permision){
    mappages(kernel_pagetable, va, pa, sz, permision);
}