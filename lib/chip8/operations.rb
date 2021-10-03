# frozen_string_literal: true

module Chip8
  # Execute opcodes of Chip-8
  module Operations
    def ld_v(index, value)
      @v[index] = value & 0xFF
    end

    def ld_i(value)
      @i = value & 0xFFFF
    end

    def add(index, value)
      @v[index] = (@v[index] + value) & 0xFF
    end
  end
end
