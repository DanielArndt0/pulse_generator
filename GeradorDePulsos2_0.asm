
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;GeradorDePulsos2_0.c,55 :: 		void interrupt()
;GeradorDePulsos2_0.c,57 :: 		if (T0IF_bit)                                                                 // Overflow do TIMER0 configurado para 1ms
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L_interrupt0
;GeradorDePulsos2_0.c,59 :: 		TMR0 = 0x06;
	MOVLW      6
	MOVWF      TMR0+0
;GeradorDePulsos2_0.c,60 :: 		T0IF_bit = 0x00;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;GeradorDePulsos2_0.c,61 :: 		DispMultiplex(pulses);
	MOVF       _pulses+0, 0
	MOVWF      FARG_DispMultiplex_num+0
	MOVF       _pulses+1, 0
	MOVWF      FARG_DispMultiplex_num+1
	CALL       _DispMultiplex+0
;GeradorDePulsos2_0.c,62 :: 		}
L_interrupt0:
;GeradorDePulsos2_0.c,63 :: 		}
L_end_interrupt:
L__interrupt90:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;GeradorDePulsos2_0.c,66 :: 		void main()
;GeradorDePulsos2_0.c,68 :: 		displayInit();
	CALL       _displayInit+0
;GeradorDePulsos2_0.c,69 :: 		while(1)
L_main1:
;GeradorDePulsos2_0.c,71 :: 		read_button();
	CALL       _read_button+0
;GeradorDePulsos2_0.c,72 :: 		buttonFunction();
	CALL       _buttonFunction+0
;GeradorDePulsos2_0.c,73 :: 		}
	GOTO       L_main1
;GeradorDePulsos2_0.c,74 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_displayInit:

;GeradorDePulsos2_0.c,77 :: 		void displayInit()                                                              // Inicializa display e configura timer0
;GeradorDePulsos2_0.c,79 :: 		TRISA = 0x00;                                                                 // Configura PORTA
	CLRF       TRISA+0
;GeradorDePulsos2_0.c,80 :: 		PORTA = 0xEF;
	MOVLW      239
	MOVWF      PORTA+0
;GeradorDePulsos2_0.c,82 :: 		TRISB = 0x2C;                                                                 // Configura PORTB
	MOVLW      44
	MOVWF      TRISB+0
;GeradorDePulsos2_0.c,83 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;GeradorDePulsos2_0.c,85 :: 		GIE_bit = 0x01;                                                               // Habilita interrupção global
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;GeradorDePulsos2_0.c,86 :: 		PEIE_bit = 0x01;                                                              // Habilita interrupção periférica
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;GeradorDePulsos2_0.c,87 :: 		T0IE_bit = 0x01;                                                              // Habilita interrupção do TIMER0
	BSF        T0IE_bit+0, BitPos(T0IE_bit+0)
;GeradorDePulsos2_0.c,88 :: 		TMR0 = 0x06;                                                                  // Inicializa TIMER0 EM 6
	MOVLW      6
	MOVWF      TMR0+0
;GeradorDePulsos2_0.c,89 :: 		OPTION_REG = 0x02;                                                            // Configura prescaler para 1:8
	MOVLW      2
	MOVWF      OPTION_REG+0
;GeradorDePulsos2_0.c,90 :: 		}
L_end_displayInit:
	RETURN
; end of _displayInit

_DispMultiplex:

;GeradorDePulsos2_0.c,93 :: 		void DispMultiplex(int num)
;GeradorDePulsos2_0.c,97 :: 		if (display == 0x01 && dsp1)                                                  // Multiplexa display 1
	MOVF       DispMultiplex_display_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_DispMultiplex5
	BTFSS      RA1_bit+0, BitPos(RA1_bit+0)
	GOTO       L_DispMultiplex5
L__DispMultiplex83:
;GeradorDePulsos2_0.c,99 :: 		display =  0x02;
	MOVLW      2
	MOVWF      DispMultiplex_display_L0+0
;GeradorDePulsos2_0.c,100 :: 		dsp2 = 0x01;
	BSF        RA6_bit+0, BitPos(RA6_bit+0)
;GeradorDePulsos2_0.c,101 :: 		dsp3 = 0x01;
	BSF        RB7_bit+0, BitPos(RB7_bit+0)
;GeradorDePulsos2_0.c,103 :: 		clearData();
	CALL       _clearData+0
;GeradorDePulsos2_0.c,104 :: 		dsp1 = 0x00;
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
;GeradorDePulsos2_0.c,105 :: 		decodeDisplay ((num % 0x03E8)/0x64);
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       FARG_DispMultiplex_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_DispMultiplex_num+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_decodeDisplay_num+0
	MOVF       R0+1, 0
	MOVWF      FARG_decodeDisplay_num+1
	CALL       _decodeDisplay+0
;GeradorDePulsos2_0.c,106 :: 		if (adjustNum == 0x01 && fAdjustMode)point = 0x01;
	MOVLW      0
	XORWF      _adjustNum+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__DispMultiplex94
	MOVLW      1
	XORWF      _adjustNum+0, 0
L__DispMultiplex94:
	BTFSS      STATUS+0, 2
	GOTO       L_DispMultiplex8
	MOVF       _fAdjustMode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_DispMultiplex8
L__DispMultiplex82:
	BSF        RA4_bit+0, BitPos(RA4_bit+0)
	GOTO       L_DispMultiplex9
L_DispMultiplex8:
;GeradorDePulsos2_0.c,107 :: 		else point = 0x00;
	BCF        RA4_bit+0, BitPos(RA4_bit+0)
L_DispMultiplex9:
;GeradorDePulsos2_0.c,108 :: 		}
	GOTO       L_DispMultiplex10
L_DispMultiplex5:
;GeradorDePulsos2_0.c,110 :: 		else if (display == 0x02 && dsp2)                                             // Multiplexa display 2
	MOVF       DispMultiplex_display_L0+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_DispMultiplex13
	BTFSS      RA6_bit+0, BitPos(RA6_bit+0)
	GOTO       L_DispMultiplex13
L__DispMultiplex81:
;GeradorDePulsos2_0.c,112 :: 		display =  0x03;
	MOVLW      3
	MOVWF      DispMultiplex_display_L0+0
;GeradorDePulsos2_0.c,113 :: 		dsp1 = 0x01;
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
;GeradorDePulsos2_0.c,114 :: 		dsp3 = 0x01;
	BSF        RB7_bit+0, BitPos(RB7_bit+0)
;GeradorDePulsos2_0.c,116 :: 		clearData();
	CALL       _clearData+0
;GeradorDePulsos2_0.c,117 :: 		dsp2 = 0x00;
	BCF        RA6_bit+0, BitPos(RA6_bit+0)
;GeradorDePulsos2_0.c,118 :: 		decodeDisplay (((num % 0x03E8)%0x64)/0x0A);
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       FARG_DispMultiplex_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_DispMultiplex_num+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      FARG_decodeDisplay_num+0
	MOVF       R0+1, 0
	MOVWF      FARG_decodeDisplay_num+1
	CALL       _decodeDisplay+0
;GeradorDePulsos2_0.c,119 :: 		if (adjustNum == 0x02 && fAdjustMode)point = 0x01;
	MOVLW      0
	XORWF      _adjustNum+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__DispMultiplex95
	MOVLW      2
	XORWF      _adjustNum+0, 0
L__DispMultiplex95:
	BTFSS      STATUS+0, 2
	GOTO       L_DispMultiplex16
	MOVF       _fAdjustMode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_DispMultiplex16
L__DispMultiplex80:
	BSF        RA4_bit+0, BitPos(RA4_bit+0)
	GOTO       L_DispMultiplex17
L_DispMultiplex16:
;GeradorDePulsos2_0.c,120 :: 		else point = 0x00;
	BCF        RA4_bit+0, BitPos(RA4_bit+0)
L_DispMultiplex17:
;GeradorDePulsos2_0.c,121 :: 		}
	GOTO       L_DispMultiplex18
L_DispMultiplex13:
;GeradorDePulsos2_0.c,123 :: 		else if (display == 0x03 && dsp3)                                             // Multiplexa display 3
	MOVF       DispMultiplex_display_L0+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_DispMultiplex21
	BTFSS      RB7_bit+0, BitPos(RB7_bit+0)
	GOTO       L_DispMultiplex21
L__DispMultiplex79:
;GeradorDePulsos2_0.c,125 :: 		display =  0x01;
	MOVLW      1
	MOVWF      DispMultiplex_display_L0+0
;GeradorDePulsos2_0.c,126 :: 		dsp1 = 0x01;
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
;GeradorDePulsos2_0.c,127 :: 		dsp2 = 0x01;
	BSF        RA6_bit+0, BitPos(RA6_bit+0)
;GeradorDePulsos2_0.c,129 :: 		clearData();
	CALL       _clearData+0
;GeradorDePulsos2_0.c,130 :: 		dsp3 = 0x00;
	BCF        RB7_bit+0, BitPos(RB7_bit+0)
;GeradorDePulsos2_0.c,131 :: 		decodeDisplay (num % 0x0A);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_DispMultiplex_num+0, 0
	MOVWF      R0+0
	MOVF       FARG_DispMultiplex_num+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      FARG_decodeDisplay_num+0
	MOVF       R0+1, 0
	MOVWF      FARG_decodeDisplay_num+1
	CALL       _decodeDisplay+0
;GeradorDePulsos2_0.c,132 :: 		if (adjustNum == 0x03 && fAdjustMode)point = 0x01;
	MOVLW      0
	XORWF      _adjustNum+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__DispMultiplex96
	MOVLW      3
	XORWF      _adjustNum+0, 0
L__DispMultiplex96:
	BTFSS      STATUS+0, 2
	GOTO       L_DispMultiplex24
	MOVF       _fAdjustMode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_DispMultiplex24
L__DispMultiplex78:
	BSF        RA4_bit+0, BitPos(RA4_bit+0)
	GOTO       L_DispMultiplex25
L_DispMultiplex24:
;GeradorDePulsos2_0.c,133 :: 		else point = 0x00;
	BCF        RA4_bit+0, BitPos(RA4_bit+0)
L_DispMultiplex25:
;GeradorDePulsos2_0.c,134 :: 		}
L_DispMultiplex21:
L_DispMultiplex18:
L_DispMultiplex10:
;GeradorDePulsos2_0.c,147 :: 		}
L_end_DispMultiplex:
	RETURN
; end of _DispMultiplex

_clearData:

;GeradorDePulsos2_0.c,150 :: 		void clearData()                                                                // Função auxiliar que limpa o barramento de dados
;GeradorDePulsos2_0.c,152 :: 		A = 0x00;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,153 :: 		B = 0x00;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,154 :: 		C = 0x00;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,155 :: 		D = 0x00;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,156 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,157 :: 		F = 0x00;
	BCF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,158 :: 		G = 0x00;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,159 :: 		}
L_end_clearData:
	RETURN
; end of _clearData

_decodeDisplay:

;GeradorDePulsos2_0.c,162 :: 		void decodeDisplay(int num)                                                     // Função auxiliar que decodifica display
;GeradorDePulsos2_0.c,164 :: 		if (num == 0x00)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay99
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay99:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay26
;GeradorDePulsos2_0.c,166 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,167 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,168 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,169 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,170 :: 		E = 0x01;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,171 :: 		F = 0x01;
	BSF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,172 :: 		G = 0x00;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,173 :: 		}
	GOTO       L_decodeDisplay27
L_decodeDisplay26:
;GeradorDePulsos2_0.c,176 :: 		else if (num == 0x01)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay100
	MOVLW      1
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay100:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay28
;GeradorDePulsos2_0.c,178 :: 		A = 0x00;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,179 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,180 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,181 :: 		D = 0x00;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,182 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,183 :: 		F = 0x00;
	BCF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,184 :: 		G = 0x00;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,185 :: 		}
	GOTO       L_decodeDisplay29
L_decodeDisplay28:
;GeradorDePulsos2_0.c,188 :: 		else if (num == 0x02)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay101
	MOVLW      2
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay101:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay30
;GeradorDePulsos2_0.c,190 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,191 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,192 :: 		C = 0x00;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,193 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,194 :: 		E = 0x01;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,195 :: 		F = 0x00;
	BCF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,196 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,197 :: 		}
	GOTO       L_decodeDisplay31
L_decodeDisplay30:
;GeradorDePulsos2_0.c,200 :: 		else if (num == 0x03)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay102
	MOVLW      3
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay102:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay32
;GeradorDePulsos2_0.c,202 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,203 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,204 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,205 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,206 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,207 :: 		F = 0x00;
	BCF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,208 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,209 :: 		}
	GOTO       L_decodeDisplay33
L_decodeDisplay32:
;GeradorDePulsos2_0.c,212 :: 		else if (num == 0x04)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay103
	MOVLW      4
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay103:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay34
;GeradorDePulsos2_0.c,214 :: 		A = 0x00;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,215 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,216 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,217 :: 		D = 0x00;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,218 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,219 :: 		F = 0x01;
	BSF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,220 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,221 :: 		}
	GOTO       L_decodeDisplay35
L_decodeDisplay34:
;GeradorDePulsos2_0.c,224 :: 		else if (num == 0x05)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay104
	MOVLW      5
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay104:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay36
;GeradorDePulsos2_0.c,226 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,227 :: 		B = 0x00;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,228 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,229 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,230 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,231 :: 		F = 0x01;
	BSF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,232 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,233 :: 		}
	GOTO       L_decodeDisplay37
L_decodeDisplay36:
;GeradorDePulsos2_0.c,236 :: 		else if (num == 0x06)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay105
	MOVLW      6
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay105:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay38
;GeradorDePulsos2_0.c,238 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,239 :: 		B = 0x00;
	BCF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,240 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,241 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,242 :: 		E = 0x01;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,243 :: 		F = 0x01;
	BSF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,244 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,245 :: 		}
	GOTO       L_decodeDisplay39
L_decodeDisplay38:
;GeradorDePulsos2_0.c,247 :: 		else if (num == 0x07)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay106
	MOVLW      7
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay106:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay40
;GeradorDePulsos2_0.c,249 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,250 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,251 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,252 :: 		D = 0x00;
	BCF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,253 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,254 :: 		F = 0x00;
	BCF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,255 :: 		G = 0x00;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,256 :: 		}
	GOTO       L_decodeDisplay41
L_decodeDisplay40:
;GeradorDePulsos2_0.c,258 :: 		else if (num == 0x08)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay107
	MOVLW      8
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay107:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay42
;GeradorDePulsos2_0.c,260 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,261 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,262 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,263 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,264 :: 		E = 0x01;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,265 :: 		F = 0x01;
	BSF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,266 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,267 :: 		}
	GOTO       L_decodeDisplay43
L_decodeDisplay42:
;GeradorDePulsos2_0.c,270 :: 		else if (num == 0x09)
	MOVLW      0
	XORWF      FARG_decodeDisplay_num+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__decodeDisplay108
	MOVLW      9
	XORWF      FARG_decodeDisplay_num+0, 0
L__decodeDisplay108:
	BTFSS      STATUS+0, 2
	GOTO       L_decodeDisplay44
;GeradorDePulsos2_0.c,272 :: 		A = 0x01;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;GeradorDePulsos2_0.c,273 :: 		B = 0x01;
	BSF        RB6_bit+0, BitPos(RB6_bit+0)
;GeradorDePulsos2_0.c,274 :: 		C = 0x01;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;GeradorDePulsos2_0.c,275 :: 		D = 0x01;
	BSF        RA3_bit+0, BitPos(RA3_bit+0)
;GeradorDePulsos2_0.c,276 :: 		E = 0x00;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;GeradorDePulsos2_0.c,277 :: 		F = 0x01;
	BSF        RA7_bit+0, BitPos(RA7_bit+0)
;GeradorDePulsos2_0.c,278 :: 		G = 0x01;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;GeradorDePulsos2_0.c,279 :: 		}
L_decodeDisplay44:
L_decodeDisplay43:
L_decodeDisplay41:
L_decodeDisplay39:
L_decodeDisplay37:
L_decodeDisplay35:
L_decodeDisplay33:
L_decodeDisplay31:
L_decodeDisplay29:
L_decodeDisplay27:
;GeradorDePulsos2_0.c,280 :: 		}
L_end_decodeDisplay:
	RETURN
; end of _decodeDisplay

_read_button:

;GeradorDePulsos2_0.c,283 :: 		void read_button()
;GeradorDePulsos2_0.c,286 :: 		if (adj) fAdj = 0x01;
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_read_button45
	MOVLW      1
	MOVWF      _fAdj+0
L_read_button45:
;GeradorDePulsos2_0.c,287 :: 		if (!adj && fAdj)
	BTFSC      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_read_button48
	MOVF       _fAdj+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_button48
L__read_button87:
;GeradorDePulsos2_0.c,289 :: 		fAdj = 0x00;
	CLRF       _fAdj+0
;GeradorDePulsos2_0.c,290 :: 		fBAdj = 0x01;
	MOVLW      1
	MOVWF      _fBAdj+0
;GeradorDePulsos2_0.c,291 :: 		}
L_read_button48:
;GeradorDePulsos2_0.c,294 :: 		if (upl) fUpl = 0x01;
	BTFSS      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_read_button49
	MOVLW      1
	MOVWF      _fUpl+0
L_read_button49:
;GeradorDePulsos2_0.c,295 :: 		if (!upl && fUpl)
	BTFSC      RB5_bit+0, BitPos(RB5_bit+0)
	GOTO       L_read_button52
	MOVF       _fUpl+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_button52
L__read_button86:
;GeradorDePulsos2_0.c,297 :: 		fUpl = 0x00;
	CLRF       _fUpl+0
;GeradorDePulsos2_0.c,298 :: 		fBUpl = 0x01;
	MOVLW      1
	MOVWF      _fBUpl+0
;GeradorDePulsos2_0.c,299 :: 		}
L_read_button52:
;GeradorDePulsos2_0.c,302 :: 		if (inc) fInc = 0x01;
	BTFSS      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_read_button53
	MOVLW      1
	MOVWF      _fInc+0
L_read_button53:
;GeradorDePulsos2_0.c,303 :: 		if (!inc && fInc)
	BTFSC      RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_read_button56
	MOVF       _fInc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_button56
L__read_button85:
;GeradorDePulsos2_0.c,305 :: 		fInc = 0x00;
	CLRF       _fInc+0
;GeradorDePulsos2_0.c,306 :: 		fBInc = 0x01;
	MOVLW      1
	MOVWF      _fBInc+0
;GeradorDePulsos2_0.c,307 :: 		}
L_read_button56:
;GeradorDePulsos2_0.c,310 :: 		if (dec) fDec = 0x01;
L_read_button57:
;GeradorDePulsos2_0.c,311 :: 		if (!dec && fDec)
	MOVF       _fDec+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_button60
L__read_button84:
;GeradorDePulsos2_0.c,313 :: 		fDec = 0x00;
	CLRF       _fDec+0
;GeradorDePulsos2_0.c,314 :: 		fBDec = 0x01;
	MOVLW      1
	MOVWF      _fBDec+0
;GeradorDePulsos2_0.c,315 :: 		}
L_read_button60:
;GeradorDePulsos2_0.c,316 :: 		}
L_end_read_button:
	RETURN
; end of _read_button

_buttonFunction:

;GeradorDePulsos2_0.c,319 :: 		void buttonFunction()
;GeradorDePulsos2_0.c,321 :: 		if (fBAdj)
	MOVF       _fBAdj+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction61
;GeradorDePulsos2_0.c,323 :: 		fBAdj = 0x00;
	CLRF       _fBAdj+0
;GeradorDePulsos2_0.c,324 :: 		fAdjustMode = 0x01;
	MOVLW      1
	MOVWF      _fAdjustMode+0
;GeradorDePulsos2_0.c,325 :: 		adjustNum++;
	INCF       _adjustNum+0, 1
	BTFSC      STATUS+0, 2
	INCF       _adjustNum+1, 1
;GeradorDePulsos2_0.c,327 :: 		if (adjustNum > 0x03) adjustNum = 0x01;
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _adjustNum+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__buttonFunction111
	MOVF       _adjustNum+0, 0
	SUBLW      3
L__buttonFunction111:
	BTFSC      STATUS+0, 0
	GOTO       L_buttonFunction62
	MOVLW      1
	MOVWF      _adjustNum+0
	CLRF       _adjustNum+1
L_buttonFunction62:
;GeradorDePulsos2_0.c,328 :: 		}
L_buttonFunction61:
;GeradorDePulsos2_0.c,330 :: 		if (fBInc && fAdjustMode)
	MOVF       _fBInc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction65
	MOVF       _fAdjustMode+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction65
L__buttonFunction88:
;GeradorDePulsos2_0.c,332 :: 		fBInc = 0x00;
	CLRF       _fBInc+0
;GeradorDePulsos2_0.c,333 :: 		switch (adjustNum)
	GOTO       L_buttonFunction66
;GeradorDePulsos2_0.c,335 :: 		case 0x01: pulses += 100; break;
L_buttonFunction68:
	MOVLW      100
	ADDWF      _pulses+0, 1
	BTFSC      STATUS+0, 0
	INCF       _pulses+1, 1
	GOTO       L_buttonFunction67
;GeradorDePulsos2_0.c,336 :: 		case 0x02: pulses += 10; break;
L_buttonFunction69:
	MOVLW      10
	ADDWF      _pulses+0, 1
	BTFSC      STATUS+0, 0
	INCF       _pulses+1, 1
	GOTO       L_buttonFunction67
;GeradorDePulsos2_0.c,337 :: 		case 0x03: pulses += 1; break;
L_buttonFunction70:
	INCF       _pulses+0, 1
	BTFSC      STATUS+0, 2
	INCF       _pulses+1, 1
	GOTO       L_buttonFunction67
;GeradorDePulsos2_0.c,338 :: 		}
L_buttonFunction66:
	MOVLW      0
	XORWF      _adjustNum+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__buttonFunction112
	MOVLW      1
	XORWF      _adjustNum+0, 0
L__buttonFunction112:
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction68
	MOVLW      0
	XORWF      _adjustNum+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__buttonFunction113
	MOVLW      2
	XORWF      _adjustNum+0, 0
L__buttonFunction113:
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction69
	MOVLW      0
	XORWF      _adjustNum+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__buttonFunction114
	MOVLW      3
	XORWF      _adjustNum+0, 0
L__buttonFunction114:
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction70
L_buttonFunction67:
;GeradorDePulsos2_0.c,339 :: 		if (pulses > 0x03E7) pulses = 0x00;
	MOVLW      128
	XORLW      3
	MOVWF      R0+0
	MOVLW      128
	XORWF      _pulses+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__buttonFunction115
	MOVF       _pulses+0, 0
	SUBLW      231
L__buttonFunction115:
	BTFSC      STATUS+0, 0
	GOTO       L_buttonFunction71
	CLRF       _pulses+0
	CLRF       _pulses+1
L_buttonFunction71:
;GeradorDePulsos2_0.c,340 :: 		}
L_buttonFunction65:
;GeradorDePulsos2_0.c,355 :: 		if (fBUpl)
	MOVF       _fBUpl+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_buttonFunction72
;GeradorDePulsos2_0.c,358 :: 		fAdjustMode = 0x00;
	CLRF       _fAdjustMode+0
;GeradorDePulsos2_0.c,359 :: 		fBUpl = 0x00;
	CLRF       _fBUpl+0
;GeradorDePulsos2_0.c,360 :: 		for (i = 0x00; i < pulses; i++)
	CLRF       R1+0
	CLRF       R1+1
L_buttonFunction73:
	MOVLW      128
	XORWF      R1+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _pulses+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__buttonFunction116
	MOVF       _pulses+0, 0
	SUBWF      R1+0, 0
L__buttonFunction116:
	BTFSC      STATUS+0, 0
	GOTO       L_buttonFunction74
;GeradorDePulsos2_0.c,362 :: 		out_pulses = 0x01;
	BSF        RB4_bit+0, BitPos(RB4_bit+0)
;GeradorDePulsos2_0.c,364 :: 		delay_ms(toff);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_buttonFunction76:
	DECFSZ     R13+0, 1
	GOTO       L_buttonFunction76
	DECFSZ     R12+0, 1
	GOTO       L_buttonFunction76
;GeradorDePulsos2_0.c,365 :: 		out_pulses = 0x00;
	BCF        RB4_bit+0, BitPos(RB4_bit+0)
;GeradorDePulsos2_0.c,367 :: 		delay_ms(ton);
	MOVLW      2
	MOVWF      R12+0
	MOVLW      75
	MOVWF      R13+0
L_buttonFunction77:
	DECFSZ     R13+0, 1
	GOTO       L_buttonFunction77
	DECFSZ     R12+0, 1
	GOTO       L_buttonFunction77
;GeradorDePulsos2_0.c,360 :: 		for (i = 0x00; i < pulses; i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;GeradorDePulsos2_0.c,368 :: 		}
	GOTO       L_buttonFunction73
L_buttonFunction74:
;GeradorDePulsos2_0.c,370 :: 		}
L_buttonFunction72:
;GeradorDePulsos2_0.c,371 :: 		}
L_end_buttonFunction:
	RETURN
; end of _buttonFunction
