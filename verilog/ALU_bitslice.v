`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:37:33 01/31/2011 
// Design Name: 
// Module Name:    ALU_bitslice 
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
module ALU_bitslice(a,b,cin,ctrl,fout,cout);
	input a,b,cin;
	input [1:0] ctrl;
	output fout,cout;
	wire [7:0] w;
	
	xor XOR0 (w[0],b,cin);	//w[0] = ~b when cin = 1, else w[0] = b
	BFA BFA0 (a,b,cin,w[1],w[6]);
	or OR0 (w[2],a,w[0]);
	and AND0 (w[3],a,w[0]);
	not NOT0 (w[5],a);
	MUX_2x1 MUX0 ({w[0],w[5]},cin,w[4]);
	MUX_4x1 MUX1 (w[4:1],ctrl,fout);
	or OR1 (w[7],ctrl[1],ctrl[0]);
	MUX_2x1 MUX2 ({cin,w[6]},w[7],cout);
	
endmodule
