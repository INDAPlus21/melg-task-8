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

.data
	newline: .asciiz "\n"

.text
# For testing my functions
main:
	# Multiplication
	# Set argument values
	move $a0, $0
	move $a1, $0
	addi $a0, $a0, 4
	addi $a1, $a1, 5 
    
	jal multiplication
	
	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print s2	
    	syscall
    	
    	# print newline
    	li $v0, 4
    	la $a0, newline
    	syscall
	
	# Set argument values
	move $a0, $0
	move $a1, $0
	addi $a0, $a0, 6
	addi $a1, $a1, 3 
    
	jal multiplication
    
    	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print s2	
    	syscall
    	
    	# print newline
    	li $v0, 4
    	la $a0, newline
    	syscall
    	
    	
    	
    	# Faculty
    	# Set argument values
	move $a0, $0
	addi $a0, $a0, 3
    
	jal faculty
    
    	# print output
    	li $v0, 1		# set system call code to "print integer"
    	move $a0, $v1		# print s2	
    	syscall
    	
    	# print newline
    	li $v0, 4
    	la $a0, newline
    	syscall
    
    	# Exit program
   	li $v0, 10
    	syscall

multiplication:
	# Push stacks
	#PUSH($s1)                       
	#PUSH($s2)
	move $s1, $ra                # Save return address
	move $s2, $0			# Assign sum value

    	# Loop 
    	li $t0, 0 # Start index
 	
 	multiplyloop:
 		addi $t0, $t0, 1 # Add one to counter
    		add $s2, $s2, $a1 # Add value
		bne $a0, $t0 multiplyloop # Continue loop if counter != end value

	# return value
	move $v1 $s2

    	# return parent values
    	#POP($s1)
    	#POP($s2)

    	# return to parent
    	jr      $ra
    	
faculty:
	# Push stacks
	PUSH($s1)                       
	PUSH($s2)
	PUSH($s3)
	move $s1, $ra                # Save return address
	move $s2, $0			# Assign multiplication value
	addi $s2, $s2, 1
	move $s3, $a0			# Save input

    	# Loop 
    	move $t0, $a0 # Start index
 	
 	facultyloop:
    		# Multiply
    		move $a0 $s2
    		move $a1 $t0
    		jal multiplication
		
		subi $t0, $t0, 1 # Add one to counter
		bne $t0, $0 facultyloop # Continue loop if counter != 0

	# return value
	move $v1 $s2

    	# return parent values
    	POP($s1)
    	POP($s2)
    	POP($s3)
    	
    	move $ra $s1

    	# return to parent
    	jr      $ra