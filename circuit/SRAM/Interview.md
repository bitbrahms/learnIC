###Round – 1
+ The interviewer initially started by asking me about my previous job and all the works that I have so far done. 
+ After a little discussion on that he went straight to one of my memory based project listed in my resume and started questioning my work and approach towards that project. 
+ As my project was based on Write Assists in SRAM, he began questioning me about the method and the approach that I have used in my project,.
+ then he asked me about the Write Margin in SRAM, I explained the Write Margin with respect to the Voltage Domain but he wanted me to explain the same in the Time Domain which I tried with the best I could make out. 
+ Then he asked me about the Read Margin in SRAM which I convincingly told him the SNM (Static Noise Margin). Then he asked me about the most critical timing parameter in Read Operation which I told him that it is the discharging of BL. 
+ Then the discussion went to the Low Power Approach that was in my project and he countered questioned me on my implemented approaches. 
+ After that he questioned me about the implemented Assists circuit impacting the Read operation and Retention Noise Margin which I explained satisfactorily to him.
+ Then, after some little discussion here and there on Sense Amplifier and decoder +
+ he shifted to some basic things starting with the Setup and Hold definition and putting some cross questions to test it like what happens if you have a hold violation at the second flop of the shift register and how will you remove it. 
+ Then he stared asking questions on CMOS basics part where the discussion went on like how would you improve the Slew of the transistor output, the answer to that is by up sizing the width 
+ then he asked me about the variation of threshold voltage with temperature and asked the reason for every answer that I gave. 
###Round – 2
+ The second round started with the discussion on Inverter basics like what will happen if we connect the input of the Inverter to its own output and initialize it to logic zero.
+  Then again there was a discussion on dependency of threshold voltage on temperature and doping. 
+  Then he asked me about the different margins for the Memory that I know. I told him what I knew,.
+  then he asked me about my project on SRAM and asked me to tell the Pros and Cons of the different techniques I have used to implement the Assists Circuit. 
+  Meanwhile in the discussion the word Process variations came and then he asked me about the types of process variation that can occur and why. I told him all that I can but he was not satisfied until I told him about the variation due to fluctuations in the Doping Density. 
+  Then he asked me general things regarding SPICE simulations like what do you need in order to simulate a circuit etc. 
+  Then he asked me about the things I have done to Verify a certain designs, I told him that I wrote directed Test Benches and Test Cases to cover the critical cases for the design.
+ Finally the discussion ended with a general talk on salary amount and my expectation. The Third round was a face to face interview consisting technical and H.R discussion alike.
overall it was a very good discussion and enriching experience. For those trying out in Memory Design or in Back End Design, I would say get very through with the basics and don’t go through the question banks available on internet directly. Prior to that ‘READ the following BOOKS’ thoroughly
	`(1) CMOS Digital Integrated Circuits: Analysis and Design`
	`(2) Digital Integrated Circuits: A Design Perspective`
These are the ones to start with.
Also make sure that for a Telephonic Interview you have balance and network in your phone, because this mistake happens most of the time and Interview gets messed up. Any queries and discussion please comment below.
###low power
+ In the above case, it was reducing the supply voltage of the Bit Cell in order to reduce the leakage current, in turn the static power loss. The idea was to use assist to close margins even at low supply voltage. So if we can have same margins with the help of assist at low supply voltage as compared to what we have without assists at higher supply voltage then we can reduce the supply voltage which in turn affects the power consumption in a big way. 
+ Apart from this conventional techniques for power saving can also be used in a bit cell, if you are ready to compromise on timings then you can use high Vt devices in the cell. Power gating is one another option which is being used, The idea is to lower down the suppl voltage when the cell is not being used, but it should be powered on in order to retain the data.
+  Apart from bit cell when you go on the full cut the dynamic powers of bit lines charging and discharging can be reduced by techniques like selective precharges