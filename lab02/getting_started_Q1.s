.include    "address_map_arm.s" 

/********************************************************************************
 * Student: Ngoc Pham
 * ECE 3610 - Lab02 Q1
 *
 * It performs the following:
 * 	1. Lowest 8-bit of SW values store a pattern in processor 
 *      2. The program takes input as SW and KEY values for performing actions
 * 	3. Holding KEY #0, shift the pattern to the right by 1 continuously
 *      4. Holding KEY #1, shift the pattern to the left by 1 continuously
 *      5. Press KEY #2 to update the new SW pattern
 *      6. Press KEY #3 to update the original SW pattern      
 ********************************************************************************/
.text        /* executable code follows */
.global     _start 
_start:                         

        MOV     R0, #31         // used to rotate a bit pattern: 31 positions to the
                                // right is equivalent to 1 position to the left
        LDR     R1, =LED_BASE   // base address of LED lights
        LDR     R2, =SW_BASE    // base address of SW switches
        LDR     R3, =KEY_BASE   // base address of KEY pushbuttons
        LDR     R4, LED_bits    // load original start-up pattern to LED displays
        LDR     R7, LED_bits    // load original start-up pattern to a register for reload to LED displays later

DO_DISPLAY:                     
        LDR     R5, [R2]        // load SW switches
        LDR     R6, [R3]        // load pushbutton keys

        @ CMP     R6, #0          // check if no keys is presssed (commented out bc unneccessary)
        @ BEQ     WAIT      
        CMP     R6, #1          // check if key #0 is presssed
        BEQ     BUTTON_0       
        CMP     R6, #2          // check if key #1 is presssed
        BEQ     BUTTON_1       
        CMP     R6, #4          // check if key #2 is presssed
        BEQ     BUTTON_2       
        CMP     R6, #8          // check if key #3 is presssed
        BEQ     BUTTON_3       
  
WAIT:
        STR     R4, [R1]        // store CURRENT pattern to the LED displays
        LDR     R6, [R3]        // load pushbuttons
        CMP     R6, #0          
        BEQ     WAIT            // wait for any key to be pressed
        BNE     DO_DISPLAY


//if key #0 is pressed, rotate the pattern to the right and stores/shows on LED display
BUTTON_0:                      
        STR     R4, [R1]        // store pattern to the LED displays
        ROR     R4, #1          // rotate the displayed pattern to the right by 1

        LDR     R6, =50000000   // delay counter        
        B       DELAY

//if key #1 is pressed, rotate the pattern to the left and stores/shows on LED display
BUTTON_1:                      
        STR     R4, [R1]        // store pattern to the LED displays
        ROR     R4, R0          // rotate the displayed pattern to the left by 1

        LDR     R6, =50000000   // delay counter        
        B       DELAY

DELAY:                          
        SUBS    R6, R6, #1      
        BNE     DELAY           

        B       DO_DISPLAY      

//if key #2 is pressed, update the new pattern 
BUTTON_2:
        MOV     R4, R5          // copy SW switch values onto LED displays
        ROR     R5, R5, #8      // the SW values are copied into the upper three
                                // bytes of the pattern register
        ORR     R4, R4, R5      // needed to make pattern consistent as all 32-bits
                                // of a register are rotated
        ROR     R5, R5, #8      // but only the lowest 8-bits are displayed on LEDs
        ORR     R4, R4, R5      
        ROR     R5, R5, #8      
        ORR     R4, R4, R5      

        B       DO_DISPLAY


//if key #3 is pressed, update the start-up pattern 
BUTTON_3:
        MOV     R4, R7          // copy start-up pattern onto LED displays
        ROR     R7, R7, #8      // the start-up pattern is copied into the upper three
                                // bytes of the pattern register
        ORR     R4, R4, R7      // needed to make pattern consistent as all 32-bits
                                // of a register are rotated
        ROR     R7, R7, #8      // but only the lowest 8-bits are displayed on LEDs
        ORR     R4, R4, R7      
        ROR     R7, R7, #8      
        ORR     R4, R4, R7

        B       DO_DISPLAY

LED_bits:                       
.word       0x0F0F0F0F 

.end         
/*
PC      | #31       
r0      | LED address
r1      | SW address
r2      | KEY address
r3      | LED values
r4      | SW values
r5      | KEY values & =50KK delay
----------------------
r6      |
r7      |
r8      |
r9      |
r10     |
r11     |
r12     |
----------------------
sp      |
lr      |
CPSR    | N  Z  C  V
*/