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
## Arrays description:
##		board - tells the final position on queens [1: present, 0:absent]
##		queens_RowNo -  
##		queens_ColNo -


.data
newline: .asciiz "\n"
tab: .asciiz "\t"

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


.text

main:


	#exit code
	li $v0,10
	syscall
#End Of Main


StartGame:
#end of StartGame

PlaceQueen:
#end of PlaceQueen

Is_Safe:
#end of Is_Safe

PrintBoard:
#End Of PrintBoard