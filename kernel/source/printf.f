

	integer(c_int) function strlen(st) bind(c)
		use iso_c_binding
		character(c_char) :: st
		integer(kind=4) :: ptr
		integer(kind=1) :: wrptr
		pointer (ptr, wrptr)
		ptr = loc(st)
		do while (wrptr .ne. 0)
			ptr = ptr + 1
		enddo
		strlen = ptr - loc(st)
		return
	end function

	subroutine printstr(st)
		use iso_c_binding
		use print_console
		implicit none
		character(c_char) :: st
		integer(kind=4) :: ptr
		integer(kind=1) :: wrptr
		pointer (ptr, wrptr)
		ptr = loc(st)
		do while(wrptr .ne. 0)
			call putc(char(wrptr))
			ptr = ptr + 1
		enddo
	end subroutine

