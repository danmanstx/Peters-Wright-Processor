`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//MUX_4x1.v
//
//A 4x1 multiplexer.
//
///////////////////////////////////////////////////////////////////////////////////////
module MUX_4x1(in, sel, out);
    input [3:0]in;      //input
    input [1:0]sel;     //select lines
    output out;         //output
    
    assign out = (sel[1] & ((sel[0] & in[3]) | (~sel[0] & in[2]))) | (~sel[1] & ((sel[0] & in[1]) | (~sel[0] & in[0])));

endmodule
