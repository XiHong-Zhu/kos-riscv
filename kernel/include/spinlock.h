#include "cpu.h"

#ifndef _SPINLOCK_H

#define _SPINLOCK_H

struct spinlock{
    int locked;
    char * name;
    struct cpu * cpu;
};

void initlock(spinlock * lk, char * name);

void acquire(spinlock * lk);

void release(spinlock * lk);

#endif