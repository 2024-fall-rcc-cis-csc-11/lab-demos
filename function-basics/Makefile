define say
	$(info [Function Basics] $1)
endef


#
REPO_PATH := $(abspath .)
$(call say,REPO_PATH: $(REPO_PATH))


#
YASM_FLAGS := -f elf64 -Werror -g dwarf2
LINK_FLAGS := -g


#
BIN_NAME := main
BIN := ./$(BIN_NAME)




#
default:	help
.PHONY: default


help:
	@echo "***** Makefile Menu *****"
	@echo
	@echo "make help          ==> This menu"
	@echo
	@echo "make build         ==> Build the program"
	@echo "make run           ==> Run the program"
	@echo "make debug         ==> Debug the program"
	@echo
	@echo "make clean         ==> Clean the build area"
	@echo
.PHONY: help



#
build:	$(BIN)
.PHONY: build


#
run:	$(BIN)
	$(BIN)
.PHONY: run


#
debug:	build
	gdb $(BIN_NAME) -x gdb-commands.txt
.PHONY: debug


#
clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean


#
$(BIN):	main.o
	ld --fatal-warnings $(LINK_FLAGS) *.o -o $(BIN)


#
main.o:	main.asm
	yasm $(YASM_FLAGS) main.asm -o main.o




