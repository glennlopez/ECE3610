.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        LDR     R1, =LED_BASE  	/* Address of red LEDs. */
        LDR     R2, =SW_BASE    /* Address of switches. */
		LDR		R3, =8
LOOP:   
        LDR     R4, [R2]        /* Read the state of switches. */
		SUBS	R4, R3			/* subtract 8 from register value, "S" in SUBS is to update the 4-bit in CPSR, in this case "N" negative register is detected if subtraction results in negative number*/ 
		STR		R4, [R1]		/* Display the state on LEDs. */
        B       LOOP            
.end                        