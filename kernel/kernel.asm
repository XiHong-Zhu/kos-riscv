
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00002117          	auipc	sp,0x2
    80000004:	81010113          	addi	sp,sp,-2032 # 80001810 <stack>
    80000008:	f1402573          	csrr	a0,mhartid
    8000000c:	6585                	lui	a1,0x1
    8000000e:	02b50533          	mul	a0,a0,a1
    80000012:	952e                	add	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
    int id = mhartid();
    w_tp((uint64)id);
    asm volatile("mret");
}

void timerinit(){
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#include "types.h"

// hatr id
static inline uint64 mhartid(){
    uint64 x;
    asm volatile("csrr %0, mhartid":"=r"(x));
    80000022:	f14027f3          	csrr	a5,mhartid
    int id = mhartid();

    // 时间片长度为1秒
    int interval = 100000000;
    // 设置时钟比较器
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	05f5e737          	lui	a4,0x5f5e
    8000003c:	10070713          	addi	a4,a4,256 # 5f5e100 <_entry-0x7a0a1f00>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)
    
    // 获取hart对应缓存区域地址
    uint64 * scratch = &mscratch[32*id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00001617          	auipc	a2,0x1
    8000004e:	fc660613          	addi	a2,a2,-58 # 80001010 <mscratch>
    80000052:	97b2                	add	a5,a5,a2
    // 设置时钟比较器缓存
    scratch[0] = CLINT_MTIMECMP(id);
    80000054:	e394                	sd	a3,0(a5)
    // 设置时间片缓存
    scratch[1] = interval;
    80000056:	e798                	sd	a4,8(a5)
    asm volatile("csrr %0, satp":"=r"(x));
    return x;
}

static inline void w_mscratch(uint64 x){
    asm volatile("csrw mscratch, %0"::"r"(x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0":: "r" (x));
    8000005c:	00000797          	auipc	a5,0x0
    80000060:	09478793          	addi	a5,a5,148 # 800000f0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
}

static inline uint64 r_mscratch(){
    uint64 x;
    asm volatile("csrr %0, mscratch":"=r"(x));
    80000068:	340027f3          	csrr	a5,mscratch
    
    // 设置M模式中断处理程序
    w_mtvec((uint64)timervec);

    // M模式开中断
    w_mstatus(r_mscratch() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0"::"r"(x));
    80000070:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie":"=r"(x));
    80000074:	304027f3          	csrr	a5,mie
    w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0"::"r"(x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
void start(){
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus":"=r"(x));
    8000008e:	300027f3          	csrr	a5,mstatus
    x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff4f8f>
    80000098:	8ff9                	and	a5,a5,a4
    x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0"::"r"(x));
    800000a2:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0"::"r"(x));
    800000a6:	00000797          	auipc	a5,0x0
    800000aa:	46c78793          	addi	a5,a5,1132 # 80000512 <main>
    800000ae:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0"::"r"(x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0"::"r"(x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0"::"r"(x));
    800000c0:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie":"=r"(x));
    800000c4:	104027f3          	csrr	a5,sie
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0"::"r"(x));
    800000cc:	10479073          	csrw	sie,a5
    timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
    asm volatile("csrr %0, mhartid":"=r"(x));
    800000d8:	f14027f3          	csrr	a5,mhartid
    w_tp((uint64)id);
    800000dc:	2781                	sext.w	a5,a5
    return x;
}

static inline void w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
    asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret
    800000ec:	0000                	unimp
	...

00000000800000f0 <timervec>:
    800000f0:	34051573          	csrrw	a0,mscratch,a0
    800000f4:	e90c                	sd	a1,16(a0)
    800000f6:	ed10                	sd	a2,24(a0)
    800000f8:	f114                	sd	a3,32(a0)
    800000fa:	610c                	ld	a1,0(a0)
    800000fc:	6510                	ld	a2,8(a0)
    800000fe:	6194                	ld	a3,0(a1)
    80000100:	96b2                	add	a3,a3,a2
    80000102:	e194                	sd	a3,0(a1)
    80000104:	4589                	li	a1,2
    80000106:	14459073          	csrw	sip,a1
    8000010a:	7114                	ld	a3,32(a0)
    8000010c:	6d10                	ld	a2,24(a0)
    8000010e:	690c                	ld	a1,16(a0)
    80000110:	34051573          	csrrw	a0,mscratch,a0
    80000114:	30200073          	mret
	...

0000000080000122 <cpuid>:
#include "include/cpu.h"
#include "include/riscv.h"

struct cpu cpus[NCPU];

int cpuid(){
    80000122:	1141                	addi	sp,sp,-16
    80000124:	e422                	sd	s0,8(sp)
    80000126:	0800                	addi	s0,sp,16
}

static inline uint64 r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000128:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    8000012a:	2501                	sext.w	a0,a0
    8000012c:	6422                	ld	s0,8(sp)
    8000012e:	0141                	addi	sp,sp,16
    80000130:	8082                	ret

0000000080000132 <mycpu>:

struct cpu * mycpu(){
    80000132:	1141                	addi	sp,sp,-16
    80000134:	e422                	sd	s0,8(sp)
    80000136:	0800                	addi	s0,sp,16
    80000138:	8792                	mv	a5,tp
    int id = r_tp();
    struct cpu *c = &cpus[id];
    8000013a:	2781                	sext.w	a5,a5
    8000013c:	078e                	slli	a5,a5,0x3
    return c;
    8000013e:	00009517          	auipc	a0,0x9
    80000142:	6d250513          	addi	a0,a0,1746 # 80009810 <cpus>
    80000146:	953e                	add	a0,a0,a5
    80000148:	6422                	ld	s0,8(sp)
    8000014a:	0141                	addi	sp,sp,16
    8000014c:	8082                	ret

000000008000014e <initlock>:
#include "include/riscv.h"

void push_off();
void pop_off();

void initlock(struct spinlock * lk, char * name){
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e422                	sd	s0,8(sp)
    80000152:	0800                	addi	s0,sp,16
    lk->locked = 0;
    80000154:	00052023          	sw	zero,0(a0)
    lk->name = name;
    80000158:	e50c                	sd	a1,8(a0)
    lk->cpu = 0;
    8000015a:	00053823          	sd	zero,16(a0)
}
    8000015e:	6422                	ld	s0,8(sp)
    80000160:	0141                	addi	sp,sp,16
    80000162:	8082                	ret

0000000080000164 <push_off>:
  __sync_synchronize();
  __sync_lock_release(&lk->locked);
  pop_off();
}

void push_off(){
    80000164:	1101                	addi	sp,sp,-32
    80000166:	ec06                	sd	ra,24(sp)
    80000168:	e822                	sd	s0,16(sp)
    8000016a:	e426                	sd	s1,8(sp)
    8000016c:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus":"=r"(x));
    8000016e:	100024f3          	csrr	s1,sstatus
    80000172:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000176:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0"::"r"(x));
    80000178:	10079073          	csrw	sstatus,a5
    int old  = intr_get();
    intr_off();
    struct cpu *c = mycpu();
    8000017c:	00000097          	auipc	ra,0x0
    80000180:	fb6080e7          	jalr	-74(ra) # 80000132 <mycpu>
    if(c->pushoff_num == 0){
    80000184:	411c                	lw	a5,0(a0)
    80000186:	e781                	bnez	a5,8000018e <push_off+0x2a>
}

static inline int intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80000188:	8085                	srli	s1,s1,0x1
    8000018a:	8885                	andi	s1,s1,1
        c->pushoff_num = old;
    8000018c:	c104                	sw	s1,0(a0)
    }
    c->pushoff_num++;
    8000018e:	411c                	lw	a5,0(a0)
    80000190:	2785                	addiw	a5,a5,1
    80000192:	c11c                	sw	a5,0(a0)
}
    80000194:	60e2                	ld	ra,24(sp)
    80000196:	6442                	ld	s0,16(sp)
    80000198:	64a2                	ld	s1,8(sp)
    8000019a:	6105                	addi	sp,sp,32
    8000019c:	8082                	ret

000000008000019e <acquire>:
{
    8000019e:	1101                	addi	sp,sp,-32
    800001a0:	ec06                	sd	ra,24(sp)
    800001a2:	e822                	sd	s0,16(sp)
    800001a4:	e426                	sd	s1,8(sp)
    800001a6:	1000                	addi	s0,sp,32
    800001a8:	84aa                	mv	s1,a0
  push_off();
    800001aa:	00000097          	auipc	ra,0x0
    800001ae:	fba080e7          	jalr	-70(ra) # 80000164 <push_off>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0);
    800001b2:	4705                	li	a4,1
    800001b4:	87ba                	mv	a5,a4
    800001b6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800001ba:	2781                	sext.w	a5,a5
    800001bc:	ffe5                	bnez	a5,800001b4 <acquire+0x16>
  __sync_synchronize();
    800001be:	0ff0000f          	fence
  lk->cpu = mycpu();
    800001c2:	00000097          	auipc	ra,0x0
    800001c6:	f70080e7          	jalr	-144(ra) # 80000132 <mycpu>
    800001ca:	e888                	sd	a0,16(s1)
}
    800001cc:	60e2                	ld	ra,24(sp)
    800001ce:	6442                	ld	s0,16(sp)
    800001d0:	64a2                	ld	s1,8(sp)
    800001d2:	6105                	addi	sp,sp,32
    800001d4:	8082                	ret

00000000800001d6 <pop_off>:

void pop_off(void)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e406                	sd	ra,8(sp)
    800001da:	e022                	sd	s0,0(sp)
    800001dc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800001de:	00000097          	auipc	ra,0x0
    800001e2:	f54080e7          	jalr	-172(ra) # 80000132 <mycpu>
  c->pushoff_num -= 1;
    800001e6:	411c                	lw	a5,0(a0)
    800001e8:	37fd                	addiw	a5,a5,-1
    800001ea:	0007871b          	sext.w	a4,a5
    800001ee:	c11c                	sw	a5,0(a0)
  if(c->pushoff_num == 0 && c->intr_enabled)
    800001f0:	eb09                	bnez	a4,80000202 <pop_off+0x2c>
    800001f2:	415c                	lw	a5,4(a0)
    800001f4:	c799                	beqz	a5,80000202 <pop_off+0x2c>
    asm volatile("csrr %0, sstatus":"=r"(x));
    800001f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800001fa:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0"::"r"(x));
    800001fe:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000202:	60a2                	ld	ra,8(sp)
    80000204:	6402                	ld	s0,0(sp)
    80000206:	0141                	addi	sp,sp,16
    80000208:	8082                	ret

000000008000020a <release>:
{
    8000020a:	1141                	addi	sp,sp,-16
    8000020c:	e406                	sd	ra,8(sp)
    8000020e:	e022                	sd	s0,0(sp)
    80000210:	0800                	addi	s0,sp,16
  lk->cpu = 0;
    80000212:	00053823          	sd	zero,16(a0)
  __sync_synchronize();
    80000216:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000021a:	0f50000f          	fence	iorw,ow
    8000021e:	0805202f          	amoswap.w	zero,zero,(a0)
  pop_off();
    80000222:	00000097          	auipc	ra,0x0
    80000226:	fb4080e7          	jalr	-76(ra) # 800001d6 <pop_off>
}
    8000022a:	60a2                	ld	ra,8(sp)
    8000022c:	6402                	ld	s0,0(sp)
    8000022e:	0141                	addi	sp,sp,16
    80000230:	8082                	ret

0000000080000232 <memset>:
#include "include/types.h"

void* memset(void *dst, int c, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e422                	sd	s0,8(sp)
    80000236:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000238:	ca19                	beqz	a2,8000024e <memset+0x1c>
    8000023a:	87aa                	mv	a5,a0
    8000023c:	1602                	slli	a2,a2,0x20
    8000023e:	9201                	srli	a2,a2,0x20
    80000240:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000244:	00b78023          	sb	a1,0(a5) # 10000 <_entry-0x7fff0000>
  for(i = 0; i < n; i++){
    80000248:	0785                	addi	a5,a5,1
    8000024a:	fee79de3          	bne	a5,a4,80000244 <memset+0x12>
  }
  return dst;
}
    8000024e:	6422                	ld	s0,8(sp)
    80000250:	0141                	addi	sp,sp,16
    80000252:	8082                	ret

0000000080000254 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80000254:	1141                	addi	sp,sp,-16
    80000256:	e422                	sd	s0,8(sp)
    80000258:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000025a:	ca05                	beqz	a2,8000028a <memcmp+0x36>
    8000025c:	fff6069b          	addiw	a3,a2,-1
    80000260:	1682                	slli	a3,a3,0x20
    80000262:	9281                	srli	a3,a3,0x20
    80000264:	0685                	addi	a3,a3,1
    80000266:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000268:	00054783          	lbu	a5,0(a0)
    8000026c:	0005c703          	lbu	a4,0(a1) # 1000 <_entry-0x7ffff000>
    80000270:	00e79863          	bne	a5,a4,80000280 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000274:	0505                	addi	a0,a0,1
    80000276:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000278:	fed518e3          	bne	a0,a3,80000268 <memcmp+0x14>
  }

  return 0;
    8000027c:	4501                	li	a0,0
    8000027e:	a019                	j	80000284 <memcmp+0x30>
      return *s1 - *s2;
    80000280:	40e7853b          	subw	a0,a5,a4
}
    80000284:	6422                	ld	s0,8(sp)
    80000286:	0141                	addi	sp,sp,16
    80000288:	8082                	ret
  return 0;
    8000028a:	4501                	li	a0,0
    8000028c:	bfe5                	j	80000284 <memcmp+0x30>

000000008000028e <memmove>:

void* memmove(void *dst, const void *src, uint n)
{
    8000028e:	1141                	addi	sp,sp,-16
    80000290:	e422                	sd	s0,8(sp)
    80000292:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000294:	02a5e563          	bltu	a1,a0,800002be <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000298:	fff6069b          	addiw	a3,a2,-1
    8000029c:	ce11                	beqz	a2,800002b8 <memmove+0x2a>
    8000029e:	1682                	slli	a3,a3,0x20
    800002a0:	9281                	srli	a3,a3,0x20
    800002a2:	0685                	addi	a3,a3,1
    800002a4:	96ae                	add	a3,a3,a1
    800002a6:	87aa                	mv	a5,a0
      *d++ = *s++;
    800002a8:	0585                	addi	a1,a1,1
    800002aa:	0785                	addi	a5,a5,1
    800002ac:	fff5c703          	lbu	a4,-1(a1)
    800002b0:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    800002b4:	fed59ae3          	bne	a1,a3,800002a8 <memmove+0x1a>

  return dst;
}
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret
  if(s < d && s + n > d){
    800002be:	02061713          	slli	a4,a2,0x20
    800002c2:	9301                	srli	a4,a4,0x20
    800002c4:	00e587b3          	add	a5,a1,a4
    800002c8:	fcf578e3          	bgeu	a0,a5,80000298 <memmove+0xa>
    d += n;
    800002cc:	972a                	add	a4,a4,a0
    while(n-- > 0)
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	d27d                	beqz	a2,800002b8 <memmove+0x2a>
    800002d4:	02069613          	slli	a2,a3,0x20
    800002d8:	9201                	srli	a2,a2,0x20
    800002da:	fff64613          	not	a2,a2
    800002de:	963e                	add	a2,a2,a5
      *--d = *--s;
    800002e0:	17fd                	addi	a5,a5,-1
    800002e2:	177d                	addi	a4,a4,-1
    800002e4:	0007c683          	lbu	a3,0(a5)
    800002e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    800002ec:	fef61ae3          	bne	a2,a5,800002e0 <memmove+0x52>
    800002f0:	b7e1                	j	800002b8 <memmove+0x2a>

00000000800002f2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n)
{
    800002f2:	1141                	addi	sp,sp,-16
    800002f4:	e406                	sd	ra,8(sp)
    800002f6:	e022                	sd	s0,0(sp)
    800002f8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002fa:	00000097          	auipc	ra,0x0
    800002fe:	f94080e7          	jalr	-108(ra) # 8000028e <memmove>
}
    80000302:	60a2                	ld	ra,8(sp)
    80000304:	6402                	ld	s0,0(sp)
    80000306:	0141                	addi	sp,sp,16
    80000308:	8082                	ret

000000008000030a <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    8000030a:	1141                	addi	sp,sp,-16
    8000030c:	e422                	sd	s0,8(sp)
    8000030e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000310:	ce11                	beqz	a2,8000032c <strncmp+0x22>
    80000312:	00054783          	lbu	a5,0(a0)
    80000316:	cf89                	beqz	a5,80000330 <strncmp+0x26>
    80000318:	0005c703          	lbu	a4,0(a1)
    8000031c:	00f71a63          	bne	a4,a5,80000330 <strncmp+0x26>
    n--, p++, q++;
    80000320:	367d                	addiw	a2,a2,-1
    80000322:	0505                	addi	a0,a0,1
    80000324:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000326:	f675                	bnez	a2,80000312 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000328:	4501                	li	a0,0
    8000032a:	a809                	j	8000033c <strncmp+0x32>
    8000032c:	4501                	li	a0,0
    8000032e:	a039                	j	8000033c <strncmp+0x32>
  if(n == 0)
    80000330:	ca09                	beqz	a2,80000342 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000332:	00054503          	lbu	a0,0(a0)
    80000336:	0005c783          	lbu	a5,0(a1)
    8000033a:	9d1d                	subw	a0,a0,a5
}
    8000033c:	6422                	ld	s0,8(sp)
    8000033e:	0141                	addi	sp,sp,16
    80000340:	8082                	ret
    return 0;
    80000342:	4501                	li	a0,0
    80000344:	bfe5                	j	8000033c <strncmp+0x32>

0000000080000346 <strncpy>:

char* strncpy(char *s, const char *t, int n)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000034c:	872a                	mv	a4,a0
    8000034e:	8832                	mv	a6,a2
    80000350:	367d                	addiw	a2,a2,-1
    80000352:	01005963          	blez	a6,80000364 <strncpy+0x1e>
    80000356:	0705                	addi	a4,a4,1
    80000358:	0005c783          	lbu	a5,0(a1)
    8000035c:	fef70fa3          	sb	a5,-1(a4)
    80000360:	0585                	addi	a1,a1,1
    80000362:	f7f5                	bnez	a5,8000034e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000364:	86ba                	mv	a3,a4
    80000366:	00c05c63          	blez	a2,8000037e <strncpy+0x38>
    *s++ = 0;
    8000036a:	0685                	addi	a3,a3,1
    8000036c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000370:	fff6c793          	not	a5,a3
    80000374:	9fb9                	addw	a5,a5,a4
    80000376:	010787bb          	addw	a5,a5,a6
    8000037a:	fef048e3          	bgtz	a5,8000036a <strncpy+0x24>
  return os;
}
    8000037e:	6422                	ld	s0,8(sp)
    80000380:	0141                	addi	sp,sp,16
    80000382:	8082                	ret

0000000080000384 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n)
{
    80000384:	1141                	addi	sp,sp,-16
    80000386:	e422                	sd	s0,8(sp)
    80000388:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000038a:	02c05363          	blez	a2,800003b0 <safestrcpy+0x2c>
    8000038e:	fff6069b          	addiw	a3,a2,-1
    80000392:	1682                	slli	a3,a3,0x20
    80000394:	9281                	srli	a3,a3,0x20
    80000396:	96ae                	add	a3,a3,a1
    80000398:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000039a:	00d58963          	beq	a1,a3,800003ac <safestrcpy+0x28>
    8000039e:	0585                	addi	a1,a1,1
    800003a0:	0785                	addi	a5,a5,1
    800003a2:	fff5c703          	lbu	a4,-1(a1)
    800003a6:	fee78fa3          	sb	a4,-1(a5)
    800003aa:	fb65                	bnez	a4,8000039a <safestrcpy+0x16>
    ;
  *s = 0;
    800003ac:	00078023          	sb	zero,0(a5)
  return os;
}
    800003b0:	6422                	ld	s0,8(sp)
    800003b2:	0141                	addi	sp,sp,16
    800003b4:	8082                	ret

00000000800003b6 <strlen>:

int strlen(const char *s)
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e422                	sd	s0,8(sp)
    800003ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003bc:	00054783          	lbu	a5,0(a0)
    800003c0:	cf91                	beqz	a5,800003dc <strlen+0x26>
    800003c2:	0505                	addi	a0,a0,1
    800003c4:	87aa                	mv	a5,a0
    800003c6:	4685                	li	a3,1
    800003c8:	9e89                	subw	a3,a3,a0
    800003ca:	00f6853b          	addw	a0,a3,a5
    800003ce:	0785                	addi	a5,a5,1
    800003d0:	fff7c703          	lbu	a4,-1(a5)
    800003d4:	fb7d                	bnez	a4,800003ca <strlen+0x14>
    ;
  return n;
}
    800003d6:	6422                	ld	s0,8(sp)
    800003d8:	0141                	addi	sp,sp,16
    800003da:	8082                	ret
  for(n = 0; s[n]; n++)
    800003dc:	4501                	li	a0,0
    800003de:	bfe5                	j	800003d6 <strlen+0x20>

00000000800003e0 <kfree>:
  initlock(&kmemory.lock, "kmemory");
  freerange(end, (void*)PHYSTOP);
}

void kfree(void *pa)
{
    800003e0:	1101                	addi	sp,sp,-32
    800003e2:	ec06                	sd	ra,24(sp)
    800003e4:	e822                	sd	s0,16(sp)
    800003e6:	e426                	sd	s1,8(sp)
    800003e8:	e04a                	sd	s2,0(sp)
    800003ea:	1000                	addi	s0,sp,32
    800003ec:	892a                	mv	s2,a0
  struct run *r;

  memset(pa, 1, PGSIZE);
    800003ee:	6605                	lui	a2,0x1
    800003f0:	4585                	li	a1,1
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	e40080e7          	jalr	-448(ra) # 80000232 <memset>

  r = (struct run*)pa;

  acquire(&kmemory.lock);
    800003fa:	00009497          	auipc	s1,0x9
    800003fe:	45648493          	addi	s1,s1,1110 # 80009850 <kmemory>
    80000402:	8526                	mv	a0,s1
    80000404:	00000097          	auipc	ra,0x0
    80000408:	d9a080e7          	jalr	-614(ra) # 8000019e <acquire>
  r->next = kmemory.freelist;
    8000040c:	6c9c                	ld	a5,24(s1)
    8000040e:	00f93023          	sd	a5,0(s2)
  kmemory.freelist = r;
    80000412:	0124bc23          	sd	s2,24(s1)
  release(&kmemory.lock);
    80000416:	8526                	mv	a0,s1
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	df2080e7          	jalr	-526(ra) # 8000020a <release>
}
    80000420:	60e2                	ld	ra,24(sp)
    80000422:	6442                	ld	s0,16(sp)
    80000424:	64a2                	ld	s1,8(sp)
    80000426:	6902                	ld	s2,0(sp)
    80000428:	6105                	addi	sp,sp,32
    8000042a:	8082                	ret

000000008000042c <freerange>:
{
    8000042c:	7179                	addi	sp,sp,-48
    8000042e:	f406                	sd	ra,40(sp)
    80000430:	f022                	sd	s0,32(sp)
    80000432:	ec26                	sd	s1,24(sp)
    80000434:	e84a                	sd	s2,16(sp)
    80000436:	e44e                	sd	s3,8(sp)
    80000438:	e052                	sd	s4,0(sp)
    8000043a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000043c:	6785                	lui	a5,0x1
    8000043e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000442:	94aa                	add	s1,s1,a0
    80000444:	757d                	lui	a0,0xfffff
    80000446:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000448:	94be                	add	s1,s1,a5
    8000044a:	0095ee63          	bltu	a1,s1,80000466 <freerange+0x3a>
    8000044e:	892e                	mv	s2,a1
    kfree(p);
    80000450:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000452:	6985                	lui	s3,0x1
    kfree(p);
    80000454:	01448533          	add	a0,s1,s4
    80000458:	00000097          	auipc	ra,0x0
    8000045c:	f88080e7          	jalr	-120(ra) # 800003e0 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000460:	94ce                	add	s1,s1,s3
    80000462:	fe9979e3          	bgeu	s2,s1,80000454 <freerange+0x28>
}
    80000466:	70a2                	ld	ra,40(sp)
    80000468:	7402                	ld	s0,32(sp)
    8000046a:	64e2                	ld	s1,24(sp)
    8000046c:	6942                	ld	s2,16(sp)
    8000046e:	69a2                	ld	s3,8(sp)
    80000470:	6a02                	ld	s4,0(sp)
    80000472:	6145                	addi	sp,sp,48
    80000474:	8082                	ret

0000000080000476 <kinit>:
{
    80000476:	1141                	addi	sp,sp,-16
    80000478:	e406                	sd	ra,8(sp)
    8000047a:	e022                	sd	s0,0(sp)
    8000047c:	0800                	addi	s0,sp,16
  initlock(&kmemory.lock, "kmemory");
    8000047e:	00001597          	auipc	a1,0x1
    80000482:	b8258593          	addi	a1,a1,-1150 # 80001000 <main+0xaee>
    80000486:	00009517          	auipc	a0,0x9
    8000048a:	3ca50513          	addi	a0,a0,970 # 80009850 <kmemory>
    8000048e:	00000097          	auipc	ra,0x0
    80000492:	cc0080e7          	jalr	-832(ra) # 8000014e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000496:	45c5                	li	a1,17
    80000498:	05ee                	slli	a1,a1,0x1b
    8000049a:	00009517          	auipc	a0,0x9
    8000049e:	3d650513          	addi	a0,a0,982 # 80009870 <end>
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	f8a080e7          	jalr	-118(ra) # 8000042c <freerange>
}
    800004aa:	60a2                	ld	ra,8(sp)
    800004ac:	6402                	ld	s0,0(sp)
    800004ae:	0141                	addi	sp,sp,16
    800004b0:	8082                	ret

00000000800004b2 <kalloc>:

void * kalloc()
{
    800004b2:	1101                	addi	sp,sp,-32
    800004b4:	ec06                	sd	ra,24(sp)
    800004b6:	e822                	sd	s0,16(sp)
    800004b8:	e426                	sd	s1,8(sp)
    800004ba:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmemory.lock);
    800004bc:	00009497          	auipc	s1,0x9
    800004c0:	39448493          	addi	s1,s1,916 # 80009850 <kmemory>
    800004c4:	8526                	mv	a0,s1
    800004c6:	00000097          	auipc	ra,0x0
    800004ca:	cd8080e7          	jalr	-808(ra) # 8000019e <acquire>
  r = kmemory.freelist;
    800004ce:	6c84                	ld	s1,24(s1)
  if(r)
    800004d0:	c885                	beqz	s1,80000500 <kalloc+0x4e>
    kmemory.freelist = r->next;
    800004d2:	609c                	ld	a5,0(s1)
    800004d4:	00009517          	auipc	a0,0x9
    800004d8:	37c50513          	addi	a0,a0,892 # 80009850 <kmemory>
    800004dc:	ed1c                	sd	a5,24(a0)
  release(&kmemory.lock);
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	d2c080e7          	jalr	-724(ra) # 8000020a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800004e6:	6605                	lui	a2,0x1
    800004e8:	4595                	li	a1,5
    800004ea:	8526                	mv	a0,s1
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	d46080e7          	jalr	-698(ra) # 80000232 <memset>
  return (void*)r;
    800004f4:	8526                	mv	a0,s1
    800004f6:	60e2                	ld	ra,24(sp)
    800004f8:	6442                	ld	s0,16(sp)
    800004fa:	64a2                	ld	s1,8(sp)
    800004fc:	6105                	addi	sp,sp,32
    800004fe:	8082                	ret
  release(&kmemory.lock);
    80000500:	00009517          	auipc	a0,0x9
    80000504:	35050513          	addi	a0,a0,848 # 80009850 <kmemory>
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d02080e7          	jalr	-766(ra) # 8000020a <release>
  if(r)
    80000510:	b7d5                	j	800004f4 <kalloc+0x42>

0000000080000512 <main>:
#include "include/cpu.h"
#include "include/kalloc.h"

static int started = 0;

void main(){
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e422                	sd	s0,8(sp)
    80000516:	0800                	addi	s0,sp,16
    while (1)
    80000518:	a001                	j	80000518 <main+0x6>
	...
