

section .data

; For syscalls
SYS_WRITE	equ		1
FD_STDOUT	equ		1

; Strings
MSG			db		"Hello from third.asm",13,10
MSG_LEN		equ		$-MSG

section .text

global third
third:
	
	; Print the message
	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG
	mov rdx, MSG_LEN
	syscall
	
	ret
