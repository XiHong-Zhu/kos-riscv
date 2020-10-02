#include "include/spinlock.h"
#include "include/riscv.h"

void initlock(struct spinlock * lk, char * name){
    lk->locked = 0;
    lk->name = name;
    lk->cpu = 0;
}

void acquire(struct spinlock *lk)
{
  push_off();
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0);
  __sync_synchronize();
  lk->cpu = mycpu();
}

void release(struct spinlock *lk)
{
  lk->cpu = 0;
  __sync_synchronize();
  __sync_lock_release(&lk->locked);
  pop_off();
}

void push_off(){
    int old  = intr_get();
    intr_off();
    struct cpu *c = mycpu();
    if(c->pushoff_num == 0){
        c->pushoff_num = old;
    }
    c->pushoff_num++;
}

void pop_off(void)
{
  struct cpu *c = mycpu();
  c->pushoff_num -= 1;
  if(c->pushoff_num == 0 && c->intr_enabled)
    intr_on();
}
