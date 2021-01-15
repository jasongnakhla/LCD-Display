IO0SET		EQU	0xE0028004	;Port 0 SET (1 sets to 1, 0 uneffected)
IO0CLR		EQU	0xE002800C	;Port 0 CLR (1 sets to 0, 0 uneffected)
IO1SET		EQU	0xE0028014	;Port 1 SET (1 sets to 1, 0 uneffected)
IO1CLR		EQU	0xE002801C	;Port 1 CLR (1 sets to 0, 0 uneffected)
IO0PIN		EQU	0xE0028000
IO1PIN		EQU	0xE0028010
LCD_DATA	EQU	0x00FF0000	;P1.16 - P1.23
LCD_RS		EQU	0x01000000	;P1.24
LCD_E		EQU	0x02000000	;P1.25
LCD_RW		EQU	0x00400000	;P0.22
LCD_LIGHT	EQU	0x40000000	;P0.30	
	
	GLOBAL LCD_init
	AREA lcdinit,CODE,READONLY
		
	IMPORT LCD_cmd
	IMPORT Wait_1us
	
LCD_init
	STMFD SP!,{R1-r9,LR}
	MRS r1,CPSR
	STMFD sp!,{r1}
	
	;Initialize registers
	LDR r2,=IO0CLR
	LDR r3,=IO0SET
	LDR r4,=IO1CLR
	LDR r5,=IO1SET
	LDR r6,=IO0PIN
	LDR r7,=IO1PIN	
	
;E=RS=RW=0 then wait 15ms=1500*10us
	;Modify Register select (0=data is command. 1=data is text)
	MOV r9,#LCD_RS		;Make mask
	STR r9,[r4]			;Modify RS (pin 1.24) to 0 with IO1CLR
	
	;Modify Read/Write (0=write to data bus. 1=Read LCD status)
	MOV r9,#LCD_RW		;Make mask
	STR r9,[r2]			;Modify RW (pin 0.22) to 0 with IO0CLR
	
	;Modify Enable (0=Bring data out. 1=Bring data in)
	MOV r9,#LCD_E		;Make mask
	STR r9,[r4]			;Modify E (pin 1.25) to 0 with IO1CLR	
	
	;Wait 15000us
	LDR r0,=15000
	BL Wait_1us		
	
	;Send command 0x30 to D[7:0] of LCD and wait 4.1ms=4100us
	LDR r0,=0x30
	BL LCD_cmd
	LDR r0,=4100
	BL Wait_1us

	;Send command 0x30 again and wait at least 100us =100us
	LDR r0,=0x30
	BL LCD_cmd
	LDR r0,=100
	BL Wait_1us
	
	;Send command 0x30 again and wait at least 4.1ms=4100us
	LDR r0,=0x30
	BL LCD_cmd
	LDR r0,=4100
	BL Wait_1us
	
	;Send command 0x38 (sum of 0x20, 0x10, 0x80)
	; and wait 40us*3 = 120us = 120us
	LDR r0,=0x38
	BL LCD_cmd
	LDR r0,=120
	BL Wait_1us
	
	;Send command 0x0C and wait 40us
	LDR r0,=0x0C
	BL LCD_cmd
	LDR r0,=40
	BL Wait_1us
	
	;Send command 0x01 and wait 1.64ms = 1640us
	LDR r0,=0x01
	BL LCD_cmd
	LDR r0,=1640
	BL Wait_1us
	
	;Send command 0x06 and wait 40us
	LDR r0,=0x06
	BL LCD_cmd
	LDR r0,=40
	BL Wait_1us
	
	LDMFD sp!,{r1}
	MSR CPSR_f,R1
	LDMFD sp!,{r1-r9,LR}
	BX LR

	END
		