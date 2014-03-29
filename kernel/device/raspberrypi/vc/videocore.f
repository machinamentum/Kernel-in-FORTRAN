C doesnt work in the slightest, not fully implemented, broken.

	module mod_VideoCore

	private

	integer, parameter :: VC_BCM2835_BASE =		z'20C00000'
	integer, parameter :: VC_BCM21553_BASE =	z'08950000'
	integer, parameter :: VC_BCM21654_BASE =	z'3C00B000'
	integer, parameter :: CM_V3DCTL =			z'20101038'
	integer, parameter :: PM_GRAFX =			z'2010010C'
	integer, parameter :: PM_GRAFX_RESET =		z'00001000'
	integer, parameter :: PM_GRAFX_MASK =		z'007f107f'
	integer, parameter :: PM_GRAFX_ENABLE_SET = z'00001000'
	integer, parameter :: PM_GRAFX_V3DRSTN_SET =z'00000040'
	integer, parameter :: PM_GRAFX_V3DRSTN_CLR =z'ffffffbf'
	integer(kind=4), parameter :: PM_PASSWORD = z'5a000000'


/*
 * Note: All VideoCore registers are 32 bits wide.
*/

	integer, parameter :: V3D_IDENT0 =		z'00000'
	integer, parameter :: V3D_IDENT1 =		z'00004'
	integer, parameter :: V3D_IDENT2 =		z'00008'
	integer, parameter :: V3D_SCRATCH =	z'00010'
	integer, parameter :: V3D_L2CACTL =	z'00020'
	integer, parameter :: V3D_SLCACTL =	z'00024'
	integer, parameter :: V3D_INTCTL =		z'00030'
	integer, parameter :: V3D_INTENA =		z'00034'
	integer, parameter :: V3D_INTDIS =		z'00038'
	integer, parameter :: V3D_CT0CS =		z'00100'
	integer, parameter :: V3D_CT1CS =		z'00104'
	integer, parameter :: V3D_CT0EA =		z'00108'
	integer, parameter :: V3D_CT1EA =		z'0010C'
	integer, parameter :: V3D_CT0CA =		z'00110'
	integer, parameter :: V3D_CT1CA =		z'00114'
	integer, parameter :: V3D_CT00RA0 =	z'00118'
	integer, parameter :: V3D_CT01RA0 =	z'0011C'
	integer, parameter :: V3D_CT0LC =		z'00120'
	integer, parameter :: V3D_CT1LC =		z'00124'
	integer, parameter :: V3D_CT0PC =		z'00128'
	integer, parameter :: V3D_CT1PC =		z'0012C'
	integer, parameter :: V3D_PCS =		z'00130'
	integer, parameter :: V3D_BFC =		z'00134'
	integer, parameter :: V3D_RFC =		z'00138'
	integer, parameter :: V3D_BPCA =		z'00300'
	integer, parameter :: V3D_BPCS =		z'00304'
	integer, parameter :: V3D_BPOA =		z'00308'
	integer, parameter :: V3D_BPOS =		z'0030C'
	integer, parameter :: V3D_BXCF =		z'00310'
	integer, parameter :: V3D_SQRSV0 =		z'00410'
	integer, parameter :: V3D_SQRSV1 =		z'00414'
	integer, parameter :: V3D_SQCNTL =		z'00418'
	integer, parameter :: V3D_SRQPC =		z'00430'
	integer, parameter :: V3D_SRQUA =		z'00434'
	integer, parameter :: V3D_SRQUL =		z'00438'
	integer, parameter :: V3D_SRQCS =		z'0043C'
	integer, parameter :: V3D_VPACNTL =	z'00500'
	integer, parameter :: V3D_VPMBASE =	z'00504'
	integer, parameter :: V3D_PCTRC =		z'00670'
	integer, parameter :: V3D_PCTRE =		z'00674'
	integer, parameter :: V3D_PCTR0 =		z'00680'
	integer, parameter :: V3D_PCTRS0 =		z'00684'
	integer, parameter :: V3D_PCTR1 =		z'00688'
	integer, parameter :: V3D_PCTRS1 =		z'0068C'
	integer, parameter :: V3D_PCTR2 =		z'00690'
	integer, parameter :: V3D_PCTRS2 =		z'00694'
	integer, parameter :: V3D_PCTR3 =		z'00698'
	integer, parameter :: V3D_PCTRS3 =		z'0069C'
	integer, parameter :: V3D_PCTR4 =		z'006A0'
	integer, parameter :: V3D_PCTRS4 =		z'006A4'
	integer, parameter :: V3D_PCTR5 =		z'006A8'
	integer, parameter :: V3D_PCTRS5 =		z'006AC'
	integer, parameter :: V3D_PCTR6 =		z'006B0'
	integer, parameter :: V3D_PCTRS6 =		z'006B4'
	integer, parameter :: V3D_PCTR7 =		z'006B8'
	integer, parameter :: V3D_PCTRS7 =		z'006BC'
	integer, parameter :: V3D_PCTR8 =		z'006C0'
	integer, parameter :: V3D_PCTRS8 =		z'006C4'
	integer, parameter :: V3D_PCTR9 =		z'006C8'
	integer, parameter :: V3D_PCTRS9 =		z'006CC'
	integer, parameter :: V3D_PCTR10 =		z'006D0'
	integer, parameter :: V3D_PCTRS10 =	z'006D4'
	integer, parameter :: V3D_PCTR11 =		z'006D8'
	integer, parameter :: V3D_PCTRS11 =	z'006DC'
	integer, parameter :: V3D_PCTR12 =		z'006E0'
	integer, parameter :: V3D_PCTRS12 =	z'006E4'
	integer, parameter :: V3D_PCTR13 =		z'006E8'
	integer, parameter :: V3D_PCTRS13 =	z'006EC'
	integer, parameter :: V3D_PCTR14 =		z'006F0'
	integer, parameter :: V3D_PCTRS14 =	z'006F4'
	integer, parameter :: V3D_PCTR15 =		z'006F8'
	integer, parameter :: V3D_PCTRS15 =	z'006FC'
	integer, parameter :: V3D_DBGE =		z'00F00'
	integer, parameter :: V3D_FDBGO =		z'00F04'
	integer, parameter :: V3D_FDBGB =		z'00F08'
	integer, parameter :: V3D_FDBGR =		z'00F0C'
	integer, parameter :: V3D_FDBGS =		z'00F10'
	integer, parameter :: V3D_ERRSTAT =	z'00F20'


	integer :: my_malloc_ptr = 0

	public :: clear_color
	public :: vc_power_on

	contains

		subroutine vc_reset()
			integer(kind=4) :: ptr, wrptr
C stop AXI interface (not sure if necessary this early in boot)

C Disable clock (set to 0)
			call vc_setup_clk(0)

			i = 32
			do while(i .gt. 0)
				i = i - 1
				i = i
			enddo
			ptr = PM_GRAFX
			wrptr = IOR(PM_PASSWORD, IAND(PM_GRAFX, PM_GRAFX_V3DRSTN_CLR) )
			i = 32
			do while(i .gt. 0)
				i = i - 1
				i = i
			enddo
			call vc_setup_clk(250 * 1000 * 1000)
C Enable AXI

			do while(i .gt. 0)
				i = i - 1
				i = i
			enddo

			call vc_setup_clk(0)
			do while(i .gt. 0)
				i = i - 1
				i = i
			enddo

			wrptr = IOR(IOR(wrptr, PM_PASSWORD), PM_GRAFX_V3DRSTN_SET)

			do while(i .gt. 0)
				i = i - 1
				i = i
			enddo

			call vc_setup_clk(250 * 1000 * 1000)
		end subroutine vc_reset

		subroutine vc_setup_clk(freq)
			integer, value :: freq

		end subroutine vc_setup_clk

		subroutine vc_power_on()
			integer(kind=4) :: ptr, wrptr
			pointer (ptr, wrptr)
			ptr = PM_GRAFX
			if(IAND(wrptr, PM_GRAFX_V3DRSTN_SET) .ne. 0) then
				call vc_reset()
			endif
C cfg VPMBASE here


		end subroutine vc_power_on

		subroutine clear_color(fbptr, width, height, color)
			use memory
			implicit none
			integer(kind=4), intent(in) :: fbptr, color
			integer(kind=2), intent(in) :: width, height
			integer(kind=1) :: wrb
			integer(kind=4) :: buff, wri, dst, wrdst, i, j
			integer(kind=2) :: wrs
			pointer (buff, wrb)
			pointer (buff, wri)
			pointer (dst, wrdst)
			if(my_malloc_ptr .eq. 0) then
				my_malloc_ptr = malloc(64)
			endif
			buff = my_malloc_ptr
			wri = color
			buff = buff + 4
			wri = color
			buff = buff + 4
			wri = 0
			buff = buff + 4
			wrb = 0
			buff = buff + 1
			wri = fbptr
			buff = buff + 4
			wrs = width
			buff = buff + 2
			wrs = height
			buff = buff + 2
			wrb = b'00001000'
			buff = buff + 1
			buff = buff + 1

			dst = IOR(VC_BCM2835_BASE, V3D_CT1CA)
			wrdst = my_malloc_ptr
C set to stop at halt


			dst = IOR(VC_BCM2835_BASE, V3D_CT1EA)
			wrdst = buff

			dst = IOR(VC_BCM2835_BASE, V3D_CT1CS)
C			wrdst = b'0000000000010000'


			buff = IOR(VC_BCM2835_BASE, V3D_CT1CA)
			dst = IOR(VC_BCM2835_BASE, V3D_CT1EA)
			i = wri
			j = wrdst
1			continue
				i = wri
				j = wrdst
			if(i .ne. j) goto 1

		end subroutine clear_color


	end module mod_VideoCore


