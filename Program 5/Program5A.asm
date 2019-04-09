TITLE Program #5A     (Program5A.asm)

; Author: Christian Roccanova
; email: roccanoc@oregonstate.edu
; Course / Project ID:      CS271-400/ Program #5A         Date: 8/10/2017
; Assignment Due: 8/13/2017
; Description: Create a program that takes takes and validates user input of 10 integers as a string.  Converts them to integers and prints the list, its sum and its average. 


INCLUDE Irvine32.inc

; (insert constant definitions here)


intCount = 10	;number of integers the program will take from the user
inputMax = 20


;*******************************
; Macro - gets string from user
;*******************************

getString	MACRO	stringPrompt, buff, strLength
	push	edx
	push	ecx
	mov		edx, stringPrompt
	call	WriteString
	call	CrLf
	mov		edx, buff
	mov		ecx, strlength
	call	ReadString
	pop		ecx
	pop		edx

ENDM

;*******************************
; Macro - displays user string
;*******************************

displayString	MACRO	userString
	push	edx
	mov		edx, userString
	call	WriteString
	;call	CrLf
	pop		edx

ENDM


.data

; (insert variable definitions here)


intro		BYTE	"Welcome to Program 5A, my name is Christian Roccanova.", 0
instruct_1	BYTE	"This program will ask you for 10 integers, one at a time. It will then display these integers, their sum and their average.", 0
prompt		BYTE	"Please enter an integer.", 0
intList		BYTE	"Your numbers are: ", 0
displaySum	BYTE	"Your sum is: ", 0
displayAvg	BYTE	"Your average is: ", 0
space		BYTE	"     ", 0
goodbye		BYTE	"Goodbye", 0
error_1		BYTE	"Error: Input was not a number or was too large.", 0
error_2		BYTE	"Please try again with a different input.", 0
errorHere	BYTE	"error after this", 0
array		DWORD	10	DUP(?)


.code
main PROC

; (insert executable instructions here)

;introduction
	
	push	OFFSET intro
	push	OFFSET instruct_1	
	call	introduction
	
	
;get user input
	push	OFFSET array
	push	intCount
	push	OFFSET prompt
	push	OFFSET error_2
	push	OFFSET error_1
	call	GetUserData


;displays the unsorted array
	push	OFFSET array
	push	intCount
	push	OFFSET intList
	push	OFFSET space
	call	displayList



;determines and displays the median value
	push	OFFSET array
	push	intCount
	push	OFFSET displaySum
	push	OFFSET displayAvg
	call	sumAverage
	

;goodbye
	push	OFFSET goodbye
	call	farewell

	
exit	
main ENDP

; (insert additional procedures here)

;*********************
;prints intro
;*********************

introduction	PROC

	push	ebp
	mov		ebp, esp

;print intro
	mov		edx, [ebp+12]
	displayString	edx
	call	CrLf

;print instructions
	mov		edx, [ebp+8]
	displayString	edx
	pop		ebp	

ret 8
introduction	ENDP

;*************************************************
;asks for number of composite numbers to generate
;*************************************************

getUserData		PROC

	call	CrLf
	push	esi
	push	ecx
	push	eax
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+36]
	mov		ecx, [ebp+32]

;cycles until 10 values are input

	fillLoop:
		mov		eax, [ebp+28]
		push	eax
		push	[ebp+24]
		push	[ebp+20]
		call	readVal
		call	CrLf
		pop		[esi]
		add		esi, 4
		loop	fillLoop
				
	pop		eax
	pop		ecx
	pop		esi
	pop		ebp
	

ret 20
getUserData		ENDP

;********************************
;takes user input
;********************************

readVal		PROC

LOCAL	userNum[20]:BYTE 
LOCAL	isValid:DWORD

	push	eax
	push	ebx
	push	esi
	push	ecx
	mov		eax, [ebp+16]
	lea		ebx, userNum
	
	readLoop:

		getString	eax, ebx, inputMax
		mov		ebx, [ebp + 8]		
		push	ebx
		lea		eax, isValid
		push	eax
		lea		eax, userNum
		push	eax
		push	20

		;calls validate before progressing to ensure input is an integer
		call	validate
		pop		edx
		mov		[ebp + 16], edx
		mov		eax, isValid
		cmp		eax, 0
		mov		eax, [ebp + 12]
		lea		ebx, userNum
		je		readLoop

		
		pop		ecx
		pop		esi
		pop		ebx
		pop		eax

ret 8
readVal		ENDP

;********************************
;validates user input
;********************************

validate		PROC

LOCAL	tooBig:DWORD

	;set counter and index
		mov		esi, [ebp + 12]
		mov		ecx, [ebp + 8]
		cld		

	; verify that characters are digits
	loadLoop:
		lodsb
		cmp		al, 0
		jz		isNull
		cmp		al, 48	;ASCII '0'
		jl		notValid
		cmp		al, 57	;ASCII '9'
		jg		notValid
		loop	loadLoop
		
	
	; converts to integer, then checks if integer is too large for register
	isNull:
		mov		edx, [ebp + 8]	
		cmp		ecx, edx	
		je		notValid			;null entered
		lea		eax, tooBig
		mov		edx, 0
		mov		[eax], edx
		push	[ebp + 12]
		push	[ebp + 8]
		lea		edx, tooBig
		push	edx
		call	convertToNum
		mov		edx, tooBig
		cmp		edx, 0
		jg		notValid
		mov		edx, [ebp + 16]
		mov		eax, 1				;isValid is true
		mov		[edx], eax
		jmp		ValidateEnd

		;prints error message
	notValid:
		mov		edx, [ebp + 20]	
		displayString	edx
		call	Crlf
		mov		edx, [ebp + 16]		;isValid is false
		mov		eax, 0
		mov		[edx], eax
		

	ValidateEnd:
		pop		edx
		mov		[ebp + 20], edx
	
ret	12
validate		ENDP


;*************************
;Displays list of numbers
;*************************
displayList	PROC
	
		push	esi
		push	ebx
		push	ecx
		push	edx
		push	ebp
		mov		ebp, esp

	;prints display message
		call	Crlf
		mov		edx, [ebp + 28]
		displayString	edx
		call	Crlf
		mov		esi, [ebp + 36]
		mov		ecx, [ebp + 32]
		mov		ebx, 1

	;prints numbers from array
	printNum:
		push	[esi]
		call	WriteVal
		add		esi, 4
		cmp		ebx, [ebp + 32]
		mov		edx, [ebp + 24]
		displayString	edx
		inc		ebx
		loop	printNum

		
		pop		edx
		pop		ecx
		pop		ebx
		pop		esi
		pop		ebp
		call	Crlf

ret	16
displayList	ENDP


;*************************
;writes integer as a string
;*************************
writeVal		PROC

LOCAL	newString[20]:BYTE

		push	eax

		;converts to string
		lea		eax, newString
		push	eax
		push	[ebp + 8]
		call	convertToString

		;prints newly converted string
		lea		eax, newString
		displayString	eax
		pop		eax

ret 4
writeVal		ENDP


;*******************************************
;Calculate and prints sum and mean of array
;*******************************************
sumAverage		PROC	
	
		push	esi
		push	edx
		push	ecx
		push	eax
		push	ebx
		push	ebp
		mov		ebp, esp

		;prints sum message
		mov		edx, [ebp + 32]			
		displayString	edx
		mov		esi, [ebp + 40]		
		mov		ecx, [ebp + 36]		
		xor		eax, eax	
	
	; calculates sum
	sumLoop:
		add		eax, [esi]
		add		esi, 4
		loop	sumLoop
	
	; prints sum
		push	eax
		call	writeVal
		call	Crlf

	; calculates mean
		mov		edx, [ebp + 28]		
		displayString	edx
		cdq
		mov		ebx, [ebp + 36]		
		div		ebx

	; prints mean
		push	eax
		call	writeVal
		call	Crlf
				
		pop		ebx
		pop		eax
		pop		ecx
		pop		edx
		pop		esi	
		pop		ebp

ret	16
sumAverage		ENDP

;*************************
;Converts string to number
;*************************
convertToNum	PROC
	LOCAL	newNum:DWORD

		push	esi
		push	ecx
		push	eax
		push	ebx
		push	edx

		
		mov	esi, [ebp + 16]
		mov	ecx, [ebp + 12]
		lea	eax, newNum
		xor	ebx, ebx
		mov	[eax], ebx
		xor	eax, eax			
		cld

	; loads string bytes
	loadNum:
		lodsb
		cmp		eax, 0
		jz		loadDone
		sub		eax, 48
		mov		ebx, eax
		mov		eax, newNum
		mov		edx, 10
		mul		edx
		jc		carry	
		add		eax, ebx
		jc		carry	
		mov		newNum, eax	
		mov		eax, 0		
		loop	loadNum

	;moves number to the stack and jumps to end
	loadDone:
		mov	eax, newNum
		mov	[ebp + 16], eax
		jmp	endConvertToNum

	; determines if number is too big for register
	carry:
		mov	ebx, [ebp + 8]	
		mov	eax, 1		
		mov	[ebx], eax
		mov	eax, 0
		mov	[ebp + 16], eax	

	endConvertToNum:
		pop		ebx
		pop		eax
		pop		ecx
		pop		esi
		pop		edx

		
ret 8
convertToNum	ENDP


;***************************
;Converts numbers to string
;***************************
convertToString		PROC
	LOCAL	newString:DWORD

		push	eax
		push	ebx
		push	ecx
				
		mov		eax, [ebp + 8]
		mov		ebx, 10
		mov		ecx, 0
		cld

	; push digits on the stack and count them
	divLoop:
		cdq
		inc		ecx
		div		ebx
		push	edx		;last digit		
		cmp		eax, 0
		jg		divLoop

		mov	edi, [ebp + 12]

	saveStr:
		pop		newString
		mov		al, BYTE PTR newString
		add		al, 48
		stosb
		loop	saveStr

		mov	al, 0
		stosb

		pop		ecx
		pop		ebx
		pop		eax

ret 8
convertToString		ENDP

;*************************
;prints farewell message
;*************************
farewell		PROC

		push	ebp
		mov		ebp, esp
				
		mov		edx, [ebp + 8]
		displayString	edx
		call	CrLf
		
	pop	ebp

ret	4
farewell		ENDP

END main