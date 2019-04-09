TITLE Program #2     (Program2.asm)

; Author: Christian Roccanova
; email: roccanoc@oregonstate.edu
; Course / Project ID:      CS271-400/ Program #2         Date: 7/14/2017
; Assignment Due: 7/16/2017
; Description: Create a program that takes takes and validates user input and calculates a set of Fibonacci numbers based on that input.  


INCLUDE Irvine32.inc

; (insert constant definitions here)

lowBound	equ 1	;lowest input boundary
highBound	equ 46	;highest input boundary


.data

; (insert variable definitions here)

numInput	DWORD	?	;number of Fibonacci numbers to be generated
userName	DWORD	21	DUP(0)	;user's name
first		DWORD	?	;first number for sequence calculation
second		DWORD	?	;second number for sequence calculation
modulo		DWORD	?	;modulo
intro_1		BYTE	"Welcome to Program 2, my name is Christian Roccanova.", 0
instruct_1	BYTE	"This program will ask you for your name and how many Fibonacci numbers you would like to generate.", 0
instruct_2	BYTE	"Enter your name as text and enter the number as an integer between 1 and 46, in numerical format.", 0
prompt_1	BYTE	"Please enter your name.", 0
prompt_2a	BYTE	"Thank you, ", 0
prompt_2b	BYTE	"How many Fibonacci numbers would you like to generate?", 0
display		BYTE	"Your sequence is:", 0
space		BYTE	"     ", 0
fibNum		DWORD	?
count		DWORD	?	;increasing loop counter
decCount	DWORD	?	;decreasing loop counter
goodbye		BYTE	"Goodbye, ", 0
lowError	BYTE	"Error: Number must be 1 or higher.", 0
highError	BYTE	"Error: Number must be 46 or lower.", 0


.code
main PROC

; (insert executable instructions here)

;introduction

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
	
;getUserData

	;gets user's name
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	mov		ecx, 21
	mov		edx, OFFSET userName
	call	ReadString
	
	;gets number of numbers to generate
	mov		edx, OFFSET prompt_2a
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

ErrorJump:	
	mov		edx, OFFSET prompt_2b
	call	WriteString
	call	CrLf
	call	ReadDec
	mov		numInput, eax
	

	;validates integer input
	;jumps if lower than 1
	cmp		numInput, lowBound
	jl		LowErr

	;jumps if higher than 46
	cmp		numInput, highBound
	jg		HighErr
	
	jmp		PreLoop
	
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


;displayFibs

PreLoop:	
	;sets initial values for the loop
	xor		ecx, ecx
	mov		count, 1
	mov		ecx, numInput
	mov		first, 1
	mov		second, 1

		
L1:	
	mov		decCount, ecx
	;if first loop
	cmp		count, 1
	je		FirstLoop

	;if second loop
	cmp		count, 2
	je		SecondLoop

	;if later loop
	cmp		count, 2
	jg		OtherLoops

LoopBottom:
	
	inc		count
	mov		ecx, decCount
	loop	L1
	jmp		Farewell

FirstLoop:
	;outputs 1 if it is the first loop
	mov		eax, first
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	jmp		LoopBottom

SecondLoop:
	;outputs 1 if it is the second loop
	mov		eax, second
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	jmp		LoopBottom

OtherLoops:
	;calculates and outputs further Fibonacci numbers
	mov		eax, first
	add		eax, second
	mov		fibNum, eax
	call	WriteDec
	mov		edx, OFFSET space
	call	WriteString
	
	;advances values for the next calculation
	
	mov		eax, second
	mov		first, eax
	mov		eax, fibNum
	mov		second, eax
	jmp		AdvanceCheck

AdvanceCheck:
	;checks if this is the fifth term in a line
	mov		eax, count
	xor		edx, edx
	mov		modulo, 5
	div		modulo
	cmp		edx, 0
	je		Advance
	jmp		LoopBottom

Advance:
	;advances to the next line
	call	CrLf
	jmp		LoopBottom


Farewell:
;goodbye

	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)


END main
