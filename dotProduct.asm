# An algorithm that multiplies two 10 x 10 symetrical pascal matrices 
# By: Malik Tillman and Austin Cho
.data
rm: .word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    .word 1, 3, 6, 10, 15, 21, 28, 36, 45, 55
    .word 1, 4, 10, 20, 35, 56, 84, 120, 165, 220
	.word 1, 5, 15, 35, 70, 126, 210, 330, 495, 715
	.word 1, 6, 21, 56, 126, 252, 462, 792, 1287, 2002
	.word 1, 7, 28, 84, 210, 462, 924, 1716, 3003, 5005
	.word 1, 8, 36, 120, 330, 792, 1716, 3432, 6435, 11440
	.word 1, 9, 45, 165, 495, 1287, 3003, 6435, 12870, 24310
	.word 1, 10, 55, 220, 715, 2002, 5005, 11440, 24310, 48620
	
cm: .word 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    .word 1, 3, 6, 10, 15, 21, 28, 36, 45, 55
    .word 1, 4, 10, 20, 35, 56, 84, 120, 165, 220
	.word 1, 5, 15, 35, 70, 126, 210, 330, 495, 715
	.word 1, 6, 21, 56, 126, 252, 462, 792, 1287, 2002
	.word 1, 7, 28, 84, 210, 462, 924, 1716, 3003, 5005
	.word 1, 8, 36, 120, 330, 792, 1716, 3432, 6435, 11440
	.word 1, 9, 45, 165, 495, 1287, 3003, 6435, 12870, 24310
	.word 1, 10, 55, 220, 715, 2002, 5005, 11440, 24310, 48620
	
dm: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	.word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

# Delete Test Cases		
rm1: .word 1, 2, 3 # [1,2]
     .word 4, 5, 6
     .word 7, 8, 9 # [3,4]
       
cm1: .word 1, 2, 3 # [1,2]
     .word 4, 5, 6
     .word 7, 8, 9 # [3,4]

dm1: .word 0, 0, 0 # [0,0]
	 .word 0, 0, 0
	 .word 0, 0, 0 # [0,0]
# Delete Test Cases
                      
sz:  .word 10

dz:  .word 4

sp: .asciiz " "
nl: .asciiz "\n"
	
.text
main: 
	la $s0, rm  # Reg s0 gets rm matrix
	la $s1, cm  # Reg s1 gets cm matrix
	la $s2, dm  # Reg s2 gets dm matrix
	
	lw $s3, sz  # C: Reg s3 gets column size
	lw $s4, dz  # D: Reg s4 gets data size (__4__)
	
	li $t0, 0  # X: Multiplier Rows
	li $t1, 0  # Y: Multiplicand Coulums
	li $t2, 0  # Z: Multiplicand Rows
	
    rLoop:
    	bge $t0, $s3, END  # for(r = 0; r < rmRows)
    	addi $t0, $t0, 1   # r++
    	li $t1, 0          # Reset cmColumns
		
		j cLoop            # Nested Loop
    
    cLoop:
    	bge $t1, $s3, rLoop # for(c = 0; c < cmColumns)
    	addi $t1, $t1, 1    # c++
    	li $t2, 0           # Reset cmRows
    	
    	j r2Loop 			# Nested Loop
    	
    r2Loop:
    	bge $t2, $s3, cLoop # for(r2 = 0; r2 < cmRows)
    	addi $t0, $t0, -1    # X: Cancel iterator interference of calculation
    	addi $t1, $t1, -1    # Y: Cancel iterator interference of calculation
    	
    	# Get address for dm[X][Y]
    	addi $a0, $t0, 0    # rowMajor(X, 
    	addi $a1, $t1, 0   	#             Y, 
    	addi $a2, $s2, 0    #                baseAddr)
    	jal rowMajor		# Calucate new address
    	lw $t7, ($s5)       # Reg t7 get dm value
    	la $t4, ($s5)       # Reg t4 gets dm address 
    	
    	# Get value for rm[X][Z]
    	addi $a0, $t0, 0    # rowMajor(X, 
    	addi $a1, $t2, 0    #            Z,
    	addi $a2, $s0, 0    #               baseAddr)
    	jal rowMajor		# Calucate new address
    	lw $t5, ($s5)       # Reg t5 gets rm[X][Z] 
    	
    	# Get value for cm[Z][Y]
    	addi $a0, $t2, 0    # rowMajor(Z,
    	addi $a1, $t1, 0 	#            Y,
    	addi $a2, $s1, 0    #               baseAddr)
    	jal rowMajor		# Calucate new address
    	lw $t6, ($s5)       # Reg t6 gets cm[Z][Y]
    	
    	mul $t5, $t5, $t6   # t5 = rm[X][Z] * cm[Z][Y]
    	add $t7, $t7, $t5   # dm[X][Z] += t5
    	sw $t7, 0($t4)      # Store in dm[X][Z]
    	
    	addi $t0, $t0, 1	# X: Redo iterator interference of caluculation
    	addi $t1, $t1, 1	# Y: Redo iterator interference of caluculation
    	addi $t2, $t2, 1 	# Z: Redo iterator interference of caluculation
    	
    	j r2Loop            # Loop
	
	rowMajor: # rowMajor(a0, a1)
    	mul $s5, $a0, $s3  # ((X * S
    	add $s5, $s5, $a1  #   	     + Y)
    	mul $s5, $s5, $s4  #             * D))
    	add $s5, $s5, $a2  #                  + baseAddr
    	
    	jr $ra

	
		
									
	END:
		li $t0, 0          # Loop X
		li $t1, 0		   # Loop Y
		
	xLoop:
		beq $s7, $s3, EXIT
		addi $s7, $s7, 1   # X++ 
		li $s6, 0          # Reset Y iterator
		
		la $a0, nl         # Print New Line
		li $v0, 4
		syscall
		
		j yLoop
		
	yLoop:
		beq $s6, $s3, xLoop
		addi $s7, $s7, -1    #Cancel X iterator interference of calculation
		
		addi $a0, $s7, 0    # rowMajor(X, 
    	addi $a1, $s6, 0   	#             Y, 
    	addi $a2, $s2, 0    #                baseAddr)
    	jal rowMajor
    	lw $a0, ($s5)       # Reg t7 get dm value
    	li $v0, 1			# Print Value
    	syscall
    	
    	la $a0, sp      	# Print Space
		li $v0, 4
		syscall
    	
    	addi $s7, $s7, 1	# Restore iterator
    	addi $s6, $s6, 1    # Y++
    	
    	j yLoop
    	
		
		
	EXIT:
		li $v0, 10
		syscall	