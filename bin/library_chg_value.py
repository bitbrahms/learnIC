#!/usr/bin/env python

import sys
import re

file = sys.argv[1]

file_new = open(file+'.new', 'w')
with open(file, 'r') as lib:
	for line in lib:
		if(re.match('\s+"-?\d*', line)):
			#
			ori = re.findall(r'(-?\d+\.?\d+)', line)
			#chg the str list to float list 
			ori_flt = map(float, ori)
			#chg list to str
			ori = ', '.join(ori)
			for i in range(len(ori_flt)):
				ori_flt[i] *= 2.0
			#chg float list to str list
			ori_str = map(str, ori_flt)
			#chg new list data to str
			new = ', '.join(ori_str)
			#replace old data with new data
			line = line.replace(ori, new)
			file_new.write(line)
		else:
			file_new.write(line)
		#print(m.group(1))
file_new.close()
