`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:32:24 03/08/2011 
// Design Name: 
// Module Name:    MUX_mxn 
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
module MUX_mxn(in,sel,out);
	parameter s_lines = 2;		//number of select lines (total input vectors = 2**m)
	parameter d_width = 4;		//input vector bus width
	input [d_width * (2**s_lines) - 1 : 0] in;	//input vectors
	input [s_lines - 1 : 0] sel;						//select lines
	output reg [d_width - 1 : 0] out;				//output vector
	integer i,j;
	
	always@(in or sel)
	begin
		j = sel;
		for(i = 0; i < d_width; i = i + 1)
		begin
			out[i] = in[d_width * j + i];
		end
	end

endmodule
