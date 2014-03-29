C BCM2835 watchdog controller based on dwelch67's wdog implementation
	module watchdog

	integer(kind=4), parameter :: PM_BASE = z'20100000'
	integer(kind=4), parameter :: PM_RSTC = PM_BASE + z'1c'
	integer(kind=4), parameter :: PM_WDOG = PM_BASE + z'24'
	integer(kind=4), parameter :: PM_WDOG_RESET = z'0000000000'
	integer(kind=4), parameter :: PM_PASSWORD = z'5a000000'
	integer(kind=4), parameter :: PM_WDOG_TIME_SET = z'000fffff'
	integer(kind=4), parameter :: PM_RSTC_WRCFG_CLR = z'ffffffcf'
	integer(kind=4), parameter :: PM_RSTC_WRCFG_SET = z'00000030'
	integer(kind=4), parameter :: PM_RSTC_WRCFG_FULL_RESET  = z'00000020'
	integer(kind=4), parameter :: PM_RSTC_RESET = z'00000102'


	contains
	subroutine watchdog_start(timeout)
	integer, intent(in) :: timeout
	integer rstc, wdog
	integer ptr
	integer rstat
	POINTER ( ptr, rstat )
	ptr = PM_RSTC
	rstc = rstat
	wdog = IOR(PM_PASSWORD, IAND(timeout, PM_WDOG_TIME_SET))
	rstc = IOR(IOR(PM_PASSWORD, IAND(rstc, PM_RSTC_WRCFG_CLR)), PM_RSTC_WRCFG_FULL_RESET)
	ptr = PM_WDOG
	rstat = wdog
	ptr = PM_RSTC
	rstat = rstc
	end subroutine watchdog_start

	integer function watchdog_get_remaining()
	integer ptr, rptr, i
	pointer (ptr, rptr)
	ptr = PM_WDOG
	i = rptr
	watchdog_get_remaining = IAND(i, PM_WDOG_TIME_SET)
	end function watchdog_get_remaining
	
	end module watchdog

