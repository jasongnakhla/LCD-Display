; Standard definitions of Mode bits and Interrupt (I & F) flags in PSR s
Mode_USR	EQU	0x10
I_Bit		EQU	0x80
F_Bit		EQU 0x40
	
;Definitions of User Mode Stack and Size
USR_Stack_Size	EQU 0x00000100
SRAM			EQU	0x40000000
Stack_Top		EQU SRAM+USR_Stack_Size
	
;MEMORY ACCELORATOR REGISTERS
MAMCR  EQU 0xE01FC000
MAMTIM EQU 0xE01FC004

	AREA RESET,CODE,READONLY
	ENTRY
	ARM
	IMPORT lcd_subs
		
VECTORS
	LDR PC,Reset_Addr
	LDR	PC,Undef_Addr
	LDR	PC,SWI_Addr
	LDR	PC,PAbt_Addr
	LDR PC,DAbt_Addr
	NOP
	LDR	PC,IRQ_Addr
	LDR PC,FIQ_Addr
	
Reset_Addr	DCD ResetHandler
Undef_Addr	DCD	UndefHandler
SWI_Addr	DCD SWIHandler
PAbt_Addr	DCD PAbtHandler
DAbt_Addr	DCD DAbtHandler
			DCD	0
IRQ_Addr	DCD	IRQHandler
FIQ_Addr	DCD	FIQHandler
	
SWIHandler	B	SWIHandler
PAbtHandler B	PAbtHandler
DAbtHandler	B	DAbtHandler
IRQHandler	B	IRQHandler
FIQHandler	B	FIQHandler
UndefHandler B	UndefHandler

;Initialize MAM
ResetHandler
	LDR R1,=MAMCR
	MOV r0,#0x0
	STR r0,[r1]	;Turn off MAM
	LDR R2,=MAMTIM
	MOV r0,#0x1
	STR R0,[R2] ;Set MAM fetch to one clock cycle
	MOV r0,#0x2
	STR r0,[r1] ;Full enable MAM

; Enter User Mode with interrupts enabled
	MOV r14,#Mode_USR
	BIC r14,r14,#(I_Bit+F_Bit)
	MSR	cpsr_c,r14
; Initialize the stack, full descending
	LDR	SP,=Stack_Top ; last line of stack initialization in user mode
	
; Lab 9
	B lcd_subs
	
	END
