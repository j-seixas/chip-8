# frozen_string_literal: true

module Chip8
  # Opcodes logic of Chip-8
  class Opcode
    class OpcodeError < StandardError; end

    def initialize(opcode)
      @opcode = opcode & 0xFFFF
      @operations = {
        op_0nnn: ["sys", nnn],
        op_00e0: ["cls"],
        op_00ee: ["ret"],
        op_1nnn: ["jp", nnn],
        op_2nnn: ["call", nnn],
        op_3xkk: ["se", x, kk],
        op_6xkk: ["ld_v", x, kk],
        op_7xkk: ["add", x, kk],
        op_8xy0: ["ld_vx_vy", x, y],
        op_8xy3: ["xor", x, y],
        op_annn: ["ld_i", nnn],
        op_fx1e: ["add_i", x],
        op_fx55: ["store_regs", x],
        op_fx65: ["read_regs", x]
      }
    end

    def decode
      case @opcode & 0xF000
      when 0x0000
        case @opcode
        when 0x00E0
          return @operations[:op_00e0]
        when 0x00EE
          return @operations[:op_00ee]
        else
          return @operations[:op_0nnn]
        end
      when 0x1000
        return @operations[:op_1nnn]
      when 0x2000
        return @operations[:op_2nnn]
      when 0x3000
        return @operations[:op_3xkk]
      when 0x6000
        return @operations[:op_6xkk]
      when 0x7000
        return @operations[:op_7xkk]
      when 0x8000
        case @opcode & 0x000F
        when 0x0000
          return @operations[:op_8xy0]
        when 0x0003
          return @operations[:op_8xy3]
        end
      when 0xa000
        return @operations[:op_annn]
      when 0xF000
        case @opcode & 0x00FF
        when 0x001E
          return @operations[:op_fx1e]
        when 0x0055
          return @operations[:op_fx55]
        when 0x0065
          return @operations[:op_fx65]
        end
      end

      raise OpcodeError.new, "Invalid opcode #{@opcode} | hex: #{@opcode.to_s(16)}"
    end

    def x
      (@opcode & 0x0F00) >> 8
    end

    def y
      (@opcode & 0x00F0) >> 8
    end

    def kk
      @opcode & 0x00FF
    end

    def nnn
      @opcode & 0x0FFF
    end
  end
end
