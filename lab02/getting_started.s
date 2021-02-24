.include    "address_map_arm.s" 

/********************************************************************************
 * Student: Ngoc Pham
 * ECE 3610 - Lab02 Q2
 *
 * It performs the following:
 * 	1. There is a pre-defined password in memory
 *      2. The program takes input as SW values for guessed password 
 * 	3. ***REMEMBER to press KEY #0 for checking password every time***
 *      4. if SW values match the pre-defined password, LEDs will display for congrats
 *      5. if SW values don't match pre-defined password, no LEDs will display
 *      6. Try different combination of SW until guess the correct password      
 *      7. ***REMEMBER to press KEY #0 for checking password every time***
 *      8. Once the current password is guessed successfully, user can now modify the password to different parttern (combination of SWs)
 *      9. Modify by: change to new combination of SWs, press KEY #2 for saving password
 *      10. Now if use the old password, press KEY #0 won't work. Only new password will work
 ********************************************************************************/
.text        /* executable code follows */
.global     _start 
_start:                         

        LDR     R1, =LED_BASE   // base address of LED lights
        LDR     R2, =SW_BASE    // base address of SW switches
        LDR     R3, =KEY_BASE   // base address of KEY pushbuttons

        MOV     R4, #0          // value for LED displays when incorrect password
        LDR     R11, LED_for_correct_password   // value for LED displays when correct password (#0bAAAAAAAA = 1010... for 32-bit)

WAIT:
        LDR     R12, password   // value of password stored in memory (#0b10011011), or new password if user modifies it (after input correct current password)
        LDR     R5, [R2]        // load SW to processor's register
        LDR     R6, [R3]        // load KEY to processor's register

        CMP     R6, #1          // check if KEY #0 is pressed
        BEQ     CHECK_PASSWORD
        BNE     WAIT

CHECK_PASSWORD:
        CMP     R5, R12        // check R5 (SW) with R12 (password in memory #0b10011011)
        BEQ     CORRECT_PASSWORD //jump to correct_password
        STR     R4, [R1]        // incorrect password, no LEDs (#0)
        BNE     WAIT            // loop back to check for SW combination

//display LED to indicate correct password
CORRECT_PASSWORD:
        STR     R11, [R1]       // store a pre-defined pattern R11 to the LED displays [R1]
        ROR     R11, #1         // rotate LEDs to the right by 1

        LDR     R6, =1   // delay counter        
        B       DELAY
DELAY:                          
        SUBS    R6, R6, #1      
        BNE     DELAY           

        LDR     R6, [R3]        // load current value of SW back to R6 in processor
        CMP     R6, #1          // check if KEY #0 is pressed
        BEQ     WAIT            //  if KEY #0 pressed, jump back to wait for load SW combination again
        CMP     R6, #4          // check if KEY #3 is pressed          
        BNE     CORRECT_PASSWORD // if KEY #0 not pressed, continue displaying LEDs of correct password
        BEQ     UPDATE_PASSWORD

UPDATE_PASSWORD:
        LDR     R5, [R2]        // load R2 (SW) to R5 (SW register)
        STR     R5, password    // store R5 (SW register) to memory as new password
        B       WAIT            // return to beginning


password:
.word       0x0000009B          // pre-defined password pattern in memory (#0b10011011), will be changed if user wants to save different password

LED_for_correct_password:       // LEDs display for correct password
.word       0xAAAAAAAA

.end         
/*
PC      |        
r0      | 
r1      | LED address
r2      | SW address
r3      | KEY address
r4      | #0
r5      | SW values
----------------------
r6      | KEY values & =50KK delay
r7      |
r8      |
r9      |
r10     |
r11     | LED_pw
r12     | password
----------------------
sp      |
lr      |
CPSR    | N  Z  C  V
----------------------
passwod | 0x0000009B
LED_pw  | 0xAAAAAAAA
*/