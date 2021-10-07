# frozen_string_literal: true

require_relative "chip8/version"
require_relative "chip8/emulator"
require_relative "chip8/memory"
require_relative "chip8/operations"
require_relative "chip8/opcode"
require_relative "chip8/cpu"
require_relative "chip8/keyboard"
require_relative "chip8/display"

Chip8::Emulator.new(ARGV[0]).run
