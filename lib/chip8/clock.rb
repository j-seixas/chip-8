# frozen_string_literal: true

module Chip8
  # Clock logic
  class Clock
    attr_accessor :delay_timer, :sound_timer
    attr_reader :cpu_clock, :cpu_stopped

    def initialize
      @cpu_stopped = false
      @clock_hz = 60
      @cpu_clock = 1.0 / @clock_hz
      @delay_timer = @sound_timer = 0x00
    end

    def increase_cpu_speed
      @clock_hz += 10
      @cpu_clock = 1.0 / @clock_hz
      puts "increased 10 #{@clock_hz}, #{@cpu_clock}"
    end

    def decrease_cpu_speed
      @clock_hz -= 10
      @cpu_clock = 1.0 / @clock_hz
      puts "decreased 10 #{@clock_hz}, #{@cpu_clock}"
    end

    def stop
      @cpu_stopped = true
    end
  end
end
