.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        LDR     R1, =LED_BASE  	/* Address of red LEDs. */
        LDR     R2, =SW_BASE    /* Address of switches. */
LOOP:   
        LDR     R3, [R2]        /* Read the state of switches. */
		AND		R4, R3, #0x00000001	/* R4 = state of lowest-order switch */
		SUBS	R4, #1			/* check if R4 equals 0 or 1 */
		BEQ		swHigh			/* jump to swHigh if SW0 = 1 */
swLow:	MOV		R3, #3			/* if the lowest-order sw is 0, light lowest 2 LEDs */
		STR		R3, [R1]		/* Display the state on LEDs. */
		B		LOOP
swHigh:	MOV		R3, #768		/* if the lowest-order sw is 1, light top 2 LEDs */
		STR		R3, [R1]
        B       LOOP            
.end                        
