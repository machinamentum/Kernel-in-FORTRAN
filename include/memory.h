#ifdef __GFORTRAN__

	interface
		subroutine memcpy(dst, src, num) bind(c,name='memcpy')
			use iso_c_binding
			integer(c_int), value :: dst
			integer(c_int), value :: src
			integer(c_int), value :: num
		end subroutine memcpy

		function malloc(size) bind(c,name='malloc')
			use iso_c_binding
			implicit none
			integer(c_int), value :: size
			integer(c_int) :: malloc
		end function malloc

		subroutine free(ptr) bind(c,name='free')
			use iso_c_binding
			integer(c_int), value :: ptr
		end subroutine free

		integer(c_int) function memset(ptr, value, num) bind(c,name='memset')
			use iso_c_binding
			integer(c_int), value :: ptr, value, num
		end function memset
	end interface



#endif
