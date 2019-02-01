#!/usr/bin/perl

system ('mkdir -p newlib');
while($lib=glob("*.lib"))
{
	open (LIB,"$lib") || die ("can not open the lib $lib\n");
	$newlib = "newlib/$lib";
	open (NEWLIB,">$newlib") || die ("can not write new timinglib $newlib\n");
	@libline=<LIB>;
	foreach $libline(@libline)
	{
		if($libline =~ /^\s*pg_pin\s*\(\s*vdd0\s*\)\s*\{/)
		{
			$flag=1;
			print NEWLIB $libline;
		}
		elsif(($flag == 1) && ($libline =~ /^\s*\}/))
		{
			$flag = 0;
			print NEWLIB "      direction : internal;\n";
			print NEWLIB "      switch_function :\"psoin\";\n";
			print NEWLIB "      pg_function : \"vddp\";\n";
			print NEWLIB $libline;
		}
		elsif($libline =~ /^\s*cell\s*\(\s*\S*\s*\)\s*\{/)
		{
			print NEWLIB $libline;
			print NEWLIB "      switch_cell_type : fine_grain;\n";
		}
		elsif($libline =~ /^\s*pin\s*\(\s*psoin\s*\)\s*\{/)
		{
			$pin = 1;
			print NEWLIB $libline;
		}
		elsif(($pin == 1) && ($libline =~ /^\s*direction\s*\:\s*input\s*\;/))
		{
			$pin =0;
			print NEWLIB $libline;
			print NEWLIB "      switch_pin : true;\n";
		}
		else
		{
			print NEWLIB $libline;
		}
	}
	close(LIB);
	close(NEWLIB);
}



