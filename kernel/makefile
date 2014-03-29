###############################################################################
#	makefile
#	 by Alex Chadwick
#
#	A makefile script for generation of raspberry pi kernel images.
###############################################################################

# The toolchain to use. arm-none-eabi works, but there does exist 
# arm-bcm2708-linux-gnueabi.
ARMGNU ?= arm-none-eabi

# The intermediate directory for compiled object files.
BUILD = build/

# The directory in which source files are stored.
SOURCE = source/

DEVICE_DIR = device/

INTERFACE = interface/

# The name of the output file to generate.
TARGET = kernel.img

# The name of the assembler listing file to generate.
LIST = kernel.list

# The name of the map file to generate.
MAP = kernel.map

# The name of the linker script to use.
LINKER = kernel.ld

LIBS :=  -lgcc
OTHERS :=  -mfpu=vfp
LD_FLAGS := -nostdlib -nodefaultlibs -nostdinc  -Os -msoft-float -fstack-check -cpp -fPIE
FFLAGS :=  -Wall -Wtabs -Wimplicit-interface -Wimplicit-procedure -Wno-conversion -Wextra \
	-J$(BUILD)mod \
	-I../include \
	-I../modules \
	-ffixed-line-length-none \
	-fpack-derived \
	-fpack-struct=16 \
	-frepack-arrays \
	-fomit-frame-pointer \
	-mno-apcs-frame \
	-fcray-pointer \
	-fno-range-check 

# The names of all object files that must be generated. Deduced from the 
# assembly code files in source.
#OBJECTS := $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s)) $(patsubst $(SOURCE)%.c,$(BUILD)%.o,$(wildcard $(SOURCE)*.c)) $(patsubst $(SOURCE)%.cpp,$(BUILD)%.o,$(wildcard $(SOURCE)*.cpp)) $(patsubst $(SOURCE)%.f95,$(BUILD)%.o,$(wildcard $(SOURCE)*.f95)) $(patsubst $(SOURCE)%.f,$(BUILD)%.o,$(wildcard $(SOURCE)*.f)) 
UBER_OBJECTS := $(BUILD)memory.o $(BUILD)memcpy.o $(BUILD)libstream/stream.o $(BUILD)elf.o

CORE_OBJECTS := $(BUILD)init.o \
	$(BUILD)null_terminator_0.o \
	$(BUILD)print_console.o \
	$(BUILD)printf.o \
	$(BUILD)renderer/backend.o \
	$(BUILD)renderer/frontend.o \
	$(BUILD)interrupts.o \
	$(BUILD)interrupt_handlers.o \
	$(BUILD)z_start.o


INTERFACE_OBJS := $(BUILD)framebuffer.o


OBJECTS :=

# Rule to make everything.
all: interfaces $(TARGET) $(LIST)


.SECONDEXPANSION:
raspberrypi: OBJECTS += $(BUILD)emmc.o \
	$(BUILD)uart.o \
	$(BUILD)gpio.o \
	$(BUILD)mailbox.o \
	$(BUILD)watchdog.o \
	$(BUILD)init_fb.o \
	$(BUILD)videocore.o
raspberrypi: DEVICE = raspberrypi
raspberrypi: LD_FLAGS += -mcpu=arm1176jzf-s -Ldevice/raspberrypi/
raspberrypi: $(UBER_OBJECTS) interfaces $$(OBJECTS) all


nexus7: OBJECTS += $(BUILD)init_fb.o \
	$(BUILD)usb.o \
	$(BUILD)mmu.o
nexus7: DEVICE = nexus7
nexus7: LD_FLAGS += -mcpu=cortex-a9
nexus7: LINKER = android.ld
nexus7: interfaces $$(OBJECTS) all



# Rule to remake everything. Does not include clean.
rebuild: all


interfaces: $(INTERFACE_OBJS)

# Rule to make the listing file.
$(LIST) : $(BUILD)output.elf
	$(ARMGNU)-objdump -D $(BUILD)output.elf > $(LIST)

# Rule to make the image file.
$(TARGET) : $(BUILD)output.elf
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary $(TARGET)
#	$(ARMGNU)-ld --print-map

# Rule to make the elf file.
$(BUILD)output.elf : $(UBER_OBJECTS) $(INTERFACE_OBJS) $(UBER_OBJECTS) $$(OBJECTS) $(CORE_OBJECTS) $(LINKER)
	$(ARMGNU)-gcc $(LD_FLAGS) -ffreestanding $(UBER_OBJECTS) $(INTERFACE_OBJS) $(OBJECTS) $(CORE_OBJECTS) -o $(BUILD)output.elf -T $(LINKER) $(LIBS) 

# Rule to make the object files.
$(BUILD)%.o: $(SOURCE)%.s
	$(ARMGNU)-as -I $(SOURCE) $< -o $@


$(BUILD)%.o: $(SOURCE)%.f95
	$(ARMGNU)-gcc -c $(LD_FLAGS) $(FFLAGS) -I $(SOURCE) $< -o $@

$(BUILD)%.o: $(SOURCE)%.f
	$(ARMGNU)-gcc -c $(LD_FLAGS)  $(FFLAGS) -I $(SOURCE) $< -o $@



$(BUILD)%.o: $(DEVICE_DIR)$$(DEVICE)/%.f
	$(ARMGNU)-gcc -c $(LD_FLAGS)  $(FFLAGS)  -I $(SOURCE) $< -o $@

$(BUILD)%.o: $(DEVICE_DIR)$$(DEVICE)/%.c
	$(ARMGNU)-gcc -c $(LD_FLAGS)  $(FFLAGS)  -I $(SOURCE) $< -o $@


$(BUILD)%.o: $(DEVICE_DIR)$$(DEVICE)/%.s
	$(ARMGNU)-gcc -c $(LD_FLAGS)  $(FFLAGS)  -I $(SOURCE) $< -o $@


$(BUILD)%.o: $(DEVICE_DIR)$$(DEVICE)/vc/%.f
	$(ARMGNU)-gcc -c $(LD_FLAGS)  $(FFLAGS)  -I $(SOURCE) $< -o $@


$(BUILD)%.o: $(INTERFACE)%.f
	$(ARMGNU)-gcc -c $(LD_FLAGS)  $(FFLAGS) -I $(SOURCE) $< -o $@



$(BUILD)%.o: $(SOURCE)%.c
	$(ARMGNU)-gcc -c $(LD_FLAGS) -I $(SOURCE) $< -o $@

$(BUILD)%.o: $(SOURCE)%.bin
	./bin2o $< $@

# Rule to clean files.
clean : 
	-rm -f $(BUILD)*.o 
	-rm -f $(BUILD)output.elf
	-rm -f $(TARGET)
	-rm -f $(LIST)
	-rm -f $(MAP)
	-rm -f *.mod
	-rm -f $(BUILD)mod/*.mod
	-rm -f $(BUILD)/renderer/*.o
	-rm -f $(BUILD)/libstream/*.o
