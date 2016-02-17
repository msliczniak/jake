.PHONY : all install clean

PROG = letters
PRG2 = 2player
TGT  = .

INSTALL = install -c
SHESC   = shesc

CPPFLAGS = -P

all : $(PROG) $(PROG)$(PRG2) Makefile

$(PROG) : Makefile $(PROG).sh $(PROG).awk
	$(SHESC) $(PROG).awk <$(PROG).sh >$(PROG)
	$(INSTALL) $(PROG) .

$(PROG).awk : Makefile $(PROG).h
	$(CPP) $(CPPFLAGS) $(PROG).h >$(PROG).awk 

$(PROG)$(PRG2) : Makefile $(PROG)$(PRG2).sh $(PROG)$(PRG2).awk
	$(SHESC) $(PROG)$(PRG2).awk <$(PROG)$(PRG2).sh >$(PROG)$(PRG2)
	$(INSTALL) $(PROG)$(PRG2) .

$(PROG)$(PRG2).awk : Makefile $(PROG)$(PRG2).h
	$(CPP) $(CPPFLAGS) $(PROG)$(PRG2).h >$(PROG)$(PRG2).awk 

install : Makefile $(PROG) $(PROG)$(PRG2) $(TGT)
	$(INSTALL) $(PROG) $(PROG)$(PRG2) $(TGT)

clean : Makefile $(PROG).h $(PROG).sh $(PROG)$(PRG2).h $(PROG)$(PRG2).sh
	$(RM) $(PROG) $(PROG).awk $(PROG)$(PRG2) $(PROG)$(PRG2).awk
