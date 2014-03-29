

	module class_KernelDriver

	type, abstract :: KernelDriver

		contains
			procedure, overridable :: init => KDInit

	end type KernelDriver

	private

	contains
		subroutine KDInit()
C Method stub
		end subroutine KDInit()

	end module class_KernelDriver
