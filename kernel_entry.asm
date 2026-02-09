; Kernel Entry Point
; This is the first code that runs in the kernel
; It calls the main C function

[BITS 32]           ; We're in 32-bit protected mode
[EXTERN kernel_main] ; kernel_main is defined in kernel.c

global _start       ; Make _start visible to linker

_start:
    ; The bootloader has already set up:
    ; - Protected mode
    ; - GDT
    ; - Stack at 0x90000
    
    ; Call the C kernel main function
    call kernel_main
    
    ; If kernel_main returns, halt
    cli             ; Disable interrupts
    hlt             ; Halt the CPU
    jmp $           ; Infinite loop as backup
