# Simple Bootloader and C Kernel

A minimal x86 bootloader written in assembly that loads and executes a simple kernel written in C.

## Overview

This project demonstrates the fundamentals of OS development:
- **boot.asm**: 16-bit bootloader that loads the kernel from disk and switches to protected mode
- **kernel_entry.asm**: Bridge between assembly and C code
- **kernel.c**: Simple C kernel that displays text using VGA text mode
- **linker.ld**: Linker script to organize kernel memory layout
- **Makefile**: Build automation

## How It Works

### 1. Boot Process
1. BIOS loads the bootloader (first 512 bytes) to memory address 0x7C00
2. Bootloader prints loading message in 16-bit real mode
3. Bootloader loads kernel sectors from disk to 0x1000
4. Bootloader sets up GDT (Global Descriptor Table)
5. Bootloader switches CPU to 32-bit protected mode
6. Bootloader jumps to kernel entry point

### 2. Kernel Execution
1. kernel_entry.asm calls the C function `kernel_main()`
2. Kernel clears screen and displays welcome message
3. Kernel runs a simple heartbeat counter to show it's alive
4. Kernel enters infinite loop

## Prerequisites

You need the following tools installed:
- **nasm** - Netwide Assembler
- **gcc** - GNU C Compiler with 32-bit support
- **ld** - GNU Linker
- **qemu-system-i386** - (Optional) For testing the OS

### Installation on Ubuntu/Debian:
```bash
sudo apt-get install nasm gcc-multilib qemu-system-x86
```

### Installation on macOS:
```bash
brew install nasm qemu
brew install i686-elf-gcc  # Cross compiler for 32-bit
```

## Building

Simply run:
```bash
make
```

This will create:
- `boot.bin` - The 512-byte bootloader
- `kernel.bin` - The compiled kernel
- `os-image.bin` - Complete OS image (bootloader + kernel)

## Running

### With QEMU (Recommended):
```bash
make run
```

Or for no-GUI mode:
```bash
make run-curses
```

### With Real Hardware (Advanced):
**WARNING**: This can damage your system if done incorrectly. Only for experienced users.

Write to USB drive (replace /dev/sdX with your drive):
```bash
sudo dd if=os-image.bin of=/dev/sdX bs=512
```

## Project Structure

```
.
├── boot.asm           # Bootloader (512 bytes)
├── kernel_entry.asm   # Kernel entry point
├── kernel.c           # C kernel code
├── linker.ld          # Linker script
├── Makefile           # Build automation
└── README.md          # This file
```

## Memory Layout

```
0x00000000 - 0x000003FF : Real mode interrupt vector table
0x00000400 - 0x000004FF : BIOS data area
0x00000500 - 0x00007BFF : Free conventional memory
0x00007C00 - 0x00007DFF : Bootloader (512 bytes)
0x00007E00 - 0x0007FFFF : Free memory
0x00080000 - 0x0008FFFF : Stack (grows down from 0x90000)
0x00001000 - 0x???????? : Kernel (loaded here)
0x000A0000 - 0x000BFFFF : Video memory
0x000B8000 - 0x000B8FFF : VGA text mode buffer
```

## Understanding the Code

### Bootloader (boot.asm)
- Starts in 16-bit real mode
- Uses BIOS interrupts to read kernel from disk
- Sets up Global Descriptor Table (GDT) for protected mode
- Switches to 32-bit protected mode
- Jumps to kernel

### Kernel Entry (kernel_entry.asm)
- Simple bridge to C code
- Calls `kernel_main()` function
- Halts CPU if kernel returns

### C Kernel (kernel.c)
- Writes directly to VGA text buffer (0xB8000)
- Implements basic text output functions
- Displays system information
- Runs simple heartbeat counter

## Extending the Kernel

Here are some ideas for enhancements:
1. **Keyboard Input**: Handle keyboard interrupts (IRQ1)
2. **Interrupt Handling**: Set up IDT and handle hardware interrupts
3. **Memory Management**: Implement paging and heap allocation
4. **Multitasking**: Add simple task switching
5. **Filesystem**: Read files from disk
6. **Shell**: Implement command-line interface

## Troubleshooting

### Build Errors
- **"gcc: error: unrecognized command line option '-m32'"**
  - Install 32-bit libraries: `sudo apt-get install gcc-multilib`

- **"nasm: command not found"**
  - Install nasm: `sudo apt-get install nasm`

### Runtime Issues
- **Black screen with no output**
  - Check that QEMU is installed correctly
  - Try: `qemu-system-i386 -drive format=raw,file=os-image.bin -serial stdio`

- **"Disk read error!" message**
  - The kernel wasn't properly concatenated
  - Run `make clean && make` to rebuild

## Learning Resources

- [OSDev Wiki](https://wiki.osdev.org/) - Comprehensive OS development resource
- [Writing a Simple Operating System from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf) - Excellent tutorial
- [Intel 64 and IA-32 Architectures Software Developer Manuals](https://software.intel.com/content/www/us/en/develop/articles/intel-sdm.html)

## License

This is educational code. Feel free to use and modify as needed.

## Credits

Created as a simple demonstration of bootloader and kernel development.
