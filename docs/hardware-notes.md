# Hardware Notes

## Original source characteristics

The original source used the following hardware assumptions:

- [`PIC16F648A`](./PIC16F648A.pdf)
- `4 MHz` clock
- multiplexed seven-segment display
- pulse output on `RB4`
- button inputs on `RB2`, `RB3`, and `RB5`

## Important note about digit mapping

The source code provided for this refactor includes **three active digit-enable mappings**:

- `RA1`
- `RA6`
- `RB7`

A fourth digit was mentioned conceptually, but it was not fully mapped in the original firmware source.

If your hardware really uses four display digits, add the fourth enable line in [`include/app_config.h`](../include/app_config.h) and extend the display refresh routine in [`src/display.c`](../src/display.c).

## Decrement button

The original source did not include an active decrement input mapping.

For that reason, the reorganized version keeps decrement support as an optional expansion point through the `BUTTON_DEC_IS_PRESSED()` macro in [`include/app_config.h`](../include/app_config.h).

## Timer0 refresh

The display is refreshed inside the `TIMER0` interrupt service routine to keep the multiplexing stable while the main loop handles button processing and pulse generation.
