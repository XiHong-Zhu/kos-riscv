#include "spinlock.h"

extern char end[];

struct run {
    struct run * next;
};

struct {
    struct spinlock lock;
    struct run * freelist;
} kmemory;

void kinit();