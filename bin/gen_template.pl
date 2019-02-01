#!/usr/bin/perl -w
open tcl_file,'>temp.tcl';

$cellname="it_way";
$clk="eeph1";
@pin_input = qw/ enable wren indx wrval	wrtag/;
@pin_output= qw/valb tagb/;
@pin       = qw/ enable wren indx wrval	wrtag valb tagb/;
@bit_input = qw/     1           1         6		 1			29               /;
@bit_output= qw/1     29/;
@bit_pin   = qw/	 1  		 1 		   6	     1			29		1	  29	/;
$enable="enable";
$wren  ="wren";

print tcl_file "
set_var def_arc_msg_level 0 
set_var max_transition 2.4e-10 
set_var min_transition 1e-11 
set_var min_output_cap 6.536e-15 \n";

print tcl_file "set cells {\\
	$cellname\\
	} \n";

print tcl_file "
		 define_template -type constraint \\
		 -index_1 {0.001 0.004 0.012 0.036 0.120 } \\
		 -index_2 {0.001 0.004 0.012 0.036 0.120 } \\
		 constraint_template_5x5 \n";

print tcl_file "
         define_template -type delay \\
		 -index_1 {0.001 0.004 0.012 0.036 0.120 }\\
		 -index_2 {0.002709 0.003959 0.006459 0.011459 0.021459 0.041459 0.081459 } \\
		 delay_template_5x7 \n";

print tcl_file "
         define_template -type power \\
		 -index_1 {0.001 0.004 0.012 0.036 0.120 } \\
		 -index_2 {0.002709 0.003959 0.006459 0.011459 0.021459 0.041459 0.081459 } \\
		 power_template_5x7 \n";

print tcl_file "define_cell \\
		-clock { $clk } \\
		-input { $pin_input[0] $pin_input[1] ${pin_input[2]}[11:6] $pin_input[3] ${pin_input[4]}[40:12] vddp psoin0 psoin1} \\
		-output {$pin_output[0] ${pin_output[1]}[40:12] psoout0 psoout1} \\
		-delay delay_template_5x7 \\
		-power power_template_5x7 \\
		-constraint constraint_template_5x5 \\
       $cellname \n\n";

$num=0;
$out_num=0;
$power_num=0;
print tcl_file "\n#######constraint arc###################\n";
foreach $temp (@pin_input)
{	&constraint_arc($temp,$bit_input[$num]);
	$num++;
}

print tcl_file "#######delay arc#######################\n";
foreach $outpin(@pin_output)
{	&delay_arc($outpin,$bit_output[$out_num]);
	$out_num++;
}

print tcl_file "#######power arc#######################\n";
foreach $pin (@pin)
{	&power_arc($pin,$bit_pin[$power_num]);
	$power_num++;
}

print tcl_file "######clock power ######################\n";
	
	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {$wren&$enable}\\
       -pin_dir R\\
       -pin {eeph1}\\
       $cellname \n\n";

	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {$wren&$enable}\\
       -pin_dir F\\
       -pin {eeph1}\\
       $cellname \n\n";


	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {$wren&!$enable}\\
       -pin_dir R\\
       -pin {eeph1}\\
       $cellname \n\n";

	print tcl_file 
	   "define_arc\\
       -type power\\
       -when {$wren&!$enable}\\
       -pin_dir F\\
       -pin {eeph1}\\
       $cellname \n\n";


	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {!$wren&$enable}\\
       -pin_dir R\\
       -pin {eeph1}\\
       $cellname \n\n";

	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {!$wren&$enable}\\
       -pin_dir F\\
       -pin {eeph1}\\
		$cellname \n\n";


	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {!$wren&!$enable}\\
       -pin_dir R\\
       -pin {eeph1}\\
        $cellname \n\n";

	print tcl_file 
	   "define_arc \\
       -type power\\
       -when {!$wren&!$enable}\\
       -pin_dir F\\
       -pin {eeph1}\\
       $cellname \n\n";

print tcl_file "#### leakage arc #################\n";
print tcl_file "define_leakage -when {!$wren & !$enable}  $cellname \n";
print tcl_file "define_leakage -when {!$wren &  $enable}  $cellname \n";
print tcl_file "define_leakage -when { $wren & !$enable}  $cellname \n";
print tcl_file "define_leakage -when { $wren &  $enable}  $cellname\n\n";

close tcl_file;

sub constraint_arc
{
	$arc_pin = $_[0];
	$arc_bit = $_[1];
	if ($arc_bit == 1)
	{	
	print tcl_file 
	   "define_arc \\
       -type setup \\
       -related_pin_dir R -pin_dir R \\
       -related_pin {$clk} \\
       -pin {$arc_pin}  \\
        $cellname\n\n";

	print tcl_file 
	   "define_arc \\
       -type setup \\
       -related_pin_dir R -pin_dir F \\
       -related_pin {$clk} \\
       -pin {$arc_pin}  \\
        $cellname\n\n";

 	print tcl_file 
	   "define_arc \\
       -type hold \\
       -related_pin_dir R -pin_dir R \\
       -related_pin {$clk} \\
       -pin {$arc_pin}  \\
        $cellname\n\n";

	print tcl_file 
	   "define_arc \\
       -type hold \\
       -related_pin_dir R -pin_dir F \\
       -related_pin {$clk} \\
       -pin {$arc_pin}  \\
        $cellname\n\n";
	}
	else	
	{
		for($j = 0;$j < $arc_bit;$j++)
			{
	       
	print tcl_file 
	   "define_arc \\
       -type setup \\
       -related_pin_dir R -pin_dir R \\
       -related_pin {$clk} \\
       -pin {${arc_pin}[$j:$j]}  \\
        $cellname\n\n";

	print tcl_file 
	   "define_arc \\
       -type setup \\
       -related_pin_dir R -pin_dir F \\
       -related_pin {$clk} \\
       -pin {${arc_pin}[$j:$j]}  \\
        $cellname\n\n";

 	print tcl_file 
	   "define_arc \\
       -type hold \\
       -related_pin_dir R -pin_dir R \\
       -related_pin {$clk} \\
       -pin {${arc_pin}[$j:$j]}  \\
        $cellname\n\n";

	print tcl_file 
	   "define_arc \\
       -type hold \\
       -related_pin_dir R -pin_dir F \\
       -related_pin {$clk} \\
       -pin {${arc_pin}[$j:$j]}  \\
        $cellname\n\n";

			}
	}
}

sub delay_arc
{   $arc_out_pin = $_[0];
	$arc_out_bit = $_[1];
	if($arc_out_bit == 1)
	{
		print tcl_file 
	   "define_arc \\
       -related_pin_dir R -pin_dir R \\
       -related_pin {$clk} \\
       -pin {$arc_out_pin}  \\
        $cellname\n\n";

		print tcl_file 
	   "define_arc \\
       -related_pin_dir R -pin_dir F \\
       -related_pin {$clk} \\
       -pin {$arc_out_pin}  \\
        $cellname\n\n";
	
		print tcl_file 
	   "define_arc \\
		-type retain \\
       -related_pin_dir R -pin_dir R \\
       -related_pin {$clk} \\
       -pin {$arc_out_pin}  \\
        $cellname\n\n";

		print tcl_file 
	   "define_arc \\
	   -type retain \\
       -related_pin_dir R -pin_dir F \\
       -related_pin {$clk} \\
       -pin {$arc_out_pin}  \\
        $cellname\n\n";
		
	}
	else
	{	
			for($j = 0;$j < $arc_out_bit;$j++)
			{ 
			print tcl_file 
	 	    "define_arc \\
       		-related_pin_dir R -pin_dir R \\
       		-related_pin {$clk} \\
       		-pin {${arc_out_pin}[$j:$j]}  \\
        	$cellname\n\n";

			print tcl_file 
	   		"define_arc \\
       		-related_pin_dir R -pin_dir F \\
       		-related_pin {$clk} \\
       		-pin {${arc_out_pin}[$j:$j]}  \\
        	$cellname\n\n";

 			print tcl_file 
	   		"define_arc \\
	   		-type retain\\
       		-related_pin_dir R -pin_dir R \\
       		-related_pin {$clk} \\
       		-pin {${arc_out_pin}[$j:$j]}  \\
        	$cellname\n\n";

			print tcl_file 
	  	   "define_arc \\
	   		-type retain\\
       		-related_pin_dir R -pin_dir F \\
       		-related_pin {$clk} \\
       		-pin {${arc_out_pin}[$j:$j]}  \\
        	$cellname\n\n";
			}
	}
}

sub power_arc

{
	$arc_power_pin = $_[0];
	$arc_power_bit = $_[1];
	if ($arc_power_bit == 1)
	{	
	print tcl_file 
	   "define_arc \\
       -type power \\
       -pin_dir R \\
       -pin {$arc_power_pin}  \\
        $cellname\n\n";

	print tcl_file 
	   "define_arc \\
       -type power \\
	   -pin_dir F \\
       -pin {$arc_power_pin}  \\
        $cellname\n\n";

	}
	else	
	{
		for($j = 0;$j < $arc_power_bit;$j++)
			{
	       
	print tcl_file 
	   "define_arc \\
       -type power \\
       -pin_dir R \\
       -pin {${arc_power_pin}[$j:$j]}  \\
        $cellname\n\n";

	print tcl_file 
	   "define_arc \\
       -type power \\
       -pin_dir F \\
       -pin {${arc_power_pin}[$j:$j]}  \\
        $cellname\n\n";

			}
	}

}



