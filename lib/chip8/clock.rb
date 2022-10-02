# frozen_string_literal: true

module Chip8
  # Clock logic
  class Clock
    attr_reader :cpu_clock

    def initialize
      @clock_hz = 60
      @cpu_clock = 1.0 / @clock_hz
      # @delay_timer = 0xFF
      # @sound_timer = 0xFF
    end
  end
end
