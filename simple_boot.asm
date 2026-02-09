; Simplified Bootloader - Can be assembled with online tools
; Visit: https://carlosrafaelgn.com.br/Asm86/
; Or: https://www.tutorialspoint.com/compile_assembly_online.php

[BITS 16]
[ORG 0x7C00]

start:
    ; Clear screen
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    
    ; Print message
    mov si, msg
    call print_string
    
    ; Infinite loop
    jmp $

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string
done:
    ret

msg: db 'Hello from your bootloader!', 0x0D, 0x0A
     db 'This is running in 16-bit mode!', 0x0D, 0x0A
     db 'Kernel would load here...', 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xAA55
