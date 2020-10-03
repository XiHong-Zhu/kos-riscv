
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00001117          	auipc	sp,0x1
    80000004:	01010113          	addi	sp,sp,16 # 80001010 <stack>
    80000008:	f1402573          	csrr	a0,mhartid
    8000000c:	6585                	lui	a1,0x1
    8000000e:	02b50533          	mul	a0,a0,a1
    80000012:	952e                	add	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	18a000ef          	jal	ra,800001a0 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <mhartid>:
#ifndef _RISCV_H

#define _RISCV_H

// hatr id
static inline uint64 mhartid(){
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec22                	sd	s0,24(sp)
    80000020:	1000                	addi	s0,sp,32
    uint64 x;
    asm volatile("csrr %0, mhartid":"=r"(x));
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	fef43423          	sd	a5,-24(s0)
    return x;
    8000002a:	fe843783          	ld	a5,-24(s0)
}
    8000002e:	853e                	mv	a0,a5
    80000030:	6462                	ld	s0,24(sp)
    80000032:	6105                	addi	sp,sp,32
    80000034:	8082                	ret

0000000080000036 <w_mstatus>:
#define MSTATUS_MPP_U    (0L << 11)     // User mode                        00

// mstatus.MIE  [3]
#define MSTATUS_MIE      (1L << 3)      //Machine mode interrupt enable    

static inline void w_mstatus(uint64 x){
    80000036:	1101                	addi	sp,sp,-32
    80000038:	ec22                	sd	s0,24(sp)
    8000003a:	1000                	addi	s0,sp,32
    8000003c:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw mstatus, %0"::"r"(x));
    80000040:	fe843783          	ld	a5,-24(s0)
    80000044:	30079073          	csrw	mstatus,a5
}
    80000048:	0001                	nop
    8000004a:	6462                	ld	s0,24(sp)
    8000004c:	6105                	addi	sp,sp,32
    8000004e:	8082                	ret

0000000080000050 <r_mstatus>:

static inline uint64 r_mstatus(){
    80000050:	1101                	addi	sp,sp,-32
    80000052:	ec22                	sd	s0,24(sp)
    80000054:	1000                	addi	s0,sp,32
    uint64 x;
    asm volatile("csrr %0, mstatus":"=r"(x));
    80000056:	300027f3          	csrr	a5,mstatus
    8000005a:	fef43423          	sd	a5,-24(s0)
    return x;
    8000005e:	fe843783          	ld	a5,-24(s0)
}
    80000062:	853e                	mv	a0,a5
    80000064:	6462                	ld	s0,24(sp)
    80000066:	6105                	addi	sp,sp,32
    80000068:	8082                	ret

000000008000006a <w_mepc>:
// Machine exception program counter
// 发生异常，指向异常指令地址
// 对于中断，指向指向中断处理后应该恢复执行的位置
// mret 指令 将 pc 设置为 mepc ，通过将mpie 设置到 mie 来恢复中断使能，
// 并将权限模式设置为mstatus.MPP
static inline void w_mepc(uint64 x){
    8000006a:	1101                	addi	sp,sp,-32
    8000006c:	ec22                	sd	s0,24(sp)
    8000006e:	1000                	addi	s0,sp,32
    80000070:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw mepc, %0"::"r"(x));
    80000074:	fe843783          	ld	a5,-24(s0)
    80000078:	34179073          	csrw	mepc,a5
}
    8000007c:	0001                	nop
    8000007e:	6462                	ld	s0,24(sp)
    80000080:	6105                	addi	sp,sp,32
    80000082:	8082                	ret

0000000080000084 <w_mie>:
// mie.MTIE [7]
#define MIE_MTIE         (1L << 7)      // Machine mode time interrupt enable
// mie.MSIE [3]
#define MIE_MSIE         (1L << 3)      // Machine mode software interrupt enable

static inline void w_mie(uint64 x){
    80000084:	1101                	addi	sp,sp,-32
    80000086:	ec22                	sd	s0,24(sp)
    80000088:	1000                	addi	s0,sp,32
    8000008a:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw mie, %0"::"r"(x));
    8000008e:	fe843783          	ld	a5,-24(s0)
    80000092:	30479073          	csrw	mie,a5
}
    80000096:	0001                	nop
    80000098:	6462                	ld	s0,24(sp)
    8000009a:	6105                	addi	sp,sp,32
    8000009c:	8082                	ret

000000008000009e <r_mie>:

static inline uint64 r_mie(){
    8000009e:	1101                	addi	sp,sp,-32
    800000a0:	ec22                	sd	s0,24(sp)
    800000a2:	1000                	addi	s0,sp,32
    uint64 x;
    asm volatile("csrr %0, mie":"=r"(x));
    800000a4:	304027f3          	csrr	a5,mie
    800000a8:	fef43423          	sd	a5,-24(s0)
    return x;
    800000ac:	fe843783          	ld	a5,-24(s0)
}
    800000b0:	853e                	mv	a0,a5
    800000b2:	6462                	ld	s0,24(sp)
    800000b4:	6105                	addi	sp,sp,32
    800000b6:	8082                	ret

00000000800000b8 <w_medeleg>:

// Machine Exception Delegation
// 控制将哪些异常委托给 S 模式
static inline void w_medeleg(uint64 x){
    800000b8:	1101                	addi	sp,sp,-32
    800000ba:	ec22                	sd	s0,24(sp)
    800000bc:	1000                	addi	s0,sp,32
    800000be:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw medeleg, %0"::"r"(x));
    800000c2:	fe843783          	ld	a5,-24(s0)
    800000c6:	30279073          	csrw	medeleg,a5
}
    800000ca:	0001                	nop
    800000cc:	6462                	ld	s0,24(sp)
    800000ce:	6105                	addi	sp,sp,32
    800000d0:	8082                	ret

00000000800000d2 <w_mideleg>:
    return x;
}

// Machine Interrupt Delegation
// 控制将哪些中断委托给 S 模式
static inline void w_mideleg(uint64 x){
    800000d2:	1101                	addi	sp,sp,-32
    800000d4:	ec22                	sd	s0,24(sp)
    800000d6:	1000                	addi	s0,sp,32
    800000d8:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw mideleg, %0"::"r"(x));
    800000dc:	fe843783          	ld	a5,-24(s0)
    800000e0:	30379073          	csrw	mideleg,a5
}
    800000e4:	0001                	nop
    800000e6:	6462                	ld	s0,24(sp)
    800000e8:	6105                	addi	sp,sp,32
    800000ea:	8082                	ret

00000000800000ec <w_mtvec>:

// Machine interrupt vector
// Machine mode中断处理程序地址
static inline void 
w_mtvec(uint64 x)
{
    800000ec:	1101                	addi	sp,sp,-32
    800000ee:	ec22                	sd	s0,24(sp)
    800000f0:	1000                	addi	s0,sp,32
    800000f2:	fea43423          	sd	a0,-24(s0)
  asm volatile("csrw mtvec, %0":: "r" (x));
    800000f6:	fe843783          	ld	a5,-24(s0)
    800000fa:	30579073          	csrw	mtvec,a5
}
    800000fe:	0001                	nop
    80000100:	6462                	ld	s0,24(sp)
    80000102:	6105                	addi	sp,sp,32
    80000104:	8082                	ret

0000000080000106 <w_sie>:
// Supervisor Interrupt Enable
#define SIE_SEIE        (1L << 9)   // sip.SEIE external interrupt enable
#define SIE_STIE        (1L << 5)   // sip.STIP timer interrupt enable
#define SIE_SSIE        (1L << 1)   // sip.SSIE software interrupt enable

static inline void w_sie(uint64 x){
    80000106:	1101                	addi	sp,sp,-32
    80000108:	ec22                	sd	s0,24(sp)
    8000010a:	1000                	addi	s0,sp,32
    8000010c:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw sie, %0"::"r"(x));
    80000110:	fe843783          	ld	a5,-24(s0)
    80000114:	10479073          	csrw	sie,a5
}
    80000118:	0001                	nop
    8000011a:	6462                	ld	s0,24(sp)
    8000011c:	6105                	addi	sp,sp,32
    8000011e:	8082                	ret

0000000080000120 <r_sie>:

static inline uint64 r_sie(){
    80000120:	1101                	addi	sp,sp,-32
    80000122:	ec22                	sd	s0,24(sp)
    80000124:	1000                	addi	s0,sp,32
    uint64 x;
    asm volatile("csrr %0, sie":"=r"(x));
    80000126:	104027f3          	csrr	a5,sie
    8000012a:	fef43423          	sd	a5,-24(s0)
    return x;
    8000012e:	fe843783          	ld	a5,-24(s0)
}
    80000132:	853e                	mv	a0,a5
    80000134:	6462                	ld	s0,24(sp)
    80000136:	6105                	addi	sp,sp,32
    80000138:	8082                	ret

000000008000013a <w_satp>:
  asm volatile("csrr %0, stval":"=r"(x));
  return x;
}

// Supervisor address translation and protection
static inline void w_satp(uint64 x){
    8000013a:	1101                	addi	sp,sp,-32
    8000013c:	ec22                	sd	s0,24(sp)
    8000013e:	1000                	addi	s0,sp,32
    80000140:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw satp, %0"::"r"(x));
    80000144:	fe843783          	ld	a5,-24(s0)
    80000148:	18079073          	csrw	satp,a5
}
    8000014c:	0001                	nop
    8000014e:	6462                	ld	s0,24(sp)
    80000150:	6105                	addi	sp,sp,32
    80000152:	8082                	ret

0000000080000154 <w_mscatch>:
    uint64 x;
    asm volatile("csrr %0, satp":"=r"(x));
    return x;
}

static inline void w_mscatch(uint64 x){
    80000154:	1101                	addi	sp,sp,-32
    80000156:	ec22                	sd	s0,24(sp)
    80000158:	1000                	addi	s0,sp,32
    8000015a:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw sscratch, %0"::"r"(x));
    8000015e:	fe843783          	ld	a5,-24(s0)
    80000162:	14079073          	csrw	sscratch,a5
}
    80000166:	0001                	nop
    80000168:	6462                	ld	s0,24(sp)
    8000016a:	6105                	addi	sp,sp,32
    8000016c:	8082                	ret

000000008000016e <r_mscratch>:

static inline uint64 r_mscratch(){
    8000016e:	1101                	addi	sp,sp,-32
    80000170:	ec22                	sd	s0,24(sp)
    80000172:	1000                	addi	s0,sp,32
    uint64 x;
    asm volatile("csrr %0, sscratch":"=r"(x));
    80000174:	140027f3          	csrr	a5,sscratch
    80000178:	fef43423          	sd	a5,-24(s0)
    return x;
    8000017c:	fe843783          	ld	a5,-24(s0)
}
    80000180:	853e                	mv	a0,a5
    80000182:	6462                	ld	s0,24(sp)
    80000184:	6105                	addi	sp,sp,32
    80000186:	8082                	ret

0000000080000188 <w_tp>:

static inline void w_tp(uint64 x)
{
    80000188:	1101                	addi	sp,sp,-32
    8000018a:	ec22                	sd	s0,24(sp)
    8000018c:	1000                	addi	s0,sp,32
    8000018e:	fea43423          	sd	a0,-24(s0)
  asm volatile("mv tp, %0" : : "r" (x));
    80000192:	fe843783          	ld	a5,-24(s0)
    80000196:	823e                	mv	tp,a5
}
    80000198:	0001                	nop
    8000019a:	6462                	ld	s0,24(sp)
    8000019c:	6105                	addi	sp,sp,32
    8000019e:	8082                	ret

00000000800001a0 <start>:
// 初始化时钟中断
void timerinit();
// machine timer interrupt handler
extern void timervec();

void start(){
    800001a0:	1101                	addi	sp,sp,-32
    800001a2:	ec06                	sd	ra,24(sp)
    800001a4:	e822                	sd	s0,16(sp)
    800001a6:	1000                	addi	s0,sp,32
    // 设置mstatus.MPP位域，最后执行mret指令，设置权限模式为S并跳转到mepc指向地址执行
    uint64 x = r_mstatus();
    800001a8:	00000097          	auipc	ra,0x0
    800001ac:	ea8080e7          	jalr	-344(ra) # 80000050 <r_mstatus>
    800001b0:	fea43423          	sd	a0,-24(s0)
    x &= ~MSTATUS_MPP_MASK;
    800001b4:	fe843703          	ld	a4,-24(s0)
    800001b8:	77f9                	lui	a5,0xffffe
    800001ba:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <end+0xffffffff7fff4f8b>
    800001be:	8ff9                	and	a5,a5,a4
    800001c0:	fef43423          	sd	a5,-24(s0)
    x |= MSTATUS_MPP_S;
    800001c4:	fe843703          	ld	a4,-24(s0)
    800001c8:	6785                	lui	a5,0x1
    800001ca:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    800001ce:	8fd9                	or	a5,a5,a4
    800001d0:	fef43423          	sd	a5,-24(s0)
    w_mstatus(x);
    800001d4:	fe843503          	ld	a0,-24(s0)
    800001d8:	00000097          	auipc	ra,0x0
    800001dc:	e5e080e7          	jalr	-418(ra) # 80000036 <w_mstatus>

    w_mepc((uint64)main);
    800001e0:	00001797          	auipc	a5,0x1
    800001e4:	93078793          	addi	a5,a5,-1744 # 80000b10 <main>
    800001e8:	853e                	mv	a0,a5
    800001ea:	00000097          	auipc	ra,0x0
    800001ee:	e80080e7          	jalr	-384(ra) # 8000006a <w_mepc>

    // 关分页
    w_satp(0);
    800001f2:	4501                	li	a0,0
    800001f4:	00000097          	auipc	ra,0x0
    800001f8:	f46080e7          	jalr	-186(ra) # 8000013a <w_satp>

    // 设置M模式异常 中断代理到S模式
    w_medeleg(0xffff);
    800001fc:	67c1                	lui	a5,0x10
    800001fe:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    80000202:	00000097          	auipc	ra,0x0
    80000206:	eb6080e7          	jalr	-330(ra) # 800000b8 <w_medeleg>
    w_mideleg(0xffff);
    8000020a:	67c1                	lui	a5,0x10
    8000020c:	fff78513          	addi	a0,a5,-1 # ffff <_entry-0x7fff0001>
    80000210:	00000097          	auipc	ra,0x0
    80000214:	ec2080e7          	jalr	-318(ra) # 800000d2 <w_mideleg>
    // S模式开中断
    w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80000218:	00000097          	auipc	ra,0x0
    8000021c:	f08080e7          	jalr	-248(ra) # 80000120 <r_sie>
    80000220:	87aa                	mv	a5,a0
    80000222:	2227e793          	ori	a5,a5,546
    80000226:	853e                	mv	a0,a5
    80000228:	00000097          	auipc	ra,0x0
    8000022c:	ede080e7          	jalr	-290(ra) # 80000106 <w_sie>

    timerinit();
    80000230:	00000097          	auipc	ra,0x0
    80000234:	032080e7          	jalr	50(ra) # 80000262 <timerinit>

    int id = mhartid();
    80000238:	00000097          	auipc	ra,0x0
    8000023c:	de4080e7          	jalr	-540(ra) # 8000001c <mhartid>
    80000240:	87aa                	mv	a5,a0
    80000242:	fef42223          	sw	a5,-28(s0)
    w_tp((uint64)id);
    80000246:	fe442783          	lw	a5,-28(s0)
    8000024a:	853e                	mv	a0,a5
    8000024c:	00000097          	auipc	ra,0x0
    80000250:	f3c080e7          	jalr	-196(ra) # 80000188 <w_tp>
    asm volatile("mret");
    80000254:	30200073          	mret
}
    80000258:	0001                	nop
    8000025a:	60e2                	ld	ra,24(sp)
    8000025c:	6442                	ld	s0,16(sp)
    8000025e:	6105                	addi	sp,sp,32
    80000260:	8082                	ret

0000000080000262 <timerinit>:

void timerinit(){
    80000262:	1101                	addi	sp,sp,-32
    80000264:	ec06                	sd	ra,24(sp)
    80000266:	e822                	sd	s0,16(sp)
    80000268:	1000                	addi	s0,sp,32
    // 获取 hartid
    int id = mhartid();
    8000026a:	00000097          	auipc	ra,0x0
    8000026e:	db2080e7          	jalr	-590(ra) # 8000001c <mhartid>
    80000272:	87aa                	mv	a5,a0
    80000274:	fef42623          	sw	a5,-20(s0)

    // 时间片长度为1秒
    int interval = 50000000;
    80000278:	02faf7b7          	lui	a5,0x2faf
    8000027c:	08078793          	addi	a5,a5,128 # 2faf080 <_entry-0x7d050f80>
    80000280:	fef42423          	sw	a5,-24(s0)
    // 设置时钟比较器
    *(uint64*)CLINT_MTIMECMP(id) = *(uint64 *)CLINT_MTIME + interval;
    80000284:	0200c7b7          	lui	a5,0x200c
    80000288:	17e1                	addi	a5,a5,-8
    8000028a:	6398                	ld	a4,0(a5)
    8000028c:	fe842783          	lw	a5,-24(s0)
    80000290:	fec42683          	lw	a3,-20(s0)
    80000294:	0036969b          	slliw	a3,a3,0x3
    80000298:	2681                	sext.w	a3,a3
    8000029a:	8636                	mv	a2,a3
    8000029c:	020046b7          	lui	a3,0x2004
    800002a0:	96b2                	add	a3,a3,a2
    800002a2:	97ba                	add	a5,a5,a4
    800002a4:	e29c                	sd	a5,0(a3)
    
    // 获取hart对应缓存区域地址
    uint64 * scratch = &mscratch[32*id];
    800002a6:	fec42783          	lw	a5,-20(s0)
    800002aa:	0057979b          	slliw	a5,a5,0x5
    800002ae:	2781                	sext.w	a5,a5
    800002b0:	00379713          	slli	a4,a5,0x3
    800002b4:	00009797          	auipc	a5,0x9
    800002b8:	d5c78793          	addi	a5,a5,-676 # 80009010 <mscratch>
    800002bc:	97ba                	add	a5,a5,a4
    800002be:	fef43023          	sd	a5,-32(s0)
    // 设置时钟比较器缓存
    scratch[0] = CLINT_MTIMECMP(id);
    800002c2:	fec42783          	lw	a5,-20(s0)
    800002c6:	0037979b          	slliw	a5,a5,0x3
    800002ca:	2781                	sext.w	a5,a5
    800002cc:	873e                	mv	a4,a5
    800002ce:	020047b7          	lui	a5,0x2004
    800002d2:	97ba                	add	a5,a5,a4
    800002d4:	873e                	mv	a4,a5
    800002d6:	fe043783          	ld	a5,-32(s0)
    800002da:	e398                	sd	a4,0(a5)
    // 设置时间片缓存
    scratch[1] = interval;
    800002dc:	fe043783          	ld	a5,-32(s0)
    800002e0:	07a1                	addi	a5,a5,8
    800002e2:	fe842703          	lw	a4,-24(s0)
    800002e6:	e398                	sd	a4,0(a5)

    // 设置mscratch寄存器
    w_mscatch((uint64)scratch);
    800002e8:	fe043783          	ld	a5,-32(s0)
    800002ec:	853e                	mv	a0,a5
    800002ee:	00000097          	auipc	ra,0x0
    800002f2:	e66080e7          	jalr	-410(ra) # 80000154 <w_mscatch>
    
    // 设置M模式中断处理程序
    w_mtvec((uint64)timervec);
    800002f6:	00000797          	auipc	a5,0x0
    800002fa:	05a78793          	addi	a5,a5,90 # 80000350 <timervec>
    800002fe:	853e                	mv	a0,a5
    80000300:	00000097          	auipc	ra,0x0
    80000304:	dec080e7          	jalr	-532(ra) # 800000ec <w_mtvec>

    // M模式开中断
    w_mstatus(r_mscratch() | MSTATUS_MIE);
    80000308:	00000097          	auipc	ra,0x0
    8000030c:	e66080e7          	jalr	-410(ra) # 8000016e <r_mscratch>
    80000310:	87aa                	mv	a5,a0
    80000312:	0087e793          	ori	a5,a5,8
    80000316:	853e                	mv	a0,a5
    80000318:	00000097          	auipc	ra,0x0
    8000031c:	d1e080e7          	jalr	-738(ra) # 80000036 <w_mstatus>
    w_mie(r_mie() | MIE_MTIE);
    80000320:	00000097          	auipc	ra,0x0
    80000324:	d7e080e7          	jalr	-642(ra) # 8000009e <r_mie>
    80000328:	87aa                	mv	a5,a0
    8000032a:	0807e793          	ori	a5,a5,128
    8000032e:	853e                	mv	a0,a5
    80000330:	00000097          	auipc	ra,0x0
    80000334:	d54080e7          	jalr	-684(ra) # 80000084 <w_mie>
}
    80000338:	0001                	nop
    8000033a:	60e2                	ld	ra,24(sp)
    8000033c:	6442                	ld	s0,16(sp)
    8000033e:	6105                	addi	sp,sp,32
    80000340:	8082                	ret
	...

0000000080000350 <timervec>:
    80000350:	34051573          	csrrw	a0,mscratch,a0
    80000354:	e90c                	sd	a1,16(a0)
    80000356:	ed10                	sd	a2,24(a0)
    80000358:	f114                	sd	a3,32(a0)
    8000035a:	610c                	ld	a1,0(a0)
    8000035c:	6510                	ld	a2,8(a0)
    8000035e:	6194                	ld	a3,0(a1)
    80000360:	96b2                	add	a3,a3,a2
    80000362:	e194                	sd	a3,0(a1)
    80000364:	4589                	li	a1,2
    80000366:	14459073          	csrw	sip,a1
    8000036a:	6914                	ld	a3,16(a0)
    8000036c:	6d10                	ld	a2,24(a0)
    8000036e:	710c                	ld	a1,32(a0)
    80000370:	34051573          	csrrw	a0,mscratch,a0
    80000374:	30200073          	mret
	...

0000000080000382 <r_tp>:

static inline uint64 r_tp()
{
    80000382:	1101                	addi	sp,sp,-32
    80000384:	ec22                	sd	s0,24(sp)
    80000386:	1000                	addi	s0,sp,32
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000388:	8792                	mv	a5,tp
    8000038a:	fef43423          	sd	a5,-24(s0)
  return x;
    8000038e:	fe843783          	ld	a5,-24(s0)
}
    80000392:	853e                	mv	a0,a5
    80000394:	6462                	ld	s0,24(sp)
    80000396:	6105                	addi	sp,sp,32
    80000398:	8082                	ret

000000008000039a <cpuid>:
#include "include/cpu.h"
#include "include/riscv.h"

struct cpu cpus[NCPU];

int cpuid(){
    8000039a:	1101                	addi	sp,sp,-32
    8000039c:	ec06                	sd	ra,24(sp)
    8000039e:	e822                	sd	s0,16(sp)
    800003a0:	1000                	addi	s0,sp,32
    int id = r_tp();
    800003a2:	00000097          	auipc	ra,0x0
    800003a6:	fe0080e7          	jalr	-32(ra) # 80000382 <r_tp>
    800003aa:	87aa                	mv	a5,a0
    800003ac:	fef42623          	sw	a5,-20(s0)
    return id;
    800003b0:	fec42783          	lw	a5,-20(s0)
}
    800003b4:	853e                	mv	a0,a5
    800003b6:	60e2                	ld	ra,24(sp)
    800003b8:	6442                	ld	s0,16(sp)
    800003ba:	6105                	addi	sp,sp,32
    800003bc:	8082                	ret

00000000800003be <mycpu>:

struct cpu * mycpu(){
    800003be:	1101                	addi	sp,sp,-32
    800003c0:	ec06                	sd	ra,24(sp)
    800003c2:	e822                	sd	s0,16(sp)
    800003c4:	1000                	addi	s0,sp,32
    int id = r_tp();
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	fbc080e7          	jalr	-68(ra) # 80000382 <r_tp>
    800003ce:	87aa                	mv	a5,a0
    800003d0:	fef42623          	sw	a5,-20(s0)
    struct cpu *c = &cpus[id];
    800003d4:	fec42783          	lw	a5,-20(s0)
    800003d8:	00379713          	slli	a4,a5,0x3
    800003dc:	00009797          	auipc	a5,0x9
    800003e0:	43478793          	addi	a5,a5,1076 # 80009810 <cpus>
    800003e4:	97ba                	add	a5,a5,a4
    800003e6:	fef43023          	sd	a5,-32(s0)
    return c;
    800003ea:	fe043783          	ld	a5,-32(s0)
    800003ee:	853e                	mv	a0,a5
    800003f0:	60e2                	ld	ra,24(sp)
    800003f2:	6442                	ld	s0,16(sp)
    800003f4:	6105                	addi	sp,sp,32
    800003f6:	8082                	ret

00000000800003f8 <w_sstatus>:
static inline void w_sstatus(uint64 x){
    800003f8:	1101                	addi	sp,sp,-32
    800003fa:	ec22                	sd	s0,24(sp)
    800003fc:	1000                	addi	s0,sp,32
    800003fe:	fea43423          	sd	a0,-24(s0)
    asm volatile("csrw sstatus, %0"::"r"(x));
    80000402:	fe843783          	ld	a5,-24(s0)
    80000406:	10079073          	csrw	sstatus,a5
}
    8000040a:	0001                	nop
    8000040c:	6462                	ld	s0,24(sp)
    8000040e:	6105                	addi	sp,sp,32
    80000410:	8082                	ret

0000000080000412 <r_sstatus>:
static inline uint64 r_sstatus(){
    80000412:	1101                	addi	sp,sp,-32
    80000414:	ec22                	sd	s0,24(sp)
    80000416:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus":"=r"(x));
    80000418:	100027f3          	csrr	a5,sstatus
    8000041c:	fef43423          	sd	a5,-24(s0)
    return x;
    80000420:	fe843783          	ld	a5,-24(s0)
}
    80000424:	853e                	mv	a0,a5
    80000426:	6462                	ld	s0,24(sp)
    80000428:	6105                	addi	sp,sp,32
    8000042a:	8082                	ret

000000008000042c <intr_on>:

static inline void intr_on()
{
    8000042c:	1141                	addi	sp,sp,-16
    8000042e:	e406                	sd	ra,8(sp)
    80000430:	e022                	sd	s0,0(sp)
    80000432:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000434:	00000097          	auipc	ra,0x0
    80000438:	fde080e7          	jalr	-34(ra) # 80000412 <r_sstatus>
    8000043c:	87aa                	mv	a5,a0
    8000043e:	0027e793          	ori	a5,a5,2
    80000442:	853e                	mv	a0,a5
    80000444:	00000097          	auipc	ra,0x0
    80000448:	fb4080e7          	jalr	-76(ra) # 800003f8 <w_sstatus>
}
    8000044c:	0001                	nop
    8000044e:	60a2                	ld	ra,8(sp)
    80000450:	6402                	ld	s0,0(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret

0000000080000456 <intr_off>:

static inline void intr_off()
{
    80000456:	1141                	addi	sp,sp,-16
    80000458:	e406                	sd	ra,8(sp)
    8000045a:	e022                	sd	s0,0(sp)
    8000045c:	0800                	addi	s0,sp,16
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000045e:	00000097          	auipc	ra,0x0
    80000462:	fb4080e7          	jalr	-76(ra) # 80000412 <r_sstatus>
    80000466:	87aa                	mv	a5,a0
    80000468:	9bf5                	andi	a5,a5,-3
    8000046a:	853e                	mv	a0,a5
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	f8c080e7          	jalr	-116(ra) # 800003f8 <w_sstatus>
}
    80000474:	0001                	nop
    80000476:	60a2                	ld	ra,8(sp)
    80000478:	6402                	ld	s0,0(sp)
    8000047a:	0141                	addi	sp,sp,16
    8000047c:	8082                	ret

000000008000047e <intr_get>:

static inline int intr_get()
{
    8000047e:	1101                	addi	sp,sp,-32
    80000480:	ec06                	sd	ra,24(sp)
    80000482:	e822                	sd	s0,16(sp)
    80000484:	1000                	addi	s0,sp,32
  uint64 x = r_sstatus();
    80000486:	00000097          	auipc	ra,0x0
    8000048a:	f8c080e7          	jalr	-116(ra) # 80000412 <r_sstatus>
    8000048e:	fea43423          	sd	a0,-24(s0)
  return (x & SSTATUS_SIE) != 0;
    80000492:	fe843783          	ld	a5,-24(s0)
    80000496:	8b89                	andi	a5,a5,2
    80000498:	00f037b3          	snez	a5,a5
    8000049c:	0ff7f793          	andi	a5,a5,255
    800004a0:	2781                	sext.w	a5,a5
}
    800004a2:	853e                	mv	a0,a5
    800004a4:	60e2                	ld	ra,24(sp)
    800004a6:	6442                	ld	s0,16(sp)
    800004a8:	6105                	addi	sp,sp,32
    800004aa:	8082                	ret

00000000800004ac <initlock>:
#include "include/riscv.h"

void push_off();
void pop_off();

void initlock(struct spinlock * lk, char * name){
    800004ac:	1101                	addi	sp,sp,-32
    800004ae:	ec22                	sd	s0,24(sp)
    800004b0:	1000                	addi	s0,sp,32
    800004b2:	fea43423          	sd	a0,-24(s0)
    800004b6:	feb43023          	sd	a1,-32(s0)
    lk->locked = 0;
    800004ba:	fe843783          	ld	a5,-24(s0)
    800004be:	0007a023          	sw	zero,0(a5)
    lk->name = name;
    800004c2:	fe843783          	ld	a5,-24(s0)
    800004c6:	fe043703          	ld	a4,-32(s0)
    800004ca:	e798                	sd	a4,8(a5)
    lk->cpu = 0;
    800004cc:	fe843783          	ld	a5,-24(s0)
    800004d0:	0007b823          	sd	zero,16(a5)
}
    800004d4:	0001                	nop
    800004d6:	6462                	ld	s0,24(sp)
    800004d8:	6105                	addi	sp,sp,32
    800004da:	8082                	ret

00000000800004dc <acquire>:

void acquire(struct spinlock *lk)
{
    800004dc:	1101                	addi	sp,sp,-32
    800004de:	ec06                	sd	ra,24(sp)
    800004e0:	e822                	sd	s0,16(sp)
    800004e2:	1000                	addi	s0,sp,32
    800004e4:	fea43423          	sd	a0,-24(s0)
  push_off();
    800004e8:	00000097          	auipc	ra,0x0
    800004ec:	06e080e7          	jalr	110(ra) # 80000556 <push_off>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0);
    800004f0:	0001                	nop
    800004f2:	fe843783          	ld	a5,-24(s0)
    800004f6:	4705                	li	a4,1
    800004f8:	0ce7a72f          	amoswap.w.aq	a4,a4,(a5)
    800004fc:	0007079b          	sext.w	a5,a4
    80000500:	fbed                	bnez	a5,800004f2 <acquire+0x16>
  __sync_synchronize();
    80000502:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000506:	00000097          	auipc	ra,0x0
    8000050a:	eb8080e7          	jalr	-328(ra) # 800003be <mycpu>
    8000050e:	872a                	mv	a4,a0
    80000510:	fe843783          	ld	a5,-24(s0)
    80000514:	eb98                	sd	a4,16(a5)
}
    80000516:	0001                	nop
    80000518:	60e2                	ld	ra,24(sp)
    8000051a:	6442                	ld	s0,16(sp)
    8000051c:	6105                	addi	sp,sp,32
    8000051e:	8082                	ret

0000000080000520 <release>:

void release(struct spinlock *lk)
{
    80000520:	1101                	addi	sp,sp,-32
    80000522:	ec06                	sd	ra,24(sp)
    80000524:	e822                	sd	s0,16(sp)
    80000526:	1000                	addi	s0,sp,32
    80000528:	fea43423          	sd	a0,-24(s0)
  lk->cpu = 0;
    8000052c:	fe843783          	ld	a5,-24(s0)
    80000530:	0007b823          	sd	zero,16(a5)
  __sync_synchronize();
    80000534:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000538:	fe843783          	ld	a5,-24(s0)
    8000053c:	0f50000f          	fence	iorw,ow
    80000540:	0807a02f          	amoswap.w	zero,zero,(a5)
  pop_off();
    80000544:	00000097          	auipc	ra,0x0
    80000548:	06a080e7          	jalr	106(ra) # 800005ae <pop_off>
}
    8000054c:	0001                	nop
    8000054e:	60e2                	ld	ra,24(sp)
    80000550:	6442                	ld	s0,16(sp)
    80000552:	6105                	addi	sp,sp,32
    80000554:	8082                	ret

0000000080000556 <push_off>:

void push_off(){
    80000556:	1101                	addi	sp,sp,-32
    80000558:	ec06                	sd	ra,24(sp)
    8000055a:	e822                	sd	s0,16(sp)
    8000055c:	1000                	addi	s0,sp,32
    int old  = intr_get();
    8000055e:	00000097          	auipc	ra,0x0
    80000562:	f20080e7          	jalr	-224(ra) # 8000047e <intr_get>
    80000566:	87aa                	mv	a5,a0
    80000568:	fef42623          	sw	a5,-20(s0)
    intr_off();
    8000056c:	00000097          	auipc	ra,0x0
    80000570:	eea080e7          	jalr	-278(ra) # 80000456 <intr_off>
    struct cpu *c = mycpu();
    80000574:	00000097          	auipc	ra,0x0
    80000578:	e4a080e7          	jalr	-438(ra) # 800003be <mycpu>
    8000057c:	fea43023          	sd	a0,-32(s0)
    if(c->pushoff_num == 0){
    80000580:	fe043783          	ld	a5,-32(s0)
    80000584:	439c                	lw	a5,0(a5)
    80000586:	e791                	bnez	a5,80000592 <push_off+0x3c>
        c->pushoff_num = old;
    80000588:	fe043783          	ld	a5,-32(s0)
    8000058c:	fec42703          	lw	a4,-20(s0)
    80000590:	c398                	sw	a4,0(a5)
    }
    c->pushoff_num++;
    80000592:	fe043783          	ld	a5,-32(s0)
    80000596:	439c                	lw	a5,0(a5)
    80000598:	2785                	addiw	a5,a5,1
    8000059a:	0007871b          	sext.w	a4,a5
    8000059e:	fe043783          	ld	a5,-32(s0)
    800005a2:	c398                	sw	a4,0(a5)
}
    800005a4:	0001                	nop
    800005a6:	60e2                	ld	ra,24(sp)
    800005a8:	6442                	ld	s0,16(sp)
    800005aa:	6105                	addi	sp,sp,32
    800005ac:	8082                	ret

00000000800005ae <pop_off>:

void pop_off(void)
{
    800005ae:	1101                	addi	sp,sp,-32
    800005b0:	ec06                	sd	ra,24(sp)
    800005b2:	e822                	sd	s0,16(sp)
    800005b4:	1000                	addi	s0,sp,32
  struct cpu *c = mycpu();
    800005b6:	00000097          	auipc	ra,0x0
    800005ba:	e08080e7          	jalr	-504(ra) # 800003be <mycpu>
    800005be:	fea43423          	sd	a0,-24(s0)
  c->pushoff_num -= 1;
    800005c2:	fe843783          	ld	a5,-24(s0)
    800005c6:	439c                	lw	a5,0(a5)
    800005c8:	37fd                	addiw	a5,a5,-1
    800005ca:	0007871b          	sext.w	a4,a5
    800005ce:	fe843783          	ld	a5,-24(s0)
    800005d2:	c398                	sw	a4,0(a5)
  if(c->pushoff_num == 0 && c->intr_enabled)
    800005d4:	fe843783          	ld	a5,-24(s0)
    800005d8:	439c                	lw	a5,0(a5)
    800005da:	eb89                	bnez	a5,800005ec <pop_off+0x3e>
    800005dc:	fe843783          	ld	a5,-24(s0)
    800005e0:	43dc                	lw	a5,4(a5)
    800005e2:	c789                	beqz	a5,800005ec <pop_off+0x3e>
    intr_on();
    800005e4:	00000097          	auipc	ra,0x0
    800005e8:	e48080e7          	jalr	-440(ra) # 8000042c <intr_on>
}
    800005ec:	0001                	nop
    800005ee:	60e2                	ld	ra,24(sp)
    800005f0:	6442                	ld	s0,16(sp)
    800005f2:	6105                	addi	sp,sp,32
    800005f4:	8082                	ret

00000000800005f6 <memset>:
#include "include/types.h"

void* memset(void *dst, int c, uint n)
{
    800005f6:	7179                	addi	sp,sp,-48
    800005f8:	f422                	sd	s0,40(sp)
    800005fa:	1800                	addi	s0,sp,48
    800005fc:	fca43c23          	sd	a0,-40(s0)
    80000600:	87ae                	mv	a5,a1
    80000602:	8732                	mv	a4,a2
    80000604:	fcf42a23          	sw	a5,-44(s0)
    80000608:	87ba                	mv	a5,a4
    8000060a:	fcf42823          	sw	a5,-48(s0)
  char *cdst = (char *) dst;
    8000060e:	fd843783          	ld	a5,-40(s0)
    80000612:	fef43023          	sd	a5,-32(s0)
  int i;
  for(i = 0; i < n; i++){
    80000616:	fe042623          	sw	zero,-20(s0)
    8000061a:	a00d                	j	8000063c <memset+0x46>
    cdst[i] = c;
    8000061c:	fec42783          	lw	a5,-20(s0)
    80000620:	fe043703          	ld	a4,-32(s0)
    80000624:	97ba                	add	a5,a5,a4
    80000626:	fd442703          	lw	a4,-44(s0)
    8000062a:	0ff77713          	andi	a4,a4,255
    8000062e:	00e78023          	sb	a4,0(a5)
  for(i = 0; i < n; i++){
    80000632:	fec42783          	lw	a5,-20(s0)
    80000636:	2785                	addiw	a5,a5,1
    80000638:	fef42623          	sw	a5,-20(s0)
    8000063c:	fec42703          	lw	a4,-20(s0)
    80000640:	fd042783          	lw	a5,-48(s0)
    80000644:	2781                	sext.w	a5,a5
    80000646:	fcf76be3          	bltu	a4,a5,8000061c <memset+0x26>
  }
  return dst;
    8000064a:	fd843783          	ld	a5,-40(s0)
}
    8000064e:	853e                	mv	a0,a5
    80000650:	7422                	ld	s0,40(sp)
    80000652:	6145                	addi	sp,sp,48
    80000654:	8082                	ret

0000000080000656 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80000656:	7139                	addi	sp,sp,-64
    80000658:	fc22                	sd	s0,56(sp)
    8000065a:	0080                	addi	s0,sp,64
    8000065c:	fca43c23          	sd	a0,-40(s0)
    80000660:	fcb43823          	sd	a1,-48(s0)
    80000664:	87b2                	mv	a5,a2
    80000666:	fcf42623          	sw	a5,-52(s0)
  const uchar *s1, *s2;

  s1 = v1;
    8000066a:	fd843783          	ld	a5,-40(s0)
    8000066e:	fef43423          	sd	a5,-24(s0)
  s2 = v2;
    80000672:	fd043783          	ld	a5,-48(s0)
    80000676:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    8000067a:	a0a1                	j	800006c2 <memcmp+0x6c>
    if(*s1 != *s2)
    8000067c:	fe843783          	ld	a5,-24(s0)
    80000680:	0007c703          	lbu	a4,0(a5)
    80000684:	fe043783          	ld	a5,-32(s0)
    80000688:	0007c783          	lbu	a5,0(a5)
    8000068c:	02f70163          	beq	a4,a5,800006ae <memcmp+0x58>
      return *s1 - *s2;
    80000690:	fe843783          	ld	a5,-24(s0)
    80000694:	0007c783          	lbu	a5,0(a5)
    80000698:	0007871b          	sext.w	a4,a5
    8000069c:	fe043783          	ld	a5,-32(s0)
    800006a0:	0007c783          	lbu	a5,0(a5)
    800006a4:	2781                	sext.w	a5,a5
    800006a6:	40f707bb          	subw	a5,a4,a5
    800006aa:	2781                	sext.w	a5,a5
    800006ac:	a01d                	j	800006d2 <memcmp+0x7c>
    s1++, s2++;
    800006ae:	fe843783          	ld	a5,-24(s0)
    800006b2:	0785                	addi	a5,a5,1
    800006b4:	fef43423          	sd	a5,-24(s0)
    800006b8:	fe043783          	ld	a5,-32(s0)
    800006bc:	0785                	addi	a5,a5,1
    800006be:	fef43023          	sd	a5,-32(s0)
  while(n-- > 0){
    800006c2:	fcc42783          	lw	a5,-52(s0)
    800006c6:	fff7871b          	addiw	a4,a5,-1
    800006ca:	fce42623          	sw	a4,-52(s0)
    800006ce:	f7dd                	bnez	a5,8000067c <memcmp+0x26>
  }

  return 0;
    800006d0:	4781                	li	a5,0
}
    800006d2:	853e                	mv	a0,a5
    800006d4:	7462                	ld	s0,56(sp)
    800006d6:	6121                	addi	sp,sp,64
    800006d8:	8082                	ret

00000000800006da <memmove>:

void* memmove(void *dst, const void *src, uint n)
{
    800006da:	7139                	addi	sp,sp,-64
    800006dc:	fc22                	sd	s0,56(sp)
    800006de:	0080                	addi	s0,sp,64
    800006e0:	fca43c23          	sd	a0,-40(s0)
    800006e4:	fcb43823          	sd	a1,-48(s0)
    800006e8:	87b2                	mv	a5,a2
    800006ea:	fcf42623          	sw	a5,-52(s0)
  const char *s;
  char *d;

  s = src;
    800006ee:	fd043783          	ld	a5,-48(s0)
    800006f2:	fef43423          	sd	a5,-24(s0)
  d = dst;
    800006f6:	fd843783          	ld	a5,-40(s0)
    800006fa:	fef43023          	sd	a5,-32(s0)
  if(s < d && s + n > d){
    800006fe:	fe843703          	ld	a4,-24(s0)
    80000702:	fe043783          	ld	a5,-32(s0)
    80000706:	08f77463          	bgeu	a4,a5,8000078e <memmove+0xb4>
    8000070a:	fcc46783          	lwu	a5,-52(s0)
    8000070e:	fe843703          	ld	a4,-24(s0)
    80000712:	97ba                	add	a5,a5,a4
    80000714:	fe043703          	ld	a4,-32(s0)
    80000718:	06f77b63          	bgeu	a4,a5,8000078e <memmove+0xb4>
    s += n;
    8000071c:	fcc46783          	lwu	a5,-52(s0)
    80000720:	fe843703          	ld	a4,-24(s0)
    80000724:	97ba                	add	a5,a5,a4
    80000726:	fef43423          	sd	a5,-24(s0)
    d += n;
    8000072a:	fcc46783          	lwu	a5,-52(s0)
    8000072e:	fe043703          	ld	a4,-32(s0)
    80000732:	97ba                	add	a5,a5,a4
    80000734:	fef43023          	sd	a5,-32(s0)
    while(n-- > 0)
    80000738:	a01d                	j	8000075e <memmove+0x84>
      *--d = *--s;
    8000073a:	fe843783          	ld	a5,-24(s0)
    8000073e:	17fd                	addi	a5,a5,-1
    80000740:	fef43423          	sd	a5,-24(s0)
    80000744:	fe043783          	ld	a5,-32(s0)
    80000748:	17fd                	addi	a5,a5,-1
    8000074a:	fef43023          	sd	a5,-32(s0)
    8000074e:	fe843783          	ld	a5,-24(s0)
    80000752:	0007c703          	lbu	a4,0(a5)
    80000756:	fe043783          	ld	a5,-32(s0)
    8000075a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    8000075e:	fcc42783          	lw	a5,-52(s0)
    80000762:	fff7871b          	addiw	a4,a5,-1
    80000766:	fce42623          	sw	a4,-52(s0)
    8000076a:	fbe1                	bnez	a5,8000073a <memmove+0x60>
  if(s < d && s + n > d){
    8000076c:	a805                	j	8000079c <memmove+0xc2>
  } else
    while(n-- > 0)
      *d++ = *s++;
    8000076e:	fe843703          	ld	a4,-24(s0)
    80000772:	00170793          	addi	a5,a4,1
    80000776:	fef43423          	sd	a5,-24(s0)
    8000077a:	fe043783          	ld	a5,-32(s0)
    8000077e:	00178693          	addi	a3,a5,1
    80000782:	fed43023          	sd	a3,-32(s0)
    80000786:	00074703          	lbu	a4,0(a4)
    8000078a:	00e78023          	sb	a4,0(a5)
    while(n-- > 0)
    8000078e:	fcc42783          	lw	a5,-52(s0)
    80000792:	fff7871b          	addiw	a4,a5,-1
    80000796:	fce42623          	sw	a4,-52(s0)
    8000079a:	fbf1                	bnez	a5,8000076e <memmove+0x94>

  return dst;
    8000079c:	fd843783          	ld	a5,-40(s0)
}
    800007a0:	853e                	mv	a0,a5
    800007a2:	7462                	ld	s0,56(sp)
    800007a4:	6121                	addi	sp,sp,64
    800007a6:	8082                	ret

00000000800007a8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n)
{
    800007a8:	7179                	addi	sp,sp,-48
    800007aa:	f406                	sd	ra,40(sp)
    800007ac:	f022                	sd	s0,32(sp)
    800007ae:	1800                	addi	s0,sp,48
    800007b0:	fea43423          	sd	a0,-24(s0)
    800007b4:	feb43023          	sd	a1,-32(s0)
    800007b8:	87b2                	mv	a5,a2
    800007ba:	fcf42e23          	sw	a5,-36(s0)
  return memmove(dst, src, n);
    800007be:	fdc42783          	lw	a5,-36(s0)
    800007c2:	863e                	mv	a2,a5
    800007c4:	fe043583          	ld	a1,-32(s0)
    800007c8:	fe843503          	ld	a0,-24(s0)
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	f0e080e7          	jalr	-242(ra) # 800006da <memmove>
    800007d4:	87aa                	mv	a5,a0
}
    800007d6:	853e                	mv	a0,a5
    800007d8:	70a2                	ld	ra,40(sp)
    800007da:	7402                	ld	s0,32(sp)
    800007dc:	6145                	addi	sp,sp,48
    800007de:	8082                	ret

00000000800007e0 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    800007e0:	7179                	addi	sp,sp,-48
    800007e2:	f422                	sd	s0,40(sp)
    800007e4:	1800                	addi	s0,sp,48
    800007e6:	fea43423          	sd	a0,-24(s0)
    800007ea:	feb43023          	sd	a1,-32(s0)
    800007ee:	87b2                	mv	a5,a2
    800007f0:	fcf42e23          	sw	a5,-36(s0)
  while(n > 0 && *p && *p == *q)
    800007f4:	a005                	j	80000814 <strncmp+0x34>
    n--, p++, q++;
    800007f6:	fdc42783          	lw	a5,-36(s0)
    800007fa:	37fd                	addiw	a5,a5,-1
    800007fc:	fcf42e23          	sw	a5,-36(s0)
    80000800:	fe843783          	ld	a5,-24(s0)
    80000804:	0785                	addi	a5,a5,1
    80000806:	fef43423          	sd	a5,-24(s0)
    8000080a:	fe043783          	ld	a5,-32(s0)
    8000080e:	0785                	addi	a5,a5,1
    80000810:	fef43023          	sd	a5,-32(s0)
  while(n > 0 && *p && *p == *q)
    80000814:	fdc42783          	lw	a5,-36(s0)
    80000818:	2781                	sext.w	a5,a5
    8000081a:	c385                	beqz	a5,8000083a <strncmp+0x5a>
    8000081c:	fe843783          	ld	a5,-24(s0)
    80000820:	0007c783          	lbu	a5,0(a5)
    80000824:	cb99                	beqz	a5,8000083a <strncmp+0x5a>
    80000826:	fe843783          	ld	a5,-24(s0)
    8000082a:	0007c703          	lbu	a4,0(a5)
    8000082e:	fe043783          	ld	a5,-32(s0)
    80000832:	0007c783          	lbu	a5,0(a5)
    80000836:	fcf700e3          	beq	a4,a5,800007f6 <strncmp+0x16>
  if(n == 0)
    8000083a:	fdc42783          	lw	a5,-36(s0)
    8000083e:	2781                	sext.w	a5,a5
    80000840:	e399                	bnez	a5,80000846 <strncmp+0x66>
    return 0;
    80000842:	4781                	li	a5,0
    80000844:	a839                	j	80000862 <strncmp+0x82>
  return (uchar)*p - (uchar)*q;
    80000846:	fe843783          	ld	a5,-24(s0)
    8000084a:	0007c783          	lbu	a5,0(a5)
    8000084e:	0007871b          	sext.w	a4,a5
    80000852:	fe043783          	ld	a5,-32(s0)
    80000856:	0007c783          	lbu	a5,0(a5)
    8000085a:	2781                	sext.w	a5,a5
    8000085c:	40f707bb          	subw	a5,a4,a5
    80000860:	2781                	sext.w	a5,a5
}
    80000862:	853e                	mv	a0,a5
    80000864:	7422                	ld	s0,40(sp)
    80000866:	6145                	addi	sp,sp,48
    80000868:	8082                	ret

000000008000086a <strncpy>:

char* strncpy(char *s, const char *t, int n)
{
    8000086a:	7139                	addi	sp,sp,-64
    8000086c:	fc22                	sd	s0,56(sp)
    8000086e:	0080                	addi	s0,sp,64
    80000870:	fca43c23          	sd	a0,-40(s0)
    80000874:	fcb43823          	sd	a1,-48(s0)
    80000878:	87b2                	mv	a5,a2
    8000087a:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    8000087e:	fd843783          	ld	a5,-40(s0)
    80000882:	fef43423          	sd	a5,-24(s0)
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000886:	0001                	nop
    80000888:	fcc42783          	lw	a5,-52(s0)
    8000088c:	fff7871b          	addiw	a4,a5,-1
    80000890:	fce42623          	sw	a4,-52(s0)
    80000894:	02f05e63          	blez	a5,800008d0 <strncpy+0x66>
    80000898:	fd043703          	ld	a4,-48(s0)
    8000089c:	00170793          	addi	a5,a4,1
    800008a0:	fcf43823          	sd	a5,-48(s0)
    800008a4:	fd843783          	ld	a5,-40(s0)
    800008a8:	00178693          	addi	a3,a5,1
    800008ac:	fcd43c23          	sd	a3,-40(s0)
    800008b0:	00074703          	lbu	a4,0(a4)
    800008b4:	00e78023          	sb	a4,0(a5)
    800008b8:	0007c783          	lbu	a5,0(a5)
    800008bc:	f7f1                	bnez	a5,80000888 <strncpy+0x1e>
    ;
  while(n-- > 0)
    800008be:	a809                	j	800008d0 <strncpy+0x66>
    *s++ = 0;
    800008c0:	fd843783          	ld	a5,-40(s0)
    800008c4:	00178713          	addi	a4,a5,1
    800008c8:	fce43c23          	sd	a4,-40(s0)
    800008cc:	00078023          	sb	zero,0(a5)
  while(n-- > 0)
    800008d0:	fcc42783          	lw	a5,-52(s0)
    800008d4:	fff7871b          	addiw	a4,a5,-1
    800008d8:	fce42623          	sw	a4,-52(s0)
    800008dc:	fef042e3          	bgtz	a5,800008c0 <strncpy+0x56>
  return os;
    800008e0:	fe843783          	ld	a5,-24(s0)
}
    800008e4:	853e                	mv	a0,a5
    800008e6:	7462                	ld	s0,56(sp)
    800008e8:	6121                	addi	sp,sp,64
    800008ea:	8082                	ret

00000000800008ec <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n)
{
    800008ec:	7139                	addi	sp,sp,-64
    800008ee:	fc22                	sd	s0,56(sp)
    800008f0:	0080                	addi	s0,sp,64
    800008f2:	fca43c23          	sd	a0,-40(s0)
    800008f6:	fcb43823          	sd	a1,-48(s0)
    800008fa:	87b2                	mv	a5,a2
    800008fc:	fcf42623          	sw	a5,-52(s0)
  char *os;

  os = s;
    80000900:	fd843783          	ld	a5,-40(s0)
    80000904:	fef43423          	sd	a5,-24(s0)
  if(n <= 0)
    80000908:	fcc42783          	lw	a5,-52(s0)
    8000090c:	2781                	sext.w	a5,a5
    8000090e:	00f04563          	bgtz	a5,80000918 <safestrcpy+0x2c>
    return os;
    80000912:	fe843783          	ld	a5,-24(s0)
    80000916:	a0a1                	j	8000095e <safestrcpy+0x72>
  while(--n > 0 && (*s++ = *t++) != 0)
    80000918:	fcc42783          	lw	a5,-52(s0)
    8000091c:	37fd                	addiw	a5,a5,-1
    8000091e:	fcf42623          	sw	a5,-52(s0)
    80000922:	fcc42783          	lw	a5,-52(s0)
    80000926:	2781                	sext.w	a5,a5
    80000928:	02f05563          	blez	a5,80000952 <safestrcpy+0x66>
    8000092c:	fd043703          	ld	a4,-48(s0)
    80000930:	00170793          	addi	a5,a4,1
    80000934:	fcf43823          	sd	a5,-48(s0)
    80000938:	fd843783          	ld	a5,-40(s0)
    8000093c:	00178693          	addi	a3,a5,1
    80000940:	fcd43c23          	sd	a3,-40(s0)
    80000944:	00074703          	lbu	a4,0(a4)
    80000948:	00e78023          	sb	a4,0(a5)
    8000094c:	0007c783          	lbu	a5,0(a5)
    80000950:	f7e1                	bnez	a5,80000918 <safestrcpy+0x2c>
    ;
  *s = 0;
    80000952:	fd843783          	ld	a5,-40(s0)
    80000956:	00078023          	sb	zero,0(a5)
  return os;
    8000095a:	fe843783          	ld	a5,-24(s0)
}
    8000095e:	853e                	mv	a0,a5
    80000960:	7462                	ld	s0,56(sp)
    80000962:	6121                	addi	sp,sp,64
    80000964:	8082                	ret

0000000080000966 <strlen>:

int strlen(const char *s)
{
    80000966:	7179                	addi	sp,sp,-48
    80000968:	f422                	sd	s0,40(sp)
    8000096a:	1800                	addi	s0,sp,48
    8000096c:	fca43c23          	sd	a0,-40(s0)
  int n;

  for(n = 0; s[n]; n++)
    80000970:	fe042623          	sw	zero,-20(s0)
    80000974:	a031                	j	80000980 <strlen+0x1a>
    80000976:	fec42783          	lw	a5,-20(s0)
    8000097a:	2785                	addiw	a5,a5,1
    8000097c:	fef42623          	sw	a5,-20(s0)
    80000980:	fec42783          	lw	a5,-20(s0)
    80000984:	fd843703          	ld	a4,-40(s0)
    80000988:	97ba                	add	a5,a5,a4
    8000098a:	0007c783          	lbu	a5,0(a5)
    8000098e:	f7e5                	bnez	a5,80000976 <strlen+0x10>
    ;
  return n;
    80000990:	fec42783          	lw	a5,-20(s0)
}
    80000994:	853e                	mv	a0,a5
    80000996:	7422                	ld	s0,40(sp)
    80000998:	6145                	addi	sp,sp,48
    8000099a:	8082                	ret

000000008000099c <freerange>:
    struct spinlock lock;
    struct run * freelist;
} kmemory;

void freerange(void *pa_start, void *pa_end)
{
    8000099c:	7179                	addi	sp,sp,-48
    8000099e:	f406                	sd	ra,40(sp)
    800009a0:	f022                	sd	s0,32(sp)
    800009a2:	1800                	addi	s0,sp,48
    800009a4:	fca43c23          	sd	a0,-40(s0)
    800009a8:	fcb43823          	sd	a1,-48(s0)
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
    800009ac:	fd843703          	ld	a4,-40(s0)
    800009b0:	6785                	lui	a5,0x1
    800009b2:	17fd                	addi	a5,a5,-1
    800009b4:	973e                	add	a4,a4,a5
    800009b6:	77fd                	lui	a5,0xfffff
    800009b8:	8ff9                	and	a5,a5,a4
    800009ba:	fef43423          	sd	a5,-24(s0)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800009be:	a829                	j	800009d8 <freerange+0x3c>
    kfree(p);
    800009c0:	fe843503          	ld	a0,-24(s0)
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	070080e7          	jalr	112(ra) # 80000a34 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800009cc:	fe843703          	ld	a4,-24(s0)
    800009d0:	6785                	lui	a5,0x1
    800009d2:	97ba                	add	a5,a5,a4
    800009d4:	fef43423          	sd	a5,-24(s0)
    800009d8:	fe843703          	ld	a4,-24(s0)
    800009dc:	6785                	lui	a5,0x1
    800009de:	97ba                	add	a5,a5,a4
    800009e0:	fd043703          	ld	a4,-48(s0)
    800009e4:	fcf77ee3          	bgeu	a4,a5,800009c0 <freerange+0x24>
}
    800009e8:	0001                	nop
    800009ea:	0001                	nop
    800009ec:	70a2                	ld	ra,40(sp)
    800009ee:	7402                	ld	s0,32(sp)
    800009f0:	6145                	addi	sp,sp,48
    800009f2:	8082                	ret

00000000800009f4 <kinit>:


void kinit()
{
    800009f4:	1141                	addi	sp,sp,-16
    800009f6:	e406                	sd	ra,8(sp)
    800009f8:	e022                	sd	s0,0(sp)
    800009fa:	0800                	addi	s0,sp,16
  initlock(&kmemory.lock, "kmemory");
    800009fc:	00000597          	auipc	a1,0x0
    80000a00:	60458593          	addi	a1,a1,1540 # 80001000 <main+0x4f0>
    80000a04:	00009517          	auipc	a0,0x9
    80000a08:	e4c50513          	addi	a0,a0,-436 # 80009850 <kmemory>
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	aa0080e7          	jalr	-1376(ra) # 800004ac <initlock>
  freerange(end, (void*)PHYSTOP);
    80000a14:	47c5                	li	a5,17
    80000a16:	01b79593          	slli	a1,a5,0x1b
    80000a1a:	00009517          	auipc	a0,0x9
    80000a1e:	e5a50513          	addi	a0,a0,-422 # 80009874 <end>
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	f7a080e7          	jalr	-134(ra) # 8000099c <freerange>
}
    80000a2a:	0001                	nop
    80000a2c:	60a2                	ld	ra,8(sp)
    80000a2e:	6402                	ld	s0,0(sp)
    80000a30:	0141                	addi	sp,sp,16
    80000a32:	8082                	ret

0000000080000a34 <kfree>:

void kfree(void *pa)
{
    80000a34:	7179                	addi	sp,sp,-48
    80000a36:	f406                	sd	ra,40(sp)
    80000a38:	f022                	sd	s0,32(sp)
    80000a3a:	1800                	addi	s0,sp,48
    80000a3c:	fca43c23          	sd	a0,-40(s0)
  struct run *r;

  memset(pa, 1, PGSIZE);
    80000a40:	6605                	lui	a2,0x1
    80000a42:	4585                	li	a1,1
    80000a44:	fd843503          	ld	a0,-40(s0)
    80000a48:	00000097          	auipc	ra,0x0
    80000a4c:	bae080e7          	jalr	-1106(ra) # 800005f6 <memset>

  r = (struct run*)pa;
    80000a50:	fd843783          	ld	a5,-40(s0)
    80000a54:	fef43423          	sd	a5,-24(s0)

  acquire(&kmemory.lock);
    80000a58:	00009517          	auipc	a0,0x9
    80000a5c:	df850513          	addi	a0,a0,-520 # 80009850 <kmemory>
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	a7c080e7          	jalr	-1412(ra) # 800004dc <acquire>
  r->next = kmemory.freelist;
    80000a68:	00009797          	auipc	a5,0x9
    80000a6c:	de878793          	addi	a5,a5,-536 # 80009850 <kmemory>
    80000a70:	6f98                	ld	a4,24(a5)
    80000a72:	fe843783          	ld	a5,-24(s0)
    80000a76:	e398                	sd	a4,0(a5)
  kmemory.freelist = r;
    80000a78:	00009797          	auipc	a5,0x9
    80000a7c:	dd878793          	addi	a5,a5,-552 # 80009850 <kmemory>
    80000a80:	fe843703          	ld	a4,-24(s0)
    80000a84:	ef98                	sd	a4,24(a5)
  release(&kmemory.lock);
    80000a86:	00009517          	auipc	a0,0x9
    80000a8a:	dca50513          	addi	a0,a0,-566 # 80009850 <kmemory>
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	a92080e7          	jalr	-1390(ra) # 80000520 <release>
}
    80000a96:	0001                	nop
    80000a98:	70a2                	ld	ra,40(sp)
    80000a9a:	7402                	ld	s0,32(sp)
    80000a9c:	6145                	addi	sp,sp,48
    80000a9e:	8082                	ret

0000000080000aa0 <kalloc>:

void * kalloc()
{
    80000aa0:	1101                	addi	sp,sp,-32
    80000aa2:	ec06                	sd	ra,24(sp)
    80000aa4:	e822                	sd	s0,16(sp)
    80000aa6:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmemory.lock);
    80000aa8:	00009517          	auipc	a0,0x9
    80000aac:	da850513          	addi	a0,a0,-600 # 80009850 <kmemory>
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	a2c080e7          	jalr	-1492(ra) # 800004dc <acquire>
  r = kmemory.freelist;
    80000ab8:	00009797          	auipc	a5,0x9
    80000abc:	d9878793          	addi	a5,a5,-616 # 80009850 <kmemory>
    80000ac0:	6f9c                	ld	a5,24(a5)
    80000ac2:	fef43423          	sd	a5,-24(s0)
  if(r)
    80000ac6:	fe843783          	ld	a5,-24(s0)
    80000aca:	cb89                	beqz	a5,80000adc <kalloc+0x3c>
    kmemory.freelist = r->next;
    80000acc:	fe843783          	ld	a5,-24(s0)
    80000ad0:	6398                	ld	a4,0(a5)
    80000ad2:	00009797          	auipc	a5,0x9
    80000ad6:	d7e78793          	addi	a5,a5,-642 # 80009850 <kmemory>
    80000ada:	ef98                	sd	a4,24(a5)
  release(&kmemory.lock);
    80000adc:	00009517          	auipc	a0,0x9
    80000ae0:	d7450513          	addi	a0,a0,-652 # 80009850 <kmemory>
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	a3c080e7          	jalr	-1476(ra) # 80000520 <release>

  if(r)
    80000aec:	fe843783          	ld	a5,-24(s0)
    80000af0:	cb89                	beqz	a5,80000b02 <kalloc+0x62>
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000af2:	6605                	lui	a2,0x1
    80000af4:	4595                	li	a1,5
    80000af6:	fe843503          	ld	a0,-24(s0)
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	afc080e7          	jalr	-1284(ra) # 800005f6 <memset>
  return (void*)r;
    80000b02:	fe843783          	ld	a5,-24(s0)
    80000b06:	853e                	mv	a0,a5
    80000b08:	60e2                	ld	ra,24(sp)
    80000b0a:	6442                	ld	s0,16(sp)
    80000b0c:	6105                	addi	sp,sp,32
    80000b0e:	8082                	ret

0000000080000b10 <main>:
#include "include/cpu.h"
#include "include/kalloc.h"

static int started = 0;

void main(){
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    80000b18:	00000097          	auipc	ra,0x0
    80000b1c:	882080e7          	jalr	-1918(ra) # 8000039a <cpuid>
    80000b20:	87aa                	mv	a5,a0
    80000b22:	ef81                	bnez	a5,80000b3a <main+0x2a>
        kinit();
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	ed0080e7          	jalr	-304(ra) # 800009f4 <kinit>
        started = 1;
    80000b2c:	00009797          	auipc	a5,0x9
    80000b30:	d4478793          	addi	a5,a5,-700 # 80009870 <started>
    80000b34:	4705                	li	a4,1
    80000b36:	c398                	sw	a4,0(a5)
    }else{
        while(started == 0);
        __sync_synchronize();
    }
    80000b38:	a811                	j	80000b4c <main+0x3c>
        while(started == 0);
    80000b3a:	0001                	nop
    80000b3c:	00009797          	auipc	a5,0x9
    80000b40:	d3478793          	addi	a5,a5,-716 # 80009870 <started>
    80000b44:	439c                	lw	a5,0(a5)
    80000b46:	dbfd                	beqz	a5,80000b3c <main+0x2c>
        __sync_synchronize();
    80000b48:	0ff0000f          	fence
    80000b4c:	0001                	nop
    80000b4e:	60a2                	ld	ra,8(sp)
    80000b50:	6402                	ld	s0,0(sp)
    80000b52:	0141                	addi	sp,sp,16
    80000b54:	8082                	ret
	...
