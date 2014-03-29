C high-ish level buffer/stream manipualtion code. Not tested, should work.

	module class_Stream

	integer, parameter :: STREAM_SEEK_BEGIN =	 0
	integer, parameter :: STREAM_SEEK_END =		-1

	type :: Stream
		integer(kind=4) :: pBuffer
		integer(kind=4) :: bSize
		integer(kind=4) :: bPos
	contains
		procedure, private :: streamInsertOp_int64, streamInsertOp_int32, streamInsertOp_int16, streamInsertOp_int8, streamInsertOp_real, streamInsertOp_double
		procedure, private :: streamWrite_int64, streamWrite_int32, streamWrite_int16, streamWrite_int8, streamWrite_real, streamWrite_double
		generic :: write => streamWrite_int64, streamWrite_int32, streamWrite_int16, streamWrite_int8, streamWrite_real, streamWrite_double
		generic :: operator(.ins.) => streamInsertOp_int64, streamInsertOp_int32, streamInsertOp_int16, streamInsertOp_int8, streamInsertOp_real, streamInsertOp_double
C		generic :: operator(.ext.) =>
		procedure :: seek => streamSeek

	end type Stream

	private

	public :: Stream

	contains

		subroutine PUT64(loc, dat)
			integer(kind=4), value :: loc
			integer(kind=8), value :: dat
			integer(kind=4) :: val
			val = IAND(ISHFT(dat, -32), z'FFFFFFFF')
			call PUT32(loc, val)
			val = IAND(dat, z'FFFFFFFF')
			call PUT32(loc + 4, val)
		end subroutine PUT64

		subroutine PUT32(loc, dat)
			integer(kind=4), value :: loc, dat
			integer(kind=4) :: ptr, wrptr
			pointer (ptr, wrptr)
			ptr = loc
			wrptr = dat
		end subroutine PUT32

		subroutine PUT16(loc, dat)
			integer(kind=4), value :: loc
			integer(kind=2), value :: dat
			integer(kind=4) :: ptr
			integer(kind=2) :: wrptr
			pointer (ptr, wrptr)
			ptr = loc
			wrptr = dat
		end subroutine PUT16

		subroutine PUT8(loc, dat)
			integer(kind=4), value :: loc
			integer(kind=1), value :: dat
			integer(kind=4) :: ptr
			integer(kind=1) :: wrptr
			pointer (ptr, wrptr)
			ptr = loc
			wrptr = dat
		end subroutine PUT8

		subroutine PUT_REAL(loc, dat)
			integer(kind=4), value :: loc
			real(kind=4), value :: dat
			integer(kind=4) :: ptr
			real(kind=4) :: wrptr
			pointer (ptr, wrptr)
			ptr = loc
			wrptr = dat
		end subroutine PUT_REAL

		subroutine PUT_DOUBLE(loc, dat)
			integer(kind=4), value :: loc
			real(kind=8), value :: dat
			integer(kind=4) :: ptr
			real(kind=8) :: wrptr
			pointer (ptr, wrptr)
			ptr = loc
			wrptr = dat
		end subroutine PUT_DOUBLE

		function GET8(loc)
			integer(kind=4), value :: loc
			integer(kind=4) :: ptr
			integer(kind=1) :: GET8, rptr
			pointer (ptr, rptr)
			ptr = loc
			GET8 = rptr
		end function GET8

		function GET16(loc)
		integer(kind=4), value :: loc
		integer(kind=4) :: ptr
		integer(kind=2) :: GET16, rptr
		pointer (ptr, rptr)
		ptr = loc
		GET16 = rptr
		end function GET16

		function GET32(loc)
			integer(kind=4), value :: loc
			integer(kind=4) :: ptr
			integer(kind=4) :: GET32, rptr
			pointer (ptr, rptr)
			ptr = loc
			GET32 = rptr
		end function GET32

		function GET64(loc)
			integer(kind=4), value :: loc
			integer(kind=8) :: GET64
			GET64 = IOR(ISHFT(int(GET32(loc), 8), 32), GET32(loc + 4))
		end function GET64

		subroutine streamWrite_int8(this, dat)
			class(Stream) :: this
			integer(kind=1) :: dat
			if(this%bPos + sizeof(dat) .ge. this%bSize) then
C Error
				return
			endif
			call PUT8(this%pBuffer + this%bPos, dat)
			this%bPos = this%bPos + sizeof(dat)
		end subroutine streamWrite_int8

		subroutine streamWrite_int16(this, dat)
			class(Stream) :: this
			integer(kind=2) :: dat
			if(this%bPos + sizeof(dat) .ge. this%bSize) then
C Error
				return
			endif
			call PUT16(this%pBuffer + this%bPos, dat)
			this%bPos = this%bPos + sizeof(dat)
		end subroutine streamWrite_int16

		subroutine streamWrite_int32(this, dat)
			class(Stream) :: this
			integer(kind=4) :: dat
			if(this%bPos + sizeof(dat) .ge. this%bSize) then
C Error
				return
			endif
			call PUT32(this%pBuffer + this%bPos, dat)
			this%bPos = this%bPos + sizeof(dat)
		end subroutine streamWrite_int32

		subroutine streamWrite_int64(this, dat)
			class(Stream) :: this
			integer(kind=8) :: dat
			if(this%bPos + sizeof(dat) .ge. this%bSize) then
C Error
				return
			endif
			call PUT64(this%pBuffer + this%bPos, dat)
			this%bPos = this%bPos + sizeof(dat)
		end subroutine streamWrite_int64

		subroutine streamWrite_real(this, dat)
			class(Stream) :: this
			real(kind=4) :: dat
			if(this%bPos + sizeof(dat) .ge. this%bSize) then
C Error
				return
			endif
			call PUT_REAL(this%pBuffer + this%bPos, dat)
			this%bPos = this%bPos + sizeof(dat)
		end subroutine streamWrite_real

		subroutine streamWrite_double(this, dat)
			class(Stream) :: this
			real(kind=8) :: dat
			if(this%bPos + sizeof(dat) .ge. this%bSize) then
C Error
				return
			endif
			call PUT_DOUBLE(this%pBuffer + this%bPos, dat)
			this%bPos = this%bPos + sizeof(dat)
		end subroutine streamWrite_double

		function streamInsertOp_int64(this, dat)
			class(Stream), intent(in), target :: this
			integer(kind=8), intent(in) :: dat
			class(Stream), pointer :: streamInsertOp_int64
			call this%write(dat)
			streamInsertOp_int64 => this
		end function streamInsertOp_int64

		function streamInsertOp_int32(this, dat)
				class(Stream), intent(in), target :: this
				integer(kind=4), intent(in) :: dat
				class(Stream), pointer :: streamInsertOp_int32
				call this%write(dat)
				streamInsertOp_int32 => this
		end function streamInsertOp_int32

		function streamInsertOp_int16(this, dat)
			class(Stream), intent(in), target :: this
			integer(kind=2), intent(in) :: dat
			class(Stream), pointer :: streamInsertOp_int16
			call this%write(dat)
			streamInsertOp_int16 => this
		end function streamInsertOp_int16

		function streamInsertOp_int8(this, dat)
			class(Stream), intent(in), target :: this
			integer(kind=1), intent(in) :: dat
			class(Stream), pointer :: streamInsertOp_int8
			call this%write(dat)
			streamInsertOp_int8 => this
		end function streamInsertOp_int8

		function streamInsertOp_real(this, dat)
			class(Stream), intent(in), target :: this
			real(kind=4), intent(in) :: dat
			class(Stream), pointer :: streamInsertOp_real
			call this%write(dat)
			streamInsertOp_real => this
		end function streamInsertOp_real

		function streamInsertOp_double(this, dat)
			class(Stream), intent(in), target :: this
			real(kind=8), intent(in) :: dat
			class(Stream), pointer :: streamInsertOp_double
			call this%write(dat)
			streamInsertOp_double => this
		end function streamInsertOp_double

		subroutine streamSeek(this, pos)
			class(Stream) :: this
			integer(kind=4), value :: pos
			if(pos .eq. STREAM_SEEK_END) then
				this%bPos = this%bSize
				return
			endif
			if(pos .lt. -1) then
C Error
				return
			endif
			if(pos .gt. this%bSize) then
C Error
				return
			endif
			this%bPos = pos
		end subroutine streamSeek

	end module class_Stream

