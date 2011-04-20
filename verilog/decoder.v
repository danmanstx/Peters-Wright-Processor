`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//decoder.v
//
//A simple parameterized decoder.
//
///////////////////////////////////////////////////////////////////////////////////////
module decoder(in,out,enable);
    paramter n;
    input [n-1:0] in;
    output reg [2**n-1:0] out;
    input enable;
    integer i;
    
    always@(input or enable)
    begin
        if(enable == 0)     //disabled
        begin
            for(i = 0 ; i < 2**n ; i = i + 1)
            begin
                out[i] = 1'b0;
            end
        end
        else
        begin
            for(i = 0 ; i < 2**n ; i = i + 1)
            begin
                if(in == i)
                    out[i] = 1;
                else
                    out[i] = 0;
            end
        end
    end
    
endmodule
