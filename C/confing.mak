SHELL       = /bin/bash

##--- make default option
USE_GDB		?=	TRUE

##--- use directry
TOPDIR      = .
INCDIR      = -I$(TOPDIR)/include -I$(TOPDIR)
LIBDIR      = -L$(TOPDIR)/lib
SRCDIR      =  $(TOPDIR)/src

##--- target/sorce
TARGET      = test
OBJS        = $(SRCDIR)/main.o \
			  $(SRCDIR)/mto_dir.o \
			  $(NULL)
LIBS        = $(LIBDIR)
LIB_OBJS    = $(NULL)

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
#LDFLAGS     = -Wl,--warn-common,--warn-constructors,--warn-multiple-gp $(LIBS)
LDFLAGS     = -Wl,--warn-common, $(LIBS)

