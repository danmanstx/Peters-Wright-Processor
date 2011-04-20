`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//ls_reg.v
//
//A parameterized load/store/shift register implementing the following control table:
//    c    clr  funct
//    xx   0    clear register to 0s
//    00   1    store
//    01   1    shift left (leftmost shifts from parallel in MSB)
//    10   1    parallel load
//    11   1    shift right (rightmost shifts from parallel in LSB)
//
///////////////////////////////////////////////////////////////////////////////////////
module lss_reg(in,c,clr,clk,out);
	parameter n;			//XXX n >= 2
	input [n-1:0] in;		//parallel load
	input [1:0] c;			//control
	input clr;				//synchronous active low clear
	input clk;				//clock
	output [n-1:0] out;	//output
	
	genvar i;
	//bitslices 0 and n-1 are different (the shift in is the input)
	lss_reg_bitslice LSSBSLICE0 (in[0],out[1],in[0],c,clr,clk,out[0]);
	lss_reg_bitslice LSSBSLICEN (in[n-1],in[n-1],out[n-2],c,clr,clk,out[n-1]);
	
	generate
	for(i = 1; i < n-1; i = i+1)
	begin:bitslices
		//lss_reg_bitslice(in,l_in,r_in,c,clr,clk,out);
		lss_reg_bitslice LSSBSLICE (in[i],out[i+1],out[i-1],c,clr,clk,out[i]);
	end
	endgenerate
endmodule
