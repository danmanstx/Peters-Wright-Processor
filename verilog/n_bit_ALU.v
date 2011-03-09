`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:54:51 02/02/2011 
// Design Name: 
// Module Name:    n_bit_ALU 
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
module n_bit_ALU(a,b,cin,ctrl,f,cout,v,z);
	parameter n=4;
	input [n-1:0] a;
	input [n-1:0] b;
	input cin;
	input [1:0] ctrl;
	output [n-1:0] f;
	output cout,v,z;
	
	wire [n:0] carry;
	wire [n-1:0] or_chain;
	assign carry[0] = cin;
	assign cout = carry[n];
	assign or_chain[0] = f[0];
	genvar i;
	
	generate	//create bistlice instances
	for(i = 0; i < n; i = i + 1)
	begin:alu_loop
		//ALU_bitslice(a,b,cin,ctrl,fout,cout);
		ALU_bitslice BSLICE (a[i],b[i],carry[i],ctrl,f[i],carry[i+1]);
	end
	for(i = 0; i < n - 1; i = i + 1)
	begin:or_loop
		or OR (or_chain[i+1],f[i+1],or_chain[i]);
	end
	endgenerate
	
	//overflow
	xor(v,carry[n-1],carry[n]);
	//zero
	not(z,or_chain[n-1]);

endmodule
