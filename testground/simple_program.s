.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        @ LDR     R0, =0xFFFFFFFF
        @ LDR     R1, =0x03F00000
        @ LDR     R2, =0x11223344
        @ LDR     R4, =0xABCDEF00
        LDR     SP, =0x00010000
        @ STMDB   SP!, {r0-r2,r4}
        @ LDMFA   SP!, {r14,r1-r3,r8}
        @ BIC     r0, r0, r1
@ LOOP:   
@         LDR     R3, [R2]        /* Read the state of switches. */
@         STR     R3, [R1]        /* Display the state on LEDs. */
@         B       LOOP            

@         MOV     r1, #16           //test cmt            
@         LDR     SP, =0x00000100      
@ LOOP:
@         SUBS    r1, r1, #1                     
@         BEQ     SET                               
@ 	LDR     r2, [SP], #4                  
@ 	LDR     r3, [SP]                        
	                                        
@ 	SUBS    r4, r3, r2                     
@ 	BPL     LOOP                          
@ 	BMI     RESET                          
@ RESET:
@ 	LDR     r0, =0x00000000
@ 	B       EXIT                             
@ SET:
@ 	LDR     r0, =0xFFFFFFFF
@ 	B       EXIT                            
@ EXIT:

        MOV     r0, #0
        MOV     r1, #6
LOOP:
        LDR     r2,[SP]
        LDR     r3,[SP],#4
        LSRS    r3,r3,#1
        ADDCS   r0,r0,r2
        SUBS    r1,r1,#1
        BEQ     EXIT
        BNE     LOOP
EXIT:


.end                        
