`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//ls_reg.v
//
//A bitslice load-store-shift bitslice that uses the following function table:
//    c    clr  funct
//    xx   0    clear register to 0s
//    00   1    store
//    01   1    shift left
//    10   1    load
//    11   1    shift right
//
///////////////////////////////////////////////////////////////////////////////////////
module lss_reg_bitslice(in,l_in,r_in,c,clr,clk,out);
	input in,l_in,r_in,clr,clk;
	input [1:0] c;
	output out;
	wire w;
	
	//MUX_4x1(in,sel,out);
	MUX_4x1 MUX0 ({l_in,in,r_in,out},c,w);
	
	//D_flip_flop(d_in,clr,set,clk,q);
	D_flip_flop DFLOP0 (w,clr,1'b1,clk,out);
endmodule
