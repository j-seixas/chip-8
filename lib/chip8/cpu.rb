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
      @sp = @dt = @st = 0x00
      @v = Array.new 16, 0x00
    end

    def start_rom
      @pc = ROM_START & 0xFFFF
    end

    def run(mem)
      loop do
        opcode = mem.instruction(@pc)
        op = Opcode.new(opcode).decode
        send(*op) # Execute op
        puts "PC: #{@pc}"
        puts "V reg: #{@v}"
        puts "I reg: #{@i}"
        puts "=============="
        inc_pc
      end
    end

    def inc_pc
      @pc = (@pc + 2) & 0xFFFF
    end
  end
end
