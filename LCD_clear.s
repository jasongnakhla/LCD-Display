	
	GLOBAL LCD_clear
	AREA lcdclear,CODE,READONLY

	IMPORT LCD_cmd
	IMPORT Wait_1us

LCD_clear
	STMFD SP!,{R1-r9,LR}
	MRS r1,CPSR
	STMFD sp!,{r1}
	
	;Clear display and wait 1.64 ms = 1640us
	MOV r0,#0x1
	BL LCD_cmd
	LDR r0,=1640
	BL Wait_1us
	
	LDMFD sp!,{r1}
	MSR CPSR_f,R1
	LDMFD sp!,{r1-r9,LR}
	BX LR


		END	
