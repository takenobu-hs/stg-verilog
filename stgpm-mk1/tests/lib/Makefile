

.PRECIOUS : %.comp


#------------------------------------------------------------------------
#  flag
#------------------------------------------------------------------------
IVERFLAGS=-Wall
#IVERFLAGS+=-DSYNTH

ifeq "$(WAVE)" "YES"
IVERFLAGS+=-DWAVE
endif


#------------------------------------------------------------------------
#  iverilog
#------------------------------------------------------------------------
VFILES=

#-- compile
%.comp : $(VFILES) %.v
	make $*.clean
	ln -s $*.v pattern.v

	iverilog $(IVERFLAGS) \
	  -o exe -s top \
	  -I ../../../../rtl/include \
	  -I ./ \
	  $(VFILES)

	touch $*.comp

#-- run
%.run : %.comp
	./exe | tee $*.run.stdout
	@- test ! -e mem.ramdump || mv -f mem.ramdump $*.run.ramdump

	

#-- wave view
wave :
	gtkwave wave.vcd


#-- clean
%.clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f mem.ramdump
	- rm -f $*.run.stdout
	- rm -f $*.run.*dump
	- rm -f $*.comp

clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f *.*dump
	- rm -f wave.vcd
	- rm -f *.run.stdout
	- rm -f *.run.*dump
	- rm -f *.comp


