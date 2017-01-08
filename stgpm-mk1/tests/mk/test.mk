

.PRECIOUS : %.comp %.run


#------------------------------------------------------------------------
#  flag
#------------------------------------------------------------------------
IVERFLAGS=-Wall
#IVERFLAGS+=-DSYNTH

ifeq "$(WAVE)" "YES"
IVERFLAGS+=-DWAVE
endif


#------------------------------------------------------------------------
#  config
#------------------------------------------------------------------------
#RTL=
#VFILES=
TESTLOG=test_summary.txt



#------------------------------------------------------------------------
#  execution all
#------------------------------------------------------------------------
#-- test all
all :
	- rm -f $(TESTLOG)
	@ for pat in `grep -v "^#" all.T` ; do \
	    make $${pat}.test ; \
	  done
	@ if `grep "Fail" $(TESTLOG) > /dev/null` ; then \
	    echo "TEST: FAIL" ; \
	  else \
	    echo "TEST: PASS" ; \
	  fi

#-- run all
run :
	@ for pat in `grep -v "^#" all.T` ; do \
	    make $${pat}.run ; \
	  done

#-- accept all
accept :
	@ for pat in `grep -v "^#" all.T` ; do \
	    make $${pat}.accept ; \
	  done



#------------------------------------------------------------------------
#  execution a pattern
#------------------------------------------------------------------------
#-- compile
%.comp : $(VFILES) %.v
	make $*.clean
	ln -s $*.v pattern.v

	iverilog $(IVERFLAGS) \
	  -o exe -s top \
	  -I $(RTL)/include \
	  -I ./ \
	  $(VFILES)

	touch $*.comp

#-- run
%.run : %.comp
	./exe > $*.run.stdout
	@- test ! -e mem.hmdump  || mv -f mem.hmdump $*.run.hmdump
	@- test ! -e mem.smdump  || mv -f mem.smdump $*.run.smdump
	@- test ! -e mem.ramdump || mv -f mem.ramdump $*.run.ramdump
	touch $*.run

#-- test
%.test : %.run
	@ echo -n "$*	" >> $(TESTLOG)
	@ if `diff $*.stdout $*.run.stdout > $*.stdout.diff` ; then \
	    echo -n "Pass" >> $(TESTLOG) ; \
	    rm -f $*.stdout.diff ; \
	  else \
	    echo -n "Fail" >> $(TESTLOG) ; \
	  fi
	@ if [ -e $*.run.hmdump ] ; then \
	    if `diff $*.hmdump $*.run.hmdump > $*.hmdump.diff` ; then \
	      echo -n "\tPass" >> $(TESTLOG) ; \
	      rm -f $*.hmdump.diff ; \
	    else \
	      echo -n "\tFail" >> $(TESTLOG) ; \
	    fi ; \
	  fi
	@ echo "" >> $(TESTLOG)

#-- accept
%.accept :
	@- test ! -e $*.run.stdout  || mv -f $*.run.stdout $*.stdout
	@- test ! -e $*.run.hmdump  || mv -f $*.run.hmdump $*.hmdump
	@- test ! -e $*.run.smdump  || mv -f $*.run.smdump $*.smdump
	@- test ! -e $*.run.ramdump || mv -f $*.run.ramdump $*.ramdump


#-- wave view
wave :
	gtkwave wave.vcd



#------------------------------------------------------------------------
#  clean
#------------------------------------------------------------------------
%.clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f mem.ramdump
	- rm -f mem.hmdump
	- rm -f $*.run.stdout
	- rm -f $*.run.*dump
	- rm -f $*.diff
	- rm -f $*.comp $*.run

clean:
	- rm -f exe
	- rm -f pattern.v
	- rm -f mem.*dump
	- rm -f wave.vcd
	- rm -f *.run.stdout
	- rm -f *.run.*dump
	- rm -f *.diff
	- rm -f *.comp *.run
	- rm -f $(TESTLOG)

