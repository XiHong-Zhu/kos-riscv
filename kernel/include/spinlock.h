#include "cpu.h"

#ifndef _SPINLOCK_H

#define _SPINLOCK_H

struct spinlock{
    int locked;
    char * name;
    struct cpu * cpu;
};

void initlock(struct spinlock * lk, char * name);

void acquire(struct spinlock * lk);

void release(struct spinlock * lk);

#endif