`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:41:17 04/19/2011 
// Design Name: 
// Module Name:    sign_extend 
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
module sign_extend(in, out);
	 input [5:0]in;
    output[7:0]out;

	assign out[0] = in[0];
	assign out[1] = in[1];
	assign out[2] = in[2];
	assign out[3] = in[3];
	assign out[4] = in[4];
	assign out[5] = in[5];
	assign out[6] = in[5];
	assign out[7] = in[5];

endmodule
