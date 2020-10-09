#include "types.h"

#ifndef _CPU_H

#define _CPU_H

struct proc;

struct context {
  uint64 ra;
  uint64 sp;
  // callee-saved
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

struct cpu{
    struct proc * proc;
    struct context context;
    int pushoff_num;
    int intr_enabled;
};

int cpuid();

struct cpu * mycpu();

#endif