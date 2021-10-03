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
    # 4xkk - SNE Vx, byte
    #
    # Skip next instruction if Vx != kk.
    # The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
    def sne(x, kk)
      @pc = (@pc + 2) & 0xFFFF if @v[x] != kk
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
    def add_vx(x, kk)
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
    # 8xy1 - OR Vx, Vy
    #
    # Set Vx = Vx OR Vy.
    # Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx.
    # A bitwise OR compares the corrseponding bits from two values, and if either bit is 1, then the same bit in the result is also 1.
    # Otherwise, it is 0.
    def or(x, y)
      @v[x] |= @v[y]
    end

    #
    # 8xy2 - AND Vx, Vy
    #
    # Set Vx = Vx AND Vy.
    # Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx.
    # A bitwise AND compares the corrseponding bits from two values, and if both bits are 1,
    # then the same bit in the result is also 1. Otherwise, it is 0.
    #
    def and(x, y)
      @v[x] &= @v[y]
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
    # 8xy4 - ADD Vx, Vy
    #
    # Set Vx = Vx + Vy, set VF = carry.
    # The values of Vx and Vy are added together. If the result is greater than 8 bits (i.e., > 255,) VF is set to 1, otherwise 0.
    # Only the lowest 8 bits of the result are kept, and stored in Vx.
    #
    def add_vx_vy(x, y)
      sum = @v[x] + @v[y]
      @v[x] = sum & 0xFF
      @v[0xF] = 1 if sum > 255
    end

    #
    # 8xy5 - SUB Vx, Vy
    #
    # Set Vx = Vx - Vy, set VF = NOT borrow.
    # If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
    #
    def sub(x, y)
      subt = @v[x] - @v[y]
      @v[x] = subt & 0xFF
      @v[0xF] = subt.positive? ? 1 : 0
    end

    #
    # 8xy6 - SHR Vx {, Vy}
    #
    # Set Vx = Vx SHR 1.
    # If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
    def shr(x)
      lsb = @v[x] & 1
      @v[0xF] = lsb
      @v[x] >>= 1
    end

    #
    # 8xy7 - SUBN Vx, Vy
    #
    # Set Vx = Vy - Vx, set VF = NOT borrow.
    # If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
    def subn(x, y)
      subt = @v[y] - @v[x]
      @v[x] = subt & 0xFF
      @v[0xF] = subt.positive? ? 1 : 0
    end

    #
    # 8xyE - SHL Vx {, Vy}
    #
    # Set Vx = Vx SHL 1.
    # If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
    #
    def shl(x)
      lsb = @v[x] & 1
      @v[0xF] = lsb
      @v[x] <<= 1
    end

    #
    # 9xy0 - SNE Vx, Vy
    #
    # Skip next instruction if Vx != Vy.
    # The values of Vx and Vy are compared, and if they are not equal, the program counter is increased by 2.
    #
    def sne_vx_vy(x, y)
      sne(x, @v[y])
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
    # Bnnn - JP V0, addr
    #
    # Jump to location nnn + V0.
    # The program counter is set to nnn plus the value of V0.
    #
    def jp_v0(nnn)
      jp((@v[0] + nnn) & 0xFFFF)
    end

    #
    # Cxkk - RND Vx, byte
    #
    # Set Vx = random byte AND kk.
    # The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk. The results are stored in Vx. See instruction 8xy2 for more information on AND.
    def rnd(x, kk)
      @v[x] = (rand(256) & kk) & 0xFF
    end

    #
    # Dxyn - DRW Vx, Vy, nibble
    #
    # Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
    # The interpreter reads n bytes from memory, starting at the address stored in I. These bytes are then displayed as sprites on screen at coordinates (Vx, Vy). Sprites are XORed onto the existing screen. If this causes any pixels to be erased, VF is set to 1, otherwise it is set to 0. If the sprite is positioned so part of it is outside the coordinates of the display, it wraps around to the opposite side of the screen. See instruction 8xy3 for more information on XOR, and section 2.4, Display, for more information on the Chip-8 screen and sprites.
    def drw(x, y, n)
      # TODO: draw
    end

    #
    # Ex9E - SKP Vx
    #
    # Skip next instruction if key with the value of Vx is pressed.
    # Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, PC is increased by 2.
    def skp(x)
      # TODO: keyboard
    end

    #
    # ExA1 - SKNP Vx
    #
    # Skip next instruction if key with the value of Vx is not pressed.
    # Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position, PC is increased by 2.
    #
    def sknp(x)
      # TODO: keyboard
    end

    #
    # Fx1E - ADD I, Vx
    #
    # Set I = I + Vx.
    # The values of I and Vx are added, and the results are stored in I.
    #
    def add_i_vx(x)
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
