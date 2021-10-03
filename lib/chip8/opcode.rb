# frozen_string_literal: true

module Chip8
  # Opcodes logic of Chip-8
  class Opcode
    class OpcodeError < StandardError; end

    def initialize(opcode)
      @opcode = opcode & 0xFFFF
      @operations = {
        op_6xkk: ["ld_v", x, kk],
        op_7xkk: ["add", x, kk],
        op_annn: ["ld_i", nnn]
      }
    end

    def decode
      case @opcode & 0xF000
      when 0x6000
        @operations[:op_6xkk]
      when 0x7000
        @operations[:op_7xkk]
      when 0xa000
        @operations[:op_annn]
      else
        raise OpcodeError.new, "Invalid opcode #{@opcode} | hex: #{@opcode.to_s(16)}"
      end
    end

    def x
      (@opcode & 0x0F00) >> 8
    end

    def kk
      @opcode & 0x00FF
    end

    def nnn
      @opcode & 0x0FFF
    end
  end
end
