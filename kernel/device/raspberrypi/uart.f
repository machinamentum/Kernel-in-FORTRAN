

	module mmio
	implicit none


	contains

		subroutine mmio_write(reg, dat)
			integer(kind=4), intent(in) :: reg
			integer(kind=4), value :: dat
			integer(kind=4) :: wrptr
			pointer (reg, wrptr)
			wrptr = dat
		end subroutine mmio_write

		integer(kind=4) function mmio_read(reg)
			integer(kind=4), intent(in) :: reg
			integer(kind=4) :: wrptr
			pointer (reg, wrptr)
			mmio_read = wrptr
		end function mmio_read


	end module mmio


	module uart
	use mmio
	implicit none


	integer, parameter :: GPIO_BASE = z'20200000'
	integer, parameter :: GPPUD = (GPIO_BASE + z'94')
	integer, parameter :: GPPUDCLK0 = (GPIO_BASE + z'98')

	integer, parameter :: UART0_BASE = z'20201000'

	integer, parameter :: UART0_DR     = (UART0_BASE + z'00')
	integer, parameter :: UART0_RSRECR = (UART0_BASE + z'04')
	integer, parameter :: UART0_FR     = (UART0_BASE + z'18')
	integer, parameter :: UART0_ILPR   = (UART0_BASE + z'20')
	integer, parameter :: UART0_IBRD   = (UART0_BASE + z'24')
	integer, parameter :: UART0_FBRD   = (UART0_BASE + z'28')
	integer, parameter :: UART0_LCRH   = (UART0_BASE + z'2C')
	integer, parameter :: UART0_CR     = (UART0_BASE + z'30')
	integer, parameter :: UART0_IFLS   = (UART0_BASE + z'34')
	integer, parameter :: UART0_IMSC   = (UART0_BASE + z'38')
	integer, parameter :: UART0_RIS    = (UART0_BASE + z'3C')
	integer, parameter :: UART0_MIS    = (UART0_BASE + z'40')
	integer, parameter :: UART0_ICR    = (UART0_BASE + z'44')
	integer, parameter :: UART0_DMACR  = (UART0_BASE + z'48')
	integer, parameter :: UART0_ITCR   = (UART0_BASE + z'80')
	integer, parameter :: UART0_ITIP   = (UART0_BASE + z'84')
	integer, parameter :: UART0_ITOP   = (UART0_BASE + z'88')
	integer, parameter :: UART0_TDR    = (UART0_BASE + z'8C')


	private :: delay

	interface uart_putc
		procedure uart_putc_char, uart_putc_int8, uart_putc_int32
	end interface uart_putc

	contains

		subroutine delay(count)
			integer, value :: count
			integer :: i
			i = 0
1			continue
				i = i + 1
			if(i .le. count) goto 1
		end subroutine delay

		subroutine uart_init()
			call mmio_write(UART0_CR, 0)
			call mmio_write(GPPUD, 0)
			call delay(150)

			call mmio_write(GPPUDCLK0, IOR(ISHFT(1, 14), ISHFT(1, 15)))
			call delay(150)

			call mmio_write(GPPUDCLK0, 0)

			call mmio_write(UART0_ICR, int(z'7FF', 4))

			call mmio_write(UART0_IBRD, 1)
			call mmio_write(UART0_FBRD, 40)

			call mmio_write(UART0_LCRH, IOR(IOR(ISHFT(1, 4), ISHFT(1, 5)), ISHFT(1, 6)))

			call mmio_write(UART0_IMSC, int(b'11111110010', 4))

			call mmio_write(UART0_CR, int(b'1100000001', 4))

		end subroutine uart_init

		subroutine uart_putc_int8(byte)
			integer(kind=1), value :: byte
			do while(.true.)
				if(IAND(mmio_read(UART0_FR), ISHFT(1, 5)) .eq. 0) then
					exit
				end if
			end do

			call mmio_write(UART0_DR, int(byte, 4))
		end subroutine uart_putc_int8

		subroutine uart_putc_char(c)
			character, value :: c
			call uart_putc_int8(int(ichar(c), 1))
		end subroutine uart_putc_char

		subroutine uart_putc_int32(c)
			integer, value :: c
			call uart_putc_int8(int(c, 1))
		end subroutine uart_putc_int32

		subroutine uart_puts(str)
			integer, value :: str
			integer(kind=4) :: ptr
			integer(kind=1) :: wrptr
			pointer (ptr, wrptr)
			ptr = str
			do while(wrptr .ne. 0)
				call uart_putc(wrptr)
				ptr = ptr + 1
			enddo
		end subroutine uart_puts

		integer(kind=1) function uart_getc(attempts)
			integer, value :: attempts
			integer :: i
			do i = 0, attempts, 1
				if(IAND(mmio_read(UART0_FR), ISHFT(1, 4)) .ne. 0) then
					uart_getc = 0
				end if
			end do

			uart_getc = mmio_read(UART0_DR)
		end function uart_getc

	end module uart

