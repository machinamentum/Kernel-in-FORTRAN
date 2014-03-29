

	module mod_UsbOtg

	integer(kind=1), parameter :: OTG_ADP_BIT = b'00000100'
	integer(kind=1), parameter :: OTG_HNP_BIT = b'00000010'
	integer(kind=1), parameter :: OTG_SRP_BIT = b'00000001'

	type :: OtgDesc
		integer(kind=1) :: bLength
		integer(kind=1) :: bDescriptorType
		integer(kind=1) :: bmAttributes
		integer(kind=2) :: bcdOTG
	end type OtgDesc

	contains



	end module mod_UsbOtg

