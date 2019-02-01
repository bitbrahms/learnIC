#!/usr/bin/python

############usage cmd lib dout
import sys
import os
import re
import shutil

library, dout= sys.argv[1:]
flag = 0
pg_flag = 0
library_new = open(library + '.new', 'w')
with open(library, 'r') as file:
	for line in file:
		#add vlotage_map about vddo info
		if (re.match('\s*voltage_map\s*\(vddp', line)):
			library_new.write(line)
			library_new.write(line.replace("vddp", "vdd0"))
		# chg max_transition from 240 to 120	
		elif (re.search('default_max_transition\s*:\s*240;', line)):
			library_new.write("default_max_transition : 120;\n")
		# add pg_pin about vddo info
		elif (re.match('\s*pg_pin\s*\(vddp', line)):
			pg_flag = 1	
			library_new.write(line)
		elif (re.match('\s*pg_pin\s*\(vdd0', line)):
			pg_flag = 0	
			library_new.write(line)
		elif ( (pg_flag == 1) and re.match('\s*pg_pin\s*\(vss0', line)):
			pg_flag = 0
			library_new.write("	pg_pin (vdd0) {\n")
			library_new.write("		pg_type : internal_power;\n")
			library_new.write("		voltage_name : \"vdd0\";\n")
			library_new.write("	}\n")
			library_new.write(line)
		#add output about power_doen_function
		elif (re.match('\s*pin\s*\(' + dout, line)):
			library_new.write(line)
			flag = 1
		elif ( (flag == 1) and re.match('\s*power_down_function', line)):
			library_new.write(line)
			flag = 0
		elif ( (flag == 1) and re.match('\s*timing\s*\(', line)):
			library_new.write("		power_down_function : \"(!vdd0) + (vss0)\";\n")
			library_new.write("		related_ground_pin : vss0;\n")
			library_new.write("		related_power_pin : vdd0;\n")
			library_new.write("		max_capacitance : 81.459;\n")
			library_new.write(line)
			flag = 0
		# no operation
		else:
			library_new.write(line)

library_new.close()

#shutil.copy("library_new", "library")
#os.remove("library")
#os.rename("library_new", "library")
