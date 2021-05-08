# TTY equivalent
The TTY system in Linux is entirely built on stuff from several decades ago, and if someone from thenabouts with expertise in unix time-traveled to today, they could still operate a shell just as well. The way TTY works today is an ugly mess of signals, way too many options, parity checks, which are no longer needed, but still there for backwards compatibility. See [The TTY demystified by Linus Akesson](https://www.linusakesson.net/programming/tty/) for an in-depth explanation of how the current system works. This replacement is meant to be fast and easy to understand.

This new TTY replacement will be called `console`.

Echoing, line control, etc., for `console` is controlled by the terminal emulator , not the kernel. The program can send escape codes (`\e` or `\x1b`) to change the settings (echoing, what key to use to kill programs, etc.), request information about the terminal (e.g. width/height, current settings, supported features of terminal emulator), change the position of the cursor, change the appearence of text, or clear text. They do not require a `[` after the `\e`, like ANSI escapes. There is a setting to turn off escape codes, until a timer has run out, a program has exited, or a file is unlocked. In addition, they are binary based, not text based.
The format is: `\e` + command (256 different commands) + args (args are known from the command, strings are length prefixed with a u32)
| Command | Args | Description |
|--|--|--
| 0x00 | - | Resets everything to defaults. (TODO: specify defaults) |
| 0x01 | u16 | Set settings to preset arg(0). See Terminal Presets. |
| 0x02 | u8 | Set color to arg(0) |
| 0x03 | u8 | Set position to arg(0) (in relation to top left, and numbers larger the terminal width go on next line) |
| 0x04 | u16 | Set position to arg(0) (in relation to top left, and numbers larger the terminal width go on next line) |
| 0x05 | u64 | Set position to arg(0) (in relation to top left, and numbers larger the terminal width go on next line) |
| 0x06 | u16, u16 | Set position to (arg(0), arg(1)) |
| 0x07 | u64, u64 | Set position to (arg(0), arg(1)) |
| 0x08 | u8, u8, u8 | Set color to RGB of (R: arg(0), G: arg(1), B: arg(2)) |
| 0x09 | u8, u8, u8, u8 | Set color to RGBA of (R: arg(0), G: arg(1), B: arg(2), A: arg(3)) |
| 0x0a | u8, bool | Set text setting arg(0) to arg(1). See Text Settings |
| 0x0b | u256 | Same as above, but set all at the same time with bitfield. |
| 0x0c | u8, u8, u8, u8 | Set color of element arg(0) to RGB of (R: arg(1), G: arg(2), B: arg(3)). Element (arg(0)) is defined as 0x00: Foreground, 0x01: Background, 0x02: Underline, 0x03: Overline, 0x04: Blinking speed where arg(1-3) is a u24 specifying the milliseconds between blinks. |
| 0x0d | - | Swap foreground and background colors. |
| 0x0e | u8, bool | Set Terminal Setting arg(0) to arg(1). See Terminal Settings. |
| 0x0f | u8, i16 | Set Terminal Setting arg(0) to arg(1), but with more options than on/off. See Terminal Settings. |

## Terminal Presets
| Number | Description |
|--|--|
| 0x00 | Default, same as `\e\x00`. |
| 0x01 | Shells should run this before starting a Program. |

## Text Settings
| Number | Description |
|--|--|
| 0x00 | Hidden (Printing text moves cursor, but does not display.) |
| 0x01 | Bold |
| 0x02 | Italic |
| 0x03 | Backwards Italic |
| 0x04 | Underlined |
| 0x05 | Overline |
| 0x06 | Superscript |
| 0x07 | Subscript |
| 0x08 | Framed (All text within is framed with a rectangle (or a polygon with more sides, if it is multiline, but still only right angles), will add screeshot of examples sometime) |
| 0x09 | Blink (default twice per second) |
| 0xfe | Rainbow (Equivalent to adding '| lolcat' to the end of the command) |
| 0xff | Rainbow, but strobing (speed controlled by blink speed) |

## Terminal Settings
| Number | Description |
|--|--|
| 0x00 | Input Echoing (display `console.r.0` on screen) |
| 0x01 | Output Echoing (display `console.w.0` on screen |
| 0x02 | Debug Input Echoing (display `console.r.1` on screen) |
| 0x03 | Debug Output Echoing (display `console.r.1` on screen) |
| 0x04 | EOF char, arg is the char that will send an EOF to `console.r.<current-mode>` |
| 0x05 | EOL char, arg is the char that will send a newline to `console.r.<current-mode>`. |
| 0x06 | Switch char, arg is the char that will switch between debug input and normal input. |
| 0x07 | Erase char, arg is the char that will delete the previous character in `console.r.<current-mode>`. |
| 0x08 | Erasing can erase to previous line. |
| 0x09 | Quit char, arg is the char that will send a quit signal to the running process. |
| 0x0a | Speed char, arg is the baud rate/100. |
| 0x0b | Line buffering (waiting until newline to flush input) |
| 0x0c | n Buffering flush every arg characters (0 means disabled) |
| 0x0d | n Buffering flush every arg characters (0 means disabled) |
| 0x0e | Enable Output |
| 0x0f | Enable Input |