.include    "address_map_arm.s" 

/********************************************************************************
 * Student: Ngoc Pham
 * ECE 3610 - Lab02 Q2
 *
 * It performs the following:
 * 	1. There is a pre-defined password in memory
 *      2. The program takes input as SW values for guessed password 
 * 	3. ***REMEMBER to press KEY #0 for checking password every time***
 *      4. if SW values match the pre-defined password, LEDs will display for cheering
 *      5. if SW values don't match pre-defined password, no LEDs will display
 *      6. Try different combination of SW until guess the correct password      
 *      7. ***REMEMBER to press KEY #0 for checking password every time***
 ********************************************************************************/
.text        /* executable code follows */
.global     _start 
_start:                         

        LDR     R1, =LED_BASE   // base address of LED lights
        LDR     R2, =SW_BASE    // base address of SW switches
        LDR     R3, =KEY_BASE   // base address of KEY pushbuttons

        MOV     R4, #0          // value for LED displays when incorrect password
        LDR     R11, LED_for_correct_password   // value for LED displays when correct password (#0bAAAAAAAA = 1010... for 32-bit)
        LDR     R12, password   // value of password stored in memory (#0b10011011)

WAIT:
        LDR     R5, [R2]        // load SW to processor's register
        LDR     R6, [R3]        // load KEY to processor's register

        CMP     R6, #1          // check if KEY #0 is pressed
        BEQ     CHECK_PASSWORD
        BNE     WAIT

CHECK_PASSWORD:
        CMP     R5, R12        // check R4 (SW) with R5 (password in memory #0b10011011)
        BEQ     CORRECT_PASSWORD //jump to correct_password
        STR     R4, [R1]        // incorrect password, no LEDs (#0)
        BNE     WAIT            // loop back to check for SW combination

//display LED to indicate correct password
CORRECT_PASSWORD:
        STR     R11, [R1]       // store a pre-defined pattern to the LED displays
        ROR     R11, #1         // rotate LEDs to the right by 1

        LDR     R6, =100000000   // delay counter        
        B       DELAY
DELAY:                          
        SUBS    R6, R6, #1      
        BNE     DELAY           

        LDR     R6, [R3]        
        CMP     R6, #1          // check if KEY #0 is pressed          
        BNE     CORRECT_PASSWORD // if KEY #0 not pressed, continue displaying LEDs of correct password
        B       WAIT            //  if KEY #0 pressed, jump back to wait for load SW combination again



password:
.word       0x0000009B          // password pattern in memory (#0b10011011)

LED_for_correct_password:       // LEDs display for correct password
.word       0xAAAAAAAA

.end         
