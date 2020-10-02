#include "defines.h"

#ifndef _CPU_H

#define _CPU_H

struct cpu{
    int pushoff_num;
    int intr_enabled;
};

struct cpu cpus[NCPU];

int cpuid();

struct cpu * mycpu();

#endif