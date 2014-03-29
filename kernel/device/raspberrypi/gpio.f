
	module gpio

	integer, parameter :: GPIO_BASE = z'20200000'
	integer, parameter :: GPIO_PIN_OUTPUT_SET = z'1C'
	integer, parameter :: GPIO_PIN_OUTPUT_CLEAR = z'28'
	integer, parameter :: GPIO_PIN_LEVEL = z'34'

	contains

	subroutine gpio_set_pin_high(pin)
	integer, intent(in) :: pin
	integer ptr
	integer V
	POINTER ( ptr, V )
	ptr = GPIO_BASE + GPIO_PIN_OUTPUT_SET
	V = ISHFT(1, pin)
	end subroutine gpio_set_pin_high

	subroutine gpio_set_pin_low(pin)
	integer, intent(in) :: pin
	integer ptr
	integer V
	POINTER ( ptr, V )
	ptr = GPIO_BASE + GPIO_PIN_OUTPUT_CLEAR
	V = ISHFT(1, pin)
	end subroutine gpio_set_pin_low

	integer function gpio_read_pin(pin)
	integer, intent(in) :: pin
	integer ptr
	integer V
	POINTER (ptr, V)
	ptr = GPIO_BASE + GPIO_PIN_LEVEL
	gpio_read_pin = IAND(ISHFT(V, -pin), z'01')
	end function gpio_read_pin

	subroutine gpio_set_pin_func(pin, func)
	integer, intent(in) :: pin
	integer, intent(in) :: func
	integer ptr
	integer V
	integer off
	POINTER ( ptr, V )
	off = (pin / 10) * 4
	
	
	ptr = z'20200000' + off
	V = ISHFT(func, modulo(pin, 10) * 3)
	end subroutine gpio_set_pin_func

	
	end module gpio
