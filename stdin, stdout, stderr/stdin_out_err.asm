
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	Assembly w Professor Peralta


;;;;;;;;;;;;;;;;
;	Data Section
section .data


;	Messages
MSG_INTRO				db		"The STDIN/STDOUT/STDERR demo module has started",0

MSG_BEGIN_STDOUT_STDERR	db		"Begin printing messages to STDOUT and STDERR ...",0
MSG_STDOUT				db		"This message will be printed to STDOUT (FD 1)",13,10,0
MSG_STDERR				db		"This message will be printed to STDERR (FD 2) ... oh noes! errorzzz!",13,10,0

MSG_BEGIN_STDIN			db		"We have detected the following STDIN:",13,10,"*** BEGIN ***",13,10,0
MSG_END_STDIN			db		"*** END ***",13,10,0

MSG_GOODBYE				db		"Program now exiting. Goodbye!",0

CRLF					db		13,10,0

BUFFER_SIZE				equ		8192

;	Syscall codes
SYS_READ				equ		0
SYS_WRITE				equ		1
SYS_EXIT				equ		60


;	File descriptors
FD_STDIN				equ		0
FD_STDOUT				equ		1
FD_STDERR				equ		2


;	Exit codes
EXIT_SUCCESS			equ		0


;;;;;;;;;;;;;;;;
;	Text Section
section .text


; Entry point!
global _start
_start:
	
	; Capture (int argc and char * argv[])
	mov r12, rdi
	mov r13, rsi
	
	; Intro
	call intro
	
	; Stdout/err demo
	call stdout_err
	
	; Stdin demo
	mov rdi, r12
	mov rsi, r13
	call stdin
	
	; Say goodbye
	mov rdi, MSG_GOODBYE
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	; Exit with success
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall



;;;;;;;;;;;;;;;;;;;
;;	void intro();
intro:
	
	;;	Print our welcome message
	mov rdi, MSG_INTRO
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	ret



;;;;;;;;;;;;;;;;
;	void stdin()
;
;	Register usage:
;
;	r12: start of buffer
stdin:
	
	; Prologue
	push r12
	push rbp
	
	; Create a buffer on the stack
	mov rbp, rsp
	sub rsp, BUFFER_SIZE
	mov r12, rbp
	
	mov rdi, MSG_BEGIN_STDIN
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	
	; Read from STDIN
	mov rax, SYS_READ
	mov rdi, FD_STDIN
	mov rsi, r12
	mov rdx, BUFFER_SIZE
	syscall
	
	; Print what we read from STDIN
	mov rdi, r12
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	
	; Say goodbye
	mov rdi, MSG_END_STDIN
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	
	; Epilogue
	mov rsp, rbp
	pop rbp
	pop r12
	
	ret


;;;;;;;;;;;;;;;;;;;;;;;;
;	void stdout_err();
stdout_err:
	
	; Announce we'll be printing to stdout and stderr
	mov rdi, MSG_BEGIN_STDOUT_STDERR
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	; Print a message to STDOUT
	mov rdi, MSG_STDOUT
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	
	; Print a message to STDERR
	mov rdi, MSG_STDERR
	mov rsi, FD_STDERR
	call printNullTerminatedString
	
	ret






;;	void printNullTerminatedString(char * cstring, long file_handle)
;;
;;	Register usage:
;;
;;	r12: cstring
;;	r13: file handle
;;	r14: cstring's length
printNullTerminatedString:
	
	; Prologue
	push r12
	push r13
	push r14
	
	; Grab incoming arguments
	mov r12, rdi
	mov r13, rsi
	
	; Compute the string's length
	mov rdi, r12
	call strlen
	mov r14, rax
	
	; Use a syscall to print the string
	mov rax, SYS_WRITE
	mov rdi, r13
	mov rsi, r12
	mov rdx, r14
	syscall
	
	; Epilogue
	pop r14
	pop r13
	pop r12
	
	ret



;;	long strlen(char * s);
;;
;;	Attempts to determine the number of characters in a null terminated string
;;
;;	Register usage:
;;
;;	r12: running pointer
;;	r13: string length
;;
;;	Returns: string length as long
strlen:
	
	; Prologue
	push r12
	push r13

strlen_loop_init:
	
	; Init the pointer and length
	mov r12, rdi
	mov r13, 0

strlen_loop_top:
	
	; We're done if we're sitting on a null terminator
	cmp byte [r12], 0
	je strlen_loop_done
	
	; Otherwise, increment the counter and the running pointer,
	; then jump to the top of the loop
	inc r12
	inc r13
	jmp strlen_loop_top
	
strlen_loop_done:
	
	; Return value
	mov rax, r13
	
	; Epilogue
	pop r13
	pop r12
	
	ret


;;	void crlf();
;;
;;	Prints CRLF
crlf:
	
	mov rdi, CRLF
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	
	ret

