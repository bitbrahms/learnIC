#!/usr/bin/python

import os, sys, re
import getopt

#---------------------------------------------------------------------------------------------
def usage():
    a = '''
Usage: $progname [-h] [-n] [-i filename] [-o filename] [-m module]
                  [-t [-p filename]] [-e|f signal] [-c] [-s]

Creates a header for a TestVect file from a Verilog module.
Optionally creates a template PERL script to generate vectors.

       h  - display this message
       i  - input Verilog filename (ie. circuit.v)
            Taken from standard input if not specified.
       o  - output TestVect header file
            Defaults to <rootname>.tv
       m  - name of the top-level module
            Defaults to <rootname>
       t  - "template" option. Creates an executable PERL script.
       p  - name of the template script
            Defaults to <rootname>.p
       n  - Set up template to do input stimulus only (no expected outputs)
     e|f  - specify "early clock" pin(s).  Will delay other signals by \#3.
       c  - combinational vector template (default is random vectors)
       s  - Include power supply pins in the output (normally not included).
    '''
    print(a)

def info(msg):
    print("Info " + msg)

def error(msg):
    print("Error " + msg)
    sys.exit()
#    global error_count
#    error_count += 1
#---------------------------------------------------------------------------------------------

def read_module(file):
    global tlist, tpin, tbit, ipin, ibit, rootname
    flag = 0
    for line in file:
        if re.match(r'\s*module\s+' + rootname, line, re.I):
            flag = 1
        elif (flag == 1) and re.match(r'\s*endmodule', line, re.I):
            flag = 0
            break
        elif (flag == 1 ):
            if re.match(r'input', line, re.I):
                process_module("input", line)
            elif re.match(r'inout', line, re.I):
                process_module("inout", line)
            elif re.match(r'output', line, re.I):
                process_module("output", line)
            else:
                continue
        else:
            continue

#---------------------------------------------------------------------------------------------
def process_module(io, line):
    io = io.lower()
    IO = io.upper()
    if re.match(r'\s*' + io, line):
        #line = line.strip('\n')
        mag = 0
        range = 0
        breakdown = re.split(r'[,\s+]', line)
        inputpin = 0
        global tlist, tpin, tbit, ipin, ibit
        for item in breakdown:
            if re.search(r'^' + io + '$', item):
                if item == "input":
                    inputpin = 1
                else:
                    pass
            elif re.search('\[', item):
                range = re.sub('^.*\[', '[', item)
                field = re.split('[:\[\]]', range)
                mag = abs(int(field[1]) - int(field[2]))
            elif re.search(r';', item):
                pin = re.sub(r';', '', item)
                if inputpin == 1:
                    ipin.append(pin)
                    ibit.append(mag)
                tpin.append(pin)
                tbit.append(mag)
                if mag == 0:
                    pass
                if mag > 0:
                    pin = pin + range
                tlist.append(IO + " " + pin )
                flag = 0
                break
    else:
        pass

#---------------------------------------------------------------------------------------------
def write_module(file):
    global tlist, tpin, tbit, ipin, ibit
    header = '''\
############################
## testvect header file
############################

'''
    file.write(header)
    for item in tlist:
        item = "%-40s" % item
        file.write(item + '#3' + '\n')

    maxlength = 0
    for item in tpin:
        if len(item) > maxlength:
            maxlength = len(item)
    file.write("\n\n\n")
    for i in range(maxlength):
        file.write("# ")
        j = 0
        for item in ipin:
            item += " " * (maxlength - len(item))
            substr = item[i:i+1]
            file.write(substr + " " * ( tbit[j]//4 + 1 ) )
            j += 1
        file.write("\n")
    file.write("# ")
    for i in tbit:
        file.write("_" * (i // 4 + 1) + " ")
    file.write("\n\n")
    file.write("BEGIN\n")
    print("TestVector header is done")


#---------------------------------------------------------------------------------------------
def printGlobal(file):
    global ipin
    file.write("    global ")
    for i in ipin[:-1]:
        file.write(i + ', ')
    file.write(ipin[-1] + '\n')

def printLine(file):
    global ibit, ipin, eeph1
    printGlobal(file)
    file.write('\
    print("\
')
    for i in ibit:
        width = int(i / 4 + 1)
        if width == 1:
            file.write(" %x")
        else:
            file.write(" %0" + str(width) + "x")
    file.write("\" % (")
    file.write(ipin[0])
    for i in ipin[1:]:
        file.write(", " + i)
    file.write("))")

def write_temp(file):
    global tlist, tpin, tbit, ipin, ibit, eeph1
    file.write('\
#!/usr/bin/python\n\
#generate vec for rss running\n\
import sys, os, getopt, random\n\
def printFormat():\n\
')
    printLine(file)
    file.write('\n\n')
#-----------------------------------------------#
    file.write('\
def clk():\n\
')
    printGlobal(file)
    file.write(\
'    ' + eeph1 + '= 1\n')
    file.write('\
    printFormat()\n')
    file.write(\
'    ' + eeph1 + '= 0\n')
    file.write('\
    printFormat()\n\n\n')
    header = rootname + ".tvhead\""
    file.write('\
def printHeader():\n\
    header= "' + header + '\n\
    try:\n\
        with open(header, \'r\') as headerfile:\n\
            for line in headerfile:\n\
                print(line)\n\
    except IOError as msg:\n\
        print(msg)\n\n\n\
def printRandVec():\n\
')
    printGlobal(file)
    file.write('\
    global vec\n\
    for i in range(vec):\n\
')
    for i in range(len(ipin)):
        if ipin[i] == eeph1:
            continue
        else:
            file.write(\
'        '+ ipin[i] + '= int(random.randint(0, 2**' + str(ibit[i]) + '))\n\
')
#---------------------------------------------#
    file.write('\
        clk()\n\n\
def main():\n\
    global vec\n\
    try:\n\
        opts,args = getopt.getopt(sys.argv[1:],\'rv:\')\n\
    except getopt.GetoptError as err:\n\
        print(err)\n\
        sys.exit(2)\n\
    for opt_name, opt_value in opts:\n\
        if opt_name == \'-r\':\n\
            pass\n\
        if opt_name == \'-v\':\n\
            vec = int(opt_value)\n\n\n\
')
    file.write("    ")
    for i in ipin:
        file.write(i + ' = ')
    file.write("0\n")
    file.write('\
    printHeader()\n\
    printRandVec()\n\
')
    file.write('\n\n\
if __name__ == \'__main__\':\n\
    vec = 32\n\
    main()\n\
')



#---------------------------------------------------------------------------------------------
def main():
    try:
        opts,args = getopt.getopt(sys.argv[1:],'hvi:o:t:c:')
    except getopt.GetoptError as err:
        print(err)
        sys.exit(2)

    global tlist, tpin, tbit, ipin, ibit, eeph1, rootname
    for opt_name,opt_value in opts:
        if opt_name == '-h':
            print("[*] Help info")
            usage()
            sys.exit()
        if opt_name == '-v':
            print("[*] Version is 0.01 ")
            sys.exit()
        if opt_name == '-i':
            tmp = opt_value
            tmp = re.sub('^.*/', '', tmp)
            tmp = re.sub('\..*', '', tmp)
            global rootname
            rootname = tmp
            IN_FILE = open(opt_value, 'r')
            read_module(IN_FILE)
        if opt_name == '-o':
            OUT_FILE = open(opt_value, 'w')
            write_module(OUT_FILE)
        if opt_name == '-c':
            global eeph1
            eeph1 = opt_value
        if opt_name == '-t':
            PERL_FILE = open(opt_value, 'w')
            write_temp(PERL_FILE)
            print("Temp file is done")

#---------------------------------------------------------------------------------------------
if __name__ == '__main__':
    rootname = eeph1 = ""
    tlist = []
    tpin = []
    tbit = []
    ipin = []
    ibit = []
    main()

