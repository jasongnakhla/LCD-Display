	GLOBAL lcd_subs
	AREA mycode,CODE,READONLY
	
	IMPORT Wait_1us
	IMPORT LCD_pins
	IMPORT LCD_cmd
	IMPORT LCD_char
	IMPORT LCD_init
	IMPORT LCD_string
	IMPORT LCD_clear
		
lcd_subs
	;Initilize pins as GPIO and set directions
	BL LCD_pins	
	
	;Initialize LCD
	BL LCD_init
	
	;Clear LCD screen
	BL LCD_clear
	
	;Do a command
	;LDR r0,= with 8 bit command
	;BL LCD_cmd
	
	;Make a char
	;LDR r0,= with 8 bit char
	;BL LCD_char
	
;Task 2: 
	;Put strings on LCD. Max char per line is 16.
	LDR r10,=myfirstline
	MOV r0,#0			;Address for first line
	ORR r0,r0,#0x80		;Address plus cmd for setting DDRAM
	BL LCD_string
	LDR r10,=mysecondline
	MOV r0,#0x40		;Address for second line
	ORR r0,r0,#0x80		;Address plus cmd for setting DDRAM	
	BL LCD_string
	LDR r0,=100000		;Wait 0.1 seconds between tasks
	BL Wait_1us	

;Task 3:
			BL LCD_clear
			MOV r0,#0x0F		;Initialize Address for right side of first line
			LDR r10,=character
			ORR r0,r0,#0x80		;Address plus cmd for setting DDRAM	
			BL LCD_string
			LDR r0,=100000		;Wait 0.1 seconds
			BL Wait_1us
left2right
			MOV r0,#0x18		;Moves display to left
			BL LCD_cmd
			LDR r0,=500000		;Wait 0.5 seconds
			BL Wait_1us
			B left2right

stop			B	stop
myfirstline		DCB	"Testing 1 2 3",0   ;13 chars
mysecondline 	DCB "Testing 4 5 6",0	;13 chars
character		DCB	"w",0
				ALIGN
				END
	