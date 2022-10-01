# frozen_string_literal: true

require "byebug"

module Chip8
  # CPU logic of Chip-8
  class CPU
    include Operations
    ROM_START = 0x200

    # 8-bit registers
    attr_reader :v, :sp, :dt, :st
    # 16-bit registers
    attr_reader :i, :pc
    attr_reader :stack

    def initialize(memory, display)
      @i = @pc = 0x0000
      @sp = @dt = @st = 0x00
      @v = Array.new 16, 0x00
      @stack = Array.new 16, 0x0000
      @memory = memory
      @display = display
      @keyboard = @display.keyboard
      @clock = Chip8::Clock.new
      @dt = @display.dt
      @st = @display.st
      start_rom
    end

    def start_rom
      @pc = ROM_START & 0xFFFF
    end

    def run
      start_time = Time.now
      loop do
        time_elapsed = Time.now - start_time
        next unless time_elapsed >= @clock.cpu_clock

        cycle

        start_time = Time.now
      end
    end

    def cycle
        opcode = @memory.instruction(@pc)
      # puts "opcode: #{opcode.to_s(16)}"
        op = Opcode.new(opcode).decode
        send(*op) # Execute op
        # puts "PC: #{@pc.to_s(16)}"
        # puts "V reg: #{@v}"
        # puts "I reg: #{@i}"
        # puts "SP: #{@sp} | stack: #{@stack}"
        # puts "KBD: #{@keyboard.keys}"
      # puts "=============="
        inc_pc
    end

    def inc_pc
      @pc = (@pc + 2) & 0xFFFF
    end
  end
end
