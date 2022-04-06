		.data
greetingtext:   .asciiz "Welcome to our MIPS project!\n"
menutext: 	.asciiz "\nMain Menu:\n"
one: 		.asciiz "1. Base Converter\n"
two: 		.asciiz "2. Add Rational Number\n"
three: 		.asciiz "3. Text Parser\n"
for: 		.asciiz "4. Mystery Matrix Operation\n"
five: 		.asciiz "5. Exit\n"	
optiontext: 	.asciiz "Please select an option: "	
		.text

		.data
jump_table:  	.word q1, q2, q3, q4, exit
		.text	
		
main:	li $v0, 4
	la $a0, greetingtext
	syscall
	j  menu

reset:
	add $s0, $zero, $zero
	add $s1, $zero, $zero
	add $s2, $zero, $zero
	
	add $a0, $zero, $zero
	add $a1, $zero, $zero
	
	add $v0, $zero, $zero
	add $v1, $zero, $zero
	
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t5, $zero, $zero
	add $t6, $zero, $zero
	add $t7, $zero, $zero
	add $t8, $zero, $zero
	add $t9, $zero, $zero
	
	j menu

menu:	li $v0, 4	# print string
	la $a0, menutext
	syscall
	
	la $a0, one
	syscall

	la $a0, two
	syscall
	
	la $a0, three
	syscall
	
	la $a0, for
	syscall
	
	la $a0, five
	syscall
	
	la $a0, optiontext
	syscall
	
	li $v0, 5	     # read integer
	syscall
	add $t0, $v0, $zero  # move $v0 to $t0.
	addi $t0, $t0, -1    # Decrement input for memory alignment of jump_table.
	sll $t0, $t0, 2	     # words are 4 bytes, so multiply input with 4.
	
	la $a0, jump_table
	add $a0, $a0, $t0
	lw $t1, 0($a0)
	jr $t1		     # jump to the given case.
	
	
# convert number
q1:    
	 .data
input:   .asciiz "\nInput: "
type:    .asciiz "Type: "
output:  .asciiz "Output: "
buffer:  .space 80
	 .text	
	
	li $v0, 4
	la $a0, input
	syscall
	
	li $v0, 8             # take string input
    	la $a0, buffer        # allocate space for string
    	li $a1, 80
    	add $t0, $a0, $zero   # save string address to t0
    	syscall
    		
	li $v0, 4
	la $a0, type
	syscall
	
	li $v0, 5	     # read integer
	syscall
	add $t1, $v0, $zero  # move $v0 to $t1.
	
	# loop counters
	addi $t3, $t3, 0
	add $t4, $t4, 1
	addi $t6, $t6, 0
	addi $t7, $t7, 8
	
	char_counter:
		add $t5, $t0, $t3
		lb $t5, 0($t5)
		beq $t5, 0, after_counter
		beq $t5, 10, after_counter
		addi $t3, $t3, 1
		j char_counter
	
	# set conditions for types:
	after_counter:
		addi $t3, $t3, -1
		beq $t1, 2, second_type_init
		j first_type
		
		second_type_init:
			li $v0, 4
			la $a0, output
			syscall
			add $t6, $zero, $zero 
			j second_type
	
	first_type:	
		beq $t3, -1, first_type_result
		add $t5, $t0, $t3
		lb $t5, 0($t5)
		
		add $t3, $t3, -1
		beq $t5, ' ', first_type # 32
		
		addi $t6, $t5, -48  # '0' - 48 = 0	
		
		beq $t3, -1, last_digit
				
		non_negative:
			mul $t6, $t6, $t4
			sll $t4, $t4, 1
			add $s1, $s1, $t6
			j first_type
			
		last_digit:
			beq $t6, $zero, non_negative # branch if the first digit is 0
			mul $t6, $t6, $t4
			mul $t6, $t6, -1
			sll $t4, $t4, 1
			add $s1, $s1, $t6
			j first_type_result
		
	first_type_result:	
		li $v0, 4
		la $a0, output
		syscall
		
		li $v0, 1
		la $a0, 0($s1)
		syscall
		
		j reset
		
	second_type:
		add $t8, $t0, $t6
		addi $t6, $t6, 1 
		
		lb $t8, 0($t8)
		beq $t8, ' ', finish_cycle
		beq $t8, '\0', reset
		beq $t8, '\n', reset
		
		addi $t8, $t8, -48  # '0' - 48 = 0
		
		mul $t8, $t8, $t7
		add $t9, $t9, $t8
		
		beq  $t7, 1, convert_to_hex
		bgt $t6, $t3, convert_to_hex
		sra $t7, $t7, 1
		j second_type

		convert_to_hex:
			bge $t9, 10, bigger_than_nine
			li $v0, 1
			move $a0, $t9
			syscall
			j finish_cycle
			
			bigger_than_nine:
				addi $t9, $t9, 55
				li $v0, 11
				move $a0, $t9
				syscall
		
		finish_cycle: 		
			add $t9, $zero, $zero
			addi $t7, $zero, 8
			j second_type
	
	j reset
q2:
	 .data
q2_first_num:    .asciiz "\nEnter the first numerator: "
q2_first_den:    .asciiz "Enter the first denominator: "
q2_second_num:	 .asciiz "Enter the second numerator: "
q2_second_den:	 .asciiz "Enter the second denominator: "
q2_output:  	 .asciiz "Output: "
q2_symbol:	 .asciiz "/"
	 .text	

	li $v0, 4
	la $a0, q2_first_num
	syscall
	
	li $v0, 5	     # read the first numerator
	syscall
	add $t0, $v0, $zero
	
	li $v0, 4
	la $a0, q2_first_den
	syscall
	
	li $v0, 5	     # read the first denominator
	syscall
	add $t1, $v0, $zero
	
	li $v0, 4
	la $a0, q2_second_num
	syscall
	
	li $v0, 5	     # read the second numerator
	syscall
	add $t2, $v0, $zero
	
	li $v0, 4
	la $a0, q2_second_den
	syscall
	
	li $v0, 5	     # read the second denominator
	syscall
	add $t3, $v0, $zero
	
	mul $t4, $t1, $t3
	mul $t5, $t0, $t3 
	mul $t6, $t2, $t1
	add $t6, $t6, $t5
	 
	  # $t6 / $t4 
	add $t2, $t4, $zero
	add $t3, $t6, $zero
			
	euclidean_algorithm:
		beq $t3, $zero, euclid_finish
		div $t2, $t3
		add $t2, $t3, $zero
		add $t9, $t3, $zero
		mfhi $t3
		j euclidean_algorithm
	
	euclid_finish:
		div $t6, $t6, $t9
		div $t4, $t4, $t9
	
	q2_result:
		li $v0, 4
		la $a0, q2_output
		syscall
		
		li $v0, 1
		move $a0, $t6
		syscall
		
		li $v0, 4
		la $a0, q2_symbol
		syscall
		
		li $v0, 1
		move $a0, $t4
		syscall
	j reset
q3:
	 .data
q3_input:     	     .asciiz "\nInput text: "
q3_parser:    	     .asciiz "Parser characters: "
q3_output:    	     .asciiz "Output: "
q3_new_line:         .asciiz "\n"
q3_buffer:    	     .space 80
q3_parser_buffer:    .space 80
	 .text	
	 
	li $v0, 4
	la $a0, q3_input
	syscall
		
	li $v0, 8           
    	la $a0, q3_buffer       
    	li $a1, 80
    	add $t0, $a0, $zero  
    	syscall
    	
    	li $v0, 4
	la $a0, q3_parser
	syscall
		
    	li $v0, 8           
    	la $a0, q3_parser_buffer    
    	li $a1, 80
    	add $t1, $a0, $zero  
    	syscall
    	
    	# initialize iterator pointers
    	add $t2, $zero, $zero # input iterator
    	add $t3, $zero, $zero # parser character iterator
    	add $t7, $zero, $zero # last index tracker
    	
    	parser_loop:
    	  	add $t4, $t0, $t2	
    	  	lb $t5, 0($t4)
    	  	beq $t5, '\0', parse_last
    		beq $t5, '\n', parse_last
    		
    		inner_loop:
    			add $t6, $t1, $t3
    			lb $t6, 0($t6)
    			beq $t5, $t6, parse
    			beq $t6, '\0', continue
    			beq $t6, '\n', continue
    			addi $t3, $t3, 1
    			j inner_loop
    			
    		
    		parse_last:
    			addi $t9, $zero, 1
    			
    		parse:	
    			add $t5, $zero, $zero # print iterator
    			
    			print:
    				add $t8, $t5, $t7
    				add $t8, $t0, $t8
    				lb $t8, 0($t8)
    				beq $t6, $t8, print_complete
    				move $a0, $t8
				li $v0, 11    # print_character
				syscall
				addi $t5, $t5, 1
				j print
				
				print_complete:
				   	add $t7, $t2, 1
    					add $t3, $zero, $zero	
    					add $t4, $t0, $t2	
    					addi $t4, $t4, 1
    	  				lb $t5, 0($t4)
    	  				add $t3, $t3, $zero
    	  				
				   	ignore_seperators:
    						add $t6, $t1, $t3
    						lb $t6, 0($t6)
    						beq $t6, '\0', print_new_line
    						beq $t6, '\n', print_new_line
    						beq $t5, $t6, done
    						addi $t3, $t3, 1
    						j ignore_seperators
    	  				
    	  				print_new_line:
						la $a0, q3_new_line
				   		li $v0, 4
						syscall
					
					done:
					beq $t9, 1, reset
					
    	  		continue:	
    				add $t3, $zero, $zero	
    				addi $t2, $t2, 1
    		
    			j parser_loop
    	
	j reset
q4:
	j reset
	
exit:	li $v0, 4
		.data
exiting_text:   .asciiz "Exiting...\n"
		.text	
	la $a0, exiting_text
	syscall
	
	li $v0, 10
	syscall
