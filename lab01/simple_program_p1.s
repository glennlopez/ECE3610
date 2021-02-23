.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        LDR     R1, =LED_BASE  	/* Address of red LEDs. */
        LDR     R2, =SW_BASE    /* Address of switches. */
LOOP:   
        LDR     R3, [R2]        /* Read the state of switches. */
		MOV		R4, #16			/* can't use literal constant with MUL instruction, move constant to register */
		MUL		R3, R4			/* multiplication of two registers */
		STR		R3, [R1]		/* Display the state on LEDs. */
        B       LOOP            
.end                        
