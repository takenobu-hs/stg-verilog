

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
#-- compile
%.comp : ../testbench/bench.v ../../../../rtl/lib/ram.v %.v
	make $*.clean
	ln -s $*.v pattern.v

	iverilog $(IVERFLAGS) \
	  -o exe -s top \
	  -I ../../../../rtl/include \
	  -I ./ \
	  ../testbench/bench.v \
	  ../../../../rtl/lib/ram.v

	touch $*.comp

#-- run
%.run : %.comp
	./exe | tee $*.run.stdout

	

#-- wave view
wave :
	gtkwave wave.vcd


#-- clean
%.clean:
	rm -f exe
	rm -f pattern.v
	rm -f $*.run.stdout
	rm -f $*.comp

clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f wave.vcd
	- rm -f *.run.stdout
	- rm -f *.comp


