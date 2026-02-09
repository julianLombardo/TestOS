/* Linker script for the kernel */

ENTRY(_start)           /* Entry point is _start from kernel_entry.asm */

SECTIONS
{
    /* Kernel loads at 0x1000 (4KB) */
    . = 0x1000;
    
    /* Code section */
    .text : ALIGN(4096)
    {
        *(.text)
    }
    
    /* Read-only data section */
    .rodata : ALIGN(4096)
    {
        *(.rodata)
    }
    
    /* Initialized data section */
    .data : ALIGN(4096)
    {
        *(.data)
    }
    
    /* Uninitialized data section */
    .bss : ALIGN(4096)
    {
        *(COMMON)
        *(.bss)
    }
}
