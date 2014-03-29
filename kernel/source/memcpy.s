.section ".text"
.global __kernel_bootstrap
.global memcpy
.global __memcpy_end


@ sig:  int kdst, int ksrc, int ksize
__kernel_bootstrap:
	bl memcpy
__done_memcpy:
	mov pc, r0

memcpy:
	mov	r3, r0
	rsb	r1, r0, r1
__memcpy_reset:
	rsb	ip, r0, r3
	cmp	ip, r2
	bxge lr
	ldrb ip, [r1, r3]
	strb ip, [r3], #1
	b __memcpy_reset
__memcpy_end:
	nop