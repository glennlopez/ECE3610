.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        LDR     R1, =LED_BASE  	/* Address of red LEDs. */
        LDR     R2, =SW_BASE    /* Address of switches. */
LOOP:   
        LDR     R3, [R2]        /* Read the state of switches. */
		MOV		R4, #16
		MUL		R3, R3, #16			/* multiply register to 16 */
		SUBS	        R3, #8			/* subtract 8 from register value, "S" in SUBS is to update the 4-bit in CPSR, in this case "N" negative register is detected if subtraction results in negative number */ 
		STR		R3, [R1]		/* Display the state on LEDs. */
        B       LOOP            
.end                        
