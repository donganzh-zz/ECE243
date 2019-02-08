.equ RED_LEDS, 0xFF200000 	   # (From DESL website > NIOS II > devices)


.data                              # "data" section for input and output lists


IN_LIST:                  	   # List of 10 signed halfwords starting at address IN_LIST
    .hword 1
    .hword -1
    .hword -2
    .hword 2
    .hword 0
    .hword -3
    .hword 100
    .hword 0xff9c
    .hword 0b1111
LAST:			 	    # These 2 bytes are the last halfword in IN_LIST
    .byte  0x01		  	    # address LAST
    .byte  0x02		  	    # address LAST+1
    
IN_LINKED_LIST:                     # Used only in Part 3
    A: .word 1
       .word B
    B: .word -1
       .word C
    C: .word -2
       .word E + 8
    D: .word 2
       .word C
    E: .word 0
       .word K
    F: .word -3
       .word G
    G: .word 100
       .word J
    H: .word 0xffffff9c
       .word E
    I: .word 0xff9c
       .word H
    J: .word 0b1111
       .word IN_LINKED_LIST + 0x40
    K: .byte 0x01		    # address K
       .byte 0x02		    # address K+1
       .byte 0x03		    # address K+2
       .byte 0x04		    # address K+3
       .word 0
    
OUT_NEGATIVE:
    .skip 40                         # Reserve space for 10 output words
    
OUT_POSITIVE:
    .skip 40                         # Reserve space for 10 output words

#-----------------------------------------

.text                  # "text" section for code

    # Register allocation:
    #   r0 is zero, and r1 is "assembler temporary". Not used here.
    #   r2  Holds the number of negative numbers in the list
    #   r3  Holds the number of positive numbers in the list
	#   r4  address of LED
    #   r7  A pointer to array element IN_LINKED_LIST
	#   r5 	length of the list
    #   r6  loop counter for IN_LIST
    #   r16, r17 Short-lived temporary values.
    #   r14, r15 pointer tho output array list

.global _start
_start:
	movia r7, IN_LINKED_LIST
    movi r2, 0
	movi r3, 0
	movi r6, 0
	movi r5, 10
	movia r14, OUT_NEGATIVE
	movia r15, OUT_POSITIVE
LOOP:
	bge r6, r5, LOOP_FOREVER
	ldw r16, 0(r7) 		/*load list item to r16*/
	ldw r7, 4(r7)       /*let r7*/
	addi r7, r7, 2 
	addi r6, r6, 1 		/*loop counter increase 1 after each iteration*/

	movia r8, RED_LEDS
	ldwio r17, 0(r8)
	addi r17, r17, 1
	stwio r17, 0(r8)

	blt r16, r0, IF 	/*r16 < o negative*/
	bgt r16, r0, ELSEIF /*r16 > o positive*/
	br LOOP			/*if r16 = o proceed to next iteration*/
IF: 					/*r16 < o negative*/
	stw r16, 0(r14)     /*store value to output negative*/
	addi r14, r14, 4
	addi r2, r2, 1
	br LOOP
ELSEIF:					/*r16 > o positive*/
	stw r16, 0(r15)		/*store value to output negative*/
	addi r15, r15, 4
	addi r3, r3, 1
	br LOOP
	
    # Your program here. Pseudocode and some code done for you:
    
    # Begin loop to process each number
    
        # Process a number here:
        #    if (number is negative) { 
        #        insert number in OUT_NEGATIVE list
        #        increment count of negative values (r2)
        #    } else if (number is positive) { 
        #        insert number in OUT_POSITIVE list
        #        increment count of positive values (r3)
        #    }
        # Done processing.


        # (You'll learn more about I/O in Lab 4.)

        # Finished output to LEDs.
    # End loop


LOOP_FOREVER:
    br LOOP_FOREVER                   # Loop forever.
    
