
; This is a comment

section .data

MY_VARIABLE		dq		128761876

section .bss

MY_ARRAY		resq	100000

section .text


extern my_other_function
extern my_other_jumppoint


global main
main:
	
	call my_other_function
	
	jmp my_other_jumppoint
	
	ret

