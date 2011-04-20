`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//ALU_bitslice.v
//
//A binary full adder.
//
///////////////////////////////////////////////////////////////////////////////////////
module BFA(a, b, cin, sum, cout);
    input a,b,cin;
    output sum,cout;
    
    assign cout = (a && b) || (b && cin) || (a && cin);
    assign sum = a ^ b ^ cin;

endmodule
