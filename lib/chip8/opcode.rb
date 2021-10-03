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
        op_4xkk: ["sne", x, kk],
        op_6xkk: ["ld_v", x, kk],
        op_7xkk: ["add_vx", x, kk],
        op_8xy0: ["ld_vx_vy", x, y],
        op_8xy1: ["or", x, y],
        op_8xy2: ["and", x, y],
        op_8xy3: ["xor", x, y],
        op_8xy4: ["add_vx_vy", x, y],
        op_8xy5: ["sub", x, y],
        op_8xy6: ["shr", x],
        op_8xy7: ["subn", x, y],
        op_8xye: ["shl", x],
        op_9xy0: ["sne_vx_vy", x, y],
        op_annn: ["ld_i", nnn],
        op_bnnn: ["jp_v0", nnn],
        op_cxkk: ["rnd", x, kk],
        op_dxyn: ["drw", x, y, n],
        op_ex9e: ["skp", x],
        op_exa1: ["sknp", x],
        op_fx1e: ["add_i_vx", x],
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
      when 0x4000
        return @operations[:op_4xkk]
      when 0x6000
        return @operations[:op_6xkk]
      when 0x7000
        return @operations[:op_7xkk]
      when 0x8000
        case @opcode & 0x000F
        when 0x0000
          return @operations[:op_8xy0]
        when 0x0001
          return @operations[:op_8xy1]
        when 0x0002
          return @operations[:op_8xy2]
        when 0x0003
          return @operations[:op_8xy3]
        when 0x0004
          return @operations[:op_8xy4]
        when 0x0005
          return @operations[:op_8xy5]
        when 0x0006
          return @operations[:op_8xy6]
        when 0x0007
          return @operations[:op_8xy7]
        when 0x000e
          return @operations[:op_8xye]
        end
      when 0x9000
        return @operations[:op_9xy0]
      when 0xa000
        return @operations[:op_annn]
      when 0xb000
        return @operations[:op_bnnn]
      when 0xc000
        return @operations[:op_cxkk]
      when 0xd000
        return @operations[:op_dxyn]
      when 0xE000
        case @opcode & 0x00FF
        when 0x009E
          return @operations[:op_ex9e]
        when 0x00A1
          return @operations[:op_exa1]
        end
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
      (@opcode & 0x00F0) >> 4
    end

    def kk
      @opcode & 0x00FF
    end

    def nnn
      @opcode & 0x0FFF
    end

    def n
      @opcode & 0x000F
    end
  end
end
