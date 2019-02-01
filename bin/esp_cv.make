

############################################################################
#INNOSPI = /circuit/angusc/ESP/CV/metropolis/sram/innospi
#INNOSPI = /c5a/users/karlwang/bin/ESPCV/innospi
LIST = ../abList
ADDLIST = /cad/bin/addList
LIC = 27010@zx1:27010@zx2:27010@zx3:27010@zx4:27010@zx5:27010@zx6:27010@zx7:27010@zx8:27010@zx9:27010@zx10:27010@zx11:27010@zx12:27010@zx13:27010@zx14:27010@zx15:27010@zxct1:27010@zxct2:27010@zxct3:27010@zxct4:27010@zxct5:27010@zxct6:27010@zxct7:27010@zxct8:27010@zxct9:27010@zxct10
#INNOHOME = /cad/innologic/Latest/bin
#INNOHOME = /cad/innologic/espcv/bin
INNOHOME = /cad/SYNOPSYS/esp_vJ-2014.06/bin
TECHHOME= /cpuwrk/msic-bjckt/wrk/tool/SOP/ESPCV/tech
SPIPATH1 = `echo $(SPIPATH)|/usr/bin/tr -d ' '`
MODELPATH1 = `echo $(MODELPATH)|/usr/bin/tr -d ' '`
PROCESS1 = `echo ${PROCESS}|/usr/bin/tr -d '[a-zA-Z]'`

############################################################################
null:
	@echo "Usage :"
	@echo " make			\c"
	@echo "- see Usage"
	@echo " make setup    - Generate the ESPCV environment "
	@echo " make CFG      - create all new configuration file "
	@echo " make GV       - create all new Switch-Level netlist "
	@echo " make TB       - create all new TestBench file "
	@echo " make CV       - Execute the ESPCV with hierarchical mode "
	@echo " make ERR      - Execute the ESPCV with debug mode "
	@echo ""
	@echo "Detail Usage:"
	@echo "   make spi  - create a new spi file "
	@echo "   make cfg  - create a new configuration file "
	@echo "   make gv   - create a new Switch-Level netlist "
	@echo "   make tb   - create a new TestBench file "
	@echo "   make cv   - run ESPCV "
	@echo "   make dump   - dump error waveform "
	@echo ""


setup:
	@for i in $(CELLLIST) ; do \
	     if [ ! -d $$i ] ; then \
		mkdir $$i ; cd $$i ; \
	        if [ ! -f ${MODELPATH1}/$$i.${EXT} ] ; then \
	            echo "$$i.${EXT} is not exist\n" ; \
	        else \
	            echo "$$i.${EXT} is exist\n" ; \
	        fi ; \
		echo "include ../makefile" > makefile ; \
		echo "BLOCK = $$i" >> makefile ; \
		if [ -f ${SPIPATH1}/$$i.pre -o -f ${SPIPATH1}/$$i.cdl ] ; then \
		  if [ -f ${SPIPATH1}/$$i.pre ] ; then \
			    echo "Find PRE file : $$i.pre \n"; \
		           /bin/cp ${SPIPATH1}/$$i.pre $$i.spi ; \
		  else \
			  echo "Find CDL file : $$i.cdl \n"; \
		          /bin/cp ${SPIPATH1}/$$i.cdl $$i.spi ; \
		  fi ;\
		  /bin/echo "***" > $$i.spi.tmp ;\
		  /bin/echo ".global vdd gnd" >> $$i.spi.tmp ;\
		  /bin/sed -e "s/\([0-9]\)um\>/\1u/g" $$i.spi >> $$i.spi.tmp ;\
		  /bin/sed -e "s/^[xX][rR]\(.*[rR]=\)/r\1/" -e "s/$$\[.*\]\(.*[rR]=\)/\1/" $$i.spi.tmp > $$i.spi ;\
		  /bin/rm $$i.spi.tmp ;\
		  /bin/echo "${MODELPATH1}/$$i.${EXT}" > vfiles ;\
		  /bin/echo "./$$i.gv" >> vfiles ;\
		  /bin/echo "./$$i.tb" >> vfiles ;\
		  /bin/echo "+incdir+../tb++" >> vfiles ;\
		else \
		    echo "Can't find PRE or CDL file in ${SPIPATH1} \n"; \
		fi ;\
		cd ..; \
	     else \
	       echo "$$i is exists" ; \
	     fi ;\
	done ;\

spi:
		@if [ -f ${SPIPATH1}/${BLOCK}.pre -o -f ${SPIPATH1}/${BLOCK}.cdl ] ; then \
		  if [ -f ${SPIPATH1}/${BLOCK}.pre ] ; then \
			    echo "Find PRE file : $$i.pre \n"; \
		           /bin/cp ${SPIPATH1}/${BLOCK}.pre ${BLOCK}.spi ; \
		  else \
			  echo "Find CDL file : ${BLOCK}.cdl \n"; \
		          /bin/cp ${SPIPATH1}/${BLOCK}.cdl ${BLOCK}.spi ; \
		  fi ;\
		  /bin/echo "***" > ${BLOCK}.spi.tmp ;\
		  /bin/echo ".global vdd gnd" >> ${BLOCK}.spi.tmp ;\
		  /bin/sed -e "s/\([0-9]\)um\>/\1u/g" ${BLOCK}.spi >> ${BLOCK}.spi.tmp ;\
		  /bin/sed -e "s/^xr\(.*R=\)/r\1/i" -e "s/$$\[.*\]\(.*R=\)/\1/i" ${BLOCK}.spi.tmp > ${BLOCK}.spi ;\
		  /bin/rm ${BLOCK}.spi.tmp ;\
		else \
		    echo "Can't find PRE or CDL file in ${SPIPATH1} \n"; \
		fi ;\

CFG:
	@for i in $(CELLLIST) ; do \
	   cd $$i ; \
	   if [ -f $$i.cfg ] ; then \
	     /bin/mv $$i.cfg $$i.cfg.bak ;\
	   fi ;\
	   PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	   espbuildcfg -verilog  $(MODELPATH1)/$$i.${EXT} -top $$i -cfg $$i.cfg -spice $$i.spi ;\
	for ck in $(CLOCK) ; do \
	  /bin/sed -e "s/port.*$$ck/port clock $$ck/" $$i.cfg > $$i.cfg.tmp ; \
	  /bin/mv $$i.cfg.tmp $$i.cfg ; \
	  /bin/echo "config clock waveform $$ck ${PERIOD} ${SETUP} 1;" >> $$i.cfg ;\
	done ; \
	/bin/echo "" >> $$i.cfg ; \
	/bin/echo '`include ${TECHHOME}/${PROCESS}.m ;' >> $$i.cfg ; \
	if [ `/bin/echo ${PROCESS}|/usr/bin/tr -d '[a-mo-zA-MO-Z0-9]'|/usr/bin/wc -c ` != 1 ] ; then \
	/bin/echo "config rcdelay_process 0.0${PROCESS1} ;" >> $$i.cfg ; \
	else \
	/bin/echo "config rcdelay_process 0.${PROCESS1} ;" >> $$i.cfg ; \
	fi; \
	/bin/echo "config rcdecaytime 2;" >> $$i.cfg ; \
	/bin/echo "config symbolcycle 4;" >> $$i.cfg ; \
	/bin/echo "config flushcycle 2;" >> $$i.cfg ; \
	for vd in $(VDD) ; do \
	  /bin/echo "net supply1 $$vd ;" >> $$i.cfg ;\
	done ; \
	for gd in $(GND) ; do \
	  /bin/echo "net supply0 $$gd ;" >> $$i.cfg ;\
	done ; \
	   cd ../ ;\
	done ;

cfg:
	@if [ -f ${BLOCK}.cfg ] ; then \
	  /bin/mv ${BLOCK}.cfg ${BLOCK}.cfg.bak ;\
	fi ;\
	PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	espbuildcfg -verilog  ${MODELPATH1}/${BLOCK}.${EXT} -top ${BLOCK} -cfg ${BLOCK}.cfg -spice ${BLOCK}.spi
	@for ck in $(CLOCK) ; do \
	  /bin/sed -e "s/port.*$$ck/port clock $$ck/" ${BLOCK}.cfg > ${BLOCK}.cfg.tmp ; \
	  /bin/mv ${BLOCK}.cfg.tmp ${BLOCK}.cfg ; \
	  /bin/echo "config clock waveform $$ck ${PERIOD} ${SETUP} 1;" >> ${BLOCK}.cfg ;\
	done ; \
	/bin/echo "" >> ${BLOCK}.cfg ; \
	/bin/echo '`include ${TECHHOME}/${PROCESS}.m ;' >> ${BLOCK}.cfg ; \
	if [ `/bin/echo ${PROCESS}|/usr/bin/tr -d '[a-mo-zA-MO-Z0-9]'|/usr/bin/wc -c ` != 1 ] ; then \
	/bin/echo "config rcdelay_process 0.0${PROCESS1} ;" >> ${BLOCK}.cfg ; \
	else \
	/bin/echo "config rcdelay_process 0.${PROCESS1} ;" >> ${BLOCK}.cfg ; \
	fi; \
	/bin/echo "config rcdecaytime 2;" >> ${BLOCK}.cfg ; \
	/bin/echo "config symbolcycle 4;" >> ${BLOCK}.cfg ; \
	/bin/echo "config flushcycle 2;" >> ${BLOCK}.cfg ; \
	for vd in $(VDD) ; do \
	  /bin/echo "net supply1 $$vd ;" >> ${BLOCK}.cfg ;\
	done ; \
	for gd in $(GND) ; do \
	  /bin/echo "net supply0 $$gd ;" >> ${BLOCK}.cfg ;\
	done ; \

GV:
	@for i in $(CELLLIST) ; do\
	   cd $$i ; \
	   PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	   esps2v -cfg $$i.cfg -rc -spice $$i.spi -verilog $$i.gv ;\
	   cd ../ ;\
	done ;

gv:
	@PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	esps2v -cfg ${BLOCK}.cfg -rc -spice ${BLOCK}.spi -verilog ${BLOCK}.gv ;\

TB:
	@for i in $(CELLLIST) ; do\
	   cd $$i ; \
	   \rm -f $$i.tb ;\
	   if [ ! -f $$i.cfg ] ; then\
		   if [ ! -f $$i.cfg ] ; then\
			echo "Can't find CFG file" ;\
		   else \
	   		PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
			esptbgen -cfg $$i.cfg -tb $$i.tb -style doit ;\
		   fi ; \
	   else \
		PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
		esptbgen -cfg $$i.cfg -tb $$i.tb -style doit ;\
	   fi ; \
	   cd ../ ;\
	done ;\

tb:
	@PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	esptbgen -cfg ${BLOCK}.cfg -tb ${BLOCK}.tb -style doit
cktb:
	@PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	esptbgen -cfg ${BLOCK}.cfg -tb ${BLOCK}.tb -style clkwave
CV:
	@for i in $(CELLLIST) ; do\
	   cd $$i ; \
	     PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	     espcv -f vfiles -hc medium -reorder on ;\
	   cd ../ ;\
	done ;\

cv:	
	@PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	espcv  -f vfiles +licq -hc high -reorder on +define+ESPCOV -randomize sysmem;\

dump:
	@PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	espcv -f vfiles -hc medium -reorder on -b -full_access ;\

ERR:	
	@for i in $(CELLLIST) ; do\
	   cd $$i ; \
	     PATH=``$(INNOHOME); LM_LICENSE_FILE=``$(LIC)''; export LM_LICENSE_FILE PATH ; \
	     espcv -f vfiles -hc medium -b -full_access ;\
	   cd ../ ;\
	done ;\:

all:
	${MAKE} setup; \
	${MAKE} CFG; \
	${MAKE} GV; \
	${MAKE} TB; \
	${MAKE} CV; \
