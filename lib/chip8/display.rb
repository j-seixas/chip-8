# frozen_string_literal: true

require "gosu"

module Chip8
  # Display logic
  class Display < Gosu::Window
    WIDTH = 64
    HEIGHT = 32
    DEFAULT_SCALE = 10

    def initialize(scale = nil)
      @scale = scale || DEFAULT_SCALE
      super @scale * WIDTH, @scale * HEIGHT
    end
  end
end
