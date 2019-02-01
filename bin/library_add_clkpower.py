#!/usr/bin/python

##############usage add_clk_power.py power.info cell.lib ###########
import sys
import os
import re

INFO, LIBRARY = sys.argv[1:]

############# process power.info ###############
with open(INFO, 'r') as info:
	for line in info:
		if ( re.match('\s+', line) or re.match('#+', line)):
			continue
		else:
			text = line.split();
			#print text[0]
			#print LIBRARY
			#print "some thing", text
			if (text[0] == LIBRARY):
				CLK = text[1]
				AREA = text[2]
				LEAK = text[3]
				POWER = text[4]
				#print "another thing", LEAK
			else:
				continue

############ process library ######################
flag = 0
flag1 = 0
library_new = open(LIBRARY + '.new', 'w')

with open(LIBRARY, 'r') as library:
	for line in library:
		if (re.match('\s+cell\s+\(', line)):
			flag = 1
			library_new.write(line)
		elif (re.match('\s+pg_pin\s+\(', line) and (flag ==1) ):
			library_new.write("     area : " + AREA + ";\n")
			library_new.write("     cell_leakage_power : " + LEAK + ";\n")
			library_new.write("     dont_use : true ;\n")
			library_new.write("     dont_touch : true ;\n")
			library_new.write("     interface_timing : true;\n")
			library_new.write("     timing_model_type : \"extracted\";\n")
			library_new.write("     is_macro_cell : true;\n")
			library_new.write("     is_memory_cell : true;\n")
			library_new.write("     switch_cell_type : fine_grain;;\n")
			library_new.write(line)
			flag = 0
		elif (flag == 1):
			continue
		elif (re.match('\s+pin\s+\('+CLK, line)):
			flag1 = 1
			library_new.write(line)
		elif (re.match('\s+\}', line) and (flag1 == 1) ):
			library_new.write("		internal_power() {\n")
			library_new.write("    		rise_power(scalar) {\n")
			library_new.write("      		values (\" " + POWER + " \" );\n")
			library_new.write("			}\n")
			library_new.write("			fall_power(scalar) {\n")
			library_new.write("      		values (\" " + POWER + " \" );\n")
			library_new.write("			}\n")
			library_new.write("		}\n")
			library_new.write(line)
			flag1 = 0;
		else :
			library_new.write(line)

library_new.close()




