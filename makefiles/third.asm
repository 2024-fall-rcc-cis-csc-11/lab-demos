
section .data

SYS_WRITE	equ 1
FD_STDOUT	equ 1

MSG		db	"Hello from third.asm",13,10
MSG_LEN		equ	$-MSG

section .text

global third
third:

	mov rax, SYS_WRITE
	mov rdi, FD_STDOUT
	mov rsi, MSG
	mov rdx, MSG_LEN
	syscall

	ret


