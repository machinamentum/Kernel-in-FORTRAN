

	subroutine init_fb(width, height, bitdepth, fbin)
	use mailbox
	use mod_framebuffer
	integer, intent(in) :: width
	integer, intent(in) :: height
	integer, intent(in) :: bitdepth
	integer, intent(in) :: fbin
	integer ret
	TYPE(FramebufferInfo) :: finf
	pointer ( fbin, finf )

	if(width .gt. 4096) return
	if(height .gt. 4096) return
	if(bitdepth .gt. 32) return

	finf%width = width
	finf%height = height
	finf%vwidth = width
	finf%vheight = height
	finf%pitch = 0
	finf%bitdepth = bitdepth
	finf%x = 0
	finf%y = 0
	finf%ptr = 0
	finf%sizet = 0
	ret = fbin + z'40000000'
	call mailbox_write(ret, 1)
	ret = z'ff'
2	continue
	ret = mailbox_read(1)
	if(ret .ne. 0) goto 2
	return
	end subroutine init_fb
