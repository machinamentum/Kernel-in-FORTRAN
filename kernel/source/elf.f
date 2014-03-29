
	module mod_elf32

#define __NO_MODULE__
#define __NO_FUNC_INTERFACE__
#include <elf.f>

	contains

	logical function elf_check_file(hdr)
		type(Elf32_Ehdr) :: hdr
C		logical :: elf_check_file
		if(hdr%e_ident(EI_MAG0) .ne. ELFMAG0) then
			elf_check_file = .false.
			return
		endif
		elf_check_file = .true.
		return
	end function elf_check_file


	end module mod_elf32
