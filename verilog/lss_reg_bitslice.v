`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:35 02/07/2011 
// Design Name: 
// Module Name:    lss_reg_bitslice 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
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
