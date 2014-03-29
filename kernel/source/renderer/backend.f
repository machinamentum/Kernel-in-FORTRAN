

	module mod_GraphicsRendererBackend
	use mod_Framebuffer

	private :: color16to32

	type :: iVec2
		integer :: x, y
	contains
	procedure :: dot => ivec2_dot
	end type iVec2

	contains

	integer function ivec2_dot(this, other)
		class(iVec2) :: this, other
		ivec2_dot = (this%x * other%x) + (this%y * other%y)
	end function ivec2_dot

	subroutine grPutPixel(fb, x, y, color)
		type(FramebufferInfo) :: fb
		integer, value :: x, y
		integer(kind=2), value :: color
		if(fb%bitdepth .eq. 32) then
			call grPutPixel32(fb, x, y, color16to32(color))
		else
			call grPutPixel16(fb, x, y, color)
		endif
	end subroutine grPutPixel

	subroutine grPutPixel16(fb, x, y, color)
		type(FramebufferInfo) :: fb
		integer, value :: x, y
		integer(kind=2), value :: color
		integer(kind=2) :: wrptr
		integer :: ptr
		pointer (ptr, wrptr)
		ptr = fb%ptr + (x * 2) + (y * fb%pitch)
		wrptr = color
	end subroutine grPutPixel16

	subroutine grPutPixel32(fb, x, y, color)
		type(FramebufferInfo) :: fb
		integer, value :: x, y, color
		integer(kind=4) :: wrptr
		integer :: ptr
		pointer (ptr, wrptr)
		ptr = fb%ptr + (x * 4) + (y * fb%pitch)
		wrptr = color
	end subroutine grPutPixel32

	subroutine grFillRect(fb, x, y, width, height, color)
		type(FramebufferInfo) :: fb
		integer, value :: x, y, width, height
		integer(kind=2), value :: color
		do j = 0, height, 1
			do i = 0, width, 1
				call grPutPixel(fb, x + i, y + j, color)
			enddo
		enddo
	end subroutine grFillRect

	subroutine grFillTriangle(fb, p0, p1, p2, color)
		type(FramebufferInfo) :: fb
		type(iVec2) :: p0, p1, p2
		integer(kind=2), value :: color
		integer :: x, y, width, height
		type(iVec2) :: temp
		x = min(p0%x, p1%x, p2%x)
		y = min(p0%y, p1%y, p2%y)
		width = max(p0%x, p1%x, p2%x)
		height = max(p0%y, p1%y, p2%y)

		do j = 0, height, 1
			do i = 0, width, 1
				if(grPointLiesInTriangle2D(iVec2(x + i, y + j), p0, p1, p2)) then
					call grPutPixel(fb, x + i, y + j, color)
				endif
			enddo
		enddo
	end subroutine grFillTriangle

	logical function grPointLiesInTriangle2D(p, p0, p1, p2)
		type(iVec2) :: p0, p1, p2, p
		type(iVec2) :: v1, v2, v3
		type(iVec2) :: v1p, v2p, v3p

		v1 = iVec2(p1%y - p0%y, -p1%x + p0%x)
		v2 = iVec2(p2%y - p1%y, -p2%x + p1%x)
		v3 = iVec2(p0%y - p2%y, -p0%x + p2%x)

		v1p = iVec2(p%x - p0%x, p%y - p0%y)
		v2p = iVec2(p%x - p1%x, p%y - p1%y)
		v3p = iVec2(p%x - p2%x, p%y - p2%y)
		grPointLiesInTriangle2D = (0 .le. v1%dot(v1p)) .and. (0 .le. v2%dot(v2p)) .and. (0 .le. v3%dot(v3p))
	end function grPointLiesInTriangle2D


	integer function color16to32(color)
		integer(kind=2), intent(in), value :: color
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
		color16to32 = IOR(IOR(IOR(i, j), k), z'00000000')
	end function color16to32

	end module mod_GraphicsRendererBackend
