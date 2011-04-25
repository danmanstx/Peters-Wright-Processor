`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//n_bit_adder.v
//
//An n-bit adder with no carry out or carry in.
//
///////////////////////////////////////////////////////////////////////////////////////
module n_bit_adder(a,b,s);
    parameter n = 8;
    input [n-1:0] a;
    input [n-1:0] b;
    output [n-1:0] s;
    wire [n-1:0] c;

    genvar i;
    assign c[0]=0;

    generate
    for(i=0; i < n-1; i=i+1)
    begin:startgen
        BFA bitslice(a[i],b[i],c[i],s[i],c[i+1]);
    end
    endgenerate

    xor finalbitslice(s[n-1],a[n-1],b[n-1],c[n-1]);

endmodule


