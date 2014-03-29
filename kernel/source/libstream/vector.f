C high level Vector container, not implemented.

	module class_Vector


	type :: Vector


	end type Vector

	interface Vector

	end interface Vector


	contains

		function new_Vector(tsize, cap)
			integer, value :: tsize, cap
			type(Vector) :: new_Vector

		end function new_Vector



	end module class_Vector

