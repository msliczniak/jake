.PHONY : install clean

PROG = letters
TGT  = .

INSTALL = install -c
SHESC   = shesc

CPPFLAGS = -P

$(PROG) : Makefile $(PROG).sh $(PROG).awk
	$(SHESC) $(PROG).awk <$(PROG).sh >$(PROG)
	$(INSTALL) $(PROG) .

$(PROG).awk : Makefile $(PROG).h
	$(CPP) $(CPPFLAGS) $(PROG).h >$(PROG).awk 

install : Makefile $(PROG) $(TGT)
	$(INSTALL) $(PROG) $(TGT)

clean : Makefile $(PROG).h $(PROG).sh
	$(RM) $(PROG) $(PROG).awk
