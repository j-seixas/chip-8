# frozen_string_literal: true

module Chip8
  # Emulator class of Chip-8
  class Emulator
    def initialize(rom)
      rom_bytes = File.open(rom, "rb", &:read).unpack("C*")
      @mem = Chip8::Memory.new
      @mem.load_rom(rom_bytes)
      @cpu = Chip8::CPU.new(@mem)
    end

    def run
      @cpu.run
    end
  end
end
