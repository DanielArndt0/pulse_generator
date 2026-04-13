# Pulse Generator for PIC

A pulse generator firmware example for the [**PIC16F648A**](docs/PIC16F648A.pdf) using **MikroC PRO** and a multiplexed seven-segment display interface.

## Overview

This project implements a configurable pulse generator controlled by push buttons and displayed on multiplexed seven-segment digits.

The firmware allows the user to:

- select the digit being adjusted
- increase the pulse count value
- trigger pulse generation on the output pin
- visualize the configured value on the display in real time

The codebase was reorganized into a small library-oriented structure to make the project easier to understand, maintain, and expand.

## Technical Details

| Category | Details |
|:--|:--|
| **Microcontroller** | [`PIC16F648A`](docs/PIC16F648A.pdf) |
| **Clock** | `4 MHz` |
| **Language** | `C` |
| **Compiler / IDE** | `MikroC PRO v7.2.0` |

## Features

- pulse count adjustment through buttons
- multiplexed seven-segment display refresh using `TIMER0`
- decimal point indication for the selected adjustment digit
- pulse output generation on a dedicated output pin
- modular source organization with separate application and display logic

## Project Structure

```bash
├── include/
│   ├── app_config.h
│   ├── display.h
│   └── pulse_generator.h
├── src/
│   ├── display.c
│   ├── main.c
│   └── pulse_generator.c
├── docs/
│   └── hardware-notes.md
├── .gitignore
├── LICENSE
└── README.md
```

## Modules

### [`display`](include/display.h)

Handles the multiplexed seven-segment display logic:

- segment decoding
- display clearing
- digit selection
- periodic refresh based on the current pulse count

### [`pulse_generator`](include/pulse_generator.h)

Handles the application logic:

- hardware initialization
- button event reading
- adjustment mode control
- pulse count update
- pulse output execution
- `TIMER0` interrupt service integration

### [`app_config`](include/app_config.h)

Centralizes hardware mapping and firmware constants such as:

- pin definitions
- pulse timing
- display behavior
- button configuration

## Current Behavior

- `BUTTON_ADJUST` selects which digit is being edited
- `BUTTON_INC` increases the selected digit
- `BUTTON_UPLOAD` starts pulse generation using the configured value
- the decimal point marks the currently selected digit during adjustment mode

## Notes

The original source provided for this refactor has **three active digit-select lines mapped in firmware**. A fourth digit can be added later by extending the hardware mapping and refresh routine.

The decrement input is also left as an optional expansion point because the original implementation did not provide an active decrement pin mapping.

## Author

[**Daniel Gier Arndt**](https://github.com/DanielArndt0)
