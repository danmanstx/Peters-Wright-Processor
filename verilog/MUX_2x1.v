`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//MUX_2x1.v
//
//A 2x1 multiplexer.
//
///////////////////////////////////////////////////////////////////////////////////////
module MUX_2x1(in,sel,out);
	input [1:0]in;	//inputs
	input sel;		//select line
	output out;		//output
	
	wire [2:0]w;	//wires
	
	not(w[0], sel);
	and(w[1], in[0], w[0]);
	and(w[2], in[1], sel);
	or(out, w[2], w[1]);

endmodule
