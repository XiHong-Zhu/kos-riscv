#include "include/kalloc.h"
#include "include/riscv.h"
#include "include/memlayout.h"

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

void kinit()
{
  initlock(&kmemory.lock, "kmemory");
  freerange(end, (void*)PHYSTOP);
}

void kfree(void *pa)
{
  struct run *r;

  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmemory.lock);
  r->next = kmemory.freelist;
  kmemory.freelist = r;
  release(&kmemory.lock);
}

void * kalloc(void)
{
  struct run *r;

  acquire(&kmemory.lock);
  r = kmemory.freelist;
  if(r)
    kmemory.freelist = r->next;
  release(&kmemory.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}