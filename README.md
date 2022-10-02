# CHIP-8

Chip-8 Emulator written in Ruby.

## Progress
- [x] Memory
- [x] CPU
- [x] Opcodes
- [x] Display
- [x] Keyboard
- [x] Timers
- [x] Check if emulator runs ROMs correctly (passes all test ROMs without errors and displays correctly)
- [ ] Adjust timing speed of CPU and Keyboard inputs

## Usage
This requires to have Ruby installed. To install all dependencies run:

```
bundle install
```

To run the emulator:
```
ruby lib/chip8 roms/ROM_NAME
```
