#ifndef DISPLAY_H
#define DISPLAY_H

void display_init(void);
void display_refresh(unsigned int value,
                     unsigned char selected_digit,
                     unsigned char adjust_mode);

#endif
