**面试环节：** 

由于大多公司并未基于验证出笔试题，所以对IC验证工程师而言，在面试阶段会更多涉及一些SV与UVM相关的思想与应用。 

总结起来,最常考的有： 

- RTL设计思想及代码考察： 

1. IC 开发flow 及个阶段使用的工具。

2. 信号的跨时钟域同步。包括单比特和多比特，对于单比特自然用两级寄存器同步最为方便。对于多比特，常考察异步FIFO以及握手方法。要理解亚稳态的概念以及避免亚稳态的方法。

3. 说到亚稳态，就不得不说setup time 和 hold time。一定要掌握两种时钟约束和分析时钟约束的方法。清楚四种路径（输入到输出，输入到寄存器，寄存器到寄存器，寄存器到输出），并能找到关键路径。会计算最高的工作频率。

   

4. 分析和修复setup time validation（降低时钟频率，组合逻辑优化或拆分，提高工作电压）和 hold time validation（插入buffer，更难修复）。

5. 用verilog描述常用的电路结构，如：D触发器，同步/异步复位，计数器，分频（奇数倍分频，偶数倍分频，小数分频（如1.5倍）），同步FIFO，异步FIFO, 序列检测器（FSM实现）。

6. 用verilog描述给出的代码或者伪代码（可能会给一段C代码，然后据此写出对于的verilog代码）。

7. 找出verilog代码中的错误，如信号未进行跨时钟域同步，无else分支会产生不期望的锁存器等等。

8. 阻塞，非阻塞赋值。

9. ROM、SRAM、DRAM、flash等各类存储器的区别与应用。

10. 掌握一些常用的协议，如I2C（能够根据提示用verilog实现），SRAM协议、AMBA(AHB、AXI、APB、OCP)等。

11. 同步复位与异步复位的优缺点，异步复位设计在使用时应当注意什么？即异步复位同步释放设计，并要画出异步复位同步释放的电路结构。

12. 掌握一些常用的低功耗方法，如clock gating(能画出电路结构图)，了解DVFS，多阈值电压技术，多电压技术。

13. 组合逻辑输出需经过一级寄存器过滤毛刺。

14. clock switch glitch free 电路实现应用与分析（路科验证前段时间的文章《什么？你也不知道这么基础的知识点》中有提及）。

15. 对FIFO的理解，同步FIFO 与异步FIFO异同,谈谈如何判断fifo的空满状态？对于异步fifo，如何处理空满时的同步问题？还可以采用什么方法？计算异步FIFO最小深度。

16. 同步fifo读写时钟相同，异步fifo读写采用不同的时钟。

17. 严格的空满判断： w_ptr==r_ptr且读写回环标志位相同时为空， w_ptr==r_ptr且读写回环标志位不同时为满。这在同步fifo中一般没什么问题，但是在异步fifo中一般要做悲观的空满判断，以免在fifo空时读获fifo满时写。

18. 保守的空满判断：方向标志与门限。设定了FIFO容量的75%作为上限，设定FIFO容量的25%为下限。当方向标志超过门限便输出满/空标志，其实这时输出空满标志FIFO并不一定真的空/满。

19. 同步：读写指针转化为格雷码后再进行同步。

20. FIFO最小深度：考虑背靠背读写情况进行计算。



▼ SV 语法考察 

1. 队列和数组的区别和用法
2. 结构体的使用 
3. 多线程fork ...join,fork ...join_any,fork ...join_none的用法差异 
4. 多线程的同步调度方法（事件、旗语、mailbox） 
5. @signal触发和wait(signal)的区别 
6. 对C++基础的理解（类、继承、多态） 
7. 带约束的随机类的语法和使用（权重约束和条件约束等都会考察） 
8. 在验证环境中，C如何access和dut中寄存器，是如何联系的？以及DPI接口的使用（C方法到SV方法、SV方法到C方法的使用） 
9. Verilog 提供VPI接口，可以将DUT的层次结构开放给外部的C/C++代码,而systemverilog提供了更好的接口：DPI.



▼ UVM的理解考察 

## 1. 请谈谈你对UVM验证方法学的理解。 

UVM验证方法学是基于systemverilog语言形成的一个高效的验证方法。它的主要特点是提高了代码的复用性，使得验证人员能通过代码移植复用修改快速搭建验证平台，
从而将主要精力放在具体测试用例的编写上。另一方面，UVM封装了很多好用的方法，这使得验证人员不必过多关注底层实现，而且减少了验证平台的调试时间。

## 2. 请谈谈UVM的验证环境结构，各个组件间的关系。 

## 3. 举例谈谈UVM组件中的一些常用方法。 

## 4. UVM component 和UVM object 的关系与差异？
继承和生命周期不同，component中有许多phase的函数，而object没有。 

## 5. UVM组件的通信方式（即TLM），TLM接口分类和用法，Peek和get方法的差异

## 6. 请谈谈virtual sequencer与sequencer的区别，以及为什么要用virtualsequencer？ 

- 如果只有一个驱动端agent，显然是不需要使用virtual sequencer的。 
- 如果有多个驱动端agent，但是多个激励之间并无协调关系，virtual sequencer 也并无必要。 
- 如果有多个驱动端agent，而且多个激励之间存在协调关系，那么virtual sequencer就很有必要了。这个时候环境中需要包含一个甚至多个virtual sequencer了。 
- virtual sequence 和virtualsequencer的“virtual”有何含义呢？
- Virtual sequencer 有三个属性： 

(1)Virtual sequencer控制其他的sequencer 

(2)Virtual sequencer并不和任何driver相连 

(3)Virtual sequencer本身并不处理item 

并不像正常的sequencer那样，将sequence item通过sequencer port传递给driver。Virtual sequencer通过一个指向subsequencer目标的句柄来指定sequencer。这里的subsequencer就是和driver相连接的真实sequencer。所谓的virtual就是指真正的sequence并不是在Virtual sequencer里产生和传递的。一个virtual sequencer可以通过它的subsequencer产生许多种不同类型的tranction。而virtual sequencer的作用就是在协调不同的subsequencer中sequence的执行秩序了。



## 7. 为什么会有sequence,sequencer,以及driver，为什么要分开实现？这样做有什么好处？ 

最初的验证平台，只需要driver即可，为什么还需要sequence机制？ 

(1).如果事务在driver里定义，会产生一个问题。比如事务种类繁多，岂不是每次启动一个事务，都要修改driver的main_phase代码部分。 

(2).如果定义多个driver，那么会把UVM树形结构搞的乱七八糟。所以，要从driver里剥离事务产生（具体包括事务定义、事务产生的步骤）的代码部分。driver只负责事务驱动即可。 

(3).补充一句，验证的case_list，是用sequence机制去实现的；并保证了UVM树形结构的单一性、统一性。使得可维护的能力大大加强。 

上述解释，也是sequence和sequence_item不属于uvm_componet的原因。case相关的代码改动，都在sequence和sequence_item里实现。 

## 8.为什么要尽量避免绝对路径的使用？如何避免？ 

绝对路径的使用大大减弱了验证平台的可移植性。避免的方法是使用宏和interface.

## 9. 如何在driver中使用interface？为什么？ 

由于driver是类，而在类中不允许直接使用interface，所以在类中使用的是virtual interface。然后再top_tb中通过uvm_config_db#(virtual)::set()…的方式将if set到driver 的vif. 

## 10. 你了解UVM的factory与callback机制吗？ 

callback机制最大的用处就是提高验证平台可重用性。它通过将两个项目不同的地方使用callback函数来做，而把相同的部分写成一个完整的env，这样重用时，只要改变相关的callback函数,env可以实现完全的重用。 

此外，callback还用于构建异常的测试用例，通过factory机制的重载也可以实现这一点。

## 11. OVM和UVM有什么区别？ 

OVM没有寄存器解决方案，也有factory机制，然而cadance推出RGM之后补上了这一短板，但使用RGM需要额外下载，没有成为OVM的一部分。OVM现在已经停止更新。 

UVM几乎完全继承 OVM，同时又采纳了synopsysVMM中的RAL寄存器解决方案，同时吸收了VMM的一些优秀的实现方式。由mentor和candence2008年联合发布。 

## 12. UVM各component之间是如何组织运行的，是串行的还是并行的？如果串行的，请问是通过什么机制实现各组件之间的运行调度的？ 

关于UVM的运行机制，学过UVM的应该都很清楚了，无非是各组件之间的关系，以及Phase机制等等。UVM其实质是软件，而软件本质上都是顺序运行的，dut硬件是并行运行的。关于各组件之间的运行调度，仅仅从《UVM实战》这本书上是得不到答案的，时候我有翻看了SV绿皮书，感觉从中找到了答案。测试平台的调度是通过事件触发驱动的（如@，->event）。 

## 13. 介绍UVM的phase机制，buildphase 和connect phase的执行顺序，
run phase 与build phase的主要区别build phase自顶向下，connect phase自底向上。 

run phase 通常要耗时，build phase 不耗时。 

## 14. UVM启动一个sequence的方法 

## 15. config_db的作用？以及其使用时传递的几个参数的含义







▼ 基本验证思想的理解 

1, 请描述一下你所验过的模块的功能。 

\2. 请谈谈验证的思想，验证人员和设计人员思考问题的差异。 

验证永远是不充分的，永远是没有最好的，用一个同事的话说，如果非要给验证订一个期限的话，我希望是一万年。 

目前通用的做法是看coverage. 

(1) 看design spec 

(2) 了解相关协议 

(3) 编写test plan及verificationspec 

(4) 搭建验证平台 

(5) 依据testplan创建测试用例testcases 

(6) 仿真和debug,包括环境和design的bug,花费时间最多。工具是VCS/verdi 

debug的手段主要有：查看log，看波形 

(7) regression 和覆盖率 

(8) code review 

\3. 你写过assertion吗？assertion分为哪几种？简单描述下assertion的用法。 

Systemverilog断言属于验证方法中的一种，断言(assertions)就是对设计属性(property行为)的描述，如果一个属性不是我们期望的那样，那么断言就会失败。assertions与verilog相比，verilog是一种过程性语言。它的设计目的是硬件描述，它可以很好的控制时序，但是描述复杂的时序关系，代码较为冗长，assertions是一种描述性语言，设计目的为仿真验证，可以有很多内嵌的函数来测试特定的时序关系和自动收集覆盖率数据。 

SVA分为并发断言和即时断言两种。并发断言是基于时钟周期的，在时钟边沿计算表达式，它可以放在模块(module)，接口(interface)，或程序块(program)的定义中，以关键词“property”来定义，可以在静态验证工具和动态验证工具中使用。即时断言是基于事件的变化，表达式的计算像verilog中的组合逻辑赋值一样，是立即被求值的，与时序无关，必须放在过程块中定义。 

并发assertions： 

property a2b_p; //描述属性 

@(posedge sclk) $rose(a) |->[2:4]$rose(b); 

endproperty 

a2b_a: assert property(a2b_p); //assertproperty SVA的关键字表示并发断言 

a2b_c: cover property(a2b_p); //覆盖语句



\4. 你们项目中都会考虑哪些coverage? 

Line coverage, condition coverage,branchcoverage, toggle coverage, statement coverage（FSM） 

\5. coverage一般不会直接达到100%，当你发现有condition未cover到的时候你该怎么做？ 

编写定向测试用例（direct case） 

6.Function coverage和codecoverage的区别，以及它们分别对项目的意义。 

这是两个衡量验证完成度的重要指标。Function coevrage 需要验证工程师基于对于设计功能的理解，自己定义需要的cover groups，通过这种方式以确保一些重要的功能点被验证到。基于我们写的激励，仿真器会自动收集code coverage，通过这种方式更直观的衡量我们的验证进度，但是code coverage只能保证我们的激励会激活哪些代码，而不能保证代码的正确性，即使code coverage达到100%，也不能说明我们的RTL没有BUG存在。 

7.对一个加密模块和解密模块进行验证，如果数据先进行加密紧接着进行解密，如果发现输入数据与输出数据相同，能不能说明这两个加解密模块功能姐没有问题？为什么？ 

看到这道题，当时的反应就是应该首先分别对加密模块进行验证，如果没有问题，再一起进行验证。但是面试官对这个问题貌似并不满意，问我为什么直接验就不行呢？我当时一下子也说不出原因。  

**总结：** 

总体上讲，基础知识部分并不会很难，都是真实项目中常用的。其中关于System verilog 和UVM的考查内容，大部分都能在路桑之前的文章中找到答案和示例，读者可以查看之前的文章。强烈期待路桑的纸质版图书快点出版。师弟师妹们在找工作之前可以对照此面经，将自己的知识梳理一下，更从容的面对面试官的考核，希望大家都可以找到一份满意的工作！

1. 先简单谈谈你现在在做的工作。
2. 请谈谈你在学校的学习和项目。
3. 请谈谈你对UVM验证方法学的理解。

UVM验证方法学是基于systemverilog语言形成的一个高效的验证方法。它的主要特点是提高了代码的复用性，使得验证人员能通过代码移植复用修改快速搭建验证平台，从而将主要精力放在具体测试用例的编写上。另一方面，UVM封装了很多好用的方法，这使得验证人员不必过多关注底层实现，而且减少了验证平台的调试时间。

1. 请谈谈UVM组件的关系。
2. 举例谈谈UVM组件中的一些常用方法。
3. 请谈谈virtual sequencer与sequencer的区别，以及为什么要用virtual sequencer？

如果只有一个驱动端agent，显然是不需要使用virtual sequencer的。

如果有多个驱动端agent，但是多个激励之间并无协调关系，virtual sequencer 也并无必要。

如果有多个驱动端agent，而且多个激励之间存在协调关系，那么virtual sequencer就很有必要了。这个时候环境中需要包含一个甚至多个virtual sequencer了。

virtual sequence 和virtual sequencer的“virtual”有何含义呢？

Virtual sequencer 有三个属性：

(1)Virtual sequencer控制其他的sequencer

(2)Virtual sequencer并不和任何driver相连

(3)Virtual sequencer本身并不处理item

并不像正常的sequencer那样，将sequence item 通过sequencer port传递给driver。Virtual sequencer通过一个指向subsequencer目标的句柄来指定sequencer。这里的subsequencer就是和driver相连接的真实sequencer。所谓的virtual就是指真正的sequence并不是在Virtual sequencer里产生和传递的。一个virtual sequencer可以通过它的subsequencer产生许多种不同类型的tranction。而virtual sequencer的作用就是在协调不同的subsequencer中sequence的执行秩序了。

1. 为什么会有sequence,sequencer,以及driver，为什么要分开实现？这样做有什么好处？

最初的验证平台，只需要driver即可，为什么还需要sequence机制？

(1).如果事务在driver里定义，会产生一个问题。比如事务种类繁多，岂不是每次启动一个事务，都要修改driver的main_phase代码部分。

(2).如果定义多个driver，那么会把UVM树形结构搞的乱七八糟。所以，要从driver里剥离事务产生（具体包括事务定义、事务产生的步骤）的代码部分。driver只负责事务驱动即可。

(3).补充一句，验证的case_list，是用sequence机制去实现的；并保证了UVM树形结构的单一性、统一性。使得可维护的能力大大加强。

上述解释，也是sequence和sequence_item不属于uvm_componet的原因。case相关的代码改动，都在sequence和sequence_item里实现。

1. 你写过assertion吗？assertion分为哪几种？简单描述下assertion的用法。

Systemverilog断言属于验证方法中的一种，断言(assertions)就是对设计属性(property行为)的描述，如果一个属性不是我们期望的那样，那么断言就会失败。assertions与verilog相比，verilog是一种过程性语言。它的设计目的是硬件描述，它可以很好的控制时序，但是描述复杂的时序关系，代码较为冗长，assertions是一种描述性语言，设计目的为仿真验证，可以有很多内嵌的函数来测试特定的时序关系和自动收集覆盖率数据。

SVA分为并发断言和即时断言两种。并发断言是基于时钟周期的，在时钟边沿计算表达式，它可以放在模块(module)，接口(interface)，或程序块(program)的定义中，以关键词“property”来定义，可以在静态验证工具和动态验证工具中使用。即时断言是基于事件的变化，表达式的计算像verilog中的组合逻辑赋值一样，是立即被求值的，与时序无关，必须放在过程块中定义。

并发assertions：

property a2b_p; //描述属性

@(posedge sclk) $rose(a) |->[2:4] $rose(b);

endproperty

a2b_a: assert property(a2b_p); //assert property SVA的关键字表示并发断言

a2b_c: cover property(a2b_p); //覆盖语句



1. 请描述一下你所验过的模块的功能。
2. 你对fifo熟悉吗？谈谈如何判断fifo的空满状态？

（1）严格的空满判断： w_ptr==r_ptr且读写回环标志位相同时为空， w_ptr==r_ptr且读写回环标志位不同时为满。这在同步fifo中一般没什么问题，但是在异步fifo中一般要做悲观的空满判断，以免在fifo空时读获fifo满时写。

（2）保守的空满判断：方向标志与门限。设定了FIFO容量的75%作为上限，设定FIFO容量的25%为下限。当方向标志超过门限便输出满/空标志，其实这时输出空满标志FIFO并不一定真的空/满。

1. fifo有同步的和异步的，它们有什么区别？

同步fifo读写时钟相同，异步fifo读写采用不同的时钟。

1. 对于异步fifo，如何处理空满时的同步问题？还可以采用什么方法？

读写指针转化为格雷码后再进行同步。

1. 请谈谈验证的思想，验证人员和设计人员思考问题的差异。

验证永远是不充分的，永远是没有最好的，用一个同事的话说，如果非要给验证订一个期限的话，我希望是一万年。

目前通用的做法是看coverage.

(1).看design spec

(2).了解相关协议

(3).编写test plan及verification spec

(4).搭建验证平台

(5).依据testplan创建测试用例testcases

(6).仿真和debug,包括环境和design的bug,花费时间最多。工具是VCS/verdi

debug的手段主要有：查看log，看波形

(7). regression 和覆盖率

(8). code review

1. 你们项目中都会考虑哪些coverage?

Line coverage, condition coverage,branch coverage, toggle coverage, statement coverage（FSM）

1. coverage一般不会直接达到100%，当你发现有condition未cover到的时候你该怎么做？

编写定向测试用例（direct case）

16.为什么要尽量避免绝对路径的使用？如何避免？

绝对路径的使用大大减弱了验证平台的可移植性。避免的方法是使用宏和interface.

1. 如何在driver中使用interface？为什么？

由于driver是类，而在类中不允许直接使用interface，所以在类中使用的是virtual interface。然后再top_tb中通过uvm_config_db#(virtual)::set()…的方式将if set到driver 的vif.

1. 你了解UVM的callback机制吗？

callback机制最大的用处就是提高验证平台可重用性。它通过将两个项目不同的地方使用callback函数来做，而把相同的部分写成一个完整的env，这样重用时，只要改变相关的callback函数,env可以实现完全的重用。

此外，callback还用于构建异常的测试用例，通过factory机制的重载也可以实现这一点。

18.OVM和UVM有什么区别？

UVM = OVM + VMM（RAL）？

OVM没有寄存器解决方案，也有factory机制，然而cadance推出RGM之后补上了这一短板，但使用RGM需要额外下载，没有成为OVM的一部分。OVM现在已经停止更新。

UVM几乎完全继承 OVM，同时又采纳了synopsysVMM中的RAL寄存器解决方案，同时吸收了VMM的一些优秀的实现方式。又mentor和candence2008年联合发布。

19.UVM各component之间是如何组织运行的，是串行的还是并行的？如果串行的，请问是通过什么机制实现各组件之间的运行调度的？

关于UVM的运行机制，学过UVM的应该都很清楚了，无非是各组件之间的关系，以及Phase机制等等。UVM其实质是软件，而软件本质上都是顺序运行的，dut硬件是并行运行的。关于各组件之间的运行调度，仅仅从《UVM实战》这本书上是得不到答案的，时候我有翻看了SV绿皮书，感觉从中找到了答案。测试平台的调度是通过事件触发驱动的（如@，

->event）

20.对一个加密模块和解密模块进行验证，如果数据先进行加密紧接着进行解密，如果发现输入数据与输出数据相同，能不能说明这两个加解密模块功能姐没有问题？为什么？

看到这道题，当时的反应就是应该首先分别对加密模块进行验证，如果没有问题，再一起进行验证。但是面试官对这个问题貌似并不满意，问我为什么直接验就不行呢？我当时一下子也说不出原因。

21.在对一个模块仿真的时候发现：如果输入是一个地址addr，发现dut的输出是一个相同的地址addr，但是参考模型的输出是addr1.请分析可能是什么问题导致的？你会怎么去解决？

我首先想到的是，要么dut设计出错，要么参考模型出错。首先需要根据spec的定义检查我们的参考模型有没有问题，如果没有问题，通过仿真对设计进行debug，找designer确认问题和修复。但是面试官依然不满意，她最后指出，我有没有考虑到可能通过配置寄存器让dut工作在不同模式，是不是dut工作在bypass模式，而参考模型工作在其他模式？当时就得自己怎么就没想到呢？有点自惭形秽，可事后细想，发现她的提问方式本身就有问题，提问时没有给出足够多的信息和引导，答不上来也是在情理之中。下来和也参加面试的同学讨论的时候发现，几乎所有人都被问到了同样的问题。
