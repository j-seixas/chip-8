# frozen_string_literal: true

module Chip8
  # Opcodes logic of Chip-8
  class Opcode
    OPCODES = {
      ld: "ld"
    }.freeze

    def self.decode(value)
      case value & 0xF000
      when 0x6000
        OPCODES[:ld]
      else
        raise OpcodeError "Invalid opcode #{value}"
      end
    end
  end

  class OpcodeError < StandardError; end
end
