

; Data section
section .data

; System calls
SYS_WRITE		equ		1

; FDs
FD_STDOUT		equ		1


; CStrings
WELCOME_MSG					db		"Hello, this is the hello module!"
WELCOME_MSG_LEN				equ		$-WELCOME_MSG

C_MSG						db		"Now calling on the C function ..."
C_MSG_LEN					equ		$-C_MSG

CPP_MSG						db		"Now calling the C++ function ..."
CPP_MSG_LEN					equ		$-CPP_MSG

GOODBYE_MSG					db		"Assembly module is finished. Control will now be returned to the driver."
GOODBYE_MSG_LEN				equ		$-GOODBYE_MSG

CRLF						db		13,10   ; \r\n
CRLF_LEN					equ		$-CRLF

;;;;;;;
; Text
section .text


; Externals
extern sea
extern the_cpp_function


;	Our hello function
global hello
hello:
	
	; Welcome message
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, WELCOME_MSG				; Pointer to first character of string to print
	mov rdx, WELCOME_MSG_LEN			; Length of the string to print
	syscall
	call crlf
	
	; C Message
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, C_MSG						; Pointer to first character of string to print
	mov rdx, C_MSG_LEN					; Length of the string to print
	syscall
	call crlf
	call sea
	
	; C++ Message
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, CPP_MSG					; Pointer to first character of string to print
	mov rdx, CPP_MSG_LEN				; Length of the string to print
	syscall
	call crlf
	call the_cpp_function
	
	; Say goodbye
	mov rax, SYS_WRITE					; System call code
	mov rdi, FD_STDOUT					; Print to stdout
	mov rsi, GOODBYE_MSG				; Pointer to first character of string to print
	mov rdx, GOODBYE_MSG_LEN			; Length of the string to print
	syscall
	call crlf
	
	;	We're done
	ret


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

















