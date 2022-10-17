# CHIP-8

Chip-8 Emulator written in Ruby.

## Usage
This requires to have Ruby installed. To install all dependencies run:

```
bundle install
```

To run the emulator:
```
ruby lib/chip8 roms/ROM_NAME
```

### Keyboard

On the left is your keyboard and on the right the keys mapped to the CHIP-8 keyboard
```
1  2  3  4          1  2  3  C

Q  W  E  R          4  5  6  D
             -->
A  S  D  F          7  8  9  E

Z  X  C  V          A  0  B  F
```

You can use `Arrow Up` and `Arrow Down` to increase/decrease cpu speed but check [caveats](#caveats).
To exit press `Escape`

### Testing

Used some test ROMS (under roms/tests):



## Caveats
Using threads in ruby doesn't have a lot of impact in performance and in this case it is negatively impacting the performance when using with the gem gosu.
However, it is necessary to run the cpu independent from the display, as we were limited by the number of times the gosu update method is called per second (dafault is 60).

Increase/decrease the cpu speed can also have some impact on showing how the performance is lacking.

For anyone doing a similar project, I recommend using another language as there isn't a really good gem for 2d graphics with separated logic and display speeds.
