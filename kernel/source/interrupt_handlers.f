

	module kernel_interrupt

	interface
		subroutine interrupt_return() bind(c)
		end subroutine interrupt_return

		subroutine malloc(r) bind(c)
			use iso_c_binding
			integer(c_int) :: r
		end subroutine malloc
	end interface

	contains

	subroutine kernel_swi_handler(r0, r1, r2) bind(c)
		use iso_c_binding
		integer(c_int), value :: r0, r1, r2
		if(r0 .eq. 0) then
			call malloc(r1)
		endif
	end subroutine kernel_swi_handler


	end module kernel_interrupt
