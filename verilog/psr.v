`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//psr0.v
//
//The pipeline stage register between stages 0 and 1.
//  clear when clr = 0
//  load left side when c_l = 1
//  shift left to right when c_r = 1
//  load only Ri when ld_ri = 1
//
///////////////////////////////////////////////////////////////////////////////////////
module psr(in, out, c_left, c_right, ld_ri, bubble, bubble_clr, clr, clk);
    parameter size = 34;
    parameter ri_lsb = 8;
    input [size-1:0] in;
    output reg [size-1:0] out;
    reg [size-1:0] in_data;
    input c_left;
    input c_right;
    input ld_ri;
    input bubble;
    input bubble_clr;
    input clr;
    input clk;
    
    reg [1:0] bubble_reg;
    
    always@(posedge clk)
    begin
        if(clr == 0)            //clear to 0s
        begin
            out <= 0;
            in_data <= 0;
            bubble_reg <= 0;
        end
        else if(bubble == 1)
        begin
            out <= 0;
            in_data <= 0;
            bubble_reg <= 1;
        end
        else
        begin
            if(ld_ri == 1 && bubble_reg == 0)          //load ri
            begin
                in_data[ri_lsb-1:0] <= in_data[ri_lsb-1:0];
                in_data[ri_lsb+7:ri_lsb] <= in[ri_lsb+7:ri_lsb];
                in_data[size-1:ri_lsb+8] <= in_data[size-1:ri_lsb+8];
            end
            else if(c_left == 1 && bubble_reg == 0)    //load all
                in_data <= in;
            else                    //store
                in_data <= in_data;
            if(bubble_clr == 1 && bubble_reg != 0)     //bubble
            begin
                bubble_reg <= bubble_reg - 1;
            end
            else if(c_right == 1)                   //shift right
                out <= in_data;
            else                    //store
                out <= out;
        end
    end
    
endmodule
