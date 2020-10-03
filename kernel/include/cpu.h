#include "defines.h"

#ifndef _CPU_H

#define _CPU_H

struct cpu{
    int pushoff_num;
    int intr_enabled;
};

int cpuid();

struct cpu * mycpu();

#endif