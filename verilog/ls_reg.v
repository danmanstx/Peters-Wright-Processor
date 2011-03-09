`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:20 02/07/2011 
// Design Name: 
// Module Name:    ls_reg 
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
module ls_reg(in,c,clr,clk,out);
	parameter n = 4;
	input [n-1:0] in;
	input c,clr,clk;
	output reg [n-1:0] out;
	
	always@(posedge clk)
	begin
		if(clr == 0)	//clear to 0s
		begin
			out <= 0;
		end
		else if(c == 1)	//load
		begin
			out <= in;
		end
		//otherwise value is stored
	end
	
endmodule
