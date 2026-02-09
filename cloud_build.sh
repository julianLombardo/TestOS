#!/bin/bash
# Cloud Build Script
# Run this in GitHub Codespaces, Replit, or any Linux environment

echo "=================================================="
echo "  Building Bootloader and Kernel in Cloud"
echo "=================================================="
echo ""

# Check if we're in the right directory
if [ ! -f "boot.asm" ]; then
    echo "Error: boot.asm not found!"
    echo "Please make sure all files are in the current directory."
    exit 1
fi

# Install required tools
echo "Installing required tools..."
if command -v apt-get &> /dev/null; then
    # Ubuntu/Debian
    sudo apt-get update
    sudo apt-get install -y nasm gcc-multilib qemu-system-x86
elif command -v yum &> /dev/null; then
    # CentOS/RedHat
    sudo yum install -y nasm gcc qemu-system-x86
else
    echo "Warning: Could not detect package manager."
    echo "Please install: nasm, gcc (with 32-bit support), qemu-system-x86"
fi

# Build the project
echo ""
echo "Building bootloader and kernel..."
make

# Check if build succeeded
if [ -f "os-image.bin" ]; then
    echo ""
    echo "=================================================="
    echo "  Build Successful!"
    echo "=================================================="
    echo ""
    echo "Files created:"
    ls -lh boot.bin kernel.bin os-image.bin
    echo ""
    echo "To test in QEMU, run:"
    echo "  make run"
    echo ""
    echo "Or download os-image.bin and test it locally!"
else
    echo ""
    echo "Build failed. Check errors above."
    exit 1
fi
