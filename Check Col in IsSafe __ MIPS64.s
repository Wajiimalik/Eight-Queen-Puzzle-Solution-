; Sheema Masood (CS-012) 
; Wajiha Muzaffar Ali (CS-013)
; Aleesha Kanwal (CS-017)
; Date:  06/04/2015
; Check Col in IsSafe __ MIPS64.s
; Description:
; 		- Module from project Eight_Queen_Puzzle.asm > Is_safe > Loop1_col
; 		- This module actually checks if there is any '1'(queen) in the specific col or not
;		- so col is fixed and row is from 0 to 7 (N = 8)
;		- we assumed tha start address of 2d array and calculated other references of mem loc wrt to that
; Registers Usage and Values:
;		- r10 : N = 8
;		- r1 : r (to run loop) = 0 (initially)
;		- r2 : col (fixed) = 1 
;		- r3 : StartAdress of array in memory = 8
;		- r6 : 1 (for comparison only)


; Addresses found N=8, r=(0-7), col=1, SA=8 are:
;	  Address = SA + 8(r * N + col);
; 		 16 = 0x10 ; 
;		 80 = ox50 ;
;		 144 = 0x90 ;
; 		 208 = 0xD0 ;
;		 272 = 0x110 ;
;		 336 = 0x150 ;
;		 400 = 0x190 ;
;		 464 = 0x1D0 ; 
 
.text
main:
	LOOP:
		; address calculation
		dmul r5,r10,r1
		dadd r5,r5,r2
		dsll r5,r5,3
		dadd r5,r5,r3
		
		; load from mem and check if it is 1 return 0(false)
		ld r5,0(r5)
		beq r5,r6,RETURN_FALSE
		
		; run loop (increment r and check if r<N then restart loop)
		daddi r1,r1,1
		slt r4,r1,r10
		bne r4,r0,LOOP
		
	#return true and exit
	daddi r12,r0,1
	j EXIT
		
	RETURN_FALSE:
		dadd r12,r0,r0
		
	EXIT:		
halt