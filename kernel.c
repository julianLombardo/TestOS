// Simple C Kernel
// Displays text on screen using VGA text mode

// VGA text mode buffer is at 0xB8000
#define VGA_MEMORY 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

// Color constants (background << 4 | foreground)
#define WHITE_ON_BLACK 0x0F
#define GREEN_ON_BLACK 0x02
#define RED_ON_BLACK 0x04

// Basic types
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;

// Video memory pointer
static uint16_t* video_memory = (uint16_t*)VGA_MEMORY;
static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;

// I/O port functions
static inline void outb(uint16_t port, uint8_t value) {
    __asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

// Clear the screen
void clear_screen() {
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        video_memory[i] = (WHITE_ON_BLACK << 8) | ' ';
    }
    cursor_x = 0;
    cursor_y = 0;
}

// Print a character at current cursor position
void putchar(char c, uint8_t color) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if (c == '\r') {
        cursor_x = 0;
    } else if (c == '\t') {
        cursor_x = (cursor_x + 4) & ~(4 - 1);
    } else {
        int offset = cursor_y * VGA_WIDTH + cursor_x;
        video_memory[offset] = (color << 8) | c;
        cursor_x++;
    }
    
    // Handle line wrap
    if (cursor_x >= VGA_WIDTH) {
        cursor_x = 0;
        cursor_y++;
    }
    
    // Handle scrolling (simplified - just wrap to top)
    if (cursor_y >= VGA_HEIGHT) {
        cursor_y = 0;
    }
}

// Print a null-terminated string
void print(const char* str, uint8_t color) {
    while (*str) {
        putchar(*str, color);
        str++;
    }
}

// Print a string with newline
void println(const char* str, uint8_t color) {
    print(str, color);
    putchar('\n', color);
}

// Convert integer to string (simple implementation)
void print_hex(uint32_t num) {
    char hex_chars[] = "0123456789ABCDEF";
    print("0x", WHITE_ON_BLACK);
    
    for (int i = 28; i >= 0; i -= 4) {
        putchar(hex_chars[(num >> i) & 0xF], WHITE_ON_BLACK);
    }
}

// Simple delay function
void delay(uint32_t count) {
    for (volatile uint32_t i = 0; i < count * 1000000; i++);
}

// Main kernel function - called from kernel_entry.asm
void kernel_main() {
    // Clear the screen
    clear_screen();
    
    // Print welcome messages
    println("================================================", GREEN_ON_BLACK);
    println("    Welcome to SimpleOS Kernel v0.1", GREEN_ON_BLACK);
    println("================================================", GREEN_ON_BLACK);
    println("", WHITE_ON_BLACK);
    
    println("Kernel loaded successfully!", WHITE_ON_BLACK);
    println("Running in 32-bit protected mode", WHITE_ON_BLACK);
    println("", WHITE_ON_BLACK);
    
    // Display some system info
    print("Video Memory Address: ", WHITE_ON_BLACK);
    print_hex((uint32_t)VGA_MEMORY);
    println("", WHITE_ON_BLACK);
    
    print("Stack Pointer: ", WHITE_ON_BLACK);
    uint32_t esp;
    __asm__ volatile ("mov %%esp, %0" : "=r"(esp));
    print_hex(esp);
    println("", WHITE_ON_BLACK);
    
    println("", WHITE_ON_BLACK);
    println("System Information:", GREEN_ON_BLACK);
    println("- CPU: x86 (32-bit)", WHITE_ON_BLACK);
    println("- Mode: Protected Mode", WHITE_ON_BLACK);
    println("- Display: VGA Text Mode (80x25)", WHITE_ON_BLACK);
    println("", WHITE_ON_BLACK);
    
    // Demonstration loop
    println("Kernel is now running...", WHITE_ON_BLACK);
    println("", WHITE_ON_BLACK);
    
    int counter = 0;
    while (1) {
        // Simple counter display
        cursor_x = 0;
        cursor_y = 20;
        print("Heartbeat counter: ", WHITE_ON_BLACK);
        print_hex(counter);
        print("  ", WHITE_ON_BLACK);
        
        counter++;
        delay(1);  // Delay to make counter visible
        
        // You can add more kernel functionality here
        // For example: keyboard input, task switching, memory management, etc.
    }
    
    // Should never reach here
    while (1) {
        __asm__ volatile ("hlt");
    }
}
