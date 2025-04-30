all: MSP430 SERVER

# Toolchain
CFLAGS=-I$(PATH_INCLUDE)
PATH_INCLUDE = /opt/homebrew/include
PATH_LIB = /opt/homebrew/lib
EMU_LIBS = -lreadline -lwebsockets -lpthread -lssl -lcrypto
SERVER_LIBS = -lwebsockets -lpthread -lssl -lcrypto
TARGET_EXTENSION=out

SRC_CPP = main.cpp debugger/websockets/emu_server.cpp
SRC_C =$(addprefix devices/,utilities.c) \
	$(addprefix devices/cpu/,registers.c decoder.c flag_handler.c formatI.c formatII.c formatIII.c) \
	$(addprefix devices/memory/,memspace.c) \
	$(addprefix devices/peripherals/,usci.c port1.c bcm.c timer_a.c) \
	$(addprefix debugger/,debugger.c disassembler.c register_display.c) \
	$(addprefix debugger/websockets/,packet_queue.c) \

build/%.o:: %.cpp
	mkdir -p $(dir $@)
	g++ -c $(CFLAGS) $< -o $@

build/%.o:: %.c
	mkdir -p $(dir $@)
	g++ -c $(CFLAGS) $< -o $@

bin/msp430.$(TARGET_EXTENSION): $(addprefix build/,$(patsubst %.c,%.o,$(SRC_C))) $(addprefix build/,$(patsubst %.cpp,%.o,$(SRC_CPP))) 
	mkdir -p bin
	g++ -o $@ $^ -L $(PATH_LIB) $(EMU_LIBS)


.PHONY: MSP430
MSP430: bin/msp430.$(TARGET_EXTENSION)

.PHONY: SERVER
SERVER : bin/server.out

bin/server.out: bin/server.o
	mkdir -p bin
	cc -o $@ $^ -L $(PATH_LIB) $(SERVER_LIBS)


bin/server.o : debugger/server/server.c
	mkdir -p bin
	cc -c $(CFLAGS) $< -o $@

CLEANUP = rm -f
MKDIR = mkdir -p
clean :
	$(CLEANUP) -r build
	$(CLEANUP) -r bin
