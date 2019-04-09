TITLE Program #1     (Program1.asm)

; Author: Christian Roccanova
; email: roccanoc@oregonstate.edu
; Course / Project ID:      CS271-400/ Program #1         Date: 7/9/2017
; Assignment Due: 7/9/2017
; Description: Create a program that takes 2 numbers from the user and then calculates and prints their sum, difference, product and quotient.  
; For extra credit, program continues until the user chooses to exit and also verifies that the first integer is larger than the second.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; (insert variable definitions here)

userVariable_1	DWORD	?	;first integer to be entered
userVariable_2	DWORD	?	;second integer to be entered
intro_1			BYTE	"Welcome to Program 1! My name is Christian Roccanova.", 0
intro_2			BYTE	"This program will ask you for 2 integers and will then determine their sum, difference, product and quotient.", 0
intro_3			BYTE	"*Note: The first integer MUST be larger than the second.", 0
prompt_1		BYTE	"Please enter the first integer. ", 0
prompt_2		BYTE	"Please enter the second integer. ", 0
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0
multiply		BYTE	" * ", 0
divide			BYTE	" / ", 0
equals			BYTE	" = ", 0
resultRemain	BYTE	" remainder: ", 0
goodBye			BYTE	"Goodbye!", 0
sum				DWORD	?
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?
ECprompt_1		BYTE	"Would you like to try again? Enter 1 for yes and 2 for no. ", 0
ECdescribe		BYTE	"**EC1: Program repeats until the user chooses to quit.", 0
ECdescribe_2	BYTE	"**EC2: Program verifies that the second integer is smaller than the first."
ErrorMessage	BYTE	"Error: Your second integer MUST be larger than your first."
choice			DWORD	?

.code
main PROC

;Extra Credit Descriptions
	mov		edx, OFFSET ECdescribe
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ECdescribe_2
	call	WriteString
	call	CrLf

;Introduce Programmer
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	CrLf
	call	CrLf

top:
;Get user input

	;first variable
	mov		edx, OFFSET	prompt_1
	call	WriteString
	call	ReadInt
	mov		userVariable_1, eax
	call	CrLf

	;second variable
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		userVariable_2, eax
	call	CrLf

;Compare user variables
	mov		eax, userVariable_1
	cmp		eax, uservariable_2
	JBE		ECerror

;Calculate sum/difference/product/quotient

	;Calculate sum
	mov		eax, userVariable_1
	add		eax, userVariable_2
	mov		sum, eax

	;Calculate difference
	mov		eax, userVariable_1
	sub		eax, userVariable_2
	mov		difference, eax

	;Calculate product
	mov		eax, userVariable_1
	mov		ebx, userVariable_2
	mul		ebx
	mov		product, eax

	;Calculate quotient
	mov		eax, userVariable_1
	cdq							
	mov		ebx, userVariable_2
	div		ebx
	mov		quotient, eax
	mov		remainder, edx


;report results
	
	;Display Sum
	mov		eax, userVariable_1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, userVariable_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

	;Display Difference
	mov		eax, userVariable_1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, userVariable_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

	;Display Product
	mov		eax, userVariable_1
	call	WriteDec
	mov		edx, OFFSET multiply
	call	WriteString
	mov		eax, userVariable_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

	;Display Quotient
	mov		eax, userVariable_1
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, userVariable_2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET resultRemain
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

ECerror:
;displays error message if second integer is larger than first
	mov		edx, OFFSET ErrorMessage
	call	WriteString
	call	CrLf

;ask user if they wish to continue
	mov		edx, OFFSET ECprompt_1
	call	WriteString
	call	ReadInt
	mov		choice, eax
	call	CrLf

;jump to beginning if choice = 1
	mov		eax, choice
	.IF		eax < 2
		mov		ecx, 1
		JMP		top
	.ENDIF

;say goodbye
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
