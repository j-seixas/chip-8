# frozen_string_literal: true

module Chip8
  # Memory logic of Chip-8
  class Memory
    MEMORY_SIZE = 4096
    ROM_OFFSET = 0x200

    def initialize
      @mem = Array.new MEMORY_SIZE, 0
    end

    def load_rom(rom_bytes)
      rom_bytes.each_with_index do |byte, i|
        @mem[ROM_OFFSET + i] = byte
      end
    end

    def instruction(index)
      ((read(index) << 8) + read(index + 1)) & 0xFFFF
    end

    def write(index, value)
      @mem[index] = value
    end

    def read(index)
      @mem[index]
    end
  end
end
