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
# -m64 is Intel CPU Only
USER_CFLAG  = -pthread -fopenmp
USER_DFLAG  = -DLINUX
#CFLAGS      = -std=c++17 -Wall -fexceptions -Wuninitialized
CFLAGS      = -std=c11 -Wall -Wuninitialized

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
LDFLAGS     = -Wl,--warn-common $(LIBS)

