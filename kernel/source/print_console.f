
	module print_console
	use memory
	use mod_Framebuffer
	use kernel_framebuffer

	COMMON /null_terminator/ null_t
	COMMON /null_terminator_0_size/ null_tsize

	COMMON /null_terminator_32/ null_t32

	TYPE :: ConsolePosition
		integer(kind=4) :: row
		integer(kind=4) :: column
	END TYPE ConsolePosition
	
	TYPE(ConsolePosition) :: console_pos = ConsolePosition(1, 0)

	contains

	subroutine putc(c)
	implicit none
	character, intent(in) :: c
	if(finfo%bitdepth .eq. 16) then
		call putc_rgb16(c)
	else
		call putc_rgb32(c)
	endif
	end subroutine putc
	
	subroutine putc_rgb16(c)
	implicit none
	character, intent(in) :: c
	integer column
	integer row
	integer  j, i, k
	integer ptr
	i = ichar(c) - z'20'
	column = modulo(i, 8) * 8
	row = (i / 8)
	row = row * 8
	j = 0
1	continue
		i = finfo%ptr + 2
		i = i + (console_pos%column * 2 * 8)
		k = j + (console_pos%row * 8)
		k = k * finfo%pitch
		i = i + k
		call memcpy(i, loc(null_t) + (column + ((row + j) * 64)) * 2, 16)
		j = j + 1
	if(j .le. 7) goto 1
	console_pos%column = console_pos%column + 1
	end subroutine putc_rgb16


	subroutine putc_rgb32(c)
	implicit none
	character, intent(in) :: c
	integer column
	integer row
	integer  j, i, k
	integer ptr
	i = ichar(c) - z'20'
	column = modulo(i, 8) * 8
	row = (i / 8)
	row = row * 8
	j = 0
1	continue
		i = finfo%ptr + 4
		i = i + (console_pos%column * 4 * 8)
		k = j + (console_pos%row * 8)
		k = k * finfo%pitch
		i = i + k
		call memcpy(i, loc(null_t32) + (column + ((row + j) * 64)) * 4, 32)
		j = j + 1
	if(j .le. 7) goto 1
	console_pos%column = console_pos%column + 1
	end subroutine putc_rgb32

	subroutine build_font32()
	implicit none
	integer :: ptr, i, ptr32, val32
	integer(kind=2) :: val
	pointer ( ptr, val )
	pointer ( ptr32, val32 )
	i = 0
	ptr = loc(null_t)
	ptr32 = loc(null_t32)
1	continue
		val32 = color16to32(val)
		ptr = ptr + 2
		ptr32 = ptr32 + 4
		i = i + 1
	if(i .lt. (24576 / 4)) goto 1
	end subroutine build_font32


	subroutine print_int(i)
	integer, intent(in) :: i
	call print_int16(ISHFT(i, -16))
C print_int16 ignores the 2 most significant bytes
	call print_int16(i)
	end subroutine print_int
	
	subroutine print_int16(i)
	integer(kind=4), intent(in) :: i
	integer k, j, s
	j = z'F000'
	do s = -12, 0, 4
		k = ISHFT(IAND(i, j), s)
		if(k .le. 9) then
			call putc(char(k + z'30'))
		else
			call putc(char(z'41' - 10 + k))
		endif
		j = ISHFT(j, -4)
	enddo
	end subroutine print_int16

C Since the least significant bits of each color cause little change, this should work...
	integer function color16to32(color)
	integer(kind=2), intent(in) :: color
	integer i, j, k
	i = IAND(ISHFT(color, -11), b'11111')
	j = IAND(ISHFT(color, -5), b'111111')
	k = IAND(color, b'11111')
	i = ISHFT(i, 3)
	j = ISHFT(j, 2)
	k = ISHFT(k, 3)
	i = ISHFT(i, 0)
	j = ISHFT(j, 8)
	k = ISHFT(k, 16)
	color16to32 = IOR(IOR(IOR(i, j), k), z'FF000000')
	end function color16to32
	end module print_console
