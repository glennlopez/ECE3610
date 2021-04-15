.include    "address_map_arm.s"

.text                       
.global     _start    
.equ    Plaintext, 0x00000050
.equ    Cyphertext, 0x0000070

_start: 
        LDR     R1, =Plaintext
        LDR     R2, =Cyphertext

        MOV     R3, #0

LOOP:   
        LDRB    r4,[r1,r3]
        CMP     r4, #0
        BEQ     Exit

        ADD     r4, r4, #1
        STRB    r4, [r2,r3]
        ADD     r3, r3, #1

        CMP     r3, #20
        BEQ     Exit

        B       LOOP


Exit:

.end                        
