## Sheema Masood (CS-012) 
## Wajiha Muzaffar Ali (CS-013)
## Aleesha Kanwal (CS-017)
## Date:  --/--/2015
## Eight_Queen_Puzzle.asm 
## Description of Project:
## 		8 Queen Puzzle is the problem of placing 8 queens on an 8x8 chess board [N queens on NxN board; N=8]
## 		so that no queens can attack each other.
## 		Thus, it is necessary that no queens share same row, column and diagonal.

## main --

## Register usage:
##		$s0 - N
##		$s1 - queens_Placed
##		$t0 - board [2D Array]
##		$t1 - queens_RowNo [1D Array]
##		$t2 - queens_ColNo [1D Array]
##
## Arrays description:
##		board - tells the final position on queens [1: present, 0:absent]
##		queens_RowNo -  
##		queens_ColNo -


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

main:
	li $s0, 8 #N=8
	li $s1,0 #queens_Placed=0
	la $t0, board #$t0=address of board
	
	jal PrintBoard #Method call
	
	#print greeting ^^
	li $v0,4
	la $a0,greeting
	syscall
	
	#exit
	li $v0,10
	syscall
#END OF MAIN 

StartGame:
#END OF STARTGAME

PlaceQueen:	
	move $s4,$a0 #r 	#saving arguments 
	move $s5, $a1 #col	
	
	move $s6, $ra #store return address
	
	li $s7, 1 #store '1' for comparison
	
	move $t8,$s4 #row=r	
	##Loop1##
	
	Loop1:
		move $a0,$t8
		move $a1,$s5	
		jal Is_Safe
	
		bne $v0, $s7, JUMP_IF_FALSE #if return num is not = 1 terminate sequencial execution
		
		#queens_RowNo[queens_Placed] = row		
		la $t1, queens_RowNo  #$t1=queens_rowno
		muli $t9,$s1,4 	#4(i)
		add $t9,$t1,$t9  #SA + 4(i)

		sw $t8,0($t9) 
		
		
		#queens_ColNo[queens_Placed] = col;	
		la $t2,queens_ColNo #$t2=queens_colno
		muli $t9,$s1,4 	#4(i)
		add $t9,$t2,$t9  #SA + 4(i)
		
		sw $s5,0($t9) 	
		
		addi $s1,$s1,1 #queens_Placed++
			
		#board[row][col] = 1; //1 for queen 

		#mem loc = SA + 4*(row*N + col)
		mul $t9,$t8,$s0			
		add $t9,$t9,$s5
		sll $t9,$t9,2
		add $t9,$t9,$t0 
			
		sw $s7,0($t9) #store 1 

		li $v0,1
		jr $ra

		JUMP_IF_FALSE:
			#row++
			addi $t8,$t8,1
			slt $t9,$t8,$s0  #if row<N then restart Loop1
			bne $t9,$zero,Loop1
		
	#if all loops have been ran without jumping to Return_True then return false
	li $v0,0
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