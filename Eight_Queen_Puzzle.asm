## Sheema Masood (CS-012) 
## Wajiha Muzaffar Ali (CS-013)
## Aleesha Kanwal (CS-017)
## Date:  06/04/2015
## Eight_Queen_Puzzle.asm 
## Description of Project:
## 		8 Queen Puzzle is the problem of placing 8 queens on an 8x8 chess board [N queens on NxN board; N=8]
## 		so that no queens can attack each other.
## 		Thus, it is necessary that no queens share same row, column and diagonal.

## Register usage:
##		$s0 - N   
##		$s1 - queens_Placed   ; how much queens are placed yet
##		$t0 - board [2D Array]
##		$t1 - queens_RowNo [1D Array]
##		$t2 - queens_ColNo [1D Array]
##
## Arrays description:
##		board - tells the final position on queens [1: present, 0: absent]
##		queens_RowNo - index number tells the queen number and value at this index tells in which row it is placed on board
##		queens_ColNo - index number tells the queen number and value at this index tells in which col it is placed on board


.data
	board: .word 0:8
		   .word 0:8
		   .word 0:8
		   .word 0:8
		   .word 0:8
		   .word 0:8
		   .word 0:8
		   .word 0:8
		   
	queens_RowNo: .word -1:8 
	queens_ColNo: .word -1:8 

	newline: .asciiz "\n"
	tab: .asciiz "\t"
	greeting: .asciiz "TADA! xD   \nAll Queens Placed!"

.text
## main -- initializes all necessary registers with values and addresses
## call 2 methods, 1 for solving puzzle and other to print board ##
## in the end prints greeting and terminates/exit the program ##
main:
	li $s0, 8 #N = 8
	li $s1, 0 #queens_Placed = 0
	la $t0, board #$t0 = address of board
	la $t1, queens_RowNo  #$t1 = queens_rowno
	la $t2, queens_ColNo  #$t2 = queens_ColNo
	
	jal StartGame
	jal PrintBoard 
	
	#print greeting ^^
	li $v0,4
	la $a0,greeting
	syscall
	
	#exit
	li $v0,10
	syscall
#END OF MAIN 



## This method starts to solve the puzzle ##
## It runs loop for columns and one loop for rows ## 
## Column number cannot be incremented until there is one queen in current column ##
## If during searching for safe place it is found that there is no safe row for queen in current col then ##
## then it decrements in column number and remove queen from that previous column ##
## and finds a new safe row for queen starting from the next row it was placed in that previous col ##
## If column number suffers increment then row number is start from 0 ##
## Registers Usage:
##		t3 - store return address
##		t5, t6 - runs loops
##  	t7 - stores "col + 1" values for each iteration
## 		t9 - stores temp values
##		s5, s6 - r, c (loads row # and col # from 1D arrays)
StartGame:
	move $t3, $ra #storing RA as 2 more functions will be called 
	
	li $t5,0 #  col=0
	FOR_LOOP:
		li $t6,0 # row = 0
			
		WHILE_LOOP:
			addi $t7,$t5,1 #t7 = "col + 1" for compare
			beq $s1,$t7,EXIT_WHILE_LOOP  #while (queens_Placed != col + 1)
				
			move $a0, $t6
			move $a1, $t5
			jal PlaceQueen
				
			bne $v0, $zero, LOOP_IF_TRUE
				addi $s1,$s1,-1    #queens_Placed--;
				
				sll $t9,$s1,2 #r = s5
				add $t9, $t1, $t9                              
				lw $s5,0($t9)
				
				sll $t9,$s1,2 #c = s6
				add $t9,$t2,$t9
				lw $s6,0($t9)
				
				#mem loc = SA + 4*(r*N + c) #board[r][c] 
				mul $t9,$s0,$s5
				add $t9,$t9,$s6
				sll $t9,$t9,2
				add $t9,$t9,$t0
			
				#load mem content
				sw $zero,0($t9) #board[r][c] = 0
				
				addi $t5,$t5,-1  #col--;
				addi $t6,$s5,1   #row = r + 1
				
				j WHILE_LOOP
				
			LOOP_IF_TRUE: 
				li $t6, 0 #row = 0
				j WHILE_LOOP
				
		EXIT_WHILE_LOOP:
			addi $t5,$t5,1 # add 1 to col
			slt $t9,$t5,$s0 #if col < N then restart for_loop
			bne $t9,$zero,FOR_LOOP
	
	move $ra, $t3
	jr $ra
#END OF STARTGAME



## It takes the position of start of row for any specific col on board as argument[r,col] ##
## If IsSafe method returns true indicating that queen is safe at this particular position ##
## then it actually places queen at that safe position by updating chess board array and then return true ##
## If all rows are finished i.e. reached to the limit (7) and no queen is placed till that point then it returns False ##
## Registers Usage:
##		s2,s3, s4 -  save arguments and return address
##		a3 -  store '1' for comparison
##		t4 - run loop
## 		t9 - store temp values
PlaceQueen:	
	move $s2,$a0 #r 	#saving arguments 
	move $s3,$a1 #col	
	move $s4,$ra #store return address
	li $a3,1 #store '1' for comparison
	
	beq $s2, $s0, RETURN_FALSE
	
	move $t4,$s2 #row=r	
	##LOOP##
	
	LOOP:
		move $a0,$t4
		move $a1,$s3	
		jal Is_Safe
	
		bne $v0, $a3, JUMP_IF_FALSE #if return num is not = 1 terminate sequential execution
			#queens_RowNo[queens_Placed] = row		
			sll $t9,$s1,2 	#4(i)
			add $t9,$t1,$t9  #SA + 4(i)
			sw $t4,0($t9) 
		
			#queens_ColNo[queens_Placed] = col;	
			sll $t9,$s1,2 	#4(i)
			add $t9,$t2,$t9  #SA + 4(i)
			sw $s3,0($t9) 	
		
			addi $s1,$s1,1 #queens_Placed++`1 

			#mem loc = SA + 4*(row*N + col)
			mul $t9,$t4,$s0			
			add $t9,$t9,$s3
			sll $t9,$t9,2
			add $t9,$t9,$t0 
			
			sw $a3,0($t9) #store 1 

			li $v0,1
			move $ra, $s4
			jr $ra

		JUMP_IF_FALSE:
			addi $t4,$t4,1 #row++
			slt $t9,$t4,$s0  #if row<N then restart Loop1
			bne $t9,$zero,LOOP
		
	RETURN_FALSE:   #if all loops have been ran without jumping to Return_True then return false	
	li $v0,0
	move $ra, $s4
	jr $ra
#END OF PLACEQUEEN



## It takes the position of any cell of board as argument[row,col] ##
## Cell is passed in this method to check whether this cell would be safe [returns 1] to place queen or not [returns 0] ##
## Safety of queen is ensured by checking this cell with the reference of previous placed queens ##
## Registers Usage:
##		s6,s7 -  run loops [temp reg]
##		t8 -  run loops [temp reg]
##		t9 - to store results [temp reg]
##		s5 - to store values for comparisons [temp reg]
Is_Safe:
	#save arguments for later use in all loops
	move $s6,$a0 #row
	move $s7, $a1 #col
		
	##Loop1_Col##	
	li $t8,0 #r=0
	Loop1_Col:	
		#mem loc calculate for accessing 2D array board
		#mem loc = SA + 4*(r*N + col)
		mul $t9,$s0,$t8
		add $t9,$t9,$s7
		sll $t9,$t9,2
		add $t9,$t9,$t0
			
		#load mem content
		lw $t9,0($t9)
		
		li $s5,1 #save 1 to be compared by mem content
		
		#if board[r][col] == 1 then jump to return false #else continue the sequence of Loop1_Col
		beq $t9,$s5,Return_False
		
		#r++
		addi $t8,$t8,1
		
		#if r<N then restart Loop1_Col
		slt $t9,$t8,$s0
		bne $t9,$zero, Loop1_Col
		
		
	##Loop2_Row##
	li $t8,0 #c=0
	
	#this loop will start running after Loop1_Col termination and so on
	Loop2_Row:
		#mem loc = SA + 4*(row*N + c)
		mul $t9,$s0,$s6
		add $t9,$t9,$t8
		sll $t9,$t9,2
		add $t9,$t9,$t0
			
		#load mem content
		lw $t9,0($t9)
		
		li $s5,1 #save 1 to be compared by mem content
		
		#if board[row][c] == 1 then jump to return false #else continue the sequence of Loop2_Row
		beq $t9,$s5,Return_False
		
		#c++
		addi $t8,$t8,1
		
		#if c<N then restart Loop2_Row
		slt $t9,$t8,$s0
		bne $t9,$zero, Loop2_Row

		
	##Loop3_D_Up##	
	move $s6,$a0 #r		#Initialize r and c from argument registers
	move $s7, $a1 #c
	
	Loop3_D_Up:
		#mem loc = SA + 4*(r*N + c)
		mul $t9,$s0,$s6
		add $t9,$t9,$s7
		sll $t9,$t9,2
		add $t9,$t9,$t0
		
		#load mem content
		lw $t9,0($t9)
		
		li $s5,1 #save 1 to be compared by mem content
		
		#if board[row][c] == 1 then jump to return false #else continue the sequence of Loop3_D_Up
		beq $t9,$s5,Return_False
		
		addi $s6,$s6,-1 #r--
		addi $s7,$s7,-1 #c--
				
		li $t9,-1 #save -1 to compare
		
		#if -1< r then restart Loop3_D_Up
		slt $t9,$t9,$s6
		bne $t9,$zero,Loop3_D_Up
		
		
	##Loop4_D_Down##
	move $s6,$a0 #r		#Initialize r and c from argument registers
	move $s7, $a1 #c
	
	Loop4_D_Down:
		#mem loc = SA + 4*(r*N + c)
		mul $t9,$s0,$s6
		add $t9,$t9,$s7
		sll $t9,$t9,2
		add $t9,$t9,$t0
		
		#load mem content
		lw $t9,0($t9)
		
		li $s5,1 #save 1 to be compared by mem content
		
		#if board[row][c] == 1 then jump to return false #else continue the sequence of Loop4_D_Down
		beq $t9,$s5,Return_False
		
		addi $s6,$s6,1 #r++
		addi $s7,$s7,-1 #c--
				
		#if r<N then restart Loop4_D_Down
		slt $t9,$s6,$s0
		bne $t9,$zero,Loop4_D_Down
	
	
	#if all loops have been ran without jumping to Return_False then return true
	li $v0,1
	jr $ra
	
	Return_False:
		li $v0,0
		jr $ra
#END OF IS_SAFE



## This to print the Queens position on board ##
## [1: present, 0: absent] ##
## [i,j: row and col number of board respectively] ##
##Regiters usage:
##		t8 - i [temp reg]
##		t9 - j [temp reg]
##		s7 - storing results [temp reg]
PrintBoard:
	li $t8,0	#i=0
	
	Loop1_i:
		li $t9,0	#j=0
		
		Loop2_j:
			#mem loc calculate for accessing 2D array board
			#mem loc = SA + 4*(i*N + j)
			mul $s7,$s0,$t8
			add $s7,$s7,$t9
			sll $s7,$s7,2
			add $s7,$s7,$t0
			
			#load mem content
			lw $s7,0($s7)
			
			#Print Array contents
			li $v0,1
			move $a0,$s7
			syscall
		
			#Tab
			li $v0,4  
			la $a0,tab
			syscall
			
			#j++
			addi $t9,$t9,1	
			
			#if j>=N then terminate loop1
			slt $s7,$t9,$s0	 
			bne $s7,$zero,Loop2_j
		
		#NewLine
		li $v0,4  
		la $a0,newline
		syscall
		syscall
			
		#i++	
		addi $t8,$t8,1	
			
		#if i>=N then terminate loop1
		slt $s7,$t8,$s0	 
		bne $s7,$zero,Loop1_i
		
	jr $ra
##END OF PRINTBOARD##