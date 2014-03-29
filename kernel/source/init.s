.section ".text.boot"
.global _start
_start:
	ldr sp, =_stack_start

	ldr r0,=_bss_start
	ldr r1,=_bss_end
	mov r2, #0

loop:

	str r2, [r0, r3]
	add r3, r3, #4
	cmp r3, r1
	blt loop

	bl __start_mod_MOD_start

