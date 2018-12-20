##3.6 Single Supply Write and Read Assist Techniques
dual VDD:
disadvantage:
+ first, voltage level shifters are required at the interface between the bitcell array voltage and the logic voltage，thus consume large area;
+ In addition,level shifters introduce additional delay, decrese the speed;
+ Moreover, the power grid design at the chip level becomes challenging since a dedicated power grid is required for memories, which adds cost due to routing and extra metal
resources required to distribute the additional power supply. For SoC，srams are placed in different places, This makes it difficult to have a dedicated power grid for all the memories
### Write Assit
1 . decrease supply voltage
	+ lowering the bitcell supply voltage improves write margin, since the PMOS pull-up is weaker
![[write assit]floating the bitcell supply](D:\CPU_Manny\EDA\circuit\SRAM\ISSCCpaper study\[write assit]floating the bitcell supply.png)
	+ disadvantage, float the bitcell supply power  may cause the bitcells on the same column to lose data due to retention failures
2 . Negative Bitline
	+ improving the strength of the NMOS passgate by applying a small negative bitline voltage(~-200mv)
3 . Wordline Boosting
### read Assit
1. Wordline Under-Drive
	+ Lowering the wordline voltage in read operation decreases the pass-gate strength and improves the read stability. 



