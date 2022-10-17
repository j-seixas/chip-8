# frozen_string_literal: true

module Chip8
  # Clock logic
  class Clock
    attr_accessor :delay_timer, :sound_timer
    attr_reader :cpu_clock

    def initialize
      @clock_hz = 60
      @cpu_clock = 1.0 / @clock_hz
      @delay_timer = @sound_timer = 0x00
    end
  end
end
