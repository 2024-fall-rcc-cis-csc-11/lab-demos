define say
	$(info [MySuperCool Builder] $1)
endef


$(call say,Now running!)


########################
# Variables
########################


# Compilers
CC	:= gcc
CPP	:= g++
ASM	:= yasm

# C/C++/Yasm flags
CC_FLAGS	:= -Wall -pedantic -g
CPP_FLAGS	:= $(CC_FLAGS) -std=c++23
ASM_FLAGS	:= -f elf64 -gdwarf2

# Linker flags
LINK_FLAGS	:= $(CPP_FLAGS) -m64 -no-pie -z noexecstack

# Tack on -c at last minute, lel
CPP_FLAGS	:= $(CPP_FLAGS) -c
CC_FLAGS	:= $(CC_FLAGS) -c


# Paths
BUILD_DIR_NAME := _build
BUILD_DIR := ./$(BUILD_DIR_NAME)
BIN_NAME := main
BIN := $(BUILD_DIR)/$(BIN_NAME)


# Print everything out
$(call say,CC == $(CC))
$(call say,CPP == $(CPP))
$(call say,ASM == $(ASM))
$(call say,CPP_FLAGS == $(CPP_FLAGS))
$(call say,CC_FLAGS == $(CC_FLAGS))
$(call say,ASM_FLAGS == $(ASM_FLAGS))
$(call say,LINK_FLAGS == $(LINK_FLAGS))
$(call say,BUILD_DIR == $(BUILD_DIR))
$(call say,BIN == $(BIN))



# Default target is the first target
le_default:	menu
.PHONY: le_default


# Menu
menu:
	@echo
	@echo "*** Makefile Menu ***"
	@echo
	@echo "make build                  ==> Build everything"
	@echo "make run                    ==> Build then run the program"
	@echo "make clean                  ==> Clean the build artifacts"
	@echo
	@echo "make silent-commands        ==> Demo silent commands"
	@echo
	@echo "make stop-on-failures       ==> Demo stopping on failed commands"
	@echo "make ignore-failures        ==> Demo ignoring failed commands"
	@echo
.PHONY: menu


# Targets to show silent and non-silent commands
silent-commands:
	@echo "Hello, this is a silent command"
	echo "Hello, this is a non-silent command"
.PHONY: silent-commands


# Targets to show stopping or ignoring failures
ignore-failures:
	-false
	-false
	@echo "This echo statement should be reached, as previous errors (false) should be ignored."
.PHONY: ignore-failures
#
stop-on-failures:
	false
	false
	@echo "This echo statement should never be reached, as previous errors (false) should cause build termination."
.PHONY: stop-on-failures


# Be sure the BUILD directory exists
$(BUILD_DIR):
	$(call say,Ensuring build dir: "$@")
	mkdir "$@"


# Run the program
run: build
	$(BIN)
.PHONY: run


# Alias for just building the binary
build:	$(BIN)


# Build and link the object files and executable
$(BIN):	$(BUILD_DIR)/first.o $(BUILD_DIR)/second.o $(BUILD_DIR)/third.o		| $(BUILD_DIR)
	$(CPP) $(LINK_FLAGS) $(BUILD_DIR)/*.o -o "$@"


# Build the first object file
$(BUILD_DIR)/first.o:	first.cpp	|	$(BUILD_DIR)
	$(CPP) $(CPP_FLAGS) "$<" -o "$@"


# Build the second object file
$(BUILD_DIR)/second.o:	second.c	|	$(BUILD_DIR)
	$(CC) $(CC_FLAGS) "$<" -o "$@"


# Build the third object file
$(BUILD_DIR)/third.o:	third.asm	|	$(BUILD_DIR)
	$(ASM) $(ASM_FLAGS) "$<" -o "$@"



# Clean the build area system thing stuff
clean:
	-rm $(BIN)
	-rm $(BUILD_DIR)/*.o
.PHONY: clean





