.include    "address_map_arm.s"

.text                       
.global     _start          
_start: 
        LDR     R1, =LED_BASE   /* Address of red LEDs. */
        LDR     R2, =SW_BASE    /* Address of switches. */
        LDR     R3, =HEX3_HEX0_BASE /* Address of the low four 7segment digits */ 
        LDR     R4, =HEX5_HEX4_BASE /* Address of the high two 7segment digits */

LOOP:   
        LDRB    R5, [R2]        /* Read the state of switches, last 4 switches only, corresponding 0-9 */
        BL      BinaryDecoder
        STR     R6, [R3]        /* Display the state on 7segment. Whole 32-bit for HEX3_HEX0 */
        STR     R6, [R4]        /* Display the state on 7segment. Whole 32-bit for HEX5_HEX4 */
        B       LOOP            

BinaryDecoder:
/* experimenting between variables in memory & direct write to register's 32-bit value */
        CMP     R5, #0
        LDREQ   R6, =0x3F3F3F3F         /* 0b00111111 = 0x3F : displaying 0 */

        CMP     R5, #1
        LDREQ   R6, =0x06060606         /* 0b00000110 = 0x06 : displaying 1 */

        CMP     R5, #2
        LDREQ   R6, two_display         /* 0b01011011 = 0x5B : displaying 2 */

        CMP     R5, #3
        LDREQ   R6, three_display       /* 0b01001111 = 0x4F : displaying 3 */

        CMP     R5, #4
        LDREQ   R6, four_display        /* 0b01100110 = 0x66 : displaying 4 */

        CMP     R5, #5
        LDREQ   R6, five_display        /* 0b01101101 = 0x6D : displaying 5 */
        
        CMP     R5, #6
        LDREQ   R6, six_display         /* 0b01111101 = 0x7D : displaying 6 */

        CMP     R5, #7
        LDREQ   R6, seven_display       /* 0b00000111 = 0x07 : displaying 7 */

        CMP     R5, #8
        LDREQ   R6, eight_display       /* 0b01111111 = 0x7F : displaying 8 */

        CMP     R5, #9                  
        LDREQ   R6, nine_display        /* 0b01101111 = 0x67 :displaying 9 */

        CMP     R5, #9                  /* any number greater than 9, subtract to 9 will be > 9, then displaying "-" for error */
        LDRGT   R6, dash_display        /* 0b01000000 = 0x40 : displaying - (dash) */     

        MOV     PC, R14

zero_display:
.word   0x3F3F3F3F      /* 0b00111111 = 0x3F : displaying 0 */
one_display:
.word   0x06060606      /* 0b00000110 = 0x06 : displaying 1 */
two_display:
.word   0x5B5B5B5B      /* 0b01011011 = 0x5B : displaying 2 */
three_display:
.word   0x4F4F4F4F      /* 0b01001111 = 0x4F : displaying 3 */
four_display:
.word   0x66666666      /* 0b01100110 = 0x66 : displaying 4 */
five_display:
.word   0x6D6D6D6D      /* 0b01101101 = 0x6D : displaying 5 */
six_display:
.word   0x7D7D7D7D      /* 0b01111101 = 0x7D : displaying 6 */
seven_display:
.word   0x07070707      /* 0b00000111 = 0x07 : displaying 7 */
eight_display:
.word   0x7F7F7F7F      /* 0b01111111 = 0x7F : displaying 8 */
nine_display:
.word   0x67676767      /* 0b01101111 = 0x67 : displaying 9 */
dash_display:
.word   0x40404040      /* 0b01000000 = 0x40 : displaying - (dash) */


.end                        
