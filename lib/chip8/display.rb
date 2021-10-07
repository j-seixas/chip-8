# frozen_string_literal: true

require "gosu"

module Chip8
  # Display logic
  class Display < Gosu::Window
    WIDTH = 64
    HEIGHT = 32
    DEFAULT_SCALE = 20

    attr_accessor :keyboard, :dt, :st

    def initialize(scale = nil, black = nil, white = nil)
      @scale = scale || DEFAULT_SCALE
      @black = map_color(black || "black")
      @white = map_color(white || "white")
      @keyboard = Keyboard.new
      @dt = @st = 0x00
      @beep = Gosu::Sample.new("sound/beep.wav")
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

    def update
      if @st.positive?
        @beep.play
        @st -= 1
      end
      @dt -= 1 if @dt.positive?
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
      @vram[(y % HEIGHT) * WIDTH + (x % WIDTH)] = pixel
    end

    def map_color(color)
      case color
      when "white" then Gosu::Color::WHITE
      when "black" then Gosu::Color::BLACK
      end
    end
  end
end
