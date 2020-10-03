#include "spinlock.h"

#ifndef _KALLOC_H

#define _KALLOC_H

void kinit();

void * kalloc();

void kfree(void *pa);

#endif