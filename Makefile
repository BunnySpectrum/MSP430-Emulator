all: MSP430 SERVER

# Point the PREFIX to the parent folder of the include and lib folders
# Can override on command line via `make PREFIX='/path/to/toolchain'`
PREFIX = /opt/homebrew

# OS-specific 
CLEANUP = rm -f
MKDIR = mkdir -p
TARGET_EXTENSION=out

# Toolchain
PATH_INCLUDE = $(PREFIX)/include
PATH_LIB = $(PREFIX)/lib
CC = cc
CXX = g++

# Build flags
CFLAGS=-I$(PATH_INCLUDE)
EMU_LIBS = -lreadline -lwebsockets -lpthread -lssl -lcrypto
SERVER_LIBS = -lwebsockets -lpthread -lssl -lcrypto

SRC_CPP = main.cpp debugger/websockets/emu_server.cpp
SRC_C =$(addprefix devices/,utilities.c) \
	$(addprefix devices/cpu/,registers.c decoder.c flag_handler.c formatI.c formatII.c formatIII.c) \
	$(addprefix devices/memory/,memspace.c) \
	$(addprefix devices/peripherals/,usci.c port1.c bcm.c timer_a.c) \
	$(addprefix debugger/,debugger.c disassembler.c register_display.c) \
	$(addprefix debugger/websockets/,packet_queue.c) \


.PHONY: MSP430
MSP430: bin/msp430.$(TARGET_EXTENSION)

build/emu/%.o:: %.cpp
	$(MKDIR) $(dir $@)
	$(CXX) -c $(CFLAGS) $< -o $@

build/emu/%.o:: %.c
	$(MKDIR) $(dir $@)
	$(CXX) -c $(CFLAGS) $< -o $@

bin/msp430.$(TARGET_EXTENSION): $(addprefix build/emu/,$(patsubst %.c,%.o,$(SRC_C))) $(addprefix build/emu/,$(patsubst %.cpp,%.o,$(SRC_CPP))) 
	$(MKDIR) bin
	$(CXX) -o $@ $^ -L $(PATH_LIB) $(EMU_LIBS)


.PHONY: SERVER
SERVER : bin/server.$(TARGET_EXTENSION)

bin/server.$(TARGET_EXTENSION): build/server/server.o
	$(MKDIR) bin
	$(CC) -o $@ $^ -L $(PATH_LIB) $(SERVER_LIBS)

build/server/server.o : debugger/server/server.c
	$(MKDIR) build/server
	$(CC) -c $(CFLAGS) $< -o $@

clean :
	$(CLEANUP) -r build
	$(CLEANUP) -r bin
