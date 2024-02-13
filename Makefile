# makefile for netcat, based off same ol' "generic makefile".
# Usually do "make systype" -- if your systype isn't defined, try "generic"
# or something else that most closely matches, see where it goes wrong, fix
# it, and MAIL THE DIFFS back to Hobbit.

### PREDEFINES

# DEFAULTS, possibly overridden by <systype> recursive call:
# pick gcc if you'd rather , and/or do -g instead of -O if debugging
# debugging
# DFLAGS = -DTEST -DDEBUG
DFLAGS =
CFLAGS = -O $(XFLAGS)
XFLAGS = 	# xtra cflags, set by systype targets
XLIBS =		# xtra libs if necessary?
# -Bstatic for sunos,  -static for gcc, etc.  You want this, trust me.
STATIC =
CC = cc $(CFLAGS)
LD = $(CC) -s	# linker; defaults to stripped executables
o = o		# object extension

ALL = nc

### BOGON-CATCHERS

bogus:
	@echo "Usage:  make  <systype>  [options]"

### HARD TARGETS

nc:	netcat.c
	$(LD) $(STATIC) $(DFLAGS) -o nc netcat.c $(XLIBS)

### SYSTYPES -- in the same order as in generic.h, please

# designed for msc and nmake, but easy to change for your compiler.  Note
# special hard-target and "quotes" instead of 'quotes' ...
dos:
	$(MAKE) -e l5-dos $(MFLAGS) CC="cl /nologo" XLIBS=dosdir.obj \
	XFLAGS="/AS -D__MSDOS__ -DMSDOS"  o=obj

ultrix:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DULTRIX'

sunos:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DSUNOS' STATIC=-Bstatic

# kludged for gcc, which many regard as the only thing available.
solaris:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DSYSV=4 -D__svr4__ -DSOLARIS' \
	CC=gcc STATIC=-static

aix:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DAIX'

linux:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DLINUX' STATIC=-static

# irix 5.2, dunno 'bout earlier versions.  If STATIC='-non_shared' doesn't
# work for you, null it out and yell at SGI for their STUPID default
# of apparently not installing /usr/lib/nonshared/*.  Sheesh.
irix:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DIRIX -DSYSV=4 -D__svr4__' \
	STATIC=-non_shared

osf:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DOSF' STATIC=-non_shared

# virtually the same as netbsd/bsd44lite/whatever
freebsd:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DFREEBSD' STATIC=-static

bsdi:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DBSDI' STATIC=-Bstatic

netbsd:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DNETBSD' STATIC=-static

# finally got to an hpux box, which turns out to be *really* warped. 
# STATIC here means "linker subprocess gets args '-a archive'" which causes
# /lib/libc.a to be searched ahead of '-a shared', or /lib/libc.sl.
hpux:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DHPUX' STATIC="-Wl,-a,archive"

# start with this for a new architecture, and see what breaks.
generic:
	make -e $(ALL) $(MFLAGS) XFLAGS='-DGENERIC' STATIC=

# Still at large: aux nextstep dgux dynix ???

### RANDOM

clean:
	rm -f $(ALL) *.o *.obj

