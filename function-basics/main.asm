

; Begin data section
section		.data


; Syscall Codes
SYS_WRITE						equ	1
SYS_EXIT						equ 60


; Exit codes
EXIT_SUCCESS					equ	0
EXIT_GIMME						equ	0


; File descriptors
FD_STDIN						equ 0
FD_STDOUT						equ	1


; Strings
HELLO_STRING					db	"Hello, my name is Gibsen Montgomery Gibson."
HELLO_STRING_LEN				equ	$-HELLO_STRING

MSG_1							db	"This is message #1"
MSG_1_LEN						equ	$-MSG_1

MSG_2							db	"This is message #2"
MSG_2_LEN						equ	$-MSG_2

MSG_3							db	"This is message #3"
MSG_3_LEN						equ	$-MSG_3

CRLF							db	13,10
CRLF_LEN						equ	$-CRLF



; Begin text section
section .text


; Begin entry point
;
; Register usage:
;	r12: Hold return value for the syscall to exit
global _start
_start:
	
	call say_hello
	
	; Print the first message
	mov rdi, MSG_1
	mov rsi, MSG_1_LEN
	call print_line
	
	; Print the second message
	mov rdi, MSG_2
	mov rsi, MSG_2_LEN
	call print_line
	
	; Print the third message
	mov rdi, MSG_3
	mov rsi, MSG_3_LEN
	call print_line
	
	; Get our return from gimme_long
	call gimme_long
	mov r12, rax
	
	; Setup the return value and call the exit syscall
	mov rax, SYS_EXIT
	mov rdi, r12
	syscall


; Function that just returns a simple long value
; long gimme_long();
gimme_long:
	
	mov rax, EXIT_GIMME
	
	ret


; Function that says hello
; void say_hello();
say_hello:
	
	; Load up argument registers and call print_something
	mov rdi, HELLO_STRING
	mov rsi, HELLO_STRING_LEN
	call print_line
	
	ret

; Prints a carriage return + newline (aka CRLF)
; void crlf();
crlf:
	
	; Setup the syscall
	mov rax, SYS_WRITE				; syscall to write
	mov rdi, FD_STDOUT				; Write to stdout
	mov rsi, CRLF					; The string to write
	mov rdx, CRLF_LEN					; The string length
	syscall
	
	ret


; Print a message given by a pointer to a cstring and integer length
; After, prints a CRLF
; void print_line(char * pChar, long size)
; 
; Register usage:
;	r12: Pointer to cstring
;	r13: Size of the string
print_line:
	
	; Prologue
	push r12
	push r13
	
	; Store incoming arguments
	mov r12, rdi				; Save the pChar (cstring char pointer)
	mov r13, rsi				; Save the size of the cstring
	
	; Setup the syscall
	mov rax, SYS_WRITE				; syscall to write
	mov rdi, FD_STDOUT				; Write to stdout
	mov rsi, r12					; The string to write
	mov rdx, r13					; The string length
	syscall
	
	; Print a newline
	call crlf
	
	; Epilogue
	pop r13
	pop r12
	
	ret








