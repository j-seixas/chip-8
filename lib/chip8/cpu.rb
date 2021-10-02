# frozen_string_literal: true

module Chip8
  # CPU logic of Chip-8
  class CPU
    include Operations
    ROM_START = 0x200

    # 8-bit registers
    attr_reader :v, :sp, :dt, :st
    # 16-bit registers
    attr_reader :i, :pc

    def initialize
      @i = @pc = 0x0000
      @v = @sp = @dt = @st = 0x00
    end

    def start_rom
      @pc = ROM_START & 0xFFFF
    end

    def run(mem)
      opcode = mem.instruction(@pc)
      op = Opcode.decode(opcode)
      send(op) # Execute op
      inc_pc
    end

    def inc_pc
      @pc = (@pc + 2) & 0xFFFF
    end
  end
end
