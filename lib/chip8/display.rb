# frozen_string_literal: true

require "gosu"

module Chip8
  # Display logic
  class Display < Gosu::Window
    WIDTH = 64
    HEIGHT = 32
    DEFAULT_SCALE = 20

    def initialize(scale = nil, black = nil, white = nil)
      @scale = scale || DEFAULT_SCALE
      @black = map_color(black || "black")
      @white = map_color(white || "white")
      super @scale * WIDTH, @scale * HEIGHT
      @vram = Array.new(WIDTH * HEIGHT, 0x0)
    end

    def draw
      @vram.each_with_index do |value, index|
        x = index % WIDTH
        y = (index / WIDTH).to_i
        draw_rect(x * @scale, y * @scale, @scale, @scale, value == 1 ? @white : @black)
      end
    end

    def pixel_at(x, y)
      @vram[y * WIDTH + x]
    end

    def set_pixel_at(x, y, pixel)
      return if y * WIDTH + x >= WIDTH * HEIGHT

      @vram[y * WIDTH + x] = pixel
    end

    def map_color(color)
      case color
      when "white" then Gosu::Color::WHITE
      when "black" then Gosu::Color::BLACK
      end
    end
  end
end
