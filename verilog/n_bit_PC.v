`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//n_bit_PC.v
//
//A program counter with synchronous active low clear with the following functionality:
//    ctrl clr  funct
//    x    0    clear register to 0s
//    00   1    store
//    01   1    increment by input
//    10   1    increment by 1
//    11   1    load from input
//
///////////////////////////////////////////////////////////////////////////////////////
module n_bit_PC(ld_in,ctrl,clr,clk,out);
    parameter a_width;              //address width parameter
    input [a_width-1:0] ld_in;      //load input
    input [1:0] ctrl;               //control lines
    input clr;                      //synchronous active low clear
    input clk;                      //clear
    output reg [a_width-1:0] out;   //PC out
    
    always@(posedge clk)
    begin
        if(clr == 1'b0)
            out <= 0;
        else
        begin
            case(ctrl)
            0: out <= out;
            1: out <= out + ld_in;
            2: out <= out + 1;
            3: out <= ld_in;
            default: out <= out;
            endcase
        end
    end
    
endmodule
