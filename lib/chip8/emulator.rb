# frozen_string_literal: true

module Chip8
  # Emulator class of Chip-8
  class Emulator
    def initialize(rom)
      rom_bytes = File.open(rom, "rb", &:read).unpack("C*")
      @mem = Chip8::Memory.new
      @mem.load_rom(rom_bytes)
      @display = Chip8::Display.new
      @cpu = Chip8::CPU.new(@mem, @display)
    end

    def run
      Thread.new do
        @cpu.run
      end

      @display.show
    end
  end
end
