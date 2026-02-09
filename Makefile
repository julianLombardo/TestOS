# Makefile for Simple Bootloader and C Kernel

# Assembler and compiler
ASM = nasm
CC = gcc
LD = ld

# Flags
ASM_FLAGS = -f bin
ASM_FLAGS_ELF = -f elf32
CC_FLAGS = -m32 -ffreestanding -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -Wall -Wextra -O2
LD_FLAGS = -m elf_i386 -T linker.ld

# Output files
BOOT_BIN = boot.bin
KERNEL_ENTRY_OBJ = kernel_entry.o
KERNEL_OBJ = kernel.o
KERNEL_BIN = kernel.bin
OS_IMAGE = os-image.bin

# Default target
all: $(OS_IMAGE)

# Build the bootloader
$(BOOT_BIN): boot.asm
	$(ASM) $(ASM_FLAGS) $< -o $@

# Build kernel entry point
$(KERNEL_ENTRY_OBJ): kernel_entry.asm
	$(ASM) $(ASM_FLAGS_ELF) $< -o $@

# Build C kernel
$(KERNEL_OBJ): kernel.c
	$(CC) $(CC_FLAGS) -c $< -o $@

# Link kernel
$(KERNEL_BIN): $(KERNEL_ENTRY_OBJ) $(KERNEL_OBJ)
	$(LD) $(LD_FLAGS) -o $@ $^
	objcopy -O binary $@ $@

# Create final OS image (bootloader + kernel)
$(OS_IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(OS_IMAGE)
	# Pad to ensure proper size (optional)
	@echo "OS image created: $(OS_IMAGE)"
	@ls -lh $(OS_IMAGE)

# Run with QEMU (if installed)
run: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=$(OS_IMAGE)

# Run with QEMU in curses mode (no GUI)
run-curses: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=$(OS_IMAGE) -curses

# Clean build files
clean:
	rm -f *.bin *.o $(OS_IMAGE)

# Rebuild everything
rebuild: clean all

.PHONY: all run run-curses clean rebuild
