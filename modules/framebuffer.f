#ifndef FRAMEBUFFER_F
#define FRAMEBUFFER_F

#ifdef __GFORTRAN__

	module mod_Framebuffer

	TYPE :: FramebufferInfo
		integer :: width
		integer :: height
		integer :: vwidth
		integer :: vheight
		integer :: pitch
		integer :: bitdepth
		integer :: x
		integer :: y
		integer :: ptr
		integer :: sizet
	END TYPE FramebufferInfo

	end module mod_Framebuffer


#endif


#endif
