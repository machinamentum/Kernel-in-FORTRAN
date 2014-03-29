

	subroutine init_fb(width, height, bitdepth, fbin)
	use mod_framebuffer
	integer, intent(in) :: width
	integer, intent(in) :: height
	integer, intent(in) :: bitdepth
	integer, intent(in) :: fbin
	TYPE(FramebufferInfo) :: finf
	pointer ( fbin, finf )

	if(width .gt. 4096) return
	if(height .gt. 4096) return
	if(bitdepth .gt. 32) return

	finf%width = 800
	finf%height = 1280
	finf%vwidth = 800
	finf%vheight = 1280
	finf%pitch = (800 * 4)
	finf%bitdepth = 32
	finf%x = 0
	finf%y = 0
	finf%ptr = z'abe01000'
	finf%sizet = (800 * 1280 * 4)

	return
	end subroutine init_fb
