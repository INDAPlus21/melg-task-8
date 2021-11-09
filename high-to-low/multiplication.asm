##
# Push value to application stack.
# PARAM: Registry with value.
##
.macro	PUSH (%reg)
	addi	$sp,$sp,-4              # decrement stack pointer (stack builds "downwards" in memory)
	sw	    %reg,0($sp)             # save value to stack
.end_macro

##
# Pop value from application stack.
# PARAM: Registry which to save value to.
##
.macro	POP (%reg)
	lw	    %reg,0($sp)             # load value from stack to given registry
	addi	$sp,$sp,4               # increment stack pointer (stack builds "downwards" in memory)
.end_macro

.globl multiplication
.globl faculty

.data
	new_line: .asciiz "\n"

.text
# For testing my functions
main:
	# Multiplication
	# Set argument values
	li $a0, 0
	li $a1, 5 
    
	jal multiplication
	
	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print	
    	syscall
    	
    	# print new_line
    	li $v0, 4
    	la $a0, new_line
    	syscall
	
	# Set argument values
	li $a0, 6
	li $a1, 3 
    
	jal multiplication
    
    	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print	
    	syscall
    	
    	# print new_line
    	li $v0, 4
    	la $a0, new_line
    	syscall
    	
    	
    	
    	# Faculty
    	# Set argument values
	li $a0, 5
    
	jal faculty
    
    	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print	
    	syscall
    	
    	# print new_line
    	li $v0, 4
    	la $a0, new_line
    	syscall
    	
    	# Set argument values
	li $a0, 3
    
	jal faculty
    
    	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print	
    	syscall
    	
    	# print new_line
    	li $v0, 4
    	la $a0, new_line
    	syscall
    	
    	# Set argument values
	li $a0, 0
    
	jal faculty
    
    	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print	
    	syscall
    	
    	# print new_line
    	li $v0, 4
    	la $a0, new_line
    	syscall
    	
    	
    
    	# Exit program
   	li $v0, 10
    	syscall

multiplication:
	PUSH($s2)
	move $s2, $0			# Assign sum value

    	# Loop 
    	li $t0, 0 # Start index
 	
 	beq $a0, $0, multiply_zero
 	beq $a1, $0, multiply_zero
 	
 	multiply_loop:
 		addi $t0, $t0, 1 # Add one to counter
    		add $s2, $s2, $a1 # Add value
		bne $a0, $t0 multiply_loop # Continue loop if counter != end value

	j multiply_return
	
	# Return 0
	multiply_zero:
	move $v1, $0

	# return value
	multiply_return:
	move $v1, $s2
	POP($s2)

    	# return to parent
    	jr $ra
    	
faculty:
	# Push stacks
	PUSH($s1)                       
	PUSH($s2)
	PUSH($s3)
	PUSH($s4)
	move $s1, $ra                # Save return address
	li $s2, 1			# Assign faculty value
	move $s3, $a0			# Save input

    	# Loop 
    	move $s4, $a0 # Start index
 	
 	beq $a0, $0, faculty_zero
 	
 	faculty_loop: 	
    		# Multiply
    		move $a0, $s2
    		move $a1, $s4
    		jal multiplication
		move $s2, $v1
		
		subi $s4, $s4, 1 # Add one to counter
		bne $s4, $0, faculty_loop # Continue loop if counter != 0

	j faculty_return
	
	# return value
	move $v1, $s2

	# return 1
	faculty_zero:
	addi $v1, $0, 1

	faculty_return:
    	# return parent values
    	move $ra, $s1
    	
    	POP($s1)
    	POP($s2)
    	POP($s3)
    	POP($s4)

    	# return to parent
    	jr $ra
