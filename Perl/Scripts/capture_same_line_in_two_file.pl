#!/usr/local/bin/perl -w
#`rm -f ./tmp* ./result*`;
# @ARGV = inst_char.meas circuitanalysis.meas result_name
$f1 = $ARGV[0];
$f2 = $ARGV[1];
$f3 = $ARGV[2];
`cp $f1 inst.meas`;
`cp $f2 speed.meas`;
#`cp inst_char.meas inst.meas`;
#`cp circuitanalysis.meas speed.meas`;


`sed -i '/^\*/d' speed.meas`;
`sed -i '/^\$/d' speed.meas`;
`sed -i 's/=/ /g' speed.meas`;
`sed -i 's/\t/ /g' speed.meas`;
`sed -i 's/[ ][ ]*/ /g' speed.meas`;
`sed -i 's/ at.*\$//g' speed.meas`;
`sed -i 's/ targ.*\$//g' speed.meas`;
`sed -i 's/ \$//g' speed.meas`;
`sed -i 's/tcqh_cyc/tcqh_far_cyc/g' speed.meas`;
`sed -i 's/tcql_cyc/tcql_far_cyc/g' speed.meas`;

`grep 'speed ' inst.meas >inst_new.meas`;
`mv inst_new.meas inst.meas`;
`sed -i '/^\*/d' inst.meas`;
`sed -i '/^\$/d' inst.meas`;
`sed -i 's/=/ /g' inst.meas`;
`sed -i 's/\t/ /g' inst.meas`;
`sed -i 's/[ ][ ]*/ /g' inst.meas`;
`sed -i 's/ at.*\$//g' inst.meas`;
`sed -i 's/ targ.*\$//g' inst.meas`;
`sed -i 's/ \$//g' inst.meas`;
`sed -i 's/_atspeed//g' inst.meas`;
`sed -i 's/tcqh /tcqh_far /g' inst.meas`;
`sed -i 's/tcql /tcql_far /g' inst.meas`;


`sed -e 's/ .*\$//' inst.meas > list`;


#open(SPEED, "<$ARGV[0]");
#open(INST, "<$ARGV[1]");
#open(LIST, "<$ARGV[2]");
open(SPEED, "<speed.meas");
open(INST, "<inst.meas");
open(LIST, "<list");
open(NEW, ">$f3");

@arr_speed = <SPEED>;
@arr_inst = <INST>;
@arr_list = <LIST>;

#print NEW "speed value inst_char value\n";
$i = 0;
foreach (@arr_list) {
	chomp;
	$line = $_;
	foreach (@arr_speed) {
		chomp;
		$line1 = $_;
		if ($line1 =~ /$line/i) {
			print NEW $line1," ",$arr_inst[$i];
			#print $line1," ",$arr_inst[$i];
		} 
	}
	$i += 1;
}

close SPEED;
close INST;
close NEW;
close LIST;

#`awk 'function abs(x){return ((x < 0.0) ? -x : x)} {print \$5 = abs(\$2/\$4) }' tmp1 > tmp2`;
#
#`paste tmp1 tmp2 > result`;
#
#`cp result result.csv`;
#`sed -i 's/ /,/g' result.csv`;

