.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        LDR     R1, =LED_BASE  /* Address of red LEDs. */
        LDR     R2, =SW_BASE    /* Address of switches. */
        LDR     R3, =HEX3_HEX0_BASE /* Address of the low four 7segment digits */ 
        LDR     R4, =HEX5_HEX4_BASE /* Address of the high two 7segment digits */

LOOP:   
        LDRB    R5, [R2]        /* Read the state of switches, last 4 switches only, corresponding 0-9 */
        BL      BinaryDecoder
        STRB    R6, [R3]        /* Display the state on 7segment. */
        STRB    R6, [R4]        /* Display the state on 7segment. */
        B       LOOP            

BinaryDecoder
        CMP     R5, #0
        MOVEQ   R6, #0b00011111

        CMP     R5, #1
        MOVEQ   R6, #0b000000110

        CMP     R5, #2
        MOVEQ   R6, #0b001011011

        CMP     R5, #3
        MOVEQ   R6, #0b001001111

        CMP     R5, #4
        MOVEQ   R6, #0b001100110

        CMP     R5, #5
        MOVEQ   R6, #0b001101101
        
        CMP     R5, #6
        MOVEQ   R6, #0b001111101

        CMP     R5, #7
        MOVEQ   R6, #0b000000111

        CMP     R5, #8
        MOVEQ   R6, #0b001111111

        CMP     R5, #9
        MOVEQ   R6, #0b001101111

        MOV     PC, R14

.end                        
