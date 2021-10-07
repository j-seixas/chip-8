# frozen_string_literal: true

module Chip8
  # Opcodes logic of Chip-8
  class Opcode
    class OpcodeError < StandardError; end

    def initialize(opcode)
      @opcode = opcode & 0xFFFF
      @operations = operations
    end

    def decode
      op =
        case msb
        when 0x0 then decode_0
        when 0x1 then :op_1nnn
        when 0x2 then :op_2nnn
        when 0x3 then :op_3xkk
        when 0x4 then :op_4xkk
        when 0x5 then :op_5xy0
        when 0x6 then :op_6xkk
        when 0x7 then :op_7xkk
        when 0x8 then decode_8
        when 0x9 then :op_9xy0
        when 0xA then :op_annn
        when 0xB then :op_bnnn
        when 0xC then :op_cxkk
        when 0xD then :op_dxyn
        when 0xE then decode_e
        when 0xF then decode_f
        end

      raise OpcodeError.new, "Invalid opcode #{@opcode} | hex: #{@opcode.to_s(16)}" if op.nil?

      @operations[op]
    end

    private

    def msb
      (@opcode & 0xF000) >> 12
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

    def decode_0
      case @opcode
      when 0x00E0 then :op_00e0
      when 0x00EE then :op_00ee
      else
        :op_0nnn
      end
    end

    def decode_8
      case n
      when 0x0 then :op_8xy0
      when 0x1 then :op_8xy1
      when 0x2 then :op_8xy2
      when 0x3 then :op_8xy3
      when 0x4 then :op_8xy4
      when 0x5 then :op_8xy5
      when 0x6 then :op_8xy6
      when 0x7 then :op_8xy7
      when 0xE then :op_8xye
      end
    end

    def decode_e
      case kk
      when 0x9E then :op_ex9e
      when 0xA1 then :op_exa1
      end
    end

    def decode_f
      case kk
      when 0x07 then :op_fx07
      when 0x0A then :op_fx0a
      when 0x15 then :op_fx15
      when 0x18 then :op_fx18
      when 0x1E then :op_fx1e
      when 0x29 then :op_fx29
      when 0x33 then :op_fx33
      when 0x55 then :op_fx55
      when 0x65 then :op_fx65
      end
    end

    def operations
      {
        op_0nnn: ["sys", nnn],
        op_00e0: ["cls"],
        op_00ee: ["ret"],
        op_1nnn: ["jp", nnn],
        op_2nnn: ["call", nnn],
        op_3xkk: ["se", x, kk],
        op_4xkk: ["sne", x, kk],
        op_5xy0: ["se_vx_vy", x, y],
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
        op_fx07: ["ld_vx_delay", x],
        op_fx0a: ["wait_key", x],
        op_fx15: ["ld_delay_vx", x],
        op_fx18: ["ld_sound_vx", x],
        op_fx1e: ["add_i_vx", x],
        op_fx29: ["ld_i_sprite", x],
        op_fx33: ["store_decimal", x],
        op_fx55: ["store_regs", x],
        op_fx65: ["read_regs", x]
      }
    end
  end
end
