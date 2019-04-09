TITLE Program #3     (Program2.asm)

; Author: Christian Roccanova
; email: roccanoc@oregonstate.edu
; Course / Project ID:      CS271-400/ Program #4         Date: 8/2/2017
; Assignment Due: 8/6/2017
; Description: Create a program that takes and validates user input and generates an array of random numbers based on that input.  It then returns the median number and sorts the array.



INCLUDE Irvine32.inc

; (insert constant definitions here)

lowBound	=	10	;lowest input boundary
highBound	=	200	;highest input boundary
min			=	100	;lowest random number
max			=	999	;highest random number

.data

; (insert variable definitions here)

request		DWORD	?	;number of composite numbers to be generated
array		DWORD	highBound DUP(?)	;array for random numbers
modulo		DWORD	?	;modulo
intro_1		BYTE	"Welcome to Program 4, my name is Christian Roccanova.", 0
instruct_1	BYTE	"This program will ask you how many random numbers you would like to generate, give you the median and then sort them for you.", 0
instruct_2	BYTE	"Enter the number as an integer between 10 and 200, in numerical format.", 0
prompt_1	BYTE	"How many random numbers would you like to generate?", 0
unsorted	BYTE	"The unsorted array is:", 0
sorted		BYTE	"The sorted array is:", 0
space		BYTE	"     ", 0
medDisplay	BYTE	"The median is: ", 0
goodbye		BYTE	"Goodbye", 0
lowError	BYTE	"Error: Number must be 10 or higher, please try again.", 0
highError	BYTE	"Error: Number must be 200 or lower, please try again.", 0


.code
main PROC

; (insert executable instructions here)

;seeds random number generator
	call	Randomize

;introduction
	call	introduction
	
	
;getUserData
	push	OFFSET request
	call	getUserData
		
;fills the array with random numbers
	push	OFFSET	array
	push	request
	call	fillArray

;displays the unsorted array
	mov		edx, OFFSET unsorted
	call	WriteString
	call	CrLf
	push	OFFSET	array
	push	request
	call	displayList


;sorts the array
	push	OFFSET	array
	push	request
	call	sortList

;determines and displays the median value
	push	OFFSET	array
	push	request
	call	displayMedian

;displays the sorted array
	mov		edx, OFFSET sorted
	call	WriteString
	call	CrLf
	push	OFFSET	array
	push	request
	call	displayList

;goodbye
	call	farewell

	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;*********************
;prints intro
;*********************

introduction	PROC

	mov		edx, OFFSET	intro_1
	call	WriteString
	call	CrLf

;userInstructions

	mov		edx, OFFSET instruct_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct_2
	call	WriteString
	call	CrLf
	

ret
introduction	ENDP

;*************************************************
;asks for number of composite numbers to generate
;*************************************************

getUserData		PROC

	push	ebp
	mov		ebp, esp
	mov		ebx, [ebp+8]

;gets number of numbers to generate
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	call	validate		
	
	pop		ebp
	

ret 4
getUserData		ENDP

;********************************
;takes and validates user input
;********************************

validate		PROC


ErrorJump:	
	
	call	ReadDec
	mov		[ebx], eax
	
	;validates integer input
	;jumps if lower than 10
	cmp		eax, lowBound
	jl		LowErr

	;jumps if higher than 200
	cmp		eax, highBound
	jg		HighErr
	
	jmp		valid
	
	;error messages

LowErr:
	;number too low
	mov		edx, OFFSET lowError
	call	WriteString
	call	CrLf
	jmp		ErrorJump

HighErr:
	;number too high
	mov		edx, OFFSET highError
	call	WriteString
	call	CrLf
	jmp		ErrorJump

valid:
	
	
ret	
validate		ENDP

;****************************
;places values into the array
;****************************
fillArray	PROC

	;sets up loop
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 12]
	mov		ecx, [ebp + 8]
	

	;loops through array, filling it with random values
	;code as seen in lecture 20
	fill:
		mov		eax, max
		sub		eax, min
		inc		eax
		call	RandomRange		;generates random number
		add		eax, min		;places random number in the appropriate range
		mov		[esi], eax
		add		esi, 4			;advances to next element
		loop	fill
		pop		ebp

ret 8
fillArray	ENDP

;****************************
;calculates and prints median
;****************************
displayMedian	PROC

	;sets up loop, counter is set to half of request
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		edx, 0	
	mov		ebx, 2
	mov		eax, [ebp+8]
	div		ebx
	mov		ecx, eax

	;advances array to the location of the median
	moveToMedian:
		add		esi, 4
		loop	moveToMedian

	;determines if the number of elements is odd or even
	cmp		edx, 0
	je		evenCount

	;odd number of elements - median is simply the middle value
	mov		edx, OFFSET medDisplay
	call	WriteString
	mov		eax, [esi]
	call	WriteDec
	call	CrLf
	jmp		medianEnd

	;even number of elements - median is the average of the two middle values
	evenCount:
		mov		eax, [esi]
		add		eax, [esi-4]
		mov		edx, 0
		div		ebx
		mov		edx, OFFSET medDisplay
		call	WriteString
		call	WriteDec
		call	CrLf

medianEnd:
	call	CrLf
	pop ebp

ret 8
displayMedian	ENDP

									
;**************
;prints array
;**************
displayList	PROC

;sets up for loop
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		ecx, [ebp+8]	;loop counter for printing
	
	mov		ebx, 0			;counter for advancement to the next line

;prints numbers in the array
printLoop:
	mov		eax, [esi]
	call	WriteDec
	inc		ebx
	mov		edx, OFFSET space
	call	WriteString
	jmp		AdvanceCheck

AdvanceCheck:
	;checks if this is the tenth term in a line
	mov		eax, ebx
	xor		edx, edx
	mov		modulo, 10
	div		modulo
	cmp		edx, 0
	je		Advance
	jmp		printEnd

Advance:
	;advances to the next line
	call	CrLf
	jmp		printEnd

printEnd:
	add		esi, 4
	loop	printLoop
	call	CrLf
	call	CrLf
	pop		ebp

ret	8
displayList		ENDP


;******************
;Sorts the array
;******************
sortList	PROC

	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+12]
	mov		ecx, [ebp+8]
	dec		ecx

	L1:
		push	ecx			;stores counter
		mov		edx, esi
		mov		eax, [esi]		

		L2:
			mov		eax, [edx]
			mov		ebx, [esi+4]

			;compares current and next element, skips swapping if the next element is smaller
			cmp		ebx, eax
			jl		nextSwap

			;performs swap if the next element is larger
			add		esi, 4
			push	esi			
			push	edx
			push	ecx
			call	exchange		;performs swap
			
			jmp		nextLoop

			nextSwap:
				add		esi, 4

			nextLoop:
				loop	L2
		
		;restores outer loop (L1)
		pop		ecx
		mov		esi, edx

		add		esi, 4
		loop	L1

		pop		ebp
	

ret 8
sortList	ENDP

;**********************************
;Swaps the position of elements
;**********************************
exchange	PROC

	push	ebp
	mov		ebp, esp
	pushad
	mov		eax, [ebp+16]
	mov		ebx, [ebp+12]

	;determines distance between elements
	mov		edx, eax
	sub		edx, ebx

	;rearranges values in the array
	mov		esi, ebx	
	mov		ecx, [ebx]	
	mov		eax, [eax]
	mov		[esi], eax
	add		esi, edx
	mov		[esi], ecx

	popad
	pop		ebp


ret 12
exchange	ENDP

;*************************
;prints farewell message
;*************************

farewell		PROC

	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

ret
farewell		ENDP

END main
