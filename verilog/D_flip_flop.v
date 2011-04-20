`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//D_flip_flop.v
//
//A D flip flop with synchronous active low clear (priority) and set.
//
///////////////////////////////////////////////////////////////////////////////////////
module D_flip_flop(d_in,clr,set,clk,q);
    input d_in;     //input
    input clr;      //synchronous active low clear (priority)
    input set;      //synchronous active low set
    input clk;      //clock
    output reg q;   //output
    
    always@(posedge clk)
    begin
        if(clr == 1'b0)
            q <= 0;
        else if(set == 1'b0)
            q <= 1;
        else
            q <= d_in;
    end
endmodule

