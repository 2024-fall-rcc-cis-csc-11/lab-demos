
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	Assembly w Professor Peralta


;;;;;;;;;;;;;;;;;;;;
; Begin data section
section		.data


; String stuff
WELCOME_STRING					db	"Welcome to the libP simple demo, fondly brought to you by Mike Peralta.",13,10
WELCOME_STRING_LEN				equ	$-WELCOME_STRING

PROMPT_STRING					db	"Please enter an integer: "
PROMPT_STRING_LEN				equ	$-PROMPT_STRING

PROMPT_ECHOBACK_STRING_1		db	"The number "
PROMPT_ECHOBACK_STRING_1_LEN	equ	$-PROMPT_ECHOBACK_STRING_1
PROMPT_ECHOBACK_STRING_2		db	" was received.",13,10
PROMPT_ECHOBACK_STRING_2_LEN	equ	$-PROMPT_ECHOBACK_STRING_2

; 
SYS_WRITE						equ	1
FD_STDOUT						equ	1
EXIT_SUCCESS					equ	0

; Begin text section
section .text


; External symbols
extern libPuhfessorP_inputSignedInteger64
extern libPuhfessorP_printSignedInteger64


; Begin demo function
global demo
demo:
	
	; Prologue
	push r12
	
	; Welcome the user
	call welcome
	
	; Ask for input
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, PROMPT_STRING
	mov rdx, PROMPT_STRING_LEN
	syscall
	
	; Read using libP
	call libPuhfessorP_inputSignedInteger64
	mov r12, rax
	
	; Echo it back to the user
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, PROMPT_ECHOBACK_STRING_1
	mov rdx, PROMPT_ECHOBACK_STRING_1_LEN
	syscall
	;
	mov rdi, r12
	call libPuhfessorP_printSignedInteger64
	;
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, PROMPT_ECHOBACK_STRING_2
	mov rdx, PROMPT_ECHOBACK_STRING_2_LEN
	syscall
	
	; Epilogue
	pop r12
	
	ret

; Welcome function
welcome:
	
	; Just say hello, basically
	mov rax, SYS_WRITE
	mov rsi, WELCOME_STRING
	mov rdi, FD_STDOUT
	mov rdx, WELCOME_STRING_LEN
	syscall
	
	ret





