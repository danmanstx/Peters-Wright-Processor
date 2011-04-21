`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//ls_reg.v
//
//A parameterized load/store register implementing the following control table:
//    c    clr  funct
//    x    0    clear register to 0s
//    0    1    store
//    1    1    load from input
//
///////////////////////////////////////////////////////////////////////////////////////
module ls_reg(in, c, clr, clk, out);
    parameter n = 4;            //register size in bits
    input [n-1:0] in;           //load input
    input c;                    //control line
    input clr;                  //synchronous active-low clear
    input clk;                  // clock
    output reg [n-1:0] out;     //output
    
    always@(posedge clk)
    begin
        if(clr == 0)            //clear to 0s
        begin
            out <= 0;
        end
        else if(c == 1)         //load
        begin
            out <= in;
        end
        else                    //c == 0, so store
        begin
            out <= out;
        end
    end
    
endmodule
