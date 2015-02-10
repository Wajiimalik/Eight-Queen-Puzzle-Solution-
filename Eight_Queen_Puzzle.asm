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
	
	jal PrintBoard #Methos call
	
	#print greeting ^^
	li $v0,4
	la $a0,greeting
	syscall
	
	#exit
	li $v0,10
	syscall
#end Of Main 

StartGame:
#end of StartGame

PlaceQueen:
#end of PlaceQueen

Is_Safe:
#end of Is_Safe


## This to print the Queens position on board ##
## [1: present, 0: absent] ##
## [i,j: row and col number of board respectively] ##
##Regiters usage:
##		t8 - i [temp reg]
##		t9 - j [temp reg]
##		s7 - storing results [temp reg]
PrintBoard:
	li $t8,0	#i=0
	
	Loop1:
		li $t9,0	#j=0
		
		Loop2:
			#mem loc calculate for accessing 2D array board
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
			bne $s7,$zero,Loop2
		
		#NewLine
		li $v0,4  
		la $a0,newline
		syscall
		syscall
			
		#i++	
		addi $t8,$t8,1	
			
		#if i>=N then terminate loop1
		slt $s7,$t8,$s0	 
		bne $s7,$zero,Loop1
		
	jr $ra
##end Of PrintBoard##