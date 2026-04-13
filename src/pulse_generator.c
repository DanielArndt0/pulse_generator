#include "app_config.h"
#include "display.h"
#include "pulse_generator.h"

static unsigned char adjust_pressed;
static unsigned char adjust_event;
static unsigned char upload_pressed;
static unsigned char upload_event;
static unsigned char inc_pressed;
static unsigned char inc_event;
static unsigned char dec_pressed;
static unsigned char dec_event;

static unsigned char adjust_mode;
static unsigned char selected_digit = 1u;
static unsigned int pulse_count;

static void hardware_init(void);
static void timer0_init(void);
static void button_update(unsigned char raw_state,
                          unsigned char *pressed_flag,
                          unsigned char *event_flag);
static void buttons_read(void);
static void buttons_handle(void);
static unsigned int pulse_get_step(unsigned char digit_index);
static void pulse_output_run(unsigned int count);

void pulse_generator_init(void)
{
    hardware_init();
    timer0_init();
    display_init();
}

void pulse_generator_task(void)
{
    buttons_read();
    buttons_handle();
}

void pulse_generator_isr(void)
{
    if (T0IF_bit)
    {
        TMR0 = 0x06;
        T0IF_bit = 0u;
        display_refresh(pulse_count, selected_digit, adjust_mode);
    }
}

static void hardware_init(void)
{
    TRISA = 0x00;
    PORTA = 0xFF;

    TRISB = 0x2C;
    PORTB = 0x00;
}

static void timer0_init(void)
{
    GIE_bit = 1u;
    PEIE_bit = 1u;
    T0IE_bit = 1u;

    TMR0 = 0x06;
    OPTION_REG = 0x02;
}

static void button_update(unsigned char raw_state,
                          unsigned char *pressed_flag,
                          unsigned char *event_flag)
{
    if (raw_state)
    {
        *pressed_flag = 1u;
    }

    if ((!raw_state) && (*pressed_flag))
    {
        *pressed_flag = 0u;
        *event_flag = 1u;
    }
}

static void buttons_read(void)
{
    button_update(BUTTON_ADJUST, &adjust_pressed, &adjust_event);
    button_update(BUTTON_UPLOAD, &upload_pressed, &upload_event);
    button_update(BUTTON_INC, &inc_pressed, &inc_event);
    button_update(BUTTON_DEC_IS_PRESSED(), &dec_pressed, &dec_event);
}

static void buttons_handle(void)
{
    if (adjust_event)
    {
        adjust_event = 0u;
        adjust_mode = 1u;
        selected_digit++;

        if (selected_digit > DISPLAY_DIGIT_COUNT)
        {
            selected_digit = 1u;
        }
    }

    if (inc_event && adjust_mode)
    {
        inc_event = 0u;
        pulse_count += pulse_get_step(selected_digit);

        if (pulse_count > PULSE_MAX_VALUE)
        {
            pulse_count = 0u;
        }
    }
    else
    {
        inc_event = 0u;
    }

    if (dec_event && adjust_mode)
    {
        unsigned int step;

        dec_event = 0u;
        step = pulse_get_step(selected_digit);

        if (pulse_count >= step)
        {
            pulse_count -= step;
        }
        else
        {
            pulse_count = PULSE_MAX_VALUE;
        }
    }
    else
    {
        dec_event = 0u;
    }

    if (upload_event)
    {
        upload_event = 0u;
        adjust_mode = 0u;
        pulse_output_run(pulse_count);
    }
}

static unsigned int pulse_get_step(unsigned char digit_index)
{
    switch (digit_index)
    {
        case 1u:
            return 100u;

        case 2u:
            return 10u;

        case 3u:
            return 1u;

        default:
            return 1u;
    }
}

static void pulse_output_run(unsigned int count)
{
    unsigned int i;

    for (i = 0u; i < count; i++)
    {
        PULSE_OUTPUT = 1u;
        Delay_ms(PULSE_HIGH_TIME_MS);

        PULSE_OUTPUT = 0u;
        Delay_ms(PULSE_LOW_TIME_MS);
    }
}
