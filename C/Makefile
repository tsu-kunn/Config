include confing.mak

all:
	@gcc -MM $(INCDIR) $(OBJS:.o=.c) > depend.mak
	@make -f makesub.mak $@

clean:
	@make -f makesub.mak clean

install:
	@make -f makesub.mak install
