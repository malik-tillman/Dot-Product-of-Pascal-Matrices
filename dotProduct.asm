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
                      
sz:  .word 10

dz:  .word 4

sp: .asciiz " "
nl: .asciiz "\n"

title: .asciiz "Welcome to the Matrix Multipier"
discription: .asciiz "This application will calculate the dot square \nof a 10 x 10 Symmetric Pascal Matrix"
	
.text
main:
    la $s0, rm                           # Reg s0 gets matrix
    la $s1, dm                           # Reg s1 gets answer matrix
	
    lw $s3, sz                           # C: Reg s3 gets matrix size
    lw $s4, dz                           # D: Reg s4 gets data size (__4__bytes)
	
    li $t0, 0                            # X: Rows Iterator
    li $t1, 0                            # Y: Coulums Iterator
    li $t2, 0                            # Z: Recursive Addition Iterator
	
    # First Nested Loop
    # Calcuates Dot Square and places it in s2
    # for(r = 0; r < MatrixRows)
    rLoop:
        bge $t0, $s3, END                # for(r = 0; r < rmRows)
    	addi $t0, $t0, 1                 # r++
    	li $t1, 0                        # Reset cmColumns
		
        j cLoop                          # Nested Loop
    
    # Second Nested Loop
    # for(c = 0; c < MatrixRows)
    cLoop: 
    	bge $t1, $s3, rLoop              # for(c = 0; c < cmColumns)
    	addi $t1, $t1, 1                 # c++
    	li $t2, 0                        # Reset cmRows
    	
    	j r2Loop                         # Nested Loop
    
    # Final Nested Loop
    # for(r2 = 0; r2 < MatrixRows)	
    r2Loop:                          
    	bge $t2, $s3, cLoop              # Branch if iterator >= Column Size
    	addi $t0, $t0, -1                # X: Cancel iterator interference of calculation
    	addi $t1, $t1, -1                # Y: Cancel iterator interference of calculation
    	
    	# Get address for dm[X][Y]
    	la $a0, ($t0)                    # rowMajor(X, 
    	la $a1, ($t1)                    #             Y, 
    	la $a2, ($s1)                    #                dm-baseAddr) 
    	jal rowMajor	                 # Calucate new address
    	lw $t7, ($s5)                    # Reg t7 get dm value
    	la $t4, ($s5)                    # Reg t4 gets dm address 
    	
    	# Get value for matrix[X][Z]
    	la $a0, ($t0)                    # rowMajor(X, 
    	la $a1, ($t2)                    #            Z,
    	la $a2, ($s0)                    #               matrix-baseAddr)
    	jal rowMajor	                 # Calucate new address
    	lw $t5, ($s5)                    # Reg t5 gets matrix[X][Z] integer
    	
    	# Get value for matrix[Z][Y]
    	la $a0, ($t2)                    # rowMajor(Z,
    	la $a1, ($t1)                    #            Y,
    	la $a2, ($s0)                    #               matrix-baseAddr)
    	jal rowMajor	                 # Calucate new address
    	lw $t6, ($s5)                    # Reg t6 gets matrix[Z][Y] integer
    	 
    	# Perform iterative dot product solution
    	mulu $t5, $t5, $t6               # t5 = matrix[X][Z] * matrix[Z][Y]
    	addu $t7, $t7, $t5               # dm[X][Z] += t5
    	sw $t7, ($t4)                    # Store in dm[X][Z]
    	
    	# Restore Iterators
    	addi $t0, $t0, 1                 # X: Redo iteration that led to interference of caluculation
    	addi $t1, $t1, 1                 # Y: Redo iteration that led to interference of caluculation
    	addi $t2, $t2, 1                 # Z: Redo iteration that led to interference of caluculation
    	j r2Loop                         # Loop
	
	# Address Generation with Row Major Order 
	# returns the address of a2[a0][a1]
	# a0 : Row Index 
	# a1 : Column Index
	# a2 : Bass Address of Array
	# Let D = Data Size in Bytes and C = Array's Column Size 
	# f(a0, a1, a2) = a2 + (D(a0 * C + a1))
	# s5 is our return register
	rowMajor:                        # rowMajor(a0, a1, a2)
    	mul $s5, $a0, $s3                # ((X * C
    	add $s5, $s5, $a1                #        + Y)
    	mul $s5, $s5, $s4                #            * D))
    	add $s5, $s5, $a2                #                 + baseAddr  	
    	jr $ra                           # Return to link
							
    END:
        li $s7, 0                        # X = 0
		
	xLoop:
	    beq $s7, $s3, EXIT           # for(x=0; x<columnSize)
	    addi $s7, $s7, 1             # X++ 
	    li $s6, 0                    # Y = 0
		
	    la $a0, nl                   # Print New Line
	    li $v0, 4                    # System call to print ascii
	    syscall
		
	    j yLoop                      # Nested Loop
		
	yLoop:
	    beq $s6, $s3, xLoop	         # for(y=0; y<columnSize)
	    addi $s7, $s7, -1            # Cancel X iterator interference of calculation
		
	    addi $a0, $s7, 0             # rowMajor(X, 
	    addi $a1, $s6, 0   	         #             Y, 
	    addi $a2, $s1, 0             #                baseAddr)
	    jal rowMajor                 # Generate Addess with parameters(a0, a1, a2)
	    
	    lw $a0, ($s5)                # Reg t7 get dm value
	    li $v0, 36		         # System Call Prints Unsigned Integer
	    syscall

	    la $a0, sp      	         # Print Space
	    li $v0, 4                    # System call for ascii print
	    syscall
    	
            addi $s7, $s7, 1	         # Restore X iterator
            addi $s6, $s6, 1             # Y++
    	
            j yLoop		         # Loop
    	
	EXIT:
	    li $v0, 10	                 #System Call to End Program
	    syscall	
