`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:56:12 01/24/2011 
// Design Name: 
// Module Name:    MUX_2x1 
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
module MUX_2x1(in,sel,out);
	input [1:0]in;
	input sel;
	output out;
	wire [2:0]w;
	
	not(w[0], sel);
	and(w[1], in[0], w[0]);
	and(w[2], in[1], sel);
	or(out, w[2], w[1]);

endmodule
