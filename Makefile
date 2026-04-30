# mrst - MrRobotOS terminal
# See LICENSE file for copyright and license details.
.POSIX:
include config.mk

SRC = st.c x.c
OBJ = $(SRC:.c=.o)

all: mrst

config.h:
	cp config.def.h config.h

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h
$(OBJ): config.h config.mk

mrst: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f mrst $(OBJ) mrst-$(VERSION).tar.gz

install: mrst
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f mrst $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/mrst
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/mrst.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/mrst.1
	tic -sx st.info
	@echo Please see the README file regarding the terminfo entry of mrst.
	mkdir -p $(DESTDIR)$(ICONPREFIX)
	[ -f $(ICONNAME) ] && cp -f $(ICONNAME) $(DESTDIR)$(ICONPREFIX) || :

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/mrst
	rm -f $(DESTDIR)$(MANPREFIX)/man1/mrst.1
	rm -f $(DESTDIR)$(ICONPREFIX)/$(ICONNAME)

.PHONY: all clean dist install uninstall
