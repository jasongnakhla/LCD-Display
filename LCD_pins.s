PINSEL1 EQU 0xE002C004	;Pin selection for P0.31 - P0.16 (0=GPIO)
PINSEL2 EQU 0xE002C014	;Pin selection for P1.25 - P1.16 (0=GPIO)
IO0DIR	EQU	0xE0028008	;Direction for port 0
IO1DIR	EQU	0xE0028018	;Direction for port 1
IO0SET	EQU	0xE0028004	;Port 0 SET (1 sets to 1, 0 uneffected)
IO0CLR	EQU	0xE002800C	;Port 0 CLR (1 sets to 0, 0 uneffected)
IO1SET	EQU	0xE0028014	;Port 1 SET (1 sets to 1, 0 uneffected)
IO1CLR	EQU	0xE002801C	;Port 1 CLR (1 sets to 0, 0 uneffected)	
	
	GLOBAL LCD_pins
	AREA lcdpins,CODE,READONLY
	
LCD_pins
	STMFD SP!,{R1-r7,LR}
	MRS r1,CPSR
	STMFD sp!,{r1}

	LDR r6,=PINSEL1			;LCD needs config for pins P0.22 and P0.30
	LDR r5,[r6]				;read the current contents of PINSEL1
	LDR r2,=0xCFFFCFFF
	AND r5,r5,r2			;modify the contents by clearing bits [29:28] & [13:12]
	STR	r5,[r6]				;write the value back to PINSEL1
	
	LDR r6,=PINSEL2			;LCD needs config for pins P1.16 - P1.25
	MOV r5,#0x0
	STR r5,[r6]
	;LDR r5,[r6]			;read the current contents of PINSEL2
	;BIC r5,r5,#0x00000004	;modify the contents by clearing bit [3]
	;STR r5,[r6]			;write the value back to PINSEL2

	LDR r6,=IO0DIR			
	LDR r5,[r6]				;Read directions of port 0
	LDR r2,=0x40400000		;Port 0 P0.22 and P0.30 affects LCD
	ORR r5,r5,r2			;Modify them as outputs
	STR r5,[r6]				;Write
	
	;Set back light on
	MOV r6,#0x40000000
	LDR r5,=IO0SET
	STR r6,[r5]
	
	LDR r6,=IO1DIR			
	LDR r5,[r6]				;Read directions of port 1
	LDR r2,=0x03FF0000		;Port 1 P1.16 and P0.25 affects LCD
	ORR r5,r5,r2			;Modify them as outputs
	STR r5,[r6]				;Write

	LDMFD sp!,{r1}
	MSR CPSR_f,R1
	LDMFD sp!,{r1-r7,LR}
	BX LR

	END
			