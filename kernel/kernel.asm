
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00000117          	auipc	sp,0x0
    80000004:	06010113          	addi	sp,sp,96 # 80000060 <stack>
    80000008:	f1402573          	csrr	a0,mhartid
    8000000c:	6585                	lui	a1,0x1
    8000000e:	02b50533          	mul	a0,a0,a1
    80000012:	952e                	add	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	020000ef          	jal	ra,80000036 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <mhartid>:

#ifndef _RISCV_H

#define _RISCV_H

uint64 mhartid(){
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

0000000080000036 <start>:
#include "include/riscv.h"
#define NCPU 8

__attribute__ ((aligned(16))) unsigned char stack[4096 * NCPU];

void start(){
    80000036:	1101                	addi	sp,sp,-32
    80000038:	ec06                	sd	ra,24(sp)
    8000003a:	e822                	sd	s0,16(sp)
    8000003c:	1000                	addi	s0,sp,32
    uint64 x = mhartid();
    8000003e:	00000097          	auipc	ra,0x0
    80000042:	fde080e7          	jalr	-34(ra) # 8000001c <mhartid>
    80000046:	fea43423          	sd	a0,-24(s0)
    x++;
    8000004a:	fe843783          	ld	a5,-24(s0)
    8000004e:	0785                	addi	a5,a5,1
    80000050:	fef43423          	sd	a5,-24(s0)
}
    80000054:	0001                	nop
    80000056:	60e2                	ld	ra,24(sp)
    80000058:	6442                	ld	s0,16(sp)
    8000005a:	6105                	addi	sp,sp,32
    8000005c:	8082                	ret
