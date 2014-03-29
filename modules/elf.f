#ifndef ELF_F
#define ELF_F




#define ELF_NIDENT	16

#define ELFMAG0		z'7F'
#define ELFMAG1		'E'
#define ELFMAG2		'L'
#define ELFMAG3		'F'

#define ELFDATA2LSB	(1) // Little Endian
#define ELFCLASS32	(1) // 32-bit arch


#define EM_NONE		(0)
#define EM_386		(3)
#define EM_ARM		(40)

#define EV_CURRENT	(1)




#ifdef __GFORTRAN__

#define Elf32_Half	integer(kind=2)
#define Elf32_Off	integer(kind=4)
#define Elf32_Addr	integer(kind=4)
#define Elf32_Word	integer(kind=4)
#define Elf32_Sword	integer(kind=4)

#ifndef __NO_MODULE__
	module mod_Elf32
#endif


	type :: Elf32_Ehdr
		integer(kind=1) :: e_ident(ELF_NIDENT)
		Elf32_Half :: e_type
		Elf32_Half :: e_machine
		Elf32_Word :: e_version
		Elf32_Addr :: e_entry
		Elf32_Off  :: e_phoff
		Elf32_Off  :: e_shoff
		Elf32_Word :: e_flags
		Elf32_Half :: e_ehsize
		Elf32_Half :: e_phentsize
		Elf32_Half :: e_phnum
		Elf32_Half :: e_shentsize
		Elf32_Half :: shnum
		Elf32_Half :: e_shstrndx
	end type Elf32_Ehdr


	enum, bind(c)
		enumerator :: EI_MAG0 =			1
		enumerator :: EI_MAG1 =			2
		enumerator :: EI_MAG2 =			3
		enumerator :: EI_MAG3 =			4
		enumerator :: EI_CLASS =		5
		enumerator :: EI_DATA =			6
		enumerator :: EI_VERSION =		7
		enumerator :: EI_OSABI =		8
		enumerator :: EI_ABIVERSION =	9
		enumerator :: EI_PAD =			10
	end enum


	enum, bind(c)
		enumerator :: ET_NONE =		0
		enumerator :: ET_REL =		1
		enumerator :: ET_EXEC =		2
		enumerator :: ET_DYN =		3
		enumerator :: ET_CORE =		4
	end enum

#ifndef __NO_FUNC_INTERFACE__
	interface
		logical function elf_check_file(hdr)
			import Elf32_Ehdr
			type(Elf32_Ehdr) :: hdr
		end function elf_check_file

		logical function elf_check_supported(hdr)
			import Elf32_Ehdr
			type(Elf32_Ehdr) :: hdr
		end function elf_check_supported

		subroutine elf_load_rel(hdr)
			import Elf32_Ehdr
			type(Elf32_Ehdr) :: hdr
		end subroutine elf_load_rel

		integer(kind=4) function elf_load_file(file)
			integer(kind=4) :: file
		end function elf_load_file


	end interface
#endif

#ifndef __NO_MODULE__
	end module mod_Elf32
#endif

#endif


#endif



