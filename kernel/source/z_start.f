

	module start_mod
	use mod_Framebuffer
	use kernel_framebuffer
	use iso_c_binding
	COMMON /null_terminator/ null_t

C This is a dummy/hack just to get the proper location of the IVT in the kernel image
	integer(c_int), bind(c) :: interrupt_vector_table
	integer(c_int), bind(c,name='__kernel_bootstrap') :: kernel_bootstrap
	integer(c_int), bind(c,name='__memcpy_end') :: memcpy_end
	integer(c_int), bind(c,name='_start') :: kernel_start

		interface
			subroutine pkboot(dst, src, num)
				integer, value :: dst
				integer, value :: src
				integer, value :: num
			end subroutine pkboot
		end interface
	contains


	
	subroutine start
C	use gpio
	use print_console
C	use mod_usb
	use mod_GraphicsRendererBackend
	use uart
	use class_Stream
C	use mod_VideoCore
C	use mailbox
C	use libhardware
C	use watchdog
	implicit none
	integer(kind=4) rstat
	integer(kind=2) color
	integer(kind=4) stat
	pointer ( stat, rstat )
	integer ptr
	integer floc
	integer fontptr
	integer(kind=2) fcolor
	integer(kind=1) cout
	integer(kind=4) ksize
	integer :: i
	type(Stream) :: kstream
	integer(kind=4) :: kernel_bootptr
	procedure(pkboot) :: kboot
	pointer (fontptr, fcolor)
	pointer(kernel_bootptr, kboot)
	TYPE(FramebufferInfo) :: framebuffer
	pointer ( ptr, framebuffer )
	stat = 0
C Copy interrupt vector table to zero page
	call memcpy(int(z'00000000', 4), loc(interrupt_vector_table), 32)
C Install kernel bootstrap code (not fully implemented/not working)
	call memcpy(int(z'00028000', 4), loc(kernel_bootstrap), loc(memcpy_end) - loc(kernel_bootstrap))
	kernel_bootptr = z'00028000'
	call uart_init()
C	call gpio_set_pin_func(16, 1)
C	call gpio_set_pin_low(16)

	ptr = loc(finfo)
	framebuffer%ptr = 0
C	call EnableMMU()
1	call init_fb(704, 480, 16, ptr)
	if(IAND(framebuffer%ptr, z'FFFFFFFF') .eq. 0) then
		goto 1
	endif
C	call mailbox_init()
	call build_font32()
	
	

C black (0x00) seems to cause problems ocassionally. Use off-black.
	color = b'0000100000100001'

C Terminate all strings with NULL
	call printstr("Hello World" //char(0))
	console_pos%row = console_pos%row + 1
	console_pos%column = 0
	call printstr("Framebuffer address: " //char(0))
	call print_int(framebuffer%ptr)
	console_pos%row = console_pos%row + 1
	console_pos%column = 0

	do while(.true.)
		cout = uart_getc(100)
		if(cout .ne. 0) then
			if(cout .eq. 5) then
				call uart_putc(6)
			endif

			if(cout .eq. 3) then
				call uart_putc(6)
C Broken, doesnt work
				ksize = int(uart_getc(1000), 4) + ISHFT(int(uart_getc(1000), 4), 8) + ISHFT(int(uart_getc(1000), 4), 16) + ISHFT(int(uart_getc(1000), 4), 24)
				kstream = Stream(malloc(ksize), ksize, 0)
				call printstr("New kernel size: " //char(0))
				call print_int(ksize)
				console_pos%row = console_pos%row + 1
				console_pos%column = 0

/*				console_pos%row = console_pos%row + 1
				console_pos%column = 0
				do i = 0, ksize, 1
					call kstream%write(uart_getc(0))
				end do */

C				call kboot(loc(kernel_start), kstream%pBuffer, ksize)
			endif
		endif

	enddo

	
	end subroutine start



	end module start_mod





