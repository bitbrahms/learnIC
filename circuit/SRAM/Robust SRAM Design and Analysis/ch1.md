### 1.4.5 Soft Errors

当空间中的中子或者来自封装材料的 &alpha; 粒子穿透晶圆时，由此产生的电荷会破坏corecell中的存储node，造成corecell翻转。特别的，随着supply 降低，corecell 内部node存储的电荷随之降低，更增加了这种错误发生的几率；

解决办法是增加redundant column,但会增加write access latency (for encoding) 和read access latency (for detection and correction)。当soft errors 造成的bit error 过多时，此时采用interleaving multiple
words onto same physical row 来解决，如下图所示：

![An interleaved SRAM array structure](D:\CPU_Manny\EDA\Memory\SRAM\Robust SRAM Design and Analysis\An interleaved SRAM array structure.png)

但是这种interleaving 结构也存在一定问题，这种结构易受read-destructive failure and poor read SNM conditions 破坏，写操作存在类似的问题。虽然通过isolated read-port 结构(8T)可以消除read SNM 问题，但是写问题依然无法解决。尤其是在低压或者功耗受限的sram bitcell 设计中。为此，一种可替代版本出现了，如下图：

![A non-interleaved SRAM array structure](D:\CPU_Manny\EDA\Memory\SRAM\Robust SRAM Design and Analysis\A non-interleaved SRAM array structure.png)

这种非interleaved 结构需要更多的hardware和更加复杂的layout，例如每个字线都需要单独的驱动；

## 1.5 SRAM Bitcell Topologies

5T cell ，需要单独的bitline precharge 电压Vpc，且VSS < Vpc < Vdd

![5T bitcell](D:\CPU_Manny\EDA\Memory\SRAM\Robust SRAM Design and Analysis\5T bitcell.png)

8T read and write operations yields a non-destructive read operation or SNM-free
read stability

# Chapter 2 Design Metrics of SRAM Bitcell

### 6T read 

Rise the WL from ‘0’ to ‘1’, result, one of the bitcell sides (node) stores the logical ‘0’; that side of the bitline is discharged through the pass-gate and pull-down transistors.
It is important that the low internal node (Q) should not rise above the trip-point (switching threshold voltage) of the inverter INV-2, to avoid a destructive read operation.
cell ratio :

​						&beta; = $$ \frac{(w/l)_(pull-down)}{(w/l)_(access)} $$ 

通常，&beta;的取值范围为1.25到2.5；&beta;越大，bitcell鲁棒性越好，snm以及$$ \I_(read)$$越大,speed 越快，但是会牺牲面积以及leakage.

### 6T read SNM Meas

The read VTC can be measured by sweeping the voltage at the data storage node Q (or QB) with both bitlines (BL,BLB) and wordline (WL) biased at V*DD *while monitoring the node voltage at QB (or Q).

### 6T write

The write VTC is measured by sweeping the voltage at the storage node Q with BL and WL biased at VDD and BLB is biased at VSS  while monitoring the voltage at node QB. 