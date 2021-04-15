.include    "address_map_arm.s" 
.include    "defines.s" 
/* externally defined variables */
.extern     KEY_DIR 
.extern     PATTERN 

/*****************************************************************************
 * Interval timer interrupt service routine
 *
 * Shifts a PATTERN being displayed on the LED lights. The shift direction
 * is determined by the external variable KEY_PRESSED.
 *
 ******************************************************************************/
.global     TIMER_ISR 
TIMER_ISR:                      
        PUSH    {R4-R7}         
        LDR     R1, =TIMER_BASE // interval timer base address
        MOVS    R0, #0          
        STR     R0, [R1]        // clear the interrupt

        LDR     R1, =LED_BASE   // LED base address
        LDR     R2, =PATTERN    // set up a pointer to the pattern for LED displays
        LDR     R7, =KEY_DIR    // set up a pointer to the shift direction variable

        LDR     R3, =PREVIOUS_STATE    // variable to resume the state (rotation direction) of the LEDs
        LDR     R4, [R3]

        LDR     R6, [R2]        // load pattern for LED displays
        STR     R6, [R1]        // store to LEDs


//checking KEY_DIR value, which is defined from key_isr                          
        LDR     R5, [R7]        // get shift direction
        
        CMP     R5, #1          // when KEY_0 is pressed
        BEQ     SHIFT_R         // shift the pattern to the right

        CMP     R5, #2          // when KEY_1 is pressed
        BEQ     SHIFT_L         // shift the pattern to the left

        CMP     R5, #4          // when KEY_2 is pressed
        BEQ     START           // start or resume to rotate the LEDs

        CMP     R5, #8          // when KEY_3 is pressed
        BEQ     STOP            // stop the rotation, stop the LEDs


        @ CMP     R5, #RIGHT      
        @ BNE     SHIFT_L         
        @ MOVS    R5, #1          // used to rotate right by 1 position
        @ RORS    R6, R5          // rotate right for KEY1
        @ B       END_TIMER_ISR   

SHIFT_R:
        MOVS    R5, #1          // used to rotate right by 1 position
        RORS    R6, R5
        STR     R6, [R2]        // store the new pattern to PATTERN variable
        
        MOV     R4, #1          // MOV 1 to register 4 so it saves in PREVIOUS_STATE variable
        STR     R4, [R3]        // store the previous state value to PREVIOUS_STATE variable
        B       END_TIMER_ISR

SHIFT_L:                        
        MOVS    R5, #31         // used to rotate left by 1 position
        RORS    R6, R5          
        STR     R6, [R2]        // store the new pattern to PATTERN variable
        
        MOV     R4, #2          // MOV 1 to register 4 so it saves in PREVIOUS_STATE variable
        STR     R4, [R3]        // store the previous state value to PREVIOUS_STATE variable
        B       END_TIMER_ISR

START:
        CMP     R4, #1          // check the PREVIOUS_STATE to resume
        BEQ     SHIFT_R         // resume to SHIFT_R state if PREVIOUS_STATE == 1
        BNE     SHIFT_L         // resume to SHIFT_L state if PREVIOUS_STATE != 1

STOP:
        STR     R6, [R2]        // store LED display pattern
        B       END_TIMER_ISR


END_TIMER_ISR:           
        @ STR     R6, [R2]        // store LED display pattern
        POP     {R4-R7}         
        BX      LR              

.end         

