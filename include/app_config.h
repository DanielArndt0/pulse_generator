#ifndef APP_CONFIG_H
#define APP_CONFIG_H

/*
 * Hardware and firmware configuration for the pulse generator.
 *
 * Target MCU: PIC16F648A
 * Clock: 4 MHz
 * Compiler / IDE: mikroC PRO v7.2.0
 */

#define PULSE_HIGH_TIME_MS    1u
#define PULSE_LOW_TIME_MS     1u
#define PULSE_MAX_VALUE       999u

/*
 * The original source currently maps three active display digits.
 * If your hardware includes a fourth digit, extend the mapping and
 * refresh routine accordingly.
 */
#define DISPLAY_DIGIT_COUNT   3u

/* Display enable lines (active-low selection) */
#define DISP_1                RA1_bit
#define DISP_2                RA6_bit
#define DISP_3                RB7_bit

/* Seven-segment bus */
#define SEG_A                 RA0_bit
#define SEG_B                 RB6_bit
#define SEG_C                 RB0_bit
#define SEG_D                 RA3_bit
#define SEG_E                 RA2_bit
#define SEG_F                 RA7_bit
#define SEG_G                 RB1_bit
#define SEG_DP                RA4_bit

/* Buttons */
#define BUTTON_ADJUST         RB2_bit
#define BUTTON_INC            RB3_bit
#define BUTTON_UPLOAD         RB5_bit

/*
 * The original firmware did not provide an active decrement input mapping.
 * Keep this macro returning 0 until a real decrement pin is wired.
 */
#define BUTTON_DEC_IS_PRESSED()  (0u)

/* Pulse output */
#define PULSE_OUTPUT          RB4_bit

#endif
