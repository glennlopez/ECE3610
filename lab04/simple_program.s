.include    "address_map_arm.s"

.text                       
.global     _start          
.equ    STACK_BASE, 0x30000000
_start: 
        LDR     R1, =KEY_BASE           /* Address of KEY pushbuttons */ 
        LDR     R2, =SW_BASE            /* Address of switches. */
        LDR     R3, =HEX3_HEX0_BASE     /* Address of the low four 7segment digits */ 
        LDR     R4, =HEX5_HEX4_BASE     /* Address of the high two 7segment digits */
        LDR     SP, =STACK_BASE

        LDR     R0, =0                  /* for keeping track of stack counter */

LOOP:   
@ for decoding 10 switches value to 4 of 7segment displays   
@ read in the state of switches, R5 = state of 10 switches = last 3 hex */

        LDR     R5, [R2]        /* for number rotation to display on SSD*/

@ for checking if KEY is pressed
        LDR     R12, [R1]       /* Read the state of key */


        CMP     R12, #1         
        BLEQ    STORE

        CMP     R12, #2
        BLEQ    CLEAR

        CMP     R12, #4
        BLEQ    ADDITION

        CMP     R12, #8
        BLEQ    SUBTRACTION

        B       LOOP     

STORE:
        MOV     R11, LR
        BL      WAIT

        STMFD   SP!,{R5}        /* update current switch values to 7segment */
        BL      ROTATION
        STR     R8, [R3]

        ADD     R0, R0, #1      /* increment stack counter */
        MOV     R6, R0          /* update stack counter on 7segment */
        BL      BinaryDecoder
        STR     R7, [R4]

        MOV     PC, R11         /* exit STORE routine */

CLEAR:
        MOV     R11, LR
        BL      WAIT
        
        LDR     R0, =0          /* reset stack counter */  
        MOV     R6, R0
        BL      BinaryDecoder
        STR     R7, [R4]
        
        LDR     SP, =STACK_BASE /* reset stack base */
        
        LDR     R8, =0x40404040 /* 0b01000000 = 0x40 : displaying - (dash) */
        STR     R8, [R3]        /* reset 7segment */

        MOV     PC, R11         /* exit CLEAR routine */

ADDITION:
        MOV     R11, LR
        BL      WAIT

        SUB     R0, R0, #1      /* decrement stack counter */
        MOV     R6, R0
        BL      BinaryDecoder
        STR     R7, [R4]

        LDMFD   SP!, {R9, R10}
        ADD     R5, R10, R9
        STMFD   SP!, {R5}

        BL      ROTATION
        STR     R8, [R3]

        MOV     PC, R11         /* exit ADDITION routine */

SUBTRACTION:
        MOV     R11, LR
        BL      WAIT

        SUB     R0, R0, #1      /* decrement stack counter */
        MOV     R6, R0
        BL      BinaryDecoder
        STR     R7, [R4]

        LDMFD   SP!, {R9, R10}
        SUB     R5, R10, R9
        STMFD   SP!, {R5}

        BL      ROTATION
        STR     R8, [R3]        

        MOV     PC, R11         /* exit SUBTRACTION routine */

ROTATION:
        MOV     R10, LR

        AND     R6, R5, #0x0000000F     /* extract 4-LSB, R7 = current state of last 4 switches */
        BL      BinaryDecoder   /* Decode state of 4 switches R7 to 7segment pattern, R6 = 7segment pattern */
        ORR     R8, R7, #0      /* store current 7segment pattern */      

        BL      NEXT_FOUR_BITS  /* Jump to routine to extract next 4 switches*/
        BL      BinaryDecoder   /* Jump to routine to decode next 4 switches to 7segment*/
        ORR     R8, R8, R7      /* store current to 32 bits pattern of 4 of 7segment displays */

        BL      NEXT_FOUR_BITS  /* Jump to routine to extract next 4 switches*/
        BL      BinaryDecoder   /* Jump to routine to decode next 4 switches to 7segment*/
        ORR     R8, R8, R7

        BL      NEXT_FOUR_BITS
        BL      BinaryDecoder   /* Jump to routine to decode next 4 switches to 7segment*/
        ORR     R8, R8, R7      

        BL      NEXT_FOUR_BITS

        MOV     PC, R10         /* exit ROTATION routine */


NEXT_FOUR_BITS:
        ROR     R5, R5, #4              /* Rotate to next 4 switches*/
        AND     R6, R5, #0x0000000F     /* Extract 4 bits */
        ROR     R8, R8, #8              /* Rotate the final 32 bit pattern of 4 of 7segment displays*/
        MOV     PC, LR


BinaryDecoder:
        CMP     R6, #0
        LDREQ   R7, =0x3F        /* 0b00111111 = 0x3F : displaying 0 */

        CMP     R6, #1
        LDREQ   R7, =0x06         /* 0b00000110 = 0x06 : displaying 1 */

        CMP     R6, #2
        LDREQ   R7, =0x5B         /* 0b01011011 = 0x5B : displaying 2 */

        CMP     R6, #3
        LDREQ   R7, =0x4F         /* 0b01001111 = 0x4F : displaying 3 */

        CMP     R6, #4
        LDREQ   R7, =0x66         /* 0b01100110 = 0x66 : displaying 4 */

        CMP     R6, #5
        LDREQ   R7, =0x6D         /* 0b01101101 = 0x6D : displaying 5 */
        
        CMP     R6, #6
        LDREQ   R7, =0x7D         /* 0b01111101 = 0x7D : displaying 6 */

        CMP     R6, #7
        LDREQ   R7, =0x07         /* 0b00000111 = 0x07 : displaying 7 */

        CMP     R6, #8
        LDREQ   R7, =0x7F         /* 0b01111111 = 0x7F : displaying 8 */

        CMP     R6, #9                  
        LDREQ   R7, =0x67         /* 0b01101111 = 0x67 :displaying 9 */

        CMP     R6, #10                 
        LDREQ   R7, =0x77         /* 0b01110111 = 0x77: displaying A */

        CMP     R6, #11                 
        LDREQ   R7, =0x7C         /* 0b01111100 = 0x7C: displaying b */

        CMP     R6, #12                 
        LDREQ   R7, =0x39         /* 0b00111001 = 0x39: displaying C */

        CMP     R6, #13                 
        LDREQ   R7, =0x5E         /* 0b01011110 = 0x5E: displaying d */

        CMP     R6, #14                 
        LDREQ   R7, =0x79         /* 0b01111001 = 0x79: displaying E */

        CMP     R6, #15                 
        LDREQ   R7, =0x71         /* 0b01110001 = 0x71: displaying F */

        MOV     PC, LR           /* exit BinaryDecoder */

WAIT:
        LDR     R12, [R1]
        CMP     R12, #0
        BNE     WAIT
        MOV     PC, LR
.end                        
/*
PC              |        
r0              | stack counter
r1              | KEY address
r2              | SW address
r3              | HEX0, HEX1, HEX2, HEX3 address
r4              | HEX4, HEX5 address
r5     0000 03FF| SW state, 10 bits - for rotation subroutine
----------------------
r6             F| current state of 4 LSB bits of switch
r7     0000 0071| 7SSD pattern, 8 bits (2 hex)
r8     3F4F 7171| 7SSD pattern, 32 bits (4 hex). operand 3 (result)
r9     0000 03FF| operand 1
r10    0000 0649| operand 2
r11    0000 03FF| SW state, 10 bits
r12    0000 0008| KEY state
----------------------
sp              |
lr              |
CPSR            | N  Z  C  V
*/