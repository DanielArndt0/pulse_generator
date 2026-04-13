#include "app_config.h"
#include "display.h"

static void display_disable_all(void);
static void display_clear_segments(void);
static void display_write_digit(unsigned char digit);
static unsigned char display_extract_digit(unsigned int value,
                                           unsigned char digit_index);

void display_init(void)
{
    display_disable_all();
    display_clear_segments();
}

void display_refresh(unsigned int value,
                     unsigned char selected_digit,
                     unsigned char adjust_mode)
{
    static unsigned char current_digit = 1u;
    unsigned char digit_value;

    if (current_digit > DISPLAY_DIGIT_COUNT)
    {
        current_digit = 1u;
    }

    display_disable_all();
    display_clear_segments();

    digit_value = display_extract_digit(value, current_digit);
    display_write_digit(digit_value);

    if (adjust_mode && (selected_digit == current_digit))
    {
        SEG_DP = 1u;
    }

    switch (current_digit)
    {
        case 1u:
            DISP_1 = 0u;
            break;

        case 2u:
            DISP_2 = 0u;
            break;

        case 3u:
            DISP_3 = 0u;
            break;

        default:
            break;
    }

    current_digit++;
    if (current_digit > DISPLAY_DIGIT_COUNT)
    {
        current_digit = 1u;
    }
}

static void display_disable_all(void)
{
    DISP_1 = 1u;
    DISP_2 = 1u;
    DISP_3 = 1u;
}

static void display_clear_segments(void)
{
    SEG_A = 0u;
    SEG_B = 0u;
    SEG_C = 0u;
    SEG_D = 0u;
    SEG_E = 0u;
    SEG_F = 0u;
    SEG_G = 0u;
    SEG_DP = 0u;
}

static void display_write_digit(unsigned char digit)
{
    switch (digit)
    {
        case 0u:
            SEG_A = 1u; SEG_B = 1u; SEG_C = 1u; SEG_D = 1u;
            SEG_E = 1u; SEG_F = 1u; SEG_G = 0u;
            break;

        case 1u:
            SEG_A = 0u; SEG_B = 1u; SEG_C = 1u; SEG_D = 0u;
            SEG_E = 0u; SEG_F = 0u; SEG_G = 0u;
            break;

        case 2u:
            SEG_A = 1u; SEG_B = 1u; SEG_C = 0u; SEG_D = 1u;
            SEG_E = 1u; SEG_F = 0u; SEG_G = 1u;
            break;

        case 3u:
            SEG_A = 1u; SEG_B = 1u; SEG_C = 1u; SEG_D = 1u;
            SEG_E = 0u; SEG_F = 0u; SEG_G = 1u;
            break;

        case 4u:
            SEG_A = 0u; SEG_B = 1u; SEG_C = 1u; SEG_D = 0u;
            SEG_E = 0u; SEG_F = 1u; SEG_G = 1u;
            break;

        case 5u:
            SEG_A = 1u; SEG_B = 0u; SEG_C = 1u; SEG_D = 1u;
            SEG_E = 0u; SEG_F = 1u; SEG_G = 1u;
            break;

        case 6u:
            SEG_A = 1u; SEG_B = 0u; SEG_C = 1u; SEG_D = 1u;
            SEG_E = 1u; SEG_F = 1u; SEG_G = 1u;
            break;

        case 7u:
            SEG_A = 1u; SEG_B = 1u; SEG_C = 1u; SEG_D = 0u;
            SEG_E = 0u; SEG_F = 0u; SEG_G = 0u;
            break;

        case 8u:
            SEG_A = 1u; SEG_B = 1u; SEG_C = 1u; SEG_D = 1u;
            SEG_E = 1u; SEG_F = 1u; SEG_G = 1u;
            break;

        case 9u:
            SEG_A = 1u; SEG_B = 1u; SEG_C = 1u; SEG_D = 1u;
            SEG_E = 0u; SEG_F = 1u; SEG_G = 1u;
            break;

        default:
            break;
    }
}

static unsigned char display_extract_digit(unsigned int value,
                                           unsigned char digit_index)
{
    switch (digit_index)
    {
        case 1u:
            return (unsigned char)((value / 100u) % 10u);

        case 2u:
            return (unsigned char)((value / 10u) % 10u);

        case 3u:
            return (unsigned char)(value % 10u);

        default:
            return 0u;
    }
}
