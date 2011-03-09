`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:59 02/04/2011 
// Design Name: 
// Module Name:    D_flip_flop 
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
module D_flip_flop(d_in,clr,set,clk,q);
	input d_in,clr,set,clk;
	output reg q;
	
	always@(posedge clk)
	begin
		if(clr == 1'b0)
			q <= 0;
		else if(set == 1'b0)
			q <= 1;
		else
			q <= d_in;
	end
endmodule

