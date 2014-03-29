.section ".text"
.global interrupt_vector_table

interrupt_vector_table:
    ldr pc,reset_handler
    ldr pc,undefined_handler
    ldr pc,swi_handler
    ldr pc,prefetch_handler
    ldr pc,data_handler
    ldr pc,unused_handler
    ldr pc,irq_handler
    ldr pc,fiq_handler

reset_handler:       .word dummy
undefined_handler:    .word dummy
swi_handler:       .word swi_handler_invoker
prefetch_handler:    .word dummy
data_handler:       .word dummy
unused_handler:    .word dummy
irq_handler:       .word dummy
fiq_handler:       .word dummy

swi_handler_invoker:
	push { r0-r7, lr }
	bl kernel_swi_handler
	pop { r0-r7, lr }
	movs pc, lr


dummy:
	b dummy
