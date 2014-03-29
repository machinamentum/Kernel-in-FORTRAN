

	module memory
	use iso_c_binding

	integer(c_int), bind(c,name='the_heap_start_') :: the_heap_start

	integer, parameter :: MEMORY_PAGE_SIZE = 4096

	integer, private :: heap_ptr = 0

	interface
		subroutine memcpy(dst, src, num) bind(c,name='memcpy')
			use iso_c_binding
			integer(c_int), value :: dst
			integer(c_int), value :: src
			integer(c_int), value :: num
		end subroutine memcpy
	end interface

	contains

/*	subroutine memcpy(dst, src, num) bind(c,name='memcpy')
		use iso_c_binding
		integer(c_int), value :: dst
		integer(c_int), value :: src
		integer(c_int), value :: num
		integer dptr, sptr, k
		integer(kind=1) i, j
		pointer (sptr,i)
		pointer (dptr,j)
C implemented using conditionals and gotos just in case GCC optimizes the loop to garbage
		dptr = dst
		sptr = src
		k = 0
		do while(k .lt. num)
			j = i
			sptr = sptr + 1
			dptr = dptr + 1
			k = k + 1
		end do
	end subroutine memcpy */

C always returns a pointer that aligns to page boundaries
	function malloc(size) bind(c,name='malloc')
		use iso_c_binding
		implicit none
		integer(c_int), value :: size
		integer(c_int) :: malloc
		if(heap_ptr .eq. 0) then
C aligns the beginning of the memory heap to page boundaries
			heap_ptr = IAND(the_heap_start, z'fffff000') + MEMORY_PAGE_SIZE
		endif
		malloc = heap_ptr
		heap_ptr = heap_ptr + ((size / MEMORY_PAGE_SIZE) * MEMORY_PAGE_SIZE)
		if(mod(size, MEMORY_PAGE_SIZE) .ne. 0) then
			heap_ptr = heap_ptr + MEMORY_PAGE_SIZE
		endif
	end function malloc

	subroutine free(ptr) bind(c,name='free')
		use iso_c_binding
		integer(c_int), value :: ptr
C meh
	end subroutine free

	integer(c_int) function memset(ptr, value, num) bind(c,name='memset')
		use iso_c_binding
		integer(c_int), value :: ptr, value, num
		integer :: i
		integer(kind=1) :: wrptr
		pointer (i, wrptr)
		do i = ptr, ptr + num, 1
			wrptr = int(value, 1)
		enddo
		memset = ptr
	end function memset

	end module memory
