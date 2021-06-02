#include <stdbool.h>

// Definições
#define ton 1
#define toff 1

// Mapeamento de hardware
    // Displays
   #define dsp1  RA1_bit
   #define dsp2  RA6_bit
   #define dsp3  RB7_bit
   //#define dsp4  RD3_bit

   // Segmentos
   #define  A RA0_bit
   #define  B RB6_bit
   #define  C RB0_bit
   #define  D RA3_bit
   #define  E RA2_bit
   #define  F RA7_bit
   #define  G RB1_bit
   #define  point RA4_bit
   
   // Botões
   #define adj RB2_bit
   #define inc RB3_bit
   #define dec 0x00
   #define upl RB5_bit
   
   // Saída de pulsos
   #define out_pulses RB4_bit

// Protótipo de funções
void displayInit();
void DispMultiplex(int num);
void clearData();
void decodeDisplay(int num);

void read_button();
void buttonFunction();

// Variáveis globais
int valor;
bool fAdj, fBAdj,
     fUpl, fBUpl,
     fDec, fBDec,
     fInc, fBInc;
bool fAdjustMode;

int adjustNum = 0x00;
int pulses = 0x00;


//============================================================================//
void interrupt()
{
  if (T0IF_bit)                                                                 // Overflow do TIMER0 configurado para 1ms
  {
    TMR0 = 0x06;
    T0IF_bit = 0x00;
    DispMultiplex(pulses);
  }
}

//============================================================================//
void main()
{
  displayInit();
  while(1)
  {
    read_button();
    buttonFunction();
  }
}

//============================================================================//
void displayInit()                                                              // Inicializa display e configura timer0
{
  TRISA = 0x00;                                                                 // Configura PORTA
  PORTA = 0xFF;
  
  TRISB = 0x2C;                                                                 // Configura PORTB
  PORTB = 0x00;

  GIE_bit = 0x01;                                                               // Habilita interrupção global
  PEIE_bit = 0x01;                                                              // Habilita interrupção periférica
  T0IE_bit = 0x01;                                                              // Habilita interrupção do TIMER0
  TMR0 = 0x06;                                                                  // Inicializa TIMER0 EM 6
  OPTION_REG = 0x02;                                                            // Configura prescaler para 1:8
}

//============================================================================//
void DispMultiplex(int num)
{
  static char display = 0x01;

  if (display == 0x01 && dsp1)                                                  // Multiplexa display 1
  {
    display =  0x02;
    dsp2 = 0x01;
    dsp3 = 0x01;
    //dsp4 = 0x01;
    clearData();
    dsp1 = 0x00;
    decodeDisplay ((num % 0x03E8)/0x64);
    if (adjustNum == 0x01 && fAdjustMode)point = 0x01;
    else point = 0x00;
  }

  else if (display == 0x02 && dsp2)                                             // Multiplexa display 2
  {
    display =  0x03;
    dsp1 = 0x01;
    dsp3 = 0x01;
    //dsp4 = 0x01;
    clearData();
    dsp2 = 0x00;
    decodeDisplay (((num % 0x03E8)%0x64)/0x0A);
    if (adjustNum == 0x02 && fAdjustMode)point = 0x01;
    else point = 0x00;
  }

  else if (display == 0x03 && dsp3)                                             // Multiplexa display 3
  {
    display =  0x01;
    dsp1 = 0x01;
    dsp2 = 0x01;
    //dsp4 = 0x01;
    clearData();
    dsp3 = 0x00;
    decodeDisplay (num % 0x0A);
    if (adjustNum == 0x03 && fAdjustMode)point = 0x01;
    else point = 0x00;
  }
/*
  else if (display == 0x04 && dsp4)                                             // Multiplexa display 4
  {
    display =  0x01;
    dsp1 = 0x01;
    dsp2 = 0x01;
    dsp3 = 0x01;
    clearData();
    dsp4 = 0x00;
    decodeDisplay (num % 10);
  }
*/
}

//============================================================================//
void clearData()                                                                // Função auxiliar que limpa o barramento de dados
{
   A = 0x00;
   B = 0x00;
   C = 0x00;
   D = 0x00;
   E = 0x00;
   F = 0x00;
   G = 0x00;
}

//============================================================================//
void decodeDisplay(int num)                                                     // Função auxiliar que decodifica display
{
  if (num == 0x00)
  {
     A = 0x01;
     B = 0x01;
     C = 0x01;
     D = 0x01;
     E = 0x01;
     F = 0x01;
     G = 0x00;
  }


  else if (num == 0x01)
  {
     A = 0x00;
     B = 0x01;
     C = 0x01;
     D = 0x00;
     E = 0x00;
     F = 0x00;
     G = 0x00;
  }


  else if (num == 0x02)
  {
     A = 0x01;
     B = 0x01;
     C = 0x00;
     D = 0x01;
     E = 0x01;
     F = 0x00;
     G = 0x01;
  }


  else if (num == 0x03)
  {
     A = 0x01;
     B = 0x01;
     C = 0x01;
     D = 0x01;
     E = 0x00;
     F = 0x00;
     G = 0x01;
  }


  else if (num == 0x04)
  {
     A = 0x00;
     B = 0x01;
     C = 0x01;
     D = 0x00;
     E = 0x00;
     F = 0x01;
     G = 0x01;
  }


  else if (num == 0x05)
  {
     A = 0x01;
     B = 0x00;
     C = 0x01;
     D = 0x01;
     E = 0x00;
     F = 0x01;
     G = 0x01;
  }


  else if (num == 0x06)
  {
     A = 0x01;
     B = 0x00;
     C = 0x01;
     D = 0x01;
     E = 0x01;
     F = 0x01;
     G = 0x01;
  }

  else if (num == 0x07)
  {
     A = 0x01;
     B = 0x01;
     C = 0x01;
     D = 0x00;
     E = 0x00;
     F = 0x00;
     G = 0x00;
  }

  else if (num == 0x08)
  {
     A = 0x01;
     B = 0x01;
     C = 0x01;
     D = 0x01;
     E = 0x01;
     F = 0x01;
     G = 0x01;
  }


  else if (num == 0x09)
  {
     A = 0x01;
     B = 0x01;
     C = 0x01;
     D = 0x01;
     E = 0x00;
     F = 0x01;
     G = 0x01;
  }
}

//============================================================================//
void read_button()
{
  // ADJUST BUTTON
  if (adj) fAdj = 0x01;
  if (!adj && fAdj)
  {
    fAdj = 0x00;
    fBAdj = 0x01;
  }

  // UPLOAD BUTTON
  if (upl) fUpl = 0x01;
  if (!upl && fUpl)
  {
    fUpl = 0x00;
    fBUpl = 0x01;
  }

  // Increase button
  if (inc) fInc = 0x01;
  if (!inc && fInc)
  {
    fInc = 0x00;
    fBInc = 0x01;
  }

  // Decrease button
  if (dec) fDec = 0x01;
  if (!dec && fDec)
  {
    fDec = 0x00;
    fBDec = 0x01;
  }
}

//============================================================================//
void buttonFunction()
{
  if (fBAdj)
  {
    fBAdj = 0x00;
    fAdjustMode = 0x01;
    adjustNum++;

    if (adjustNum > 0x03) adjustNum = 0x01;
  }

  if (fBInc && fAdjustMode)
  {
    fBInc = 0x00;
    switch (adjustNum)
    {
      case 0x01: pulses += 100; break;
      case 0x02: pulses += 10; break;
      case 0x03: pulses += 1; break;
    }
    if (pulses > 0x03E7) pulses = 0x00;
  }
/*
  if (fBDec && fAdjustMode)
  {
    fBDec = 0x00;
    switch (adjustNum)
    {
      case 0x01: pulses -= 100; break;
      case 0x02: pulses -= 10; break;
      case 0x03: pulses -= 1; break;
    }
    if (pulses < 0x00 ) pulses = 0x03E7;
  }
*/

  if (fBUpl)
  {
    int i;
    fAdjustMode = 0x00;
    fBUpl = 0x00;
    for (i = 0x00; i < pulses; i++)
    {
      out_pulses = 0x01;
      //LED = 0x00;
      delay_ms(toff);
      out_pulses = 0x00;
      //LED = 0x01;
      delay_ms(ton);
    }
    //LED = 0x01;
  }
}