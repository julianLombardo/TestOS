# Testing Your Bootloader Without Admin Access

Since you're on a school computer without admin privileges, here are several alternatives:

## Option 1: Online x86 Emulator (EASIEST)

### Copy86 Online Emulator
1. Visit: https://copy.sh/v86/
2. Click on "Create your own image"
3. Upload a bootable disk image
4. Run it in the browser!

Unfortunately, you still need to assemble the .asm to .bin first...

## Option 2: Use Online Assembly Tools + Hex Editor

### Step 1: Assemble Online
1. Go to: https://carlosrafaelgn.com.br/Asm86/
2. Paste the contents of `simple_boot.asm`
3. Click "Assemble"
4. Download the binary output

### Step 2: Test in Browser Emulator
1. Go to: https://copy.sh/v86/
2. Upload your .bin file as a floppy or hard drive image
3. Boot it!

## Option 3: Portable Tools (No Installation Required)

### Download Portable NASM
1. Download NASM portable from: https://www.nasm.us/pub/nasm/releasebuilds/
2. Extract to your Desktop/TestOS folder (no admin needed!)
3. Run from command line:
   ```
   ./nasm -f bin boot.asm -o boot.bin
   ```

### Download Portable QEMU
1. Download QEMU for Windows (portable): https://qemu.weilnetz.de/w64/
2. Extract anywhere you have write access
3. Run:
   ```
   qemu-system-i386.exe -drive format=raw,file=boot.bin
   ```

## Option 4: Create Bootable USB (Risky on School Computer!)

**WARNING**: Only do this if you have permission and your own USB drive!

1. Assemble boot.asm to boot.bin
2. Use Rufus (portable, no install): https://rufus.ie/
3. Write boot.bin to USB
4. Boot from USB (may need BIOS access)

## Option 5: Virtual Machine in Browser

### Jor1k (RISC-V Emulator in Browser)
While not x86, you could learn similar concepts:
- Visit: https://s-macke.github.io/jor1k/demos/main.html

## Option 6: Use WSL (if Available)

If your school computer has WSL (Windows Subsystem for Linux) enabled:
```bash
wsl --install -d Ubuntu
```

Then you can install tools in WSL without admin on Windows.

## Option 7: Cloud Development Environment

### Use GitHub Codespaces (FREE)
1. Create GitHub account
2. Upload your files to a repository
3. Open in Codespaces (cloud VS Code)
4. Install tools in the cloud environment
5. Build and download the .bin file
6. Test locally in browser emulator

### Use Replit (FREE)
1. Go to: https://replit.com
2. Create a new "Bash" repl
3. Upload your files
4. Run commands in the cloud

## Recommended Path for You:

**Best Option**: GitHub Codespaces or Replit
- Free, no installation required
- Full development environment
- Can build everything properly
- Download the compiled .bin file
- Test in Copy.sh v86 emulator

**Quick Test Option**: 
1. Use online assembler for simple_boot.asm
2. Test in Copy.sh v86 browser emulator

---

## Files I'm Providing

I'll create:
1. `simple_boot.asm` - Simplified bootloader for online assembly
2. `portable_setup.md` - Instructions for portable tools
3. `cloud_build.sh` - Script to run in cloud environment

Would you like me to help you set up any of these options?
