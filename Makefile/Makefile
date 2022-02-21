SHELL       = /bin/bash

##--- make default option
USE_GDB		?=	TRUE

##--- use directry
TOPDIR      = .
INCDIR      = -I$(TOPDIR)/include
SRCDIR      =  $(TOPDIR)/src
STUBDIR     = 

##--- target/sorce
TARGET      = tgarw
OBJS        = $(SRCDIR)/main.o \
			  $(SRCDIR)/tga.o
LIB_OBJS    = $(OBJS)
PRX_OBJS    = $(OBJS)

##--- use command
AS          = gcc
CC          = gcc
LD          = gcc
AR          = ar
RANLIB      = ranlib
OBJDUMP     = objdump

##--- compile option
#USER_CFLAG  = -pthread -m64 -fopenmp
USER_CFLAG  = 
USER_DFLAG  = -DLINUX
CFLAGS      = -std=c11 -Wall -fexceptions -Wuninitialized

ifndef NDEBUG
CFLAGS     += -O0 $(USER_CFLAG) $(USER_DFLAG)

## use GDB ?
ifeq ($(USE_GDB), TRUE)
CFLAGS     += -ggdb
else
CFLAGS     += -g
endif

else
CFLAGS     += -O3 $(USER_CFLAG) -DNDEBUG $(USER_DFLAG)
endif

ASFLAGS     = -c -xassembler-with-cpp
LDFLAGS     = -Wl,--warn-common,--warn-constructors,--warn-multiple-gp


all: $(TARGET)

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

.c.o:
	$(CC) $(CFLAGS) $(TMPFLAGS) $(INCDIR) -Wa,-al=$*.lst -c $< -o $*.o

clean:
	@$(RM) $(SRCDIR)/*.o $(SRCDIR)/*.map $(SRCDIR)/*.lst
	@$(RM) *.o *.map *.lst
	@$(RM) $(TARGET)
	@$(RM) $(SRCDIR)/*.bak


install: all


