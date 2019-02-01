#!/usr/bin/perl
#  %W% %G%
##############################################################################
#       purpose: Add power scalar information into timing library files
#
#       usage:  addPowerScalar.p power.info
#
#               power.info is the power information file for IP cell
#		format: cell_name pin_name rise/fall_edge power_value
#
#               ex: To create "power.info_org" reference  file:
#                       addPowerScalar.p
#
#               ex: Run program :
#                       addPowerScalar.p power.info
#
#        by Huafen Shi  2008/07/16  for BJ site
##############################################################################
#### initional : if argv1 = 0,generate a power,info_org as reference###################
local($info)	= $ARGV[0];
if ($info eq "") { 
        &genForm_info("power.info_org");
	print "\n";
        print "\t Create \"power.info_org\" files for reference\n\n";
        exit();
}

#### begin here: check arguments ###################
if ($#ARGV !=1) {
	print "\nInput argument number error...\n";
	print "Usage : addPowerScalar.p power.info library\n\n";
	exit 0;
}

###############addPOwerScalar.p  power.info ip_lib############
###############                     $info      $library######
local($library)	= $ARGV[1];

###################read power,info infomation ##########
open(INFO, $info) || die "Can't open file \"$info\" : $!\n";
while(<INFO>) {
	if ((/^\s*\n/) || (/^\s*[#*]/)) {
		next;
	} else {
		@line = split(/\s+/, $_);
		$CELL = $line[0];
		$PIN = $line[1];
		if ($PIN eq "leakage") {
			$LEAK{$CELL}{"leak"} = $line[2];
			if ($LEAK{$CELL}{"leak"} eq "") {
				$LEAK{$CELL}{"leak"} = "0.000000";
			}
		} elsif ($PIN eq "area") {
			$AREA{$CELL}{"area"} = $line[2];
            if ($AREA{$CELL}{"area"} eq "") {
				$AREA{$CELL}{"area"} = "0.000000";
            }
        } else {
            $POWER{$CELL}{$PIN}{"rise"} = $line[2];
			$POWER{$CELL}{$PIN}{"fall"} = $line[2];
			if ($POWER{$CELL}{$PIN}{"rise"} eq "") {
				$POWER{$CELL}{$PIN}{"rise"} = "0.000000";
			}
			if ($POWER{$CELL}{$PIN}{"fall"} eq "") {
                $POWER{$CELL}{$PIN}{"fall"} = "0.000000";
            }
		}
	}
}
close(INFO);

#######################################
open(LIB, $library) || die "Can't open file \"$library\" : $!\n";
open(OUT,"> $library.power") || die "Can't open file \"$library.power\" : $!\n";
while(<LIB>) {
	if (/^\s*cell\s*\((\S*)\)/) {
		$cell=$1;
		print OUT "$_";
		if(keys %{$LEAK{$cell}}) {
		#	print OUT "/*   ADD LEAKAGE POWER HERE .... */\n";
            print OUT "     area : $AREA{$CELL}{\"area\"}  ;\n";
            print OUT "     cell_leakage_power : $LEAK{$CELL}{\"leak\"};\n"; 
            print OUT "     dont_use : true ;\n";
            print OUT "     dont_touch : true ;\n";
            print OUT "     interface_timing : true;\n";
            print OUT "     timing_model_type : \"extracted\";\n";
            print OUT "     is_macro_cell : true;\n";
			print OUT "     is_memory_cell : true;\n";
		}
	} elsif (/^\s*pin\s*\((\S*)\)/) {
		$pin=$1;
                print OUT "$_";
		if(keys %{$POWER{$cell}{$pin}}) {
			print OUT "/*    ADD SCALAR POWER HERE .... */\n";
			print OUT "           internal_power() {\n";
			print OUT "              rise_power(scalar) {\n";
			print OUT "                values (\" $POWER{$cell}{$pin}{\"rise\"} \")\;\n";
			print OUT "              }\n";
			print OUT "              fall_power(scalar) {\n";
			print OUT "                values (\" $POWER{$cell}{$pin}{\"fall\"} \")\;\n";
			print OUT "              }\n";
			print OUT "           }\n";
		}
	} else {
		print OUT "$_";
	}
}
close(LIB);
close(OUT);
	

sub genForm_info {
	local($outfile)	= @_[0];
	open(OUT, "> $outfile") || die "Can't open file \"$outfile\" : $!\n";
	print OUT "\n";
	print OUT "\#\#\# setting cell power value in column 4th \#\#\#\n";
	print OUT "\n";
	print OUT "\#\#\# cell_name	pin_name	rise/fall/both (edge)	power_value \#\#\#\n";
	print OUT "\n";
	print OUT "\#DLYCOMP_S          CLKO            rise            5.000000\n";
	print OUT "\#DLYCOMP_S          CLKO            fall            5.000000\n";
	print OUT "\#DLYCOMP_S          CLKO            both            5.000000\n";
        print OUT "\#DLYCOMP_S		leakage		25.000000\n";
	print OUT "\n";
	close(OUT);
}



