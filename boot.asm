; Simple Bootloader - Loads kernel from disk and jumps to it
; Compiles to 512 bytes and sits in the boot sector

[BITS 16]           ; We start in 16-bit real mode
[ORG 0x7C00]        ; BIOS loads bootloader at 0x7C00

KERNEL_OFFSET equ 0x1000  ; Load kernel at 1MB mark

start:
    ; Set up segments
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00      ; Stack grows downward from bootloader

    ; Print loading message
    mov si, msg_loading
    call print_string

    ; Load kernel from disk
    call load_kernel

    ; Switch to protected mode
    call switch_to_pm

    ; Should never reach here
    jmp $

;=============================================================================
; Load kernel from disk using BIOS interrupt
;=============================================================================
load_kernel:
    mov bx, KERNEL_OFFSET   ; Read to this address
    mov dh, 15              ; Read 15 sectors (adjust as needed)
    mov dl, [BOOT_DRIVE]    ; Drive number
    
    mov ah, 0x02            ; BIOS read sector function
    mov al, dh              ; Number of sectors to read
    mov ch, 0x00            ; Cylinder 0
    mov cl, 0x02            ; Start from sector 2 (sector 1 is boot sector)
    mov dh, 0x00            ; Head 0
    
    int 0x13                ; Call BIOS disk interrupt
    
    jc disk_error           ; Jump if carry flag set (error)
    
    mov si, msg_loaded
    call print_string
    ret

disk_error:
    mov si, msg_disk_error
    call print_string
    jmp $

;=============================================================================
; Print string (SI points to null-terminated string)
;=============================================================================
print_string:
    pusha
.loop:
    lodsb                   ; Load byte from SI into AL
    or al, al               ; Check if zero
    jz .done
    mov ah, 0x0E            ; BIOS teletype function
    int 0x10                ; Print character
    jmp .loop
.done:
    popa
    ret

;=============================================================================
; Switch to 32-bit Protected Mode
;=============================================================================
switch_to_pm:
    cli                     ; Disable interrupts
    lgdt [gdt_descriptor]   ; Load GDT
    
    ; Set PE (Protection Enable) bit in CR0
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    
    ; Far jump to flush pipeline and switch to 32-bit code
    jmp CODE_SEG:init_pm

[BITS 32]
init_pm:
    ; Update segment registers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    ; Set up stack
    mov ebp, 0x90000
    mov esp, ebp
    
    ; Jump to kernel
    call KERNEL_OFFSET
    
    ; Halt if kernel returns
    jmp $

;=============================================================================
; Global Descriptor Table (GDT)
;=============================================================================
gdt_start:
    ; Null descriptor
    dq 0x0

gdt_code:
    ; Code segment descriptor
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10011010b    ; Access byte: present, ring 0, code, executable, readable
    db 11001111b    ; Flags + Limit (bits 16-19): 4KB granularity, 32-bit
    db 0x0          ; Base (bits 24-31)

gdt_data:
    ; Data segment descriptor
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0          ; Base (bits 0-15)
    db 0x0          ; Base (bits 16-23)
    db 10010010b    ; Access byte: present, ring 0, data, writable
    db 11001111b    ; Flags + Limit (bits 16-19): 4KB granularity, 32-bit
    db 0x0          ; Base (bits 24-31)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of GDT
    dd gdt_start                 ; Address of GDT

; GDT segment selectors
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

;=============================================================================
; Data
;=============================================================================
BOOT_DRIVE: db 0

msg_loading: db "Loading kernel...", 0x0D, 0x0A, 0
msg_loaded: db "Kernel loaded!", 0x0D, 0x0A, 0
msg_disk_error: db "Disk read error!", 0x0D, 0x0A, 0

;=============================================================================
; Boot sector padding and signature
;=============================================================================
times 510-($-$$) db 0   ; Pad to 510 bytes
dw 0xAA55               ; Boot signature
