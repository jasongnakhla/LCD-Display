	GLOBAL Wait_1us
	AREA subrout,CODE,READONLY


;1E-6 second x one loop = 1
;one loop = clock cycles / Frequency
;clock cycles = 4
;frequency = 12MHz
;1E-6 sec wait= 1/one loop = 12E6/4 = 3E6
;wait = 3

Wait_1us 
	STMFD SP!,{R1-r3,LR}
	MRS r1,CPSR
	STMFD sp!,{r1}
			
		LDR r2,=3
		MUL r3,r2,r0
loop	SUBS r3,r3,#1
		BNE loop
				
	LDMFD sp!,{r1}
	MSR CPSR_f,R1
	LDMFD sp!,{r1-r3,LR}
	BX LR
	
	END
		