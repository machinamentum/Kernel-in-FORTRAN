

	module mod_GraphicsRenderer
	use mod_GraphicsRendererBackend

	type :: GraphicsRenderer
		type(FramebufferInfo), private :: framebuffer
		contains
	end type GraphicsRenderer

	interface GraphicsRenderer
		procedure gr_init
	end interface

	contains

	function gr_init(fb)
		type(FramebufferInfo) :: fb
		type(GraphicsRenderer) :: gr_init
		gr_init%framebuffer = fb
	end function gr_init



	end module mod_GraphicsRenderer

