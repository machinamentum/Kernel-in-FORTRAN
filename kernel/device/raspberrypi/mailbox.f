
	module mailbox


	integer, parameter :: MB_BASE = z'2000B880'
	integer, parameter :: MB_WRITE = z'20'
	integer, parameter :: MB_READ = z'00'
	integer, parameter :: MB_STATUS = z'18'

C allocate 1 page of memory for mailbox buffering
	integer, parameter :: MB_MAX_BUFFER_SIZE = 4096

	integer :: mem_pool = 0


	contains

	subroutine mailbox_put32(loc, dat)
		integer, value :: loc
		integer, value :: dat
		integer(kind=4) :: ptr, wrptr
		pointer (ptr, wrptr)
		ptr = loc
		wrptr = dat
	end subroutine mailbox_put32

	subroutine mailbox_init()
		use memory
		if(mem_pool .eq. 0) then
			mem_pool = malloc(MB_MAX_BUFFER_SIZE)
		endif
	end subroutine mailbox_init

	integer function mailbox_get_videocore_firmware()
		use memory
		integer :: tag, size, req, ptr, wrptr
		pointer (ptr, wrptr)
		ptr = memset(mem_pool, 0, MB_MAX_BUFFER_SIZE)
		tag = z'00000001'
		size = 4
		req = 0
		wrptr = MB_MAX_BUFFER_SIZE
		ptr = ptr + 4
		wrptr = 0
		ptr = ptr + 4
		wrptr = tag
		ptr = ptr + 4
		wrptr = size
		ptr = ptr + 4
		wrptr = req
		ptr = ptr + 4
		wrptr = 0
		ptr = ptr + 4
		wrptr = 0
		call mailbox_write(int(IOR(mem_pool, z'40000000'), 4), 8)
2		continue
		i = mailbox_read(8)
		if(i .ne. 0) goto 2
		ptr = mem_pool + 4
/*		if(wrptr .eq. z'80000001') then
			call printstr("Got succes")
		else if(wrptr .eq. z'80000000') then
			call printstr("Got error")
		else
			call printstr("Got nothing?")
		endif */
		ptr = mem_pool + 4 + 4 + 4 + 4 + 4
		mailbox_get_videocore_firmware = wrptr
	end function mailbox_get_videocore_firmware

	subroutine mailbox_write(dat, channel)
	integer, intent(in) :: dat
	integer, intent(in) :: channel
	integer ptr
	integer mbase
	integer i
	pointer ( ptr, mbase )
	if (IAND(dat, b'1111') .ne. 0) then
C		call printstr("Error: dat is not 16-byte aligned")
	endif
	if(channel .gt. 15) return
	ptr = MB_BASE + MB_STATUS
1	continue
	i = mbase
	i = IAND(i, z'80000000')
	if(i .ne. 0) goto 1
	ptr = MB_BASE + MB_WRITE
	mbase = IOR(dat, channel)
	return
	end subroutine mailbox_write

	integer function mailbox_read(channel)
		integer, intent(in) :: channel
		integer dat
		integer ptr
		integer mbase	
		integer rptr
		integer rbase
		integer i, j
		pointer ( ptr, mbase )
		pointer ( rptr, rbase )
		if(channel .gt. 15) return
		ptr = MB_BASE + MB_STATUS
		rptr = MB_BASE + MB_READ
		do while(IAND(i, b'1111') .ne. channel)
			do while(IAND(j, z'40000000') .ne. 0)
				j = mbase
			enddo
			i = rbase
		enddo
		mailbox_read = IAND(rbase, z'fffffff0')
		return

	end function mailbox_read

	end module mailbox

