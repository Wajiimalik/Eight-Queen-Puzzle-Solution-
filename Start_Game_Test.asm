.data
greeting: .asciiz " \n TADA! xD   \nAll Queens Placed!"

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
	
	li $s0, 8 					 #  N=8
	li $s4, 0  			   	     #  col=0
	li $s2, 0				     # row = 0
	li $s1, 0					 # queens_Placed = 0
	li $t8, 1	                 # dummy value
	li $t9, 2					 # dummy value
	li $s5, 1					 # PlaceQueen = 1 (false)
	li $t6, 2                    #testing code
	li $t7, 2					 #testing code
	la $t0, board
##	$s6 r
##	$s7 c
##  $t1 - queens_RowNo [1D Array]
##	$t2 - queens_ColNo [1D Array]
##	$t3
	
	

loop1:
		beq $s1, $s0, next1        # if t1 == 8 we are done
		li $s2, 0 				   # row = 0
		
		addi $s1, $s1, 1		   #col = col + 1
			
		
        loop2:
			beq $s1, $s4, loop1				   #while (queens_Placed != col + 1)
			slt $t6, $t8, $t9
			
			bne $s5, $t6, next3	               #if (PlaceQueen(row, col) == false)
			addi $s1, $s1, -1                  #queens_Placed--;
			
			la $t1, queens_RowNo		       #queens_RowNo[queens_Placed] 
			sll $s1,$s1,2
			add $s1,$s1,$t1                                
			lw $s1, 0($s1)
			move  $s6,$s1
			
			
			
			la $t2, queens_ColNo               #queens_ColNo[queens_Placed]
			sll $s1,$s1,2
			add $s1,$s1,$t2
			lw $s1, 4($s1)
		    move $s7,$s1			
			
			
			
			
			#mem loc = SA + 4*(r*N + c)        #board[r][c] 
			mul $t3,$s0,$s6
			add $t3,$t3,$s7
			sll $t3,$t3,2
			add $t3,$t3,$t0
		
			#load mem content
			lw $t3,8($t3)
			add $t3,$t3,0           		  #board[r][c] = 0
			
			
			addi $s4, $s4, -1 				  #col--;
			addi $s6,$s6,1    				  #queens_RowNo[queens_Placed] + 1
			move $s2,$s6      				  #row = queens_RowNo[queens_Placed] + 1
			
			next3:
				li $s2,0
				j loop2
		
		
	addi $s4, $s4, 1                          # add 1 to s1
	j loop1
next1:
		li $v0,4				 
		la $a0,greeting
		syscall
		
		li $v0,10 			   	 #exit
		syscall