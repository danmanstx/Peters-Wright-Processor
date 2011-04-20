`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//ALU_bitslice.v
//
//An ALU bitslice that implements the following function table:
//    ctrl cin  funct
//    00   0    A+B
//    00   1    A-B
//    01   0    A|B
//    01   1    A|~B
//    10   0    A&B
//    10   1    A&~B
//    11   0    ~A
//    11   1    ~B
//
///////////////////////////////////////////////////////////////////////////////////////
module ALU_bitslice(a,b,cin,ctrl,fout,cout);
	input a;				//A input
	input b;				//B input
	input cin;			//carry in (inverts B)
	input [1:0] ctrl; //control inputs
	output fout;		//F output
	output cout;		//carry out
	
	wire [7:0] w;		//wires
	
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
