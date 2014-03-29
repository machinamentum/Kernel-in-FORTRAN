ENTRY(_start)
 
SECTIONS
{
    /* Starts at LOADER_ADDR. */
    _stack_start = 0x81000000;
    . = 0x80a00800;
    _start = .;
    _text_start = .;
    .text :
    {
        KEEP(*(.text.boot))
        *(.text)
    }
    . = ALIGN(4096); /* align to page size */
    _text_end = .;
 
    _rodata_start = .;
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096); /* align to page size */
    _rodata_end = .;
    _data_start = .;
    .data :
    {
	. = ALIGN(16);
        *(.data)
    }
    . = ALIGN(4096); /* align to page size */
    _data_end = .;
 
    _bss_start = .;
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096); /* align to page size */
    _bss_end = .;
    _end = .;
    end = .;

}