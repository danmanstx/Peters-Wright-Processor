`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//comparator.v
//
//                  this functional unit compares two values and outputs 
//                  a one or a zero depending if the first value (A) is bigger
//                  than the second value (B)
//
///////////////////////////////////////////////////////////////////////////////////////
module comparator(A, B, En, out);
    parameter width = 8;            // width of the inputs
    input [width-1:0]A;             // first input called A
    input [width-1:0]B;             // second input called b
    input En;                       // chip enable
    output out;                     // output out
    
    assign out = (En && A==B) ?  1:0;   // if enable and a >= b then output one, else zero
    
endmodule
