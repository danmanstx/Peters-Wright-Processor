`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:43 02/07/2011 
// Design Name: 
// Module Name:    lss_reg 
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
module lss_reg(in,c,clr,clk,out);
	parameter n = 4;	//n >= 2
	input [n-1:0] in;
	input [1:0] c;
	input clr,clk;
	output [n-1:0] out;
	
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
