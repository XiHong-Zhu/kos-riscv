
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00000117          	auipc	sp,0x0
    80000004:	37010113          	addi	sp,sp,880 # 80000370 <stack>
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
    800001ba:	7ff78793          	addi	a5,a5,2047 # ffffffffffffe7ff <mscratch+0xffffffff7fff648f>
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
    800001e0:	00000797          	auipc	a5,0x0
    800001e4:	18278793          	addi	a5,a5,386 # 80000362 <main>
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
    800002b4:	00008797          	auipc	a5,0x8
    800002b8:	0bc78793          	addi	a5,a5,188 # 80008370 <mscratch>
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
    80000350:	30200073          	mret
	...

0000000080000362 <main>:
void main(){
    80000362:	1141                	addi	sp,sp,-16
    80000364:	e422                	sd	s0,8(sp)
    80000366:	0800                	addi	s0,sp,16
    while (1){}
    80000368:	a001                	j	80000368 <main+0x6>
