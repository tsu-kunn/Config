include confing.mak
include depend.mak

all: $(TARGET)

$(TARGET).a: $(LIB_OBJS)
	$(RM) $@
	$(AR) r $@ $^
	$(RANLIB) $@

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



