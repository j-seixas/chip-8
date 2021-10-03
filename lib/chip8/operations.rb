# frozen_string_literal: true

module Chip8
  # Execute opcodes of Chip-8
  module Operations
    #
    # 0nnn - SYS addr
    #
    # Jump to a machine code routine at nnn.
    # This instruction is only used on the old computers on which Chip-8 was originally implemented.
    # It is ignored by modern interpreters.
    #
    def sys(value)
      # don't do anything
    end

    #
    # 00E0 - CLS
    # Clear the display.
    #
    def cls
      # TODO: clear the display
    end

    #
    # 00EE - RET
    #
    # Return from a subroutine.
    # The interpreter sets the program counter to the address at the top of the stack,
    # then subtracts 1 from the stack pointer.
    #
    def ret
      @sp -= 1
      raise "Out of bounds sp: #{@sp}" if @sp.negative?

      @pc = @stack[@sp] & 0xFFFF
    end

    #
    # 1nnn - JP addr
    #
    # Jump to location nnn.
    # The interpreter sets the program counter to nnn.
    #
    def jp(nnn)
      @pc = nnn & 0xFFFF
    end

    #
    # 2nnn - CALL addr
    #
    # Call subroutine at nnn.
    # The interpreter increments the stack pointer, then puts the current PC on the top of the stack.
    # The PC is then set to nnn.
    #
    def call(nnn)
      @stack[@sp] = @pc & 0xFFFF
      @sp += 1
      raise "Out of bounds sp: #{@sp}" if @sp >= 16

      @pc = nnn & 0xFFFF
    end

    #
    # 3xkk - SE Vx, byte
    #
    # Skip next instruction if Vx = kk.
    # The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
    #
    def se(x, kk)
      @pc = (@pc + 2) & 0xFFFF if @v[x] == kk
    end

    #
    # 6xkk - LD Vx, byte
    #
    # Set Vx = kk.
    # The interpreter puts the value kk into register Vx.
    #
    def ld_v(x, kk)
      @v[x] = kk & 0xFF
    end

    #
    # 7xkk - ADD Vx, byte
    #
    # Set Vx = Vx + kk.
    # Adds the value kk to the value of register Vx, then stores the result in Vx.
    #
    def add(x, kk)
      @v[x] = (@v[x] + kk) & 0xFF
    end

    #
    # 8xy0 - LD Vx, Vy
    #
    # Set Vx = Vy.
    # Stores the value of register Vy in register Vx.
    def ld_vx_vy(x, y)
      @v[x] = @v[y] & 0xFF
    end

    #
    # 8xy3 - XOR Vx, Vy
    #
    # Set Vx = Vx XOR Vy.
    #
    # Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx.
    # An exclusive OR compares the corrseponding bits from two values, and if the bits are not both the same,
    # then the corresponding bit in the result is set to 1. Otherwise, it is 0.
    #
    def xor(x, y)
      @v[x] = @v[x] ^ @v[y]
    end

    #
    # Annn - LD I, addr
    #
    # Set I = nnn.
    # The value of register I is set to nnn.
    #
    def ld_i(nnn)
      @i = nnn & 0xFFFF
    end

    #
    # Fx1E - ADD I, Vx
    #
    # Set I = I + Vx.
    # The values of I and Vx are added, and the results are stored in I.
    #
    def add_i(x)
      @i = (@i + @v[x]) & 0xFFFF
    end

    #
    # Fx55 - LD [I], Vx
    #
    # Store registers V0 through Vx in memory starting at location I.
    # The interpreter copies the values of registers V0 through Vx into memory, starting at the address in I.
    #
    def store_regs(x)
      (0..x).each do |index|
        @memory.write(@i + index, @v[index] & 0xFF)
      end
    end

    #
    # Fx65 - LD Vx, [I]
    #
    # Read registers V0 through Vx from memory starting at location I.
    # The interpreter reads values from memory starting at location I into registers V0 through Vx.
    #
    def read_regs(x)
      (0..x).each do |index|
        @v[index] = @memory.read(@i + index) & 0xFF
      end
    end
  end
end
