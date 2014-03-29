TARGET = libdummy_modules.so

OBJS := elf.o framebuffer.o

FFLAGS := -ffixed-line-length-none \
	-fpack-derived \
	-fpack-struct=16 \
	-frepack-arrays \
	-fomit-frame-pointer \
	-mno-apcs-frame \
	-fcray-pointer \
	-fno-range-check \
	-msoft-float \
	-fstack-check \
	-cpp \
	-Wtabs \
	-I../include \
	-J../include

TARGET_TRIPLET ?= arm-none-eabi
FC = $(TARGET_TRIPLET)-gfortran
LD = $(TARGET_TRIPLET)-ld

$(TARGET) : $(OBJS)
	$(LD) -shared -o $(TARGET) $(OBJS)

%.o : %.f
	$(FC) -c $(FFLAGS) -fpic $<


clean:
	rm -f ../include/*.mod $(TARGET) $(OBJS)
