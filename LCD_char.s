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
	
	GLOBAL LCD_char
	AREA lcdchar,CODE,READONLY
		
	IMPORT Wait_1us
	
LCD_char
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
	
	;Pass command to LCD
	MOV r0,r0,LSL#16	;Move to position in IO1PIN
	LDR r8,[r7]			;Read contents of IO1PIN
	MVN r9,#LCD_DATA	;Complement mask
	AND r8,r9,r8		;Clear pins for new data
	ORR r8,r0,r8		;Set data 	
	STR	r8,[r7]			;Write data
	
	;Modify Register select (0=data is command. 1=data is text)
	MOV r9,#LCD_RS		;Make mask
	STR r9,[r5]			;Modify RS (pin 1.24) to 1 with IO1SET
	
	;Modify Read/Write (0=write to data bus. 1=Read LCD status)
	MOV r9,#LCD_RW		;Make mask
	STR r9,[r2]			;Modify RW (pin 0.22) to 0 with IO0CLR
	
	;Modify Enable (0=Bring data out. 1=Bring data in)
	MOV r9,#LCD_E		;Make mask
	STR r9,[r4]			;Modify E (pin 1.25) to 0 with IO1CLR	
	
	;Wait 6us
	LDR r0,=6
	BL Wait_1us					

	;Modify Enable (0=Bring data out. 1=Bring data in)
	MOV r9,#LCD_E		;Make mask
	STR r9,[r5]			;Modify E (pin 1.25) to 1 with IO1SET
	
	;Wait 6us
	LDR r0,=6
	BL Wait_1us		
	
	;Modify Enable (0=Bring data out. 1=Bring data in)
	MOV r9,#LCD_E		;Make mask
	STR r9,[r4]			;Modify E (pin 1.25) to 0 with IO1CLR	
	
	;Wait 40us
	LDR r0,=40
	BL Wait_1us	

	LDMFD sp!,{r1}
	MSR CPSR_f,R1
	LDMFD sp!,{r1-r9,LR}
	BX LR
	
	END
		