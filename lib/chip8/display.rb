# frozen_string_literal: true

require "gosu"

module Chip8
  # Display logic
  class Display < Gosu::Window
    WIDTH = 64
    HEIGHT = 32
    DEFAULT_SCALE = 20

    attr_reader :keyboard

    def initialize(scale = nil, black = nil, white = nil)
      @scale = scale || DEFAULT_SCALE
      @black = map_color(black || "black")
      @white = map_color(white || "white")
      @keyboard = Keyboard.new
      super @scale * WIDTH, @scale * HEIGHT
      clear_screen
    end

    def draw
      @vram.each_with_index do |value, index|
        x = index % WIDTH
        y = (index / WIDTH).to_i
        draw_rect(x * @scale, y * @scale, @scale, @scale, value == 1 ? @white : @black)
      end
    end

    def button_down(id)
      mapped_key = @keyboard.map_gosu_key(id)
      @keyboard.set_key(mapped_key, true) if mapped_key
      super
    end

    def button_up(id)
      mapped_key = @keyboard.map_gosu_key(id)
      @keyboard.set_key(mapped_key, false) if mapped_key
      super
    end

    def clear_screen
      @vram = Array.new(WIDTH * HEIGHT, 0x0)
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
