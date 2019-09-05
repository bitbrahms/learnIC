#!/global/freeware/Linux/RHEL6/python-3.7.0/bin/python

import pandas as pd
import numpy as np
import re
import os

def func(ref_file, new_file, val_file):
	val = pd.read_csv(val_file, header=None).values
	cnt = 0

	f2 = open(new_file, 'w')

	with open(ref_file, 'r') as f:
		for line in f.readlines():
			if(re.search(r'set_property RMI1 ', line)):
				line_new = "region $reg set_property RMI1 " +  str(val[cnt][0]) + "\n"
			elif(re.search(r'set_property RMI2 ', line)):
				line_new = "region $reg set_property RMI2 " +  str(val[cnt][1]) + "\n"
			elif(re.search(r'set_property RMI3 ', line)):
				line_new = "region $reg set_property RMI3 " +  str(val[cnt][2]) + "\n"
			elif(re.search(r'set_property WMI1 ', line)):
				line_new = "region $reg set_property WMI1 " +  str(val[cnt][3]) + "\n"
			elif(re.search(r'set_property WMI2 ', line)):
				line_new = "region $reg set_property WMI2 " +  str(val[cnt][4]) + "\n"
			elif(re.search(r'set_property WMI3 ', line)):
				line_new = "region $reg set_property WMI3 " +  str(val[cnt][5]) + "\n"
				cnt += 1
			else:
				line_new = line
			
			f2.write(line_new)
	f2.close()


if __name__ == "__main__":
	ref_file="./comp_char.cpj"
	new_file = "./comp_char.cpj.new"
	val_file = "./test"
	if(os.path.exists(new_file)):
		os.remove(new_file)
	if not os.path.exists(ref_file or val_file):
		print("!!Error: not enough files\n")
		os._exit(0)
	func(ref_file, new_file, val_file)
