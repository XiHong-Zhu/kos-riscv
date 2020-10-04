
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00003117          	auipc	sp,0x3
    80000004:	83010113          	addi	sp,sp,-2000 # 80002830 <stack>
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

    // 时间片长度为1/10秒
    int interval = 1000000;
    // 设置时钟比较器
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)
    
    // 获取hart对应缓存区域地址
    uint64 * scratch = &mscratch[32*id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00002617          	auipc	a2,0x2
    8000004e:	fe660613          	addi	a2,a2,-26 # 80002030 <mscratch>
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
    asm volatile("csrr %0, mstatus":"=r"(x));
    80000068:	300027f3          	csrr	a5,mstatus
    
    // 设置M模式中断处理程序
    w_mtvec((uint64)timervec);

    // M模式开中断
    w_mstatus(r_mstatus() | MSTATUS_MIE);
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff3f57>
    80000098:	8ff9                	and	a5,a5,a4
    x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0"::"r"(x));
    800000a2:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0"::"r"(x));
    800000a6:	00000797          	auipc	a5,0x0
    800000aa:	4e878793          	addi	a5,a5,1256 # 8000058e <main>
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

0000000080000118 <kernelvec>:
    80000118:	7111                	addi	sp,sp,-256
    8000011a:	e006                	sd	ra,0(sp)
    8000011c:	e40a                	sd	sp,8(sp)
    8000011e:	e80e                	sd	gp,16(sp)
    80000120:	ec12                	sd	tp,24(sp)
    80000122:	f016                	sd	t0,32(sp)
    80000124:	f41a                	sd	t1,40(sp)
    80000126:	f81e                	sd	t2,48(sp)
    80000128:	fc22                	sd	s0,56(sp)
    8000012a:	e0a6                	sd	s1,64(sp)
    8000012c:	e4aa                	sd	a0,72(sp)
    8000012e:	e8ae                	sd	a1,80(sp)
    80000130:	ecb2                	sd	a2,88(sp)
    80000132:	f0b6                	sd	a3,96(sp)
    80000134:	f4ba                	sd	a4,104(sp)
    80000136:	f8be                	sd	a5,112(sp)
    80000138:	fcc2                	sd	a6,120(sp)
    8000013a:	e146                	sd	a7,128(sp)
    8000013c:	e54a                	sd	s2,136(sp)
    8000013e:	e94e                	sd	s3,144(sp)
    80000140:	ed52                	sd	s4,152(sp)
    80000142:	f156                	sd	s5,160(sp)
    80000144:	f55a                	sd	s6,168(sp)
    80000146:	f95e                	sd	s7,176(sp)
    80000148:	fd62                	sd	s8,184(sp)
    8000014a:	e1e6                	sd	s9,192(sp)
    8000014c:	e5ea                	sd	s10,200(sp)
    8000014e:	e9ee                	sd	s11,208(sp)
    80000150:	edf2                	sd	t3,216(sp)
    80000152:	f1f6                	sd	t4,224(sp)
    80000154:	f5fa                	sd	t5,232(sp)
    80000156:	f9fe                	sd	t6,240(sp)
    80000158:	688000ef          	jal	ra,800007e0 <kerneltrap>
    8000015c:	6082                	ld	ra,0(sp)
    8000015e:	6122                	ld	sp,8(sp)
    80000160:	61c2                	ld	gp,16(sp)
    80000162:	7282                	ld	t0,32(sp)
    80000164:	7322                	ld	t1,40(sp)
    80000166:	73c2                	ld	t2,48(sp)
    80000168:	7462                	ld	s0,56(sp)
    8000016a:	6486                	ld	s1,64(sp)
    8000016c:	6526                	ld	a0,72(sp)
    8000016e:	65c6                	ld	a1,80(sp)
    80000170:	6666                	ld	a2,88(sp)
    80000172:	7686                	ld	a3,96(sp)
    80000174:	7726                	ld	a4,104(sp)
    80000176:	77c6                	ld	a5,112(sp)
    80000178:	7866                	ld	a6,120(sp)
    8000017a:	688a                	ld	a7,128(sp)
    8000017c:	692a                	ld	s2,136(sp)
    8000017e:	69ca                	ld	s3,144(sp)
    80000180:	6a6a                	ld	s4,152(sp)
    80000182:	7a8a                	ld	s5,160(sp)
    80000184:	7b2a                	ld	s6,168(sp)
    80000186:	7bca                	ld	s7,176(sp)
    80000188:	7c6a                	ld	s8,184(sp)
    8000018a:	6c8e                	ld	s9,192(sp)
    8000018c:	6d2e                	ld	s10,200(sp)
    8000018e:	6dce                	ld	s11,208(sp)
    80000190:	6e6e                	ld	t3,216(sp)
    80000192:	7e8e                	ld	t4,224(sp)
    80000194:	7f2e                	ld	t5,232(sp)
    80000196:	7fce                	ld	t6,240(sp)
    80000198:	6111                	addi	sp,sp,256
    8000019a:	10200073          	sret

000000008000019e <cpuid>:
#include "include/cpu.h"
#include "include/riscv.h"

struct cpu cpus[NCPU];

int cpuid(){
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
}

static inline uint64 r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    800001a4:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    800001a6:	2501                	sext.w	a0,a0
    800001a8:	6422                	ld	s0,8(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret

00000000800001ae <mycpu>:

struct cpu * mycpu(){
    800001ae:	1141                	addi	sp,sp,-16
    800001b0:	e422                	sd	s0,8(sp)
    800001b2:	0800                	addi	s0,sp,16
    800001b4:	8792                	mv	a5,tp
    int id = r_tp();
    struct cpu *c = &cpus[id];
    800001b6:	2781                	sext.w	a5,a5
    800001b8:	078e                	slli	a5,a5,0x3
    return c;
    800001ba:	0000a517          	auipc	a0,0xa
    800001be:	67650513          	addi	a0,a0,1654 # 8000a830 <cpus>
    800001c2:	953e                	add	a0,a0,a5
    800001c4:	6422                	ld	s0,8(sp)
    800001c6:	0141                	addi	sp,sp,16
    800001c8:	8082                	ret

00000000800001ca <initlock>:
#include "include/riscv.h"

void push_off();
void pop_off();

void initlock(struct spinlock * lk, char * name){
    800001ca:	1141                	addi	sp,sp,-16
    800001cc:	e422                	sd	s0,8(sp)
    800001ce:	0800                	addi	s0,sp,16
    lk->locked = 0;
    800001d0:	00052023          	sw	zero,0(a0)
    lk->name = name;
    800001d4:	e50c                	sd	a1,8(a0)
    lk->cpu = 0;
    800001d6:	00053823          	sd	zero,16(a0)
}
    800001da:	6422                	ld	s0,8(sp)
    800001dc:	0141                	addi	sp,sp,16
    800001de:	8082                	ret

00000000800001e0 <push_off>:
  __sync_synchronize();
  __sync_lock_release(&lk->locked);
  pop_off();
}

void push_off(){
    800001e0:	1101                	addi	sp,sp,-32
    800001e2:	ec06                	sd	ra,24(sp)
    800001e4:	e822                	sd	s0,16(sp)
    800001e6:	e426                	sd	s1,8(sp)
    800001e8:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus":"=r"(x));
    800001ea:	100024f3          	csrr	s1,sstatus
    800001ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

static inline void intr_off()
{
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800001f2:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0"::"r"(x));
    800001f4:	10079073          	csrw	sstatus,a5
    int old  = intr_get();
    intr_off();
    struct cpu *c = mycpu();
    800001f8:	00000097          	auipc	ra,0x0
    800001fc:	fb6080e7          	jalr	-74(ra) # 800001ae <mycpu>
    if(c->pushoff_num == 0){
    80000200:	411c                	lw	a5,0(a0)
    80000202:	e781                	bnez	a5,8000020a <push_off+0x2a>
}

static inline int intr_get()
{
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
    80000204:	8085                	srli	s1,s1,0x1
    80000206:	8885                	andi	s1,s1,1
        c->pushoff_num = old;
    80000208:	c104                	sw	s1,0(a0)
    }
    c->pushoff_num++;
    8000020a:	411c                	lw	a5,0(a0)
    8000020c:	2785                	addiw	a5,a5,1
    8000020e:	c11c                	sw	a5,0(a0)
}
    80000210:	60e2                	ld	ra,24(sp)
    80000212:	6442                	ld	s0,16(sp)
    80000214:	64a2                	ld	s1,8(sp)
    80000216:	6105                	addi	sp,sp,32
    80000218:	8082                	ret

000000008000021a <acquire>:
{
    8000021a:	1101                	addi	sp,sp,-32
    8000021c:	ec06                	sd	ra,24(sp)
    8000021e:	e822                	sd	s0,16(sp)
    80000220:	e426                	sd	s1,8(sp)
    80000222:	1000                	addi	s0,sp,32
    80000224:	84aa                	mv	s1,a0
  push_off();
    80000226:	00000097          	auipc	ra,0x0
    8000022a:	fba080e7          	jalr	-70(ra) # 800001e0 <push_off>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0);
    8000022e:	4705                	li	a4,1
    80000230:	87ba                	mv	a5,a4
    80000232:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000236:	2781                	sext.w	a5,a5
    80000238:	ffe5                	bnez	a5,80000230 <acquire+0x16>
  __sync_synchronize();
    8000023a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000023e:	00000097          	auipc	ra,0x0
    80000242:	f70080e7          	jalr	-144(ra) # 800001ae <mycpu>
    80000246:	e888                	sd	a0,16(s1)
}
    80000248:	60e2                	ld	ra,24(sp)
    8000024a:	6442                	ld	s0,16(sp)
    8000024c:	64a2                	ld	s1,8(sp)
    8000024e:	6105                	addi	sp,sp,32
    80000250:	8082                	ret

0000000080000252 <pop_off>:

void pop_off(void)
{
    80000252:	1141                	addi	sp,sp,-16
    80000254:	e406                	sd	ra,8(sp)
    80000256:	e022                	sd	s0,0(sp)
    80000258:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000025a:	00000097          	auipc	ra,0x0
    8000025e:	f54080e7          	jalr	-172(ra) # 800001ae <mycpu>
  c->pushoff_num -= 1;
    80000262:	411c                	lw	a5,0(a0)
    80000264:	37fd                	addiw	a5,a5,-1
    80000266:	0007871b          	sext.w	a4,a5
    8000026a:	c11c                	sw	a5,0(a0)
  if(c->pushoff_num == 0 && c->intr_enabled)
    8000026c:	eb09                	bnez	a4,8000027e <pop_off+0x2c>
    8000026e:	415c                	lw	a5,4(a0)
    80000270:	c799                	beqz	a5,8000027e <pop_off+0x2c>
    asm volatile("csrr %0, sstatus":"=r"(x));
    80000272:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000276:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0"::"r"(x));
    8000027a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000027e:	60a2                	ld	ra,8(sp)
    80000280:	6402                	ld	s0,0(sp)
    80000282:	0141                	addi	sp,sp,16
    80000284:	8082                	ret

0000000080000286 <release>:
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e406                	sd	ra,8(sp)
    8000028a:	e022                	sd	s0,0(sp)
    8000028c:	0800                	addi	s0,sp,16
  lk->cpu = 0;
    8000028e:	00053823          	sd	zero,16(a0)
  __sync_synchronize();
    80000292:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000296:	0f50000f          	fence	iorw,ow
    8000029a:	0805202f          	amoswap.w	zero,zero,(a0)
  pop_off();
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	fb4080e7          	jalr	-76(ra) # 80000252 <pop_off>
}
    800002a6:	60a2                	ld	ra,8(sp)
    800002a8:	6402                	ld	s0,0(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret

00000000800002ae <memset>:
#include "include/types.h"

void* memset(void *dst, int c, uint n)
{
    800002ae:	1141                	addi	sp,sp,-16
    800002b0:	e422                	sd	s0,8(sp)
    800002b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002b4:	ca19                	beqz	a2,800002ca <memset+0x1c>
    800002b6:	87aa                	mv	a5,a0
    800002b8:	1602                	slli	a2,a2,0x20
    800002ba:	9201                	srli	a2,a2,0x20
    800002bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002c0:	00b78023          	sb	a1,0(a5) # 10000 <_entry-0x7fff0000>
  for(i = 0; i < n; i++){
    800002c4:	0785                	addi	a5,a5,1
    800002c6:	fee79de3          	bne	a5,a4,800002c0 <memset+0x12>
  }
  return dst;
}
    800002ca:	6422                	ld	s0,8(sp)
    800002cc:	0141                	addi	sp,sp,16
    800002ce:	8082                	ret

00000000800002d0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002d6:	ca05                	beqz	a2,80000306 <memcmp+0x36>
    800002d8:	fff6069b          	addiw	a3,a2,-1
    800002dc:	1682                	slli	a3,a3,0x20
    800002de:	9281                	srli	a3,a3,0x20
    800002e0:	0685                	addi	a3,a3,1
    800002e2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002e4:	00054783          	lbu	a5,0(a0)
    800002e8:	0005c703          	lbu	a4,0(a1) # 1000 <_entry-0x7ffff000>
    800002ec:	00e79863          	bne	a5,a4,800002fc <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002f0:	0505                	addi	a0,a0,1
    800002f2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002f4:	fed518e3          	bne	a0,a3,800002e4 <memcmp+0x14>
  }

  return 0;
    800002f8:	4501                	li	a0,0
    800002fa:	a019                	j	80000300 <memcmp+0x30>
      return *s1 - *s2;
    800002fc:	40e7853b          	subw	a0,a5,a4
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	addi	sp,sp,16
    80000304:	8082                	ret
  return 0;
    80000306:	4501                	li	a0,0
    80000308:	bfe5                	j	80000300 <memcmp+0x30>

000000008000030a <memmove>:

void* memmove(void *dst, const void *src, uint n)
{
    8000030a:	1141                	addi	sp,sp,-16
    8000030c:	e422                	sd	s0,8(sp)
    8000030e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000310:	02a5e563          	bltu	a1,a0,8000033a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000314:	fff6069b          	addiw	a3,a2,-1
    80000318:	ce11                	beqz	a2,80000334 <memmove+0x2a>
    8000031a:	1682                	slli	a3,a3,0x20
    8000031c:	9281                	srli	a3,a3,0x20
    8000031e:	0685                	addi	a3,a3,1
    80000320:	96ae                	add	a3,a3,a1
    80000322:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000324:	0585                	addi	a1,a1,1
    80000326:	0785                	addi	a5,a5,1
    80000328:	fff5c703          	lbu	a4,-1(a1)
    8000032c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000330:	fed59ae3          	bne	a1,a3,80000324 <memmove+0x1a>

  return dst;
}
    80000334:	6422                	ld	s0,8(sp)
    80000336:	0141                	addi	sp,sp,16
    80000338:	8082                	ret
  if(s < d && s + n > d){
    8000033a:	02061713          	slli	a4,a2,0x20
    8000033e:	9301                	srli	a4,a4,0x20
    80000340:	00e587b3          	add	a5,a1,a4
    80000344:	fcf578e3          	bgeu	a0,a5,80000314 <memmove+0xa>
    d += n;
    80000348:	972a                	add	a4,a4,a0
    while(n-- > 0)
    8000034a:	fff6069b          	addiw	a3,a2,-1
    8000034e:	d27d                	beqz	a2,80000334 <memmove+0x2a>
    80000350:	02069613          	slli	a2,a3,0x20
    80000354:	9201                	srli	a2,a2,0x20
    80000356:	fff64613          	not	a2,a2
    8000035a:	963e                	add	a2,a2,a5
      *--d = *--s;
    8000035c:	17fd                	addi	a5,a5,-1
    8000035e:	177d                	addi	a4,a4,-1
    80000360:	0007c683          	lbu	a3,0(a5)
    80000364:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000368:	fef61ae3          	bne	a2,a5,8000035c <memmove+0x52>
    8000036c:	b7e1                	j	80000334 <memmove+0x2a>

000000008000036e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n)
{
    8000036e:	1141                	addi	sp,sp,-16
    80000370:	e406                	sd	ra,8(sp)
    80000372:	e022                	sd	s0,0(sp)
    80000374:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000376:	00000097          	auipc	ra,0x0
    8000037a:	f94080e7          	jalr	-108(ra) # 8000030a <memmove>
}
    8000037e:	60a2                	ld	ra,8(sp)
    80000380:	6402                	ld	s0,0(sp)
    80000382:	0141                	addi	sp,sp,16
    80000384:	8082                	ret

0000000080000386 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    80000386:	1141                	addi	sp,sp,-16
    80000388:	e422                	sd	s0,8(sp)
    8000038a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000038c:	ce11                	beqz	a2,800003a8 <strncmp+0x22>
    8000038e:	00054783          	lbu	a5,0(a0)
    80000392:	cf89                	beqz	a5,800003ac <strncmp+0x26>
    80000394:	0005c703          	lbu	a4,0(a1)
    80000398:	00f71a63          	bne	a4,a5,800003ac <strncmp+0x26>
    n--, p++, q++;
    8000039c:	367d                	addiw	a2,a2,-1
    8000039e:	0505                	addi	a0,a0,1
    800003a0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003a2:	f675                	bnez	a2,8000038e <strncmp+0x8>
  if(n == 0)
    return 0;
    800003a4:	4501                	li	a0,0
    800003a6:	a809                	j	800003b8 <strncmp+0x32>
    800003a8:	4501                	li	a0,0
    800003aa:	a039                	j	800003b8 <strncmp+0x32>
  if(n == 0)
    800003ac:	ca09                	beqz	a2,800003be <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003ae:	00054503          	lbu	a0,0(a0)
    800003b2:	0005c783          	lbu	a5,0(a1)
    800003b6:	9d1d                	subw	a0,a0,a5
}
    800003b8:	6422                	ld	s0,8(sp)
    800003ba:	0141                	addi	sp,sp,16
    800003bc:	8082                	ret
    return 0;
    800003be:	4501                	li	a0,0
    800003c0:	bfe5                	j	800003b8 <strncmp+0x32>

00000000800003c2 <strncpy>:

char* strncpy(char *s, const char *t, int n)
{
    800003c2:	1141                	addi	sp,sp,-16
    800003c4:	e422                	sd	s0,8(sp)
    800003c6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003c8:	872a                	mv	a4,a0
    800003ca:	8832                	mv	a6,a2
    800003cc:	367d                	addiw	a2,a2,-1
    800003ce:	01005963          	blez	a6,800003e0 <strncpy+0x1e>
    800003d2:	0705                	addi	a4,a4,1
    800003d4:	0005c783          	lbu	a5,0(a1)
    800003d8:	fef70fa3          	sb	a5,-1(a4)
    800003dc:	0585                	addi	a1,a1,1
    800003de:	f7f5                	bnez	a5,800003ca <strncpy+0x8>
    ;
  while(n-- > 0)
    800003e0:	86ba                	mv	a3,a4
    800003e2:	00c05c63          	blez	a2,800003fa <strncpy+0x38>
    *s++ = 0;
    800003e6:	0685                	addi	a3,a3,1
    800003e8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003ec:	fff6c793          	not	a5,a3
    800003f0:	9fb9                	addw	a5,a5,a4
    800003f2:	010787bb          	addw	a5,a5,a6
    800003f6:	fef048e3          	bgtz	a5,800003e6 <strncpy+0x24>
  return os;
}
    800003fa:	6422                	ld	s0,8(sp)
    800003fc:	0141                	addi	sp,sp,16
    800003fe:	8082                	ret

0000000080000400 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n)
{
    80000400:	1141                	addi	sp,sp,-16
    80000402:	e422                	sd	s0,8(sp)
    80000404:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000406:	02c05363          	blez	a2,8000042c <safestrcpy+0x2c>
    8000040a:	fff6069b          	addiw	a3,a2,-1
    8000040e:	1682                	slli	a3,a3,0x20
    80000410:	9281                	srli	a3,a3,0x20
    80000412:	96ae                	add	a3,a3,a1
    80000414:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000416:	00d58963          	beq	a1,a3,80000428 <safestrcpy+0x28>
    8000041a:	0585                	addi	a1,a1,1
    8000041c:	0785                	addi	a5,a5,1
    8000041e:	fff5c703          	lbu	a4,-1(a1)
    80000422:	fee78fa3          	sb	a4,-1(a5)
    80000426:	fb65                	bnez	a4,80000416 <safestrcpy+0x16>
    ;
  *s = 0;
    80000428:	00078023          	sb	zero,0(a5)
  return os;
}
    8000042c:	6422                	ld	s0,8(sp)
    8000042e:	0141                	addi	sp,sp,16
    80000430:	8082                	ret

0000000080000432 <strlen>:

int strlen(const char *s)
{
    80000432:	1141                	addi	sp,sp,-16
    80000434:	e422                	sd	s0,8(sp)
    80000436:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000438:	00054783          	lbu	a5,0(a0)
    8000043c:	cf91                	beqz	a5,80000458 <strlen+0x26>
    8000043e:	0505                	addi	a0,a0,1
    80000440:	87aa                	mv	a5,a0
    80000442:	4685                	li	a3,1
    80000444:	9e89                	subw	a3,a3,a0
    80000446:	00f6853b          	addw	a0,a3,a5
    8000044a:	0785                	addi	a5,a5,1
    8000044c:	fff7c703          	lbu	a4,-1(a5)
    80000450:	fb7d                	bnez	a4,80000446 <strlen+0x14>
    ;
  return n;
}
    80000452:	6422                	ld	s0,8(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret
  for(n = 0; s[n]; n++)
    80000458:	4501                	li	a0,0
    8000045a:	bfe5                	j	80000452 <strlen+0x20>

000000008000045c <kfree>:
  initlock(&kmemory.lock, "kmemory");
  freerange(end, (void*)PHYSTOP);
}

void kfree(void *pa)
{
    8000045c:	1101                	addi	sp,sp,-32
    8000045e:	ec06                	sd	ra,24(sp)
    80000460:	e822                	sd	s0,16(sp)
    80000462:	e426                	sd	s1,8(sp)
    80000464:	e04a                	sd	s2,0(sp)
    80000466:	1000                	addi	s0,sp,32
    80000468:	892a                	mv	s2,a0
  struct run *r;

  memset(pa, 1, PGSIZE);
    8000046a:	6605                	lui	a2,0x1
    8000046c:	4585                	li	a1,1
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	e40080e7          	jalr	-448(ra) # 800002ae <memset>

  r = (struct run*)pa;

  acquire(&kmemory.lock);
    80000476:	0000a497          	auipc	s1,0xa
    8000047a:	3fa48493          	addi	s1,s1,1018 # 8000a870 <kmemory>
    8000047e:	8526                	mv	a0,s1
    80000480:	00000097          	auipc	ra,0x0
    80000484:	d9a080e7          	jalr	-614(ra) # 8000021a <acquire>
  r->next = kmemory.freelist;
    80000488:	6c9c                	ld	a5,24(s1)
    8000048a:	00f93023          	sd	a5,0(s2)
  kmemory.freelist = r;
    8000048e:	0124bc23          	sd	s2,24(s1)
  release(&kmemory.lock);
    80000492:	8526                	mv	a0,s1
    80000494:	00000097          	auipc	ra,0x0
    80000498:	df2080e7          	jalr	-526(ra) # 80000286 <release>
}
    8000049c:	60e2                	ld	ra,24(sp)
    8000049e:	6442                	ld	s0,16(sp)
    800004a0:	64a2                	ld	s1,8(sp)
    800004a2:	6902                	ld	s2,0(sp)
    800004a4:	6105                	addi	sp,sp,32
    800004a6:	8082                	ret

00000000800004a8 <freerange>:
{
    800004a8:	7179                	addi	sp,sp,-48
    800004aa:	f406                	sd	ra,40(sp)
    800004ac:	f022                	sd	s0,32(sp)
    800004ae:	ec26                	sd	s1,24(sp)
    800004b0:	e84a                	sd	s2,16(sp)
    800004b2:	e44e                	sd	s3,8(sp)
    800004b4:	e052                	sd	s4,0(sp)
    800004b6:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800004b8:	6785                	lui	a5,0x1
    800004ba:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800004be:	94aa                	add	s1,s1,a0
    800004c0:	757d                	lui	a0,0xfffff
    800004c2:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800004c4:	94be                	add	s1,s1,a5
    800004c6:	0095ee63          	bltu	a1,s1,800004e2 <freerange+0x3a>
    800004ca:	892e                	mv	s2,a1
    kfree(p);
    800004cc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800004ce:	6985                	lui	s3,0x1
    kfree(p);
    800004d0:	01448533          	add	a0,s1,s4
    800004d4:	00000097          	auipc	ra,0x0
    800004d8:	f88080e7          	jalr	-120(ra) # 8000045c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800004dc:	94ce                	add	s1,s1,s3
    800004de:	fe9979e3          	bgeu	s2,s1,800004d0 <freerange+0x28>
}
    800004e2:	70a2                	ld	ra,40(sp)
    800004e4:	7402                	ld	s0,32(sp)
    800004e6:	64e2                	ld	s1,24(sp)
    800004e8:	6942                	ld	s2,16(sp)
    800004ea:	69a2                	ld	s3,8(sp)
    800004ec:	6a02                	ld	s4,0(sp)
    800004ee:	6145                	addi	sp,sp,48
    800004f0:	8082                	ret

00000000800004f2 <kinit>:
{
    800004f2:	1141                	addi	sp,sp,-16
    800004f4:	e406                	sd	ra,8(sp)
    800004f6:	e022                	sd	s0,0(sp)
    800004f8:	0800                	addi	s0,sp,16
  initlock(&kmemory.lock, "kmemory");
    800004fa:	00002597          	auipc	a1,0x2
    800004fe:	b0658593          	addi	a1,a1,-1274 # 80002000 <userret+0xf70>
    80000502:	0000a517          	auipc	a0,0xa
    80000506:	36e50513          	addi	a0,a0,878 # 8000a870 <kmemory>
    8000050a:	00000097          	auipc	ra,0x0
    8000050e:	cc0080e7          	jalr	-832(ra) # 800001ca <initlock>
  freerange(end, (void*)PHYSTOP);
    80000512:	45c5                	li	a1,17
    80000514:	05ee                	slli	a1,a1,0x1b
    80000516:	0000a517          	auipc	a0,0xa
    8000051a:	39250513          	addi	a0,a0,914 # 8000a8a8 <end>
    8000051e:	00000097          	auipc	ra,0x0
    80000522:	f8a080e7          	jalr	-118(ra) # 800004a8 <freerange>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	addi	sp,sp,16
    8000052c:	8082                	ret

000000008000052e <kalloc>:

void * kalloc()
{
    8000052e:	1101                	addi	sp,sp,-32
    80000530:	ec06                	sd	ra,24(sp)
    80000532:	e822                	sd	s0,16(sp)
    80000534:	e426                	sd	s1,8(sp)
    80000536:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmemory.lock);
    80000538:	0000a497          	auipc	s1,0xa
    8000053c:	33848493          	addi	s1,s1,824 # 8000a870 <kmemory>
    80000540:	8526                	mv	a0,s1
    80000542:	00000097          	auipc	ra,0x0
    80000546:	cd8080e7          	jalr	-808(ra) # 8000021a <acquire>
  r = kmemory.freelist;
    8000054a:	6c84                	ld	s1,24(s1)
  if(r)
    8000054c:	c885                	beqz	s1,8000057c <kalloc+0x4e>
    kmemory.freelist = r->next;
    8000054e:	609c                	ld	a5,0(s1)
    80000550:	0000a517          	auipc	a0,0xa
    80000554:	32050513          	addi	a0,a0,800 # 8000a870 <kmemory>
    80000558:	ed1c                	sd	a5,24(a0)
  release(&kmemory.lock);
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	d2c080e7          	jalr	-724(ra) # 80000286 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000562:	6605                	lui	a2,0x1
    80000564:	4595                	li	a1,5
    80000566:	8526                	mv	a0,s1
    80000568:	00000097          	auipc	ra,0x0
    8000056c:	d46080e7          	jalr	-698(ra) # 800002ae <memset>
  return (void*)r;
    80000570:	8526                	mv	a0,s1
    80000572:	60e2                	ld	ra,24(sp)
    80000574:	6442                	ld	s0,16(sp)
    80000576:	64a2                	ld	s1,8(sp)
    80000578:	6105                	addi	sp,sp,32
    8000057a:	8082                	ret
  release(&kmemory.lock);
    8000057c:	0000a517          	auipc	a0,0xa
    80000580:	2f450513          	addi	a0,a0,756 # 8000a870 <kmemory>
    80000584:	00000097          	auipc	ra,0x0
    80000588:	d02080e7          	jalr	-766(ra) # 80000286 <release>
  if(r)
    8000058c:	b7d5                	j	80000570 <kalloc+0x42>

000000008000058e <main>:
#include "include/vm.h"
#include "include/trap.h"

static int started = 0;

void main(){
    8000058e:	1141                	addi	sp,sp,-16
    80000590:	e406                	sd	ra,8(sp)
    80000592:	e022                	sd	s0,0(sp)
    80000594:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	c08080e7          	jalr	-1016(ra) # 8000019e <cpuid>
    8000059e:	cd01                	beqz	a0,800005b6 <main+0x28>
        // kvminithart();
        // trapinit();
        // trapinithart();
        started = 1;
    }else{
        while(started == 0);
    800005a0:	00002797          	auipc	a5,0x2
    800005a4:	a707a783          	lw	a5,-1424(a5) # 80002010 <started>
    800005a8:	c381                	beqz	a5,800005a8 <main+0x1a>
        __sync_synchronize();
    800005aa:	0ff0000f          	fence
    }
    800005ae:	60a2                	ld	ra,8(sp)
    800005b0:	6402                	ld	s0,0(sp)
    800005b2:	0141                	addi	sp,sp,16
    800005b4:	8082                	ret
        kinit();
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	f3c080e7          	jalr	-196(ra) # 800004f2 <kinit>
        started = 1;
    800005be:	4785                	li	a5,1
    800005c0:	00002717          	auipc	a4,0x2
    800005c4:	a4f72823          	sw	a5,-1456(a4) # 80002010 <started>
    800005c8:	b7dd                	j	800005ae <main+0x20>

00000000800005ca <kvminit>:

extern char etext[];

extern char trampoline[];

void kvminit(){
    800005ca:	1141                	addi	sp,sp,-16
    800005cc:	e406                	sd	ra,8(sp)
    800005ce:	e022                	sd	s0,0(sp)
    800005d0:	0800                	addi	s0,sp,16
    // 分配页表页
    kernel_pagetable = (pagetable_t) kalloc();
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	f5c080e7          	jalr	-164(ra) # 8000052e <kalloc>
    800005da:	00002797          	auipc	a5,0x2
    800005de:	a2a7bf23          	sd	a0,-1474(a5) # 80002018 <kernel_pagetable>
    memset(kernel_pagetable, 0 , PGSIZE);
    800005e2:	6605                	lui	a2,0x1
    800005e4:	4581                	li	a1,0
    800005e6:	00000097          	auipc	ra,0x0
    800005ea:	cc8080e7          	jalr	-824(ra) # 800002ae <memset>
    

}
    800005ee:	60a2                	ld	ra,8(sp)
    800005f0:	6402                	ld	s0,0(sp)
    800005f2:	0141                	addi	sp,sp,16
    800005f4:	8082                	ret

00000000800005f6 <kvminithart>:

void kvminithart(){
    800005f6:	1141                	addi	sp,sp,-16
    800005f8:	e422                	sd	s0,8(sp)
    800005fa:	0800                	addi	s0,sp,16
    // 设置页表
    w_satp(MAKE_SATP(kernel_pagetable));
    800005fc:	00002797          	auipc	a5,0x2
    80000600:	a1c7b783          	ld	a5,-1508(a5) # 80002018 <kernel_pagetable>
    80000604:	83b1                	srli	a5,a5,0xc
    80000606:	577d                	li	a4,-1
    80000608:	177e                	slli	a4,a4,0x3f
    8000060a:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0"::"r"(x));
    8000060c:	18079073          	csrw	satp,a5
typedef uint64 pte_t;
typedef uint64 *pagetable_t; // 512 PTEs

static inline void sfence_vma()
{
  asm volatile("sfence.vma zero, zero");
    80000610:	12000073          	sfence.vma
    // 刷新页表缓存
    sfence_vma();
}
    80000614:	6422                	ld	s0,8(sp)
    80000616:	0141                	addi	sp,sp,16
    80000618:	8082                	ret

000000008000061a <walk>:

// 根据虚拟地址遍历页表
// alloc != 0 时 分配页表
pte_t * walk(pagetable_t pagetable, uint64 va, int alloc){
    8000061a:	7139                	addi	sp,sp,-64
    8000061c:	fc06                	sd	ra,56(sp)
    8000061e:	f822                	sd	s0,48(sp)
    80000620:	f426                	sd	s1,40(sp)
    80000622:	f04a                	sd	s2,32(sp)
    80000624:	ec4e                	sd	s3,24(sp)
    80000626:	e852                	sd	s4,16(sp)
    80000628:	e456                	sd	s5,8(sp)
    8000062a:	e05a                	sd	s6,0(sp)
    8000062c:	0080                	addi	s0,sp,64
    8000062e:	84aa                	mv	s1,a0
    80000630:	89ae                	mv	s3,a1
    80000632:	8ab2                	mv	s5,a2
    80000634:	4a79                	li	s4,30
    // 先求二级页表 页表项
    // 再求一级页表 页表项
    for(int level = 2; level > 0; level--){
    80000636:	4b31                	li	s6,12
    80000638:	a80d                	j	8000066a <walk+0x50>
        if(*pte & PTE_V){
            // 页表项求下一级页表
            pagetable = (pagetable_t)PTE2PA(*pte);
        }else{
            // 页表项不存在，分配页表
            if(!alloc || (pagetable = (pde_t *)kalloc()) == 0){
    8000063a:	060a8663          	beqz	s5,800006a6 <walk+0x8c>
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	ef0080e7          	jalr	-272(ra) # 8000052e <kalloc>
    80000646:	84aa                	mv	s1,a0
    80000648:	c529                	beqz	a0,80000692 <walk+0x78>
                return 0;
            }
            memset(pagetable, 0, PGSIZE);
    8000064a:	6605                	lui	a2,0x1
    8000064c:	4581                	li	a1,0
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c60080e7          	jalr	-928(ra) # 800002ae <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    80000656:	00c4d793          	srli	a5,s1,0xc
    8000065a:	07aa                	slli	a5,a5,0xa
    8000065c:	0017e793          	ori	a5,a5,1
    80000660:	00f93023          	sd	a5,0(s2)
    for(int level = 2; level > 0; level--){
    80000664:	3a5d                	addiw	s4,s4,-9
    80000666:	036a0063          	beq	s4,s6,80000686 <walk+0x6c>
        pte_t * pte = &pagetable[PX(level, va)];
    8000066a:	0149d933          	srl	s2,s3,s4
    8000066e:	1ff97913          	andi	s2,s2,511
    80000672:	090e                	slli	s2,s2,0x3
    80000674:	9926                	add	s2,s2,s1
        if(*pte & PTE_V){
    80000676:	00093483          	ld	s1,0(s2)
    8000067a:	0014f793          	andi	a5,s1,1
    8000067e:	dfd5                	beqz	a5,8000063a <walk+0x20>
            pagetable = (pagetable_t)PTE2PA(*pte);
    80000680:	80a9                	srli	s1,s1,0xa
    80000682:	04b2                	slli	s1,s1,0xc
    80000684:	b7c5                	j	80000664 <walk+0x4a>
        }
    }
    // 返回0级页表项
    return &pagetable[PX(0,va)];
    80000686:	00c9d513          	srli	a0,s3,0xc
    8000068a:	1ff57513          	andi	a0,a0,511
    8000068e:	050e                	slli	a0,a0,0x3
    80000690:	9526                	add	a0,a0,s1
}
    80000692:	70e2                	ld	ra,56(sp)
    80000694:	7442                	ld	s0,48(sp)
    80000696:	74a2                	ld	s1,40(sp)
    80000698:	7902                	ld	s2,32(sp)
    8000069a:	69e2                	ld	s3,24(sp)
    8000069c:	6a42                	ld	s4,16(sp)
    8000069e:	6aa2                	ld	s5,8(sp)
    800006a0:	6b02                	ld	s6,0(sp)
    800006a2:	6121                	addi	sp,sp,64
    800006a4:	8082                	ret
                return 0;
    800006a6:	4501                	li	a0,0
    800006a8:	b7ed                	j	80000692 <walk+0x78>

00000000800006aa <walkaddr>:

uint64 walkaddr(pagetable_t pagetable, uint64 va){
    800006aa:	1141                	addi	sp,sp,-16
    800006ac:	e406                	sd	ra,8(sp)
    800006ae:	e022                	sd	s0,0(sp)
    800006b0:	0800                	addi	s0,sp,16
    pte_t * pte;
    uint64 pa;

    pte = walk(pagetable, va, 0);
    800006b2:	4601                	li	a2,0
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f66080e7          	jalr	-154(ra) # 8000061a <walk>
    pa = PTE2PA(*pte);
    800006bc:	6108                	ld	a0,0(a0)
    800006be:	8129                	srli	a0,a0,0xa
    return pa;
}
    800006c0:	0532                	slli	a0,a0,0xc
    800006c2:	60a2                	ld	ra,8(sp)
    800006c4:	6402                	ld	s0,0(sp)
    800006c6:	0141                	addi	sp,sp,16
    800006c8:	8082                	ret

00000000800006ca <kvmpa>:

uint64 kvmpa(uint64 va){
    800006ca:	1101                	addi	sp,sp,-32
    800006cc:	ec06                	sd	ra,24(sp)
    800006ce:	e822                	sd	s0,16(sp)
    800006d0:	e426                	sd	s1,8(sp)
    800006d2:	1000                	addi	s0,sp,32
    800006d4:	84aa                	mv	s1,a0
    uint64 offset = va % PGSIZE;
    pte_t *pte;
    uint64 pa;

    pte = walk(kernel_pagetable, va, 0);
    800006d6:	4601                	li	a2,0
    800006d8:	85aa                	mv	a1,a0
    800006da:	00002517          	auipc	a0,0x2
    800006de:	93e53503          	ld	a0,-1730(a0) # 80002018 <kernel_pagetable>
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f38080e7          	jalr	-200(ra) # 8000061a <walk>
    pa = PTE2PA(*pte);
    800006ea:	6108                	ld	a0,0(a0)
    800006ec:	8129                	srli	a0,a0,0xa
    800006ee:	0532                	slli	a0,a0,0xc
    uint64 offset = va % PGSIZE;
    800006f0:	14d2                	slli	s1,s1,0x34
    800006f2:	90d1                	srli	s1,s1,0x34
    return pa + offset;
}
    800006f4:	9526                	add	a0,a0,s1
    800006f6:	60e2                	ld	ra,24(sp)
    800006f8:	6442                	ld	s0,16(sp)
    800006fa:	64a2                	ld	s1,8(sp)
    800006fc:	6105                	addi	sp,sp,32
    800006fe:	8082                	ret

0000000080000700 <mappages>:

int mappages(pagetable_t pagetable, uint64 va, uint64 pa, uint64 sz, int permision){
    80000700:	715d                	addi	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	fc26                	sd	s1,56(sp)
    80000708:	f84a                	sd	s2,48(sp)
    8000070a:	f44e                	sd	s3,40(sp)
    8000070c:	f052                	sd	s4,32(sp)
    8000070e:	ec56                	sd	s5,24(sp)
    80000710:	e85a                	sd	s6,16(sp)
    80000712:	e45e                	sd	s7,8(sp)
    80000714:	0880                	addi	s0,sp,80
    80000716:	8aaa                	mv	s5,a0
    80000718:	8b3a                	mv	s6,a4
    uint64 address, last;
    pte_t * pte;

    // 按PGSIZE对齐 
    // 首地址
    address = PGROUNDDOWN(va);
    8000071a:	777d                	lui	a4,0xfffff
    8000071c:	00e5f7b3          	and	a5,a1,a4
    // 最后一页地址
    last = PGROUNDDOWN(va + sz - 1);
    80000720:	16fd                	addi	a3,a3,-1
    80000722:	00b689b3          	add	s3,a3,a1
    80000726:	00e9f9b3          	and	s3,s3,a4
    address = PGROUNDDOWN(va);
    8000072a:	893e                	mv	s2,a5
    8000072c:	40f60a33          	sub	s4,a2,a5
        }
        *pte = PA2PTE(pa) | permision | PTE_V;
        if(address == last){
            break;
        }
        address += PGSIZE;
    80000730:	6b85                	lui	s7,0x1
    80000732:	a011                	j	80000736 <mappages+0x36>
    80000734:	995e                	add	s2,s2,s7
    while(1){
    80000736:	012a04b3          	add	s1,s4,s2
        if((pte = walk(pagetable, address, 1)) == 0){
    8000073a:	4605                	li	a2,1
    8000073c:	85ca                	mv	a1,s2
    8000073e:	8556                	mv	a0,s5
    80000740:	00000097          	auipc	ra,0x0
    80000744:	eda080e7          	jalr	-294(ra) # 8000061a <walk>
    80000748:	cd01                	beqz	a0,80000760 <mappages+0x60>
        *pte = PA2PTE(pa) | permision | PTE_V;
    8000074a:	80b1                	srli	s1,s1,0xc
    8000074c:	04aa                	slli	s1,s1,0xa
    8000074e:	0164e4b3          	or	s1,s1,s6
    80000752:	0014e493          	ori	s1,s1,1
    80000756:	e104                	sd	s1,0(a0)
        if(address == last){
    80000758:	fd391ee3          	bne	s2,s3,80000734 <mappages+0x34>
        pa += PGSIZE;
    }
    return 0;
    8000075c:	4501                	li	a0,0
    8000075e:	a011                	j	80000762 <mappages+0x62>
            return -1;
    80000760:	557d                	li	a0,-1
}
    80000762:	60a6                	ld	ra,72(sp)
    80000764:	6406                	ld	s0,64(sp)
    80000766:	74e2                	ld	s1,56(sp)
    80000768:	7942                	ld	s2,48(sp)
    8000076a:	79a2                	ld	s3,40(sp)
    8000076c:	7a02                	ld	s4,32(sp)
    8000076e:	6ae2                	ld	s5,24(sp)
    80000770:	6b42                	ld	s6,16(sp)
    80000772:	6ba2                	ld	s7,8(sp)
    80000774:	6161                	addi	sp,sp,80
    80000776:	8082                	ret

0000000080000778 <kvmmap>:

void kvmmap(uint64 va, uint64 pa, uint64 sz, int permision){
    80000778:	1141                	addi	sp,sp,-16
    8000077a:	e406                	sd	ra,8(sp)
    8000077c:	e022                	sd	s0,0(sp)
    8000077e:	0800                	addi	s0,sp,16
    80000780:	8736                	mv	a4,a3
    mappages(kernel_pagetable, va, pa, sz, permision);
    80000782:	86b2                	mv	a3,a2
    80000784:	862e                	mv	a2,a1
    80000786:	85aa                	mv	a1,a0
    80000788:	00002517          	auipc	a0,0x2
    8000078c:	89053503          	ld	a0,-1904(a0) # 80002018 <kernel_pagetable>
    80000790:	00000097          	auipc	ra,0x0
    80000794:	f70080e7          	jalr	-144(ra) # 80000700 <mappages>
    80000798:	60a2                	ld	ra,8(sp)
    8000079a:	6402                	ld	s0,0(sp)
    8000079c:	0141                	addi	sp,sp,16
    8000079e:	8082                	ret

00000000800007a0 <trapinit>:
struct spinlock tickslock;
uint ticks;

extern void kernelvec();

void trapinit(){
    800007a0:	1141                	addi	sp,sp,-16
    800007a2:	e406                	sd	ra,8(sp)
    800007a4:	e022                	sd	s0,0(sp)
    800007a6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "ticks");
    800007a8:	00002597          	auipc	a1,0x2
    800007ac:	86058593          	addi	a1,a1,-1952 # 80002008 <userret+0xf78>
    800007b0:	0000a517          	auipc	a0,0xa
    800007b4:	0e050513          	addi	a0,a0,224 # 8000a890 <tickslock>
    800007b8:	00000097          	auipc	ra,0x0
    800007bc:	a12080e7          	jalr	-1518(ra) # 800001ca <initlock>
}
    800007c0:	60a2                	ld	ra,8(sp)
    800007c2:	6402                	ld	s0,0(sp)
    800007c4:	0141                	addi	sp,sp,16
    800007c6:	8082                	ret

00000000800007c8 <trapinithart>:

void trapinithart(void)
{
    800007c8:	1141                	addi	sp,sp,-16
    800007ca:	e422                	sd	s0,8(sp)
    800007cc:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0"::"r"(x));
    800007ce:	00000797          	auipc	a5,0x0
    800007d2:	94a78793          	addi	a5,a5,-1718 # 80000118 <kernelvec>
    800007d6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800007da:	6422                	ld	s0,8(sp)
    800007dc:	0141                	addi	sp,sp,16
    800007de:	8082                	ret

00000000800007e0 <kerneltrap>:

void kerneltrap(){
    800007e0:	1141                	addi	sp,sp,-16
    800007e2:	e422                	sd	s0,8(sp)
    800007e4:	0800                	addi	s0,sp,16
    
}
    800007e6:	6422                	ld	s0,8(sp)
    800007e8:	0141                	addi	sp,sp,16
    800007ea:	8082                	ret
	...

0000000080001000 <_trampoline>:
    80001000:	14051573          	csrrw	a0,sscratch,a0
    80001004:	02153423          	sd	ra,40(a0)
    80001008:	02253823          	sd	sp,48(a0)
    8000100c:	02353c23          	sd	gp,56(a0)
    80001010:	04453023          	sd	tp,64(a0)
    80001014:	04553423          	sd	t0,72(a0)
    80001018:	04653823          	sd	t1,80(a0)
    8000101c:	04753c23          	sd	t2,88(a0)
    80001020:	f120                	sd	s0,96(a0)
    80001022:	f524                	sd	s1,104(a0)
    80001024:	fd2c                	sd	a1,120(a0)
    80001026:	e150                	sd	a2,128(a0)
    80001028:	e554                	sd	a3,136(a0)
    8000102a:	e958                	sd	a4,144(a0)
    8000102c:	ed5c                	sd	a5,152(a0)
    8000102e:	0b053023          	sd	a6,160(a0)
    80001032:	0b153423          	sd	a7,168(a0)
    80001036:	0b253823          	sd	s2,176(a0)
    8000103a:	0b353c23          	sd	s3,184(a0)
    8000103e:	0d453023          	sd	s4,192(a0)
    80001042:	0d553423          	sd	s5,200(a0)
    80001046:	0d653823          	sd	s6,208(a0)
    8000104a:	0d753c23          	sd	s7,216(a0)
    8000104e:	0f853023          	sd	s8,224(a0)
    80001052:	0f953423          	sd	s9,232(a0)
    80001056:	0fa53823          	sd	s10,240(a0)
    8000105a:	0fb53c23          	sd	s11,248(a0)
    8000105e:	11c53023          	sd	t3,256(a0)
    80001062:	11d53423          	sd	t4,264(a0)
    80001066:	11e53823          	sd	t5,272(a0)
    8000106a:	11f53c23          	sd	t6,280(a0)
    8000106e:	140022f3          	csrr	t0,sscratch
    80001072:	06553823          	sd	t0,112(a0)
    80001076:	00853103          	ld	sp,8(a0)
    8000107a:	02053203          	ld	tp,32(a0)
    8000107e:	01053283          	ld	t0,16(a0)
    80001082:	00053303          	ld	t1,0(a0)
    80001086:	18031073          	csrw	satp,t1
    8000108a:	12000073          	sfence.vma
    8000108e:	8282                	jr	t0

0000000080001090 <userret>:
    80001090:	18059073          	csrw	satp,a1
    80001094:	12000073          	sfence.vma
    80001098:	07053283          	ld	t0,112(a0)
    8000109c:	14029073          	csrw	sscratch,t0
    800010a0:	02853083          	ld	ra,40(a0)
    800010a4:	03053103          	ld	sp,48(a0)
    800010a8:	03853183          	ld	gp,56(a0)
    800010ac:	04053203          	ld	tp,64(a0)
    800010b0:	04853283          	ld	t0,72(a0)
    800010b4:	05053303          	ld	t1,80(a0)
    800010b8:	05853383          	ld	t2,88(a0)
    800010bc:	7120                	ld	s0,96(a0)
    800010be:	7524                	ld	s1,104(a0)
    800010c0:	7d2c                	ld	a1,120(a0)
    800010c2:	6150                	ld	a2,128(a0)
    800010c4:	6554                	ld	a3,136(a0)
    800010c6:	6958                	ld	a4,144(a0)
    800010c8:	6d5c                	ld	a5,152(a0)
    800010ca:	0a053803          	ld	a6,160(a0)
    800010ce:	0a853883          	ld	a7,168(a0)
    800010d2:	0b053903          	ld	s2,176(a0)
    800010d6:	0b853983          	ld	s3,184(a0)
    800010da:	0c053a03          	ld	s4,192(a0)
    800010de:	0c853a83          	ld	s5,200(a0)
    800010e2:	0d053b03          	ld	s6,208(a0)
    800010e6:	0d853b83          	ld	s7,216(a0)
    800010ea:	0e053c03          	ld	s8,224(a0)
    800010ee:	0e853c83          	ld	s9,232(a0)
    800010f2:	0f053d03          	ld	s10,240(a0)
    800010f6:	0f853d83          	ld	s11,248(a0)
    800010fa:	10053e03          	ld	t3,256(a0)
    800010fe:	10853e83          	ld	t4,264(a0)
    80001102:	11053f03          	ld	t5,272(a0)
    80001106:	11853f83          	ld	t6,280(a0)
    8000110a:	14051573          	csrrw	a0,sscratch,a0
    8000110e:	10200073          	sret
	...
