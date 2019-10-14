#!/usr/bin/perl 
$file = $ARGV[0];
open FILE_OLD, "< $file";
open FILE_NEW, ">$file.new";

@file_org=<FILE_OLD>;

foreach $line (@file_org){
	if($line =~ /^\+/i){
		$up = pop @lib_new;
		chomp($up);
		$line =~ s/^\+//;
		$new = $up.$line;
		push (@lib_new, $new);
	}elsif ( $line =~ /^\s*$/ ){
	
	} else {
		push (@lib_new, $line);	
	}
		
}

foreach $line (@lib_new){
	print FILE_NEW $line;
}

print "\n\ndone!";

close FILE_NEW;
close FILE_OLD;

#`mv $file.new $file`
