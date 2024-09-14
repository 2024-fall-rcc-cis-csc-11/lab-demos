
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;	Assembly w Professor Peralta


;;;;;;;;;;;;;;;;
;	Data Section
section .data


;	Messages
MSG_INTRO				db		"The File IO demo module has started",0

MSG_FILE_OPEN_SUCCESS	db		"Successfully opened read file: ",0
MSG_FILE_OPEN_FAIL		db		"Failed to open file: ",0

MSG_FILE_CREATE_SUCCESS	db		"Successfully created file: ",0
MSG_FILE_CREATE_FAIL	db		"Failed to create file: ",0

MSG_FILE_COPY_DONE		db		"Done copying files",0

MSG_DIE_FILE_OPEN		db		"Terminating program after failure to open file.",0
MSG_DIE_FILE_CREATE		db		"Terminating program after failure to create file.",0

CRLF					db		13,10,0

COPY_BUFFER_LEN			equ		8

;	Files names (don't forget the null terminator!)
FILENAME_TO_READ		db		"input.txt",0
FILENAME_TO_WRITE		db		"output.txt",0


;	File open flags
FILE_FLAGS_READ			equ		0


;	File create flags			rw,r,0
FILE_PERMS_STANDARD		equ		00640q


;	Syscall codes
SYS_READ				equ		0
SYS_WRITE				equ		1
SYS_OPEN				equ		2
SYS_CREATE				equ		85
SYS_CLOSE				equ		3
SYS_EXIT				equ		60


;	File descriptors
FD_STDOUT				equ		1
FD_STDERR				equ		2


;	Exit codes
EXIT_SUCCESS			equ		0
EXIT_FAIL				equ		1


;;;;;;;;;;;;;;;;
;	Text Section
section .text


; Entry point!
global _start
_start:
	
	call welcome
	call file_io
	
	; Exit with success
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall

;;;;;;;;;;;;;;;;;;;;;;;;
;	void file_io();
global file_io
file_io:
	
	call file_tests
	
	ret


;;;;;;;;;;;;;;;;;;;
;;	void welcome();
welcome:
	
	;;	Print our welcome message
	mov rdi, MSG_INTRO
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	ret


;;;;;;;;;;;;;;;;;;;;;;
;;	void file_tests();
;;
;;	Register usage:
;;		r12: Input file handle
;;		r13: Output file handle
;;		r14: Count of bytes read from the input file
file_tests:
	
	; Prologue
	push r12
	push r13
	push r14
	
	; Open the file to read
	mov rdi, FILENAME_TO_READ
	mov rsi, FILE_FLAGS_READ
	call open_file_read
	mov r12, rax
	
	; Create the file to write
	mov rdi, FILENAME_TO_WRITE
	mov rsi, FILE_PERMS_STANDARD
	call create_file
	mov r13, rax
	
	; Copy the input file to the output file
	mov rdi, r12
	mov rsi, r13
	call copy_file
	
	; Print a success message
	mov rdi, MSG_FILE_COPY_DONE
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	; Close both files
	mov rdi, r12
	call close_file
	mov rdi, r13
	call close_file
	
	; Epilogue
	pop r14
	pop r13
	pop r12
	
	ret


;;	long_FILEHANDLE open_file_read(char * file_name, long flags);
;;
;;	Attempts to open a file for reading
;;	On success, returns a file handle
;;	On failure, complains and exits the program
;;
;;	Register usage:
;;
;;	r12: File name char *
;;	r13: File flags
;;	r14: File handle
open_file_read:
	
	;	Prologue
	push r12
	push r13
	push r14
	
	;	Grab incoming arguments
	mov r12, rdi
	mov r13, rsi
	
	;	Attempt to open with a syscall
	mov rax, SYS_OPEN
	mov rdi, r12		; File name
	mov rsi, r13		; File status flags
	syscall
	mov r14, rax		; Save the file handle
	
	;	If we succeeded, jump to the success label
	cmp r14, 0
	jge open_file_read_success

open_file_read_fail:
	
	;	Otherwise, we have failed
	mov rdi, MSG_FILE_OPEN_FAIL
	mov rsi, FD_STDERR
	call printNullTerminatedString
	;
	mov rdi, r12
	mov rsi, FD_STDERR
	call printNullTerminatedString
	call crlf
	
	;	Call DIE to exit
	mov rdi, MSG_DIE_FILE_OPEN
	call die

open_file_read_success:
	
	; Announce success
	mov rdi, MSG_FILE_OPEN_SUCCESS
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	;
	mov rdi, FILENAME_TO_READ
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	;	Return value into rax (file handle)
	mov rax, r14
	
	;	Epilogue
	pop r14
	pop r13
	pop r12
	
	ret


;;	long create_file(char * file_name, long flags);
;;
;;	Attempts to create a file for writing. Calls DIE on failure.
;;
;;	Register usage:
;;
;;	r12: char * file_name
;;	r13: file creation flags
;;	r14: file handle
;;
;;	Return value: file handle
create_file:
	
	; Prologue
	push r12
	push r13
	push r14
	
	; Grab incoming arguments
	mov r12, rdi
	mov r13, rsi
	
	; Syscall
	mov rax, SYS_CREATE
	mov rdi, r12			; File name
	mov rsi, r13			; File's initial permissions
	syscall
	mov r14, rax			; Save the file handle
	
	; Check whether we successfully created the file
	cmp r14, 0
	jge create_file_success

create_file_fail:
	
	;	Otherwise, we have failed
	mov rdi, MSG_FILE_CREATE_FAIL
	mov rsi, FD_STDERR
	call printNullTerminatedString
	;
	mov rdi, r12
	mov rsi, FD_STDERR
	call printNullTerminatedString
	call crlf
	
	;	Call DIE to exit
	mov rdi, MSG_DIE_FILE_CREATE
	call die
	
create_file_success:
	
	; Announce our success in creating the file
	mov rdi, MSG_FILE_CREATE_SUCCESS
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	mov rdi, FILENAME_TO_WRITE
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	call crlf
	
	; Return the handle
	mov rax, r14
	
	; Epilogue
	pop r14
	pop r13
	pop r12
	
	ret


;;	void copy_file(long input_handle, long output_handle);
;;
;;	Attempts to copy the contents of one file to another, using file handles
;;
;;	Register usage:
;;
;;	r12: input_handle
;;	r13: output_handle
;;	r14: beginning of temp buffer
;;	r15: temp bytes read
;;	
copy_file:
	
	; Prologue
	push r12
	push r13
	push r14
	push r15
	push rbp
	
	; Grab incoming arguments
	mov rdi, r12
	mov rsi, r13
	
	; Make a buffer on the stack
	mov rbp, rsp
	sub rsp, COPY_BUFFER_LEN
	mov r14, rsp

copy_file_iterate:

	; Read a portion of the input file to the buffer
	mov rax, SYS_READ
	mov rdi, r12					; File descriptor (input file)
	mov rsi, r14					; Address of where to store the characters
	mov rdx, COPY_BUFFER_LEN		; Maximum count to read (size of our buffer)
	syscall
	mov r15, rax					; Remember how many bytes we read from the file
	
	; If we haven't read anything, we're (probably done)
	cmp r15, 0
	je copy_file_done
	
	; Write to the output file
	mov rax, SYS_WRITE				; Syscall code
	mov rdi, r13					; Target for output
	mov rsi, r14					; Buffer
	mov rdx, r15					; How many characters to write
	syscall
	
	; Read some more
	jmp copy_file_iterate

copy_file_done:

	; Epilogue
	mov rsp, rbp
	pop rbp
	pop r15
	pop r14
	pop r13
	pop r12
	
	ret


;;	void close_file(long handle);
;;
;;	attempts to close a file specified by the incoming handle
;;
;;	Register usage:
;;
;;	r12: file handle
close_file:
	
	; Prologue
	push r12
	
	; Grab incoming arguments
	mov r12, rdi
	
	; Close the file
	mov rax, SYS_CLOSE
	mov rdi, r12					; Closing the input file, by its handle
	syscall
	
	; Epilogue
	pop r12
	
	ret


;;	long strlen(char * s);
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



;;	Prints CRLF
crlf:
	
	mov rdi, CRLF
	mov rsi, FD_STDOUT
	call printNullTerminatedString
	
	ret



;;	void die(char * message);
;;	Prints the message to stderr, then exits with code 1
;;
;;	Register usage:
;;
;;	r12: char * message
die:
	
	; Prologue/Epilogue not needed (we're exiting here)
	
	; Grab incoming args
	mov r12, rdi
	
	; Print the message to stderr
	mov rdi, r12
	mov rsi, FD_STDERR
	call printNullTerminatedString
	call crlf
	
	; Exit the program
	mov rax, SYS_EXIT
	mov rdi, 1
	syscall





