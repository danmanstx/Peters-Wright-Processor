`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:44 02/04/2011 
// Design Name: 
// Module Name:    n_bit_PC 
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
module n_bit_PC(ld_in,ctrl,clr,clk,out);
	parameter n=4;
	input [n-1:0] ld_in;
	input [1:0] ctrl;
	input clr,clk;
	output reg [n-1:0] out;
	
	always@(posedge clk)
	begin
		if(clr == 1'b0)
			out <= 0;
		else
		begin
			case(ctrl)
			0: out <= out;
			1: out <= out + ld_in;
			2: out <= out + 1;
			3: out <= ld_in;
			default: out <= out;
			endcase
		end
	end
	
endmodule
