

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
#	- mv -f heap.dump $*.heap.dump

	

#-- wave view
wave :
	gtkwave wave.vcd


#-- clean
%.clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f $*.run.stdout
	- rm -f $*.heap.dump
	- rm -f $*.comp

clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f wave.vcd
	- rm -f *.run.stdout
	- rm -f *.heap.dump
	- rm -f *.comp


