	
	GLOBAL LCD_string
	AREA lcdstring,CODE,READONLY

	IMPORT LCD_char
	IMPORT LCD_cmd
	IMPORT Wait_1us
	
LCD_string
	STMFD SP!,{R1-r9,LR}
	MRS r1,CPSR
	STMFD sp!,{r1}

;Initialize registers
counter	RN	2
	MOV counter,#0 ;Initial count = 0
	
;Send LCD to put cursor on first character location
	ORR r0,r0,#0x80
	BL LCD_cmd
	LDR r0,=40
	BL Wait_1us ;40us to execute
	
;Upload string one char at a time. test for null
loop
	LDRB r0,[r10,counter]
	CMP	r0,#0
	BLNE LCD_char
	ADD counter,counter,#1
	BNE loop

	LDMFD sp!,{r1}
	MSR CPSR_f,R1
	LDMFD sp!,{r1-r9,LR}
	BX LR

	END	
