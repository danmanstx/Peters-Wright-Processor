`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//n_bit_shifter.v
//
//A shifter that implements the following function table:
//    ctrl funct
//    0    LSL A by B
//    1    LSR A by B
//
///////////////////////////////////////////////////////////////////////////////////////
module n_bit_shifter(a, b, f, ctrl);
    parameter max_s_bits = 3;           //d_width = 2**max_s_bits
    input [(2**max_s_bits)-1:0] a;      //A input (data to shift)
    input [max_s_bits-1:0] b;      //B input (shifting input)
    output [(2**max_s_bits)-1:0] f;     //output
    input ctrl;                         //ctrl input
    
    wire [3*(2**max_s_bits)-3:0] w;     //wires
    assign w[3*(2**max_s_bits)-3:2*(2**max_s_bits)-1] = 0;
    assign w[2*(2**max_s_bits)-2:(2**max_s_bits)-1] = a;
    assign w[(2**max_s_bits)-2:0] = 0;
    wire [max_s_bits:0] sel;
    wire not_ctrl;
    assign sel[max_s_bits] = ctrl;
    assign not_ctrl = ~ctrl;
    genvar i;
    
    generate
    for(i = 0; i < max_s_bits; i = i + 1)
    begin:xors
        xor (sel[i],not_ctrl,b[i]);
    end
    endgenerate    
    
    generate
    for(i = 0; i < 2**max_s_bits; i = i + 1)
    begin:muxes
        MUX_mxn #(.d_width(1),.s_lines(max_s_bits+1)) MUX ({w[2*(2**max_s_bits)-2+i:(2**max_s_bits)-1+i],w[(2**max_s_bits)-1+i:i]}, sel, f[i]);
    end
    endgenerate

endmodule
