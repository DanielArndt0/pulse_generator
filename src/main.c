#include "pulse_generator.h"

void interrupt(void)
{
    pulse_generator_isr();
}

void main(void)
{
    pulse_generator_init();

    while (1)
    {
        pulse_generator_task();
    }
}
