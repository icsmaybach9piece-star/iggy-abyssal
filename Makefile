ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment")
endif

include $(DEVKITARM)/gba_rules

TARGET      := IGGY_ABYSSAL
BUILD       := build
SOURCES     := source
INCLUDES    := include

ARCH        := -mthumb -mthumb-interwork
CFLAGS      := -g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH)
CXXFLAGS    := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS     := -g $(ARCH)
LDFLAGS     := -g $(ARCH) -Wl,-Map,$(TARGET).map

LIBS        := -lgba

export INCLUDE := $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                  -I$(CURDIR)/$(BUILD)

export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

CFILES      := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c))
CPPFILES    := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.cpp))
SFILES      := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.s))
OFILES      := $(CFILES:.c=.o) $(CPPFILES:.cpp=.o) $(SFILES:.s=.o)

.PHONY: all clean

all: $(TARGET).gba

$(TARGET).gba: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(TARGET).elf: $(OFILES)
	$(LD) $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.s
	$(CC) $(ASFLAGS) $(INCLUDE) -c $< -o $@

clean:
	rm -f $(OFILES) $(TARGET).elf $(TARGET).gba $(TARGET).map
