#-------------------------------------------------------------------------------
.SUFFIXES:
#-------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path to>/devkitpro")
endif

TOPDIR ?= $(CURDIR)

include $(DEVKITPRO)/wut/share/wut_rules

#-------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# DATA is a list of directories containing data files
# INCLUDES is a list of directories containing header files
#-------------------------------------------------------------------------------
TARGET		:=	$(notdir $(CURDIR))
BUILD		:=	build
SOURCES		:=	src \
				src/fs \
				src/gui \
				src/menu \
				src/resources \
				src/system \
				src/utils \
				src/kernel 
DATA		:=	data \
				data/images \
				data/sounds \
				data/fonts
INCLUDES	:=	src

#-------------------------------------------------------------------------------
# options for code generation
#-------------------------------------------------------------------------------
CFLAGS	:=	-g -Wall -Ofast -ffunction-sections -flto=auto -fuse-linker-plugin \
			-fno-fat-lto-objects -pipe $(MACHDEP)

CFLAGS	+=	$(INCLUDE) -D__WIIU__ -D__WUT__ -D_GNU_SOURCE

CXXFLAGS	:= $(CFLAGS)

ASFLAGS	:=	-g $(ARCH) -mregnames
LDFLAGS	=	-g $(ARCH) $(RPXSPECS) -Wl,-Map,$(notdir $*.map) $(CFLAGS)

LIBS	:=  -lgui -lfreetype -lgd -lpng -ljpeg -lz -lmad -lvorbisidec -logg -lbz2 -lwut 

#-------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level
# containing include and lib
#-------------------------------------------------------------------------------
LIBDIRS	:= $(PORTLIBS) $(WUT_ROOT) $(WUT_ROOT)/usr


#-------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#-------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#-------------------------------------------------------------------------------
FILELIST	:=	$(shell bash ./filelist.sh)
export OUTPUT	:=	$(CURDIR)/$(TARGET)
export TOPDIR	:=	$(CURDIR)

export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
sFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.S)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*.*)))

#-------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#-------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#-------------------------------------------------------------------------------
	export LD	:=	$(CC)
#-------------------------------------------------------------------------------
else
#-------------------------------------------------------------------------------
	export LD	:=	$(CXX)
#-------------------------------------------------------------------------------
endif
#-------------------------------------------------------------------------------

export OFILES_BIN	:=	$(addsuffix .o,$(BINFILES))
export OFILES_SRC	:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(sFILES:.s=.o) $(SFILES:.S=.o)
export OFILES 	:=	$(OFILES_BIN) $(OFILES_SRC)
export HFILES_BIN	:=	$(addsuffix .h,$(subst .,_,$(BINFILES)))

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
			$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
			-I$(CURDIR)/$(BUILD) -I$(PORTLIBS_PATH)/ppc/include/freetype2

export LIBPATHS	:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean all

#-------------------------------------------------------------------------------
all: $(BUILD)

$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#-------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).rpx $(TARGET).elf
#---------------------------------------------------------------------------------
install_channel: $(BUILD) NUSPacker.jar encryptKeyWith
	@cp $(OUTPUT).rpx channel/code/
	java -jar NUSPacker.jar -in "channel" -out "install_channel"

NUSPacker.jar:
	wget https://bitbucket.org/timogus/nuspacker/downloads/NUSPacker.jar

encryptKeyWith:
	@echo "Missing common key file \"encryptKeyWith\"! Insert the common key as string into \"encryptKeyWith\" file in the HBL Makefile path!"
	@exit 1
	
clean_channel:
	@rm -fr install_channel NUSPacker.jar fst.bin output tmp

#---------------------------------------------------------------------------------
else
.PHONY:	all

DEPENDS	:=	$(OFILES:.o=.d)

#-------------------------------------------------------------------------------
# main targets
#-------------------------------------------------------------------------------
all	:	$(OUTPUT).rpx

$(OUTPUT).rpx	:	$(OUTPUT).elf
$(OUTPUT).elf	:	$(OFILES)

$(OFILES_SRC)	: $(HFILES_BIN)

#-------------------------------------------------------------------------------
# you need a rule like this for each extension you use as binary data
#-------------------------------------------------------------------------------
%.bin.o	%_bin.h :	%.bin
	@echo $(notdir $<)
	bin2s -a 32 $< | $(AS) -o $(<F).o

%.png.o	%_png.h :	%.png
	@echo $(notdir $<)
	bin2s -a 32 $< | $(AS) -o $(<F).o
	
%.ogg.o	%_ogg.h :	%.ogg
	@echo $(notdir $<)
	bin2s -a 32  $< | $(AS) -o $(<F).o	
	
%.mp3.o	%_mp3.h :	%.mp3
	@echo $(notdir $<)
	bin2s -a 32  $< | $(AS) -o $(<F).o	
	
%.ttf.o	%_ttf.h :	%.ttf
	@echo $(notdir $<)
	bin2s -a 32  $< | $(AS) -o $(<F).o	
	

-include $(DEPENDS)

#-------------------------------------------------------------------------------
endif
#-------------------------------------------------------------------------------
