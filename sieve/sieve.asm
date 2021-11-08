### Data Declaration Section ###

.data

primes:	.space  1000            # reserves a block of 1000 bytes in application memory
err_msg: .asciiz "Invalid input! Expected integer n, where 1 < n < 1001.\n"
space: .asciiz " "

### Executable Code Section ###

.text
main:
    	# get input
    	li $v0, 5                   # set system call code to "read integer"
    	syscall                         # read integer from standard input stream to $v0

    	# validate input
    	li $t0, 1001
    	slt $t1, $v0, $t0		        # $t1 = input < 1001
    	beq $t1, $0, invalid_input # if !(input < 1001), jump to invalid_input
    
    	li $t0, 1
    	slt $t1, $t0, $v0		        # $t1 = 1 < input
    	beq $t1, $0, invalid_input # if !(1 < input), jump to invalid_input
    
    	# initialise primes array
    	la $t0, primes              # address of the first element in the array
    	li $t1, 999
    	li $t2, 0
    	li $t3, 1
    	
    	# store input
    	move $s0, $v0 # n 
	subi $s1, $s0, 2 # index of n: -2 as the first element is 2 and not 0
	
	init_loop:
    		sb $t3, ($t0)              # primes[i] = 1
    		addi $t0, $t0, 1             # increment pointer
    		addi $t2, $t2, 1             # increment counter
    		bne $t2, $t1, init_loop     # loop if counter != 999
 
	# loop
	subi $t0, $0, 1 # counter
	
	# loop through all values
	main_loop:
		bgt $t0, $s1, loop_finished # exit loop		
		addi $t0, $t0, 1 # counter++
		la $t1, primes # reset pointer	
		add $t1, $t1, $t0 # start loop from current index
		addi $t2, $t0, 2 # accual number (index + 2)
		
		# continue if number at index is not a prime
		lb $t3, ($t1)
		beq $t3, $0, main_loop
		
		move $t3, $t0 # counter secondary loop
		# remove primes
		secondary_loop:	
			add $t1, $t1, $t2 # pointer += $t2
			add $t3, $t3, $t2 # counter += $t2
			
			bgt $t3, $s1, main_loop # continue main loop
			
			# change to non-prime
			sb $0, ($t1)
			
			j secondary_loop # continue

	loop_finished:

    	# print
    	la $t0, primes # pointer
    	subi $t0, $t0, 1
    	subi $t1, $0, 1 # counter
    	
    	print_loop: 		
    		addi $t0, $t0, 1 # pointer++
    		addi $t1, $t1, 1 # counter++
    		bgt $t1, $s1, exit_program # Exit loop as the print function jumps back here
    		lb $t3, ($t0)
    		bne $t3, $0, print_number # print if index i is a prime	
    		j print_loop # continue

print_number:
	# print number
	addi $a0, $t1, 2 # First element is 2
	li $v0, 1 # print prime index
	syscall
	
	# print space
	li $v0, 4
	la $a0, space
	syscall
	
	j print_loop
	
invalid_input:
    	# print error message
    	li $v0, 4                  # set system call code "print string"
    	la $a0, err_msg            # load address of string err_msg into the system call argument registry
    	syscall                         # print the message to standard output stream

exit_program:
    	# exit program
    	li $v0, 10                      # set system call code to "terminate program"
    	syscall                         # exit program
