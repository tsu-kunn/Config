include confing.mak

all:
	@gcc -MM $(INCDIR) $(OBJS:.o=.cpp) > depend.mak
	@make -f makesub.mak $@

clean:
	@make -f makesub.mak clean

install:
	@make -f makesub.mak install
