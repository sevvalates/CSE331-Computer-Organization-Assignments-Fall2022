.data
myArray: .space 400 #100 element integer array
msg1: .asciiz "Enter the size of the array:"
msg2: .asciiz "Enter the integer divisor:"
msg3: .asciiz "Enter the elements of the array:"
msg4: .asciiz "\nThe number of the divisible pairs: "
msg5: .asciiz " and "
msg6: .asciiz " , "
msg7: .asciiz "\nThe divisible pairs are: "

.text
get_size:
	li $v0, 4
	la $a0, msg1
	syscall             # print msg1

	li $v0, 5 # load syscall read_int into $v0.
	syscall

	move $s2, $v0 # move the number read into $v0. $s2 contains the size of the array. : $s2 = n
	addi $s1, $zero, 101 #maximum element size is 100, $s1=101
	slt $t1, $s2, $s1 # if ($s1 <= $s2) check if the max number of element is exceeded.
	beq $t1, $zero, get_size #branch to the label size again if it is exceeded else continue s2 is the size
	
get_divisor:
	li $v0, 4
	la $a0, msg2
	syscall             # print msg2

	li $v0, 5 # load syscall read_int into $v0.
	syscall

	move $s4, $v0 		# move the number read into $v0. $s2 contains the size of the array. : $s4 = k
	addi $s3, $zero, 101 	# maximum integer divisor is 100, $s1=101
	slt $t1, $s4, $s3 	# if ($s3 <= $s4) check if the max integer divisor is exceeded.
	beq $t1, $zero, get_divisor #branch to the label size again if it is exceeded else continue

print_get_elements:				
	addi $t0,$t0,0  # index = $t0
	addi $t2,$t2,0  # count = $t1

	li $v0, 4
	la $a0, msg3
	syscall             # print msg3

get_elements:
	li $v0, 5
	syscall
	
	sw $v0,myArray($t0)
	addi $t0,$t0,4  # increment array address location
	addi $t2,$t2,1  # increment array size
	
	bne $t2,$s2,get_elements
	
li $v0, 4
la $a0, msg7
syscall             # print msg7	
	
move $s6,$zero 	# s6 = (count) number of the divisible pairs = 0		
move $s0,$zero 	# s0 = i = 0	
addi $s2,$s2,-1 # s2 = n = n-1
outer_for_loop: 
	slt $t0, $s0, $s2 	# t0 = 0 if s0 >= s2 , i>= n-1 
	beq $t0, $zero, exit1 	# go to exit1 if s0 >= s2 , i>=n-1 
	add $s1, $s0, $zero 	# s1 = j = i
	
inner_for_loop:
	slt $t0, $s1, $s2 	# t0 = 0 if s1 >= s2 , j>= n-1
	beq $t0, $zero, exit2 	# go to exit1 if s1 >= s2 , i>= n-1  
	addi $t1, $s1, 1	# j = j + 1
	sll $t1, $t1, 2		# t1 = j * 4
	sll $t2, $s0, 2		# t2 = i * 4
	lw $t3, myArray($t1)	# t3 = myArray[j+1]
	lw $t4, myArray($t2)	# t4 = myArray[i]
	add $t5, $t3,$t4 	# t5 = myArray[j+1] + myArray[i]
	
	#li $v0,1
	#add $a0, $t5, $zero	# print to see if myArray[j+1] + myArray[i] give true results
	#syscall
	
	#doing the mod thing
	add $t0, $zero, $s4    	# Store the divisor( s4 = k ) in $t0
    	div $t0, $t5, $t0     	# Divide (myArray[j+1] + myArray[i]) by divisor
    	mfhi $s5              	# Save remainder in $s5
    	beq $s5, $zero ,divisibleSumPairs 	# go to count if s5=0
    	

	addi $s1, $s1, 1	# j = j+1
	j inner_for_loop	# jump to inner for loop
exit1:
	li $v0,4
	la $a0, msg4
	syscall
	
	li $v0,1
	add $a0, $s6, $zero	# print the number of the divisible pairs
	syscall
	
	li $v0,10
	syscall

exit2:
	addi $s0, $s0, 1	# i = i+1
	j outer_for_loop	# jump to outer for loop
	
divisibleSumPairs:
	add $s6, $s6 , 1   	# increment the count
	addi $s1, $s1, 1	# j = j+1
	
	li $v0,1
	add $a0, $t4, $zero	# print the the divisible pairs
	syscall
	
	li $v0,4
	la $a0, msg5
	syscall
	
	li $v0,1
	add $a0, $t3, $zero	# print the the divisible pairs
	syscall
	
	li $v0,4
	la $a0, msg6
	syscall
	
	j inner_for_loop	# jump to inner for loop
	 

