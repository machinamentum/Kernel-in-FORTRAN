C not implemented

	module mod_emmc

	integer, parameter :: EMMC_BASE = z'7E300000'
	integer, parameter :: EMMC_ARG2 = z'0'
	integer, parameter :: EMMC_BLKSIZECNT = z'4'
	integer, parameter :: EMMC_ARG1 = z'8'
	integer, parameter :: EMMC_CMDTM = z'C'
	integer, parameter :: EMMC_RESP0 = z'10'
	integer, parameter :: EMMC_RESP1 = z'14'
	integer, parameter :: EMMC_RESP2 = z'18'
	integer, parameter :: EMMC_RESP3 = z'1C'
	integer, parameter :: EMMC_DATA = z'20'
	integer, parameter :: EMMC_STATUS = z'24'
	integer, parameter :: EMMC_CONTROL0 = z'28'
	integer, parameter :: EMMC_CONTROL1 = z'2C'
	integer, parameter :: EMMC_INTERRUPT = z'30'
	integer, parameter :: EMMC_IRPT_MASK = z'34'
	integer, parameter :: EMMC_IRPT_EN = z'38'
	integer, parameter :: EMMC_CONTROL2 = z'3C'
	integer, parameter :: EMMC_FORCE_IRPT = z'50'
	integer, parameter :: EMMC_BOOT_TIMEOUT = z'70'
	integer, parameter :: EMMC_DBG_SEL = z'74'
	integer, parameter :: EMMC_EXRDFIFO_CFG = z'80'
	integer, parameter :: EMMC_EXRDFIFO_EN = z'84'
	integer, parameter :: EMMC_TUNE_STEP = z'88'
	integer, parameter :: EMMC_TUNE_STEPS_STD = z'8C'
	integer, parameter :: EMMC_TUNE_STEPS_DDR = z'90'
	integer, parameter :: EMMC_SPI_INT_SPT = z'F0'
	integer, parameter :: EMMC_SLOTISR_VER = z'FC'

	end module mod_emmc
