`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//MUX_mxn.v
//
//A parameterized multiplexer.
//
///////////////////////////////////////////////////////////////////////////////////////
module MUX_mxn(in, sel, out);
    parameter s_lines = 4;  //number of select lines (total input vectors = 2**m)
    parameter d_width = 1;  //input vector bus width
    input [d_width * (2**s_lines) - 1 : 0] in;  //input vectors
    input [s_lines - 1 : 0] sel;                //select lines
    output reg [d_width - 1 : 0] out;           //output vector
    integer i,j;
    
    always@(in or sel)
    begin
        j = sel;
        for(i = 0; i < d_width; i = i + 1)
        begin
            out[i] = in[d_width * j + i];
        end
    end

endmodule
