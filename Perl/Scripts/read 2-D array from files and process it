#!/usr/local/bin/perl -w

open(CPJ, "<comp_char.cpj");
open(VAL, "<test");
open(NEW, ">comp_char.cpj.new");

print("test should be same thing like this: \n");
print("RMI1	RMI2	RMI3	WMI1	WMI2	WMI3\n");
print("val1	val2	val3	val4	val5	val6\n");

@array =();
foreach(<VAL>) {
	if( ($_ =~ /^#/) || ($_ =~ /^\s*$/)) {
		next;
	} else {
		chomp;
		@cols = split;    
		push @array, [ @cols ];
	}
}
$cnt = 0;
foreach (<CPJ>){
	if($_ =~ /set_property RMI1 /){
		s/(^.*set_property RMI1 ).*$/$1$array[$cnt][0]/;
		print NEW $_;
	} elsif ($_ =~ /set_property RMI2 /) {
		s/(^.*set_property RMI2 ).*$/$1$array[$cnt][1]/;
		print NEW $_;
	} elsif ($_ =~ /set_property RMI3 /) {
		s/(^.*set_property RMI3 )\d.*$/$1$array[$cnt][2]/;
		print NEW $_;
	} elsif ($_ =~ /set_property WMI1 /) {
		s/(^.*set_property WMI1 )\d.*$/$1$array[$cnt][3]/;
		print NEW $_;
	} elsif ($_ =~ /set_property WMI2 /) {
		s/(^.*set_property WMI2 )\d.*$/$1$array[$cnt][4]/;
		print NEW $_;
	} elsif ($_ =~ /set_property WMI3 /) {
		s/(^.*set_property WMI3 )\d.*$/$1$array[$cnt][5]/;
		print NEW $_;
		$cnt += 1;
	} else {
		print NEW $_;
	}
}

close CPJ;
close VAL;
close NEW;
