.data
    # Variables
    seedPrompt:    .asciiz "Enter a number for the seed (preferably a 16-bit number): \n"
    highPrompt:    .asciiz "Enter a number for the high end of the range: "
    lowPrompt:     .asciiz "Enter a number for the low end of the range: "
    countPrompt:   .asciiz "Enter how many times you would like to execute: "
    randNum:       .asciiz "Random Number: "
    newLine:       .asciiz "\n"
    seed:          .word 0 
    highRange:     .word 0
    lowRange:      .word 0
    count:         .word 0 
        
.text 
    # Get the upper range from user
    userInputHigh:
        la $a0, highPrompt                # Point to prompt   
        li $v0 , 4                        # Print prompt
        syscall
        li $v0, 5                         # Read the Range
        syscall
        move $t3, $v0                     # Move the value to $t3
        ble $t3, $t4, userInputHigh       # Ask for another number if less than equal to low range
        ble $t3, $zero, userInputHigh     # Ask for another number if less than equal zero
        
     # Get the upper range from user
     userInputLow:
        la $a0, lowPrompt                 # Point to prompt   
        li $v0 , 4                        # Print prompt
        syscall
        li $v0, 5                         # Read the Range
        syscall
        move $t4, $v0                     # Move the value to $t4
        bge $t4, $t3, userInputLow        # Ask for another number if greater than equal to high range 
        ble $t4, $zero, userInputLow      # Ask for another number if less than equal zero

    # Get the Seed from user
    userInputSeed:
        la $a0, seedPrompt                # Point to prompt
        li $v0, 4                         # Print prompt
        syscall
        li $v0, 5                         # Read the seed
        syscall 
        move $t0, $v0                     # Move the seed before changed to $t0
    	
    # Get the Count from the user
    userInputCount:
        la $a0, countPrompt               # Point to prompt
        li $v0, 4                         # Print prompt
        syscall 
        li $v0, 5                         # Read the Count
        syscall
        move $t5, $v0                     # Move Count to $t5
        ble $t5, $zero, userInputCount    # Check if less than or equal to zero
    
    
    addi $t1, $zero, 49433                # Saves prime number as 78487
    addi $t8, $zero, 1                    # Saves 1 in $t8
    sub $t9, $t3, $t4                     # (High - Low)
    add $t9, $t9, $t8                     # (High - Low) + 1
    
    loop:         
    	multu $t0, $t1                    # Multiply the prime number($t1) with the seed($t0)
    	mflo $t0                          # Save the LO reg to $t0
    	mfhi $t7                          # Save the HI reg to $t7   
    	la $a0, randNum                   # Points to randNum
    	li $v0, 4                         # Reads randNum
    	div $t7, $t9                      # (randNum / (High - Low) + 1)
    	mfhi $t6                          # Gets remainder from previous step
    	add $t6, $t6, $t4                 # Saves (randNum % ((High - Low) + 1) + Low) to $t6
    	syscall
    	move $a0, $t6                     # Moves $t6 to $a0
    	li $v0, 1                         # Reads $t7
    	syscall
    	la $a0, newLine                   # Points to newLine
    	li $v0, 4                         # Reads newLine
    	syscall
    	
    	sub $t5, $t5, $t8                 # Subtracts 1 from the count 
    	ble $t5, $zero, exit              # If count is less than equal to zero; branch to exit
    	j  loop                           # Branch to loop

    exit:	
        # Exit Program
        li $v0, 10
        syscall
    
    
    
    