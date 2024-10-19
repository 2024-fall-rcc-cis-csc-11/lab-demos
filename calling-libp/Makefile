define say
	$(info [libP Demo] $1)
endef


#
CC := gcc
ASM := yasm
C_FLAGS := -c -Wall -gdwarf-2 -m64 -no-pie
YASM_FLAGS := -f elf64 -g dwarf2 -Werror
LINK_FLAGS := -Wall -gdwarf-2 -m64 -Werror -no-pie -z noexecstack


#
REPO_PATH := $(abspath .)
$(call say,REPO_PATH: $(REPO_PATH))


#
BIN_NAME := main
BIN := ./$(BIN_NAME)
$(call say,Binary path: $(BIN))


#
default:	help
.PHONY: default


#
help:
	@echo "***** Makefile Menu *****"
	@echo
	@echo "make help         ==> This help menu"
	@echo
	@echo "make build        ==> Rebuild your project"
	@echo "make run          ==> Run your project"
	@echo "make debug        ==> Debug your project"
	@echo
	@echo "make clean        ==> Clean temporary build files"
	@echo
.PHONY: help


#
build:	$(BIN)
.PHONY: build


#
run:	build
	$(BIN)
.PHONY: run


#
gradescope:
	multirepo-blackbox-grader --config "$(REPO_PATH)/grader.yml" --repo "$(REPO_PATH)"
.PHONY: gradescope


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
$(BIN):	main.o demo.o
	$(CC) $(LINK_FLAGS) *.o *.so -o $(BIN)


#
main.o:	main.c
	$(CC) $(C_FLAGS) $< -o "$@"


#
demo.o:	demo.asm
	$(ASM) $(YASM_FLAGS) $< -o "$@"





