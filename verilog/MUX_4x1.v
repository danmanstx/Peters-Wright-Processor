`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:19:23 01/24/2011 
// Design Name: 
// Module Name:    MUX_4x1 
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
module MUX_4x1(in,sel,out);
	input [3:0]in;
	input [1:0]sel;
	output out;
	
	assign out = (sel[1] & ((sel[0] & in[3]) | (~sel[0] & in[2]))) | (~sel[1] & ((sel[0] & in[1]) | (~sel[0] & in[0])));

endmodule
