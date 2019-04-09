TITLE Program #3     (Program2.asm)

; Author: Christian Roccanova
; email: roccanoc@oregonstate.edu
; Course / Project ID:      CS271-400/ Program #3         Date: 7/26/2017
; Assignment Due: 7/30/2017
; Description: Create a program that takes takes and validates user input and calculates a set of composite number based on that input using procedures and nested loops.
; Extra Credit Description: Aligns printed number columns


INCLUDE Irvine32.inc

; (insert constant definitions here)

lowBound	equ 1	;lowest input boundary
highBound	equ 400	;highest input boundary


.data

; (insert variable definitions here)

numInput	DWORD	?	;number of composite numbers to be generated
userName	DWORD	21	DUP(0)	;user's name
first		DWORD	?	;first number for sequence calculation
second		DWORD	?	;second number for sequence calculation
modulo		DWORD	?	;modulo
intro_1		BYTE	"Welcome to Program 3, my name is Christian Roccanova.", 0
instruct_1	BYTE	"This program will ask you how many composite numbers you would like to generate.", 0
instruct_2	BYTE	"Enter the number as an integer between 1 and 400, in numerical format.", 0
ECprompt	BYTE	"EC: This program will align the printed numbers.", 0
prompt_1	BYTE	"How many composite numbers would you like to generate?", 0
display		BYTE	"Your sequence is:", 0
space_7		BYTE	"       ", 0
space_6		BYTE	"      ", 0
space_5		BYTE	"     ", 0
space_4		BYTE	"    ", 0
compNum		DWORD	3	;number to be tested, increases with each cycle
divNum		DWORD	?	;number used to check if a number composite
count		DWORD	?	;increasing loop counter
decCount	DWORD	?	;decreasing loop counter
goodbye		BYTE	"Goodbye, ", 0
lowError	BYTE	"Error: Number must be 1 or higher, please try again.", 0
highError	BYTE	"Error: Number must be 400 or lower, please try again.", 0


.code
main PROC

; (insert executable instructions here)

;introduction
	call	introduction
	
	
;getUserData
	call	getUserData
	


;displays and generates composite numbers
	call	showComposites


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
	mov		edx, OFFSET ECprompt
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

;gets number of numbers to generate
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf
	call	validate
		

	

ret
getUserData		ENDP

;********************************
;takes and validates user input
;********************************

validate		PROC

ErrorJump:	
	
	call	ReadDec
	mov		numInput, eax
	
	;validates integer input
	;jumps if lower than 1
	cmp		numInput, lowBound
	jl		LowErr

	;jumps if higher than 46
	cmp		numInput, highBound
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



;***************************************
;generates and prints composite numbers
;***************************************
showComposites	PROC

;PreLoop: sets initial values for the loop
	xor		ecx, ecx
	mov		count, 0
	mov		ecx, numInput




		
L1:	
	mov		decCount, ecx
	
LoopBottom:
	
	call	isComposite
	mov		ecx, decCount
	dec		decCount
	loop	L1
	
ret
showComposites	ENDP


									
;*************************
;prints composite numbers
;*************************
printNum	PROC
	mov		eax, compNum
	call	WriteDec
	inc		count

;determines how many spaces need to be printed to align columns
	cmp		compNum, 10
	jl		less10
	jge		great10

;aligns columns
less10:	
	mov		edx, OFFSET space_7
	call	WriteString
	jmp		AdvanceCheck

great10:
	cmp		compNum, 100
	jge		great100
	mov		edx, OFFSET space_6
	call	WriteString
	jmp		AdvanceCheck
	
great100:
	cmp		compNum, 1000
	jge		great1000
	mov		edx, OFFSET space_5
	call	WriteString
	jmp		AdvanceCheck

great1000:
	mov		edx, OFFSET space_4
	call	WriteString
	jmp		AdvanceCheck

	;advances values for the next calculation
	
	jmp		AdvanceCheck

AdvanceCheck:
	;checks if this is the tenth term in a line
	mov		eax, count
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
ret
printNum		ENDP




;****************************
;;calculates and outputs composite numbers
;****************************
isComposite		PROC
	
;isComposite
;generates composite number
genLoop:
	inc		compNum
	mov		divNum, 2
	mov		ecx, compNum
								
	
compLoop:								
	mov		eax, compNum
	mov		edx, 0
	div		divNum
	cmp		edx, 0
	je		comp
	inc		divNum		
	mov		eax, divNum
	cmp		eax, compNum
	je		genLoop
	loop	compLoop
	jmp		genLoop
	
	;prints if composite
comp:
	call	printNum

ret
isComposite		ENDP

;*************************
;prints farewell message
;*************************

farewell		PROC

	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

ret
farewell		ENDP

END main
