# frozen_string_literal: true

require "gosu"

module Chip8
  # Keyboard logic
  class Keyboard
    attr_reader :keys

    def initialize
      @keys = Array.new(16, false)
    end

    def set_key(index, is_key_down)
      @keys[index - 1] = is_key_down
    end

    def key_down?(index)
      @keys[index - 1]
    end

    def any_key_down?
      key = @keys.find_index(true)
      key + 1 if key
    end

    def map_gosu_key(key)
      case key
      when Gosu::Kb1 then 0x1
      when Gosu::Kb2 then 0x2
      when Gosu::Kb3 then 0x3
      when Gosu::Kb4 then 0xC
      when Gosu::KbQ then 0x4
      when Gosu::KbW then 0x5
      when Gosu::KbE then 0x6
      when Gosu::KbR then 0xD
      when Gosu::KbA then 0x7
      when Gosu::KbS then 0x8
      when Gosu::KbD then 0x9
      when Gosu::KbF then 0xE
      when Gosu::KbZ then 0xA
      when Gosu::KbX then 0x0
      when Gosu::KbC then 0xB
      when Gosu::KbV then 0xF
      end
    end
  end
end
