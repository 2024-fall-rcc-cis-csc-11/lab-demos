

;;;;;;;;;;;;;;
; Data Section
section .data


;;;
; System Calls
SYS_WRITE						equ		1


;;;
; File descriptors
FD_STDOUT						equ		1


;;;
; CStrings
WELCOME_MSG					db		"Hello, this is the whoops module!"
WELCOME_MSG_LEN				equ		$-WELCOME_MSG

PRINTF_MSG					db		"This is printed by printf!",13,10,0
PRINTF_MSG_LEN				equ		$-PRINTF_MSG

GOODBYE_MSG					db		"Assembly module is finished. Control will now be returned to the driver."
GOODBYE_MSG_LEN				equ		$-GOODBYE_MSG

CRLF						db		13,10   ; \r\n
CRLF_LEN					equ		$-CRLF


;;;;;;;;;;;;;;
; Text Section
section .text


; External symbols
extern printf


; Our hello function
global whoops
whoops:
	
	; Prologue
	push rax							; Stack alignment
	
	; Welcome message
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, WELCOME_MSG				; Pointer to first character of string to print
	mov rdx, WELCOME_MSG_LEN			; Length of the string to print
	syscall
	call crlf
	
	; Call on printf
	mov rdi, PRINTF_MSG
	call printf
	
	; Call on printf
	mov rdi, PRINTF_MSG
	call printf
	
	; Say goodbye
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, GOODBYE_MSG				; Pointer to first character of string to print
	mov rdx, GOODBYE_MSG_LEN			; Length of the string to print
	syscall
	call crlf
	
	; Epilogue
	pop rax								; Stack alignment
	
	; We're done
	ret									; Return control back to the caller (driver)


;;;
; Custom function to print a CRLF
crlf:
	
	; Print the CRLF!
	mov rax, SYS_WRITE	; System call code
	mov rdi, FD_STDOUT	; Print to stdout
	mov rsi, CRLF		; Pointer to first character of string to print
	mov rdx, CRLF_LEN	; Length of the string to print
	syscall
	
	ret





