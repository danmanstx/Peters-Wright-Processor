`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//n_bit_ALU.v
//
//An ALU that implements the following function table:
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
//Having the following outputs:
//    f     result
//    v     v=1 if overflow
//    z     z=1 if f=0
//    cout  carry out
//
///////////////////////////////////////////////////////////////////////////////////////
module n_bit_ALU(a,b,cin,ctrl,f,cout,v,z);
	parameter n;			//data width
	input [n-1:0] a;		//A input
	input [n-1:0] b;		//B input
	input cin;				//carry in (inverts B)
	input [1:0] ctrl;		//control inputs
	output [n-1:0] f;		//output
	output cout;			//carry out
	output v;				//v=1 if overflow
	output z;				//z=1 if f=0
	
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
