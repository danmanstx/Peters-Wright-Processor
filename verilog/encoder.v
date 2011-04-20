`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//encoder.v
//
//A 4x1 priority encoder with enable line.
//
///////////////////////////////////////////////////////////////////////////////////////
module encoder(in,enable,out,valid);
    input [3:0] in;
    input enable;
    output reg [1:0] out;
    output reg valid;
    
    always@(in or enable)
    begin
        if(enable == 0)
        begin
            out = 2'b00;
            valid = 1'b0;
        end
        else
        begin
            if(in[3] == 1'b1)
            begin
                valid = 1'b1;
                out = 2'b11;
            end
            else if(in[2] == 1'b1)
            begin
                valid = 1'b1;
                out = 2'b10;
            end
            else if(in[1] == 1'b1)
            begin
                valid = 1'b1;
                out = 2'b01;
            end
            else if(in[0] == 1'b1)
            begin
                valid = 1'b1;
                out = 2'b00;
            end
            else
            begin
                valid = 1'b0;
                out = 2'b00;
            end
        end
    end

endmodule

