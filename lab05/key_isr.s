.include    "address_map_arm.s"
.include    "defines.s"     
.extern     KEY_DIR         /* externally defined variable */
/***************************************************************************************
 * Pushbutton KEY - Interrupt Service Routine
 *
 * This routine toggles the KEY_DIR variable from 0 <-> 1
 ****************************************************************************************/
.global     KEY_ISR         
KEY_ISR:
        LDR     R0, =KEY_BASE   // base address of pushbutton KEY parallel port
/* KEY[1] is the only key configured for interrupts, so just clear it. */
        LDR     R1, [R0, #0xC]  // read edge capture register
        STR     R1, [R0, #0xC]  // clear the interrupt


        LDR     R3, =KEY_DIR    // set up a pointer to the shift direction variable
        @ LDR     R2, [R1]        // load value of shift direction variable
        @ EOR     R2, R2, #1      // toggle the shift direction
        @ STR     R2, [R1]        

        LDR     R2, [R3]        // load value of shift direction variable

        CMP     R1 , #1         // check if key 0 is pressed 
        MOVEQ   R2, #1          // If pressed, Mov 1 to register 2 which is a pointer to KEY_DIR

        CMP     R1, #2          // check if key 1 is pressed  
        MOVEQ   R2, #2          // If pressed, Mov 2 to register 2 which is a pointer to KEY_DIR

        CMP     R1, #4          // check if key 2 is pressed 
        MOVEQ   R2, #4          // If pressed, Mov 4 to register 2 which is a pointer to KEY_DIR 

        CMP     R1, #8          // check if key 3 is pressed 
        MOVEQ   R2, #8          // If pressed, Mov 8 to register 2 which is a pointer to KEY_DIR

        STR     R2, [R3]          

END_KEY_ISR:
        BX      LR              
.end                        

