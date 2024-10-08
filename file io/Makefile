define say
	$(info [File IO] $1)
endef

#	Assembler and flags
ASM := yasm
ASM_FLAGS := -f elf64 -gdwarf2 -Werror 

#	Linker and flags
LINKER := ld
LINKER_FLAGS := -g


# Executable name
BIN_NAME := main
BIN := ./$(BIN_NAME)


# Output file name
INFILE	:= input.txt
OUTFILE	:= output.txt


# File containing initial gdb commands
GDBFILE := gdb.txt


###### Begin Recipe Section


# The default taregt is the first target that appears in the Makefile
menu:
	@echo
	@echo "*** Main Menu ***"
	@echo
	@echo "make menu      ==> This menu"
	@echo
	@echo "make build     ==> Build the program"
	@echo "make run       ==> Run the program"
	@echo "make debug     ==> Debug the program"
	@echo
	@echo "make clean     ==> Clean the working area"
	@echo
.PHONY:	menu


# Run the program
run:	build
	$(call say,Running the program!)
	$(BIN)
	@echo -n "$(INFILE)  ==> " ; md5sum $(INFILE)
	@echo -n "$(OUTFILE) ==> " ; md5sum $(OUTFILE)
.PHONY: run


# Debug the program
debug:	build
	$(call say,Debugging the program)
	gdb $(BIN) --command $(GDBFILE)


# Build only
build:	$(BIN)
.PHONY: build


# Build the main executable/binary
$(BIN):	file_io.o
	$(call say,Linking executable: $@)
	ld --fatal-warnings $(LINK_FLAGS) *.o -o $(BIN)


# Compile pure assembly module
file_io.o:	file_io.asm
	$(call say,Assembling: $@)
	$(ASM) $(ASM_FLAGS) "$<" -o "$@"


# Clean up our repo
clean:
	$(call say,Cleaning repo)
	-rm *.o
	-rm $(BIN)
	-rm $(OUTFILE)
.PHONY: clean








