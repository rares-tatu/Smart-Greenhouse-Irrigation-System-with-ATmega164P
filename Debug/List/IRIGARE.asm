
;CodeVisionAVR C Compiler V4.03 Evaluation
;(C) Copyright 1998-2024 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega164
;Program type           : Application
;Clock frequency        : 10,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega164
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _err=R4
	.DEF _umd=R3
	.DEF _templ=R6
	.DEF _S=R5
	.DEF _Q=R8
	.DEF _in=R7
	.DEF _out=R10
	.DEF _timp=R11
	.DEF _timp_msb=R12

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0xF,0x6,0x5,0x0,0x3
_0x4:
	.DB  0x0,0x1,0x10
_0x5:
	.DB  0x80,0x2,0x10,0x1
_0x6:
	.DB  0x0,0x3,0x10,0x2
_0x7:
	.DB  0x80,0x4,0x10,0x3
_0x8:
	.DB  0x0,0x5,0x10,0x4
_0x9:
	.DB  0x80,0x0,0x10,0x5
_0xA:
	.DB  0x2,0x1,0x1,0x0,0x0,0x2
_0xB:
	.DB  0x0,0x1,0x10
_0xC:
	.DB  0x80,0x2,0x10,0x1
_0xD:
	.DB  0x0,0x3,0x10,0x2
_0xE:
	.DB  0x80,0x4,0x10,0x3
_0xF:
	.DB  0x0,0x5,0x10,0x4
_0x10:
	.DB  0x80,0x6,0x10,0x5
_0x11:
	.DB  0x0,0x7,0x10,0x6
_0x12:
	.DB  0x80,0x0,0x10,0x7
_0x13:
	.DB  0x2,0x1,0x1,0x0,0x0,0x3,0x3,0x2

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0B
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _TAB
	.DW  _0x3*2

	.DW  0x03
	.DW  _A0
	.DW  _0x4*2

	.DW  0x04
	.DW  _A1
	.DW  _0x5*2

	.DW  0x04
	.DW  _A2
	.DW  _0x6*2

	.DW  0x04
	.DW  _A3
	.DW  _0x7*2

	.DW  0x04
	.DW  _A4
	.DW  _0x8*2

	.DW  0x04
	.DW  _A5
	.DW  _0x9*2

	.DW  0x06
	.DW  _Tout1
	.DW  _0xA*2

	.DW  0x03
	.DW  _B0
	.DW  _0xB*2

	.DW  0x04
	.DW  _B1
	.DW  _0xC*2

	.DW  0x04
	.DW  _B2
	.DW  _0xD*2

	.DW  0x04
	.DW  _B3
	.DW  _0xE*2

	.DW  0x04
	.DW  _B4
	.DW  _0xF*2

	.DW  0x04
	.DW  _B5
	.DW  _0x10*2

	.DW  0x04
	.DW  _B6
	.DW  _0x11*2

	.DW  0x04
	.DW  _B7
	.DW  _0x12*2

	.DW  0x08
	.DW  _Tout2
	.DW  _0x13*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x200

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG
;void test_RST(void) {
; 0000 002F void test_RST(void) {

	.CSEG
_test_RST:
; .FSTART _test_RST
; 0000 0030 if ((in & 0x40) == 0)  //testam resetul RST
	SBRC R7,6
	RJMP _0x14
; 0000 0031 {
; 0000 0032 out = out & 0x00;        // aprinde toate LED-urile
	LDI  R30,LOW(0)
	AND  R10,R30
; 0000 0033 S = 11;
	LDI  R30,LOW(11)
	MOV  R5,R30
; 0000 0034 }
; 0000 0035 }
_0x14:
	RET
; .FEND
;void clc(void)
; 0000 0038 {
_clc:
; .FSTART _clc
; 0000 0039 char senzor = in & 0x0F;
; 0000 003A err = TAB[senzor];  //EROARE BITII 0,1,2
	ST   -Y,R17
;	senzor -> R17
	MOV  R30,R7
	ANDI R30,LOW(0xF)
	MOV  R17,R30
	LDI  R31,0
	SUBI R30,LOW(-_TAB)
	SBCI R31,HIGH(-_TAB)
	LD   R4,Z
; 0000 003B if (err != 0x07) S = 10; // stare eroare
	LDI  R30,LOW(7)
	CP   R30,R4
	BREQ _0x15
	LDI  R30,LOW(10)
	RJMP _0x45
; 0000 003C else
_0x15:
; 0000 003D {
; 0000 003E out=(out | 0xFF) & 0X7F;//irigarea activa
	RCALL SUBOPT_0x0
; 0000 003F S = 8;
	LDI  R30,LOW(8)
_0x45:
	MOV  R5,R30
; 0000 0040 }
; 0000 0041 }
	LD   R17,Y+
	RET
; .FEND
;void cls1(void) {
; 0000 0043 void cls1(void) {
_cls1:
; .FSTART _cls1
; 0000 0044 char i;
; 0000 0045 char *adr;
; 0000 0046 char ready;
; 0000 0047 adr = TABA1[Q];
	RCALL __SAVELOCR4
;	i -> R17
;	*adr -> R18,R19
;	ready -> R16
	MOV  R30,R8
	LDI  R26,LOW(_TABA1)
	LDI  R27,HIGH(_TABA1)
	RCALL SUBOPT_0x1
; 0000 0048 i=0;
; 0000 0049 ready=0;
; 0000 004A while (!ready)
_0x17:
	CPI  R16,0
	BRNE _0x19
; 0000 004B {
; 0000 004C if ((in & 0x80) == *(adr+i)) { Q =*(adr+i+1); ready=1; }
	RCALL SUBOPT_0x2
	BRNE _0x1A
	RCALL SUBOPT_0x3
	LDD  R8,Z+1
	LDI  R16,LOW(1)
; 0000 004D else if (*(adr+i) == T) ready=1;
	RJMP _0x1B
_0x1A:
	RCALL SUBOPT_0x3
	LD   R26,Z
	CPI  R26,LOW(0x10)
	BRNE _0x1C
	LDI  R16,LOW(1)
; 0000 004E else i += 2;
	RJMP _0x1D
_0x1C:
	SUBI R17,-LOW(2)
; 0000 004F }
_0x1D:
_0x1B:
	RJMP _0x17
_0x19:
; 0000 0050 }
	RJMP _0x2000001
; .FEND
;void cls2(void) {
; 0000 0052 void cls2(void) {
_cls2:
; .FSTART _cls2
; 0000 0053 char i;
; 0000 0054 char *adr;
; 0000 0055 char ready;
; 0000 0056 adr = TABA2[Q];
	RCALL __SAVELOCR4
;	i -> R17
;	*adr -> R18,R19
;	ready -> R16
	MOV  R30,R8
	LDI  R26,LOW(_TABA2)
	LDI  R27,HIGH(_TABA2)
	RCALL SUBOPT_0x1
; 0000 0057 i=0;
; 0000 0058 ready=0;
; 0000 0059 while (!ready) {
_0x1E:
	CPI  R16,0
	BRNE _0x20
; 0000 005A if ((in & 0x80) == *(adr+i)) { Q =*(adr+i+1); ready=1; }
	RCALL SUBOPT_0x2
	BRNE _0x21
	RCALL SUBOPT_0x3
	LDD  R8,Z+1
	LDI  R16,LOW(1)
; 0000 005B else if (*(adr+i) == T) ready=1;
	RJMP _0x22
_0x21:
	RCALL SUBOPT_0x3
	LD   R26,Z
	CPI  R26,LOW(0x10)
	BRNE _0x23
	LDI  R16,LOW(1)
; 0000 005C else i += 2;
	RJMP _0x24
_0x23:
	SUBI R17,-LOW(2)
; 0000 005D }
_0x24:
_0x22:
	RJMP _0x1E
_0x20:
; 0000 005E }
_0x2000001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;interrupt [19] void timer0_ovf_isr(void)
; 0000 0062 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0063 TCNT0 = 0x3C;//reinitializam timperul la 0
	LDI  R30,LOW(60)
	OUT  0x26,R30
; 0000 0064 
; 0000 0065 in = PIND;
	IN   R7,9
; 0000 0066 
; 0000 0067 switch (S) {
	MOV  R30,R5
	LDI  R31,0
; 0000 0068 case 0:
	SBIW R30,0
	BRNE _0x28
; 0000 0069 if ((in & 0x80) == 0) S = 1;//testez SET/
	SBRC R7,7
	RJMP _0x29
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 006A else
	RJMP _0x2A
_0x29:
; 0000 006B {
; 0000 006C out = (out | 0xFF) & 0x7F;  //stingem ledul ce indica daca irigarea este pornita sau oprita
	RCALL SUBOPT_0x0
; 0000 006D clc();
	RCALL _clc
; 0000 006E }
_0x2A:
; 0000 006F test_RST();//testam daca s a apasat RST/
	RJMP _0x46
; 0000 0070 break;
; 0000 0071 
; 0000 0072 case 1:
_0x28:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
; 0000 0073 if ((in & 0x80) != 0) S = 2; //testam SET
	SBRS R7,7
	RJMP _0x2C
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0074 test_RST();
_0x2C:
	RJMP _0x46
; 0000 0075 break;
; 0000 0076 
; 0000 0077 case 2:
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D
; 0000 0078 out = (out & 0x00) | 0x87; // LED6-3 pornite
	MOV  R30,R10
	ANDI R30,LOW(0x0)
	ORI  R30,LOW(0x87)
	MOV  R10,R30
; 0000 0079 if ((in & 0x20) == 0) S = 3;  //testam UMD/
	SBRC R7,5
	RJMP _0x2E
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 007A if ((in & 0x10) == 0) S = 4;  //TESTAM TEMPL/
_0x2E:
	SBRC R7,4
	RJMP _0x2F
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 007B if ((in & 0x40) == 0) S = 7;  //testam /RST
_0x2F:
	SBRC R7,6
	RJMP _0x30
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 007C test_RST();
_0x30:
	RJMP _0x46
; 0000 007D break;
; 0000 007E 
; 0000 007F case 3:
_0x2D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x31
; 0000 0080 if ((in & 0x20) != 0) S = 5;
	SBRS R7,5
	RJMP _0x32
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 0081 test_RST();
_0x32:
	RJMP _0x46
; 0000 0082 break;
; 0000 0083 
; 0000 0084 case 4:
_0x31:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x33
; 0000 0085 if ((in & 0x10) != 0) S = 6;
	SBRS R7,4
	RJMP _0x34
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 0086 test_RST();
_0x34:
	RJMP _0x46
; 0000 0087 break;
; 0000 0088 
; 0000 0089 case 5:
_0x33:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x35
; 0000 008A cls1();
	RCALL _cls1
; 0000 008B umd = Tout1[Q] << 5;//iesire cls bitii 5,6
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_Tout1)
	SBCI R31,HIGH(-_Tout1)
	LD   R30,Z
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R3,R30
; 0000 008C out = out & 0x9F;//stergem bitii 5, 6 - masca 10011111
	LDI  R30,LOW(159)
	AND  R10,R30
; 0000 008D out = out | umd;//actualizez out
	OR   R10,R3
; 0000 008E if ((in & 0x40) == 0) S = 7; //testam /RST
	SBRC R7,6
	RJMP _0x36
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 008F test_RST();
_0x36:
	RJMP _0x46
; 0000 0090 break;
; 0000 0091 
; 0000 0092 case 6:
_0x35:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x37
; 0000 0093 cls2();
	RCALL _cls2
; 0000 0094 templ = Tout2[Q] << 3;//iesire cls bitii 4,3
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_Tout2)
	SBCI R31,HIGH(-_Tout2)
	LD   R30,Z
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R6,R30
; 0000 0095 out = out & 0xE7;//stergem bitii 4, 3 - masca 11100111
	LDI  R30,LOW(231)
	AND  R10,R30
; 0000 0096 out = out | templ;//actualizez out
	OR   R10,R6
; 0000 0097 if ((in & 0x40) == 0) S = 7; //testam /RST
	SBRC R7,6
	RJMP _0x38
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0098 test_RST();
_0x38:
	RJMP _0x46
; 0000 0099 break;
; 0000 009A 
; 0000 009B case 7:
_0x37:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x39
; 0000 009C if ((in & 0x40) != 0) S = 0;//testez RST
	SBRC R7,6
	CLR  R5
; 0000 009D test_RST();
	RJMP _0x46
; 0000 009E break;
; 0000 009F 
; 0000 00A0 case 8:
_0x39:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3B
; 0000 00A1 if ((in & 0x80) == 0) S = 1; //testam SET/
	SBRC R7,7
	RJMP _0x3C
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 00A2 timp = (timp+1) % 10; //ca sa contorizam 5 minute trebuie sa punem      dar pentru testare am pus 10 ca sa mearga mai rapid
_0x3C:
	__GETW2R 11,12
	ADIW R26,1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	__PUTW1R 11,12
; 0000 00A3 if ((in & 0xF) != 0)   //testez senzorii
	MOV  R30,R7
	ANDI R30,LOW(0xF)
	BRNE _0x47
; 0000 00A4 {
; 0000 00A5 out = (out | 0xFF) & 0x7F;
; 0000 00A6 S = 9;
; 0000 00A7 }
; 0000 00A8 else if(timp == 0)
	MOV  R0,R11
	OR   R0,R12
	BRNE _0x3F
; 0000 00A9 {
; 0000 00AA out = (out | 0xFF) & 0x7F;
_0x47:
	MOV  R30,R10
	ORI  R30,LOW(0xFF)
	ANDI R30,0x7F
	MOV  R10,R30
; 0000 00AB S = 9;
	LDI  R30,LOW(9)
	MOV  R5,R30
; 0000 00AC }
; 0000 00AD test_RST();
_0x3F:
	RJMP _0x46
; 0000 00AE break;
; 0000 00AF 
; 0000 00B0 case 9:
_0x3B:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x40
; 0000 00B1 out = (out | 0xFF) & 0xFF;
	MOV  R30,R10
	ORI  R30,LOW(0xFF)
	MOV  R10,R30
; 0000 00B2 S = 0;
	CLR  R5
; 0000 00B3 timp = 0;
	CLR  R11
	CLR  R12
; 0000 00B4 test_RST();
	RJMP _0x46
; 0000 00B5 break;
; 0000 00B6 
; 0000 00B7 case 10:
_0x40:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x41
; 0000 00B8 out = out & 0xFF; // inchid toate becurile
	LDI  R30,LOW(255)
	AND  R10,R30
; 0000 00B9 out = (out | err) << 0; // actualizeaza out
	OR   R10,R4
; 0000 00BA out = out | 0xF8; //inchid toate LED-urile in afara de cele de eroare LED 2-0
	LDI  R30,LOW(248)
	OR   R10,R30
; 0000 00BB test_RST();// testeaza RST/
	RJMP _0x46
; 0000 00BC break;
; 0000 00BD 
; 0000 00BE case 11:
_0x41:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x27
; 0000 00BF if ( (in & 0x40) != 0 ) // testeaza RST
	SBRS R7,6
	RJMP _0x43
; 0000 00C0 {
; 0000 00C1 out = out | 0xFF; // stinge LED7-0
	LDI  R30,LOW(255)
	OR   R10,R30
; 0000 00C2 err=0x07;
	LDI  R30,LOW(7)
	MOV  R4,R30
; 0000 00C3 out = out | err; // sterge erori
	OR   R10,R4
; 0000 00C4 S=0;
	CLR  R5
; 0000 00C5 }
; 0000 00C6 test_RST();// testeaza RST/
_0x43:
_0x46:
	RCALL _test_RST
; 0000 00C7 break;
; 0000 00C8 }
_0x27:
; 0000 00C9 
; 0000 00CA PORTB = out; //iesirea
	OUT  0x5,R10
; 0000 00CB 
; 0000 00CC }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void main(void) {
; 0000 00D1 void main(void) {
_main:
; .FSTART _main
; 0000 00D2 TABA1[0] = A0; TABA1[1] = A1; TABA1[2] = A2;TABA1[3] = A3; TABA1[4] = A4; TABA1[5] = A5;
	LDI  R30,LOW(_A0)
	LDI  R31,HIGH(_A0)
	STS  _TABA1,R30
	STS  _TABA1+1,R31
	__POINTW2MN _TABA1,2
	LDI  R30,LOW(_A1)
	LDI  R31,HIGH(_A1)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA1,4
	LDI  R30,LOW(_A2)
	LDI  R31,HIGH(_A2)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA1,6
	LDI  R30,LOW(_A3)
	LDI  R31,HIGH(_A3)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA1,8
	LDI  R30,LOW(_A4)
	LDI  R31,HIGH(_A4)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA1,10
	LDI  R30,LOW(_A5)
	LDI  R31,HIGH(_A5)
	ST   X+,R30
	ST   X,R31
; 0000 00D3 TABA2[0] = B0; TABA2[1] = B1; TABA2[2] = B2; TABA2[3] = B3;TABA2[4] = B4; TABA2[5] = B5; TABA2[6] = B6; TABA2[7] = B7;
	LDI  R30,LOW(_B0)
	LDI  R31,HIGH(_B0)
	STS  _TABA2,R30
	STS  _TABA2+1,R31
	__POINTW2MN _TABA2,2
	LDI  R30,LOW(_B1)
	LDI  R31,HIGH(_B1)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA2,4
	LDI  R30,LOW(_B2)
	LDI  R31,HIGH(_B2)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA2,6
	LDI  R30,LOW(_B3)
	LDI  R31,HIGH(_B3)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA2,8
	LDI  R30,LOW(_B4)
	LDI  R31,HIGH(_B4)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA2,10
	LDI  R30,LOW(_B5)
	LDI  R31,HIGH(_B5)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA2,12
	LDI  R30,LOW(_B6)
	LDI  R31,HIGH(_B6)
	ST   X+,R30
	ST   X,R31
	__POINTW2MN _TABA2,14
	LDI  R30,LOW(_B7)
	LDI  R31,HIGH(_B7)
	ST   X+,R30
	ST   X,R31
; 0000 00D4 out = 0xFF;
	LDI  R30,LOW(255)
	MOV  R10,R30
; 0000 00D5 S = 0;
	CLR  R5
; 0000 00D6 Q = 0;
	CLR  R8
; 0000 00D7 //while (1) { }- ca sa nu mai avem brakepoint in debugger
; 0000 00D8 }
_0x44:
	RJMP _0x44
; .FEND

	.DSEG
_TAB:
	.BYTE 0x10
_TABA1:
	.BYTE 0xC
_A0:
	.BYTE 0x4
_A1:
	.BYTE 0x4
_A2:
	.BYTE 0x4
_A3:
	.BYTE 0x4
_A4:
	.BYTE 0x4
_A5:
	.BYTE 0x4
_Tout1:
	.BYTE 0x6
_TABA2:
	.BYTE 0x10
_B0:
	.BYTE 0x4
_B1:
	.BYTE 0x4
_B2:
	.BYTE 0x4
_B3:
	.BYTE 0x4
_B4:
	.BYTE 0x4
_B5:
	.BYTE 0x4
_B6:
	.BYTE 0x4
_B7:
	.BYTE 0x4
_Tout2:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOV  R30,R10
	ORI  R30,LOW(0xFF)
	ANDI R30,0x7F
	MOV  R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X+
	LD   R19,X
	LDI  R17,LOW(0)
	LDI  R16,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	MOV  R30,R7
	ANDI R30,LOW(0x80)
	MOV  R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R18
	ADC  R31,R19
	LD   R30,Z
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R18
	ADC  R31,R19
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

;END OF CODE MARKER
__END_OF_CODE:
