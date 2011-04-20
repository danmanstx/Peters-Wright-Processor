`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//register_file.v
//
//A parameterized register file with a dual continuous read and a synchronized single
//write.  Has a synchronous active low clear.
//
///////////////////////////////////////////////////////////////////////////////////////
module register_file(write,reg0addr,reg1addr,writeaddr,data_in,clr,clk,data0,data1);
    parameter d_width;              //register width
    parameter a_width;              //address width (2**m) registers
    input write;                    //write data_in to writeaddr when write = 1
    input [a_width-1:0] reg0addr;   //read register 0 address (data to data0)
    input [a_width-1:0] reg1addr;   //read register 1 address (data to data1)
    input [a_width-1:0] writeaddr;  //address of register to write to
    input [d_width-1:0] data_in;    //data to write when writing
    input clr;                      //synchronous active low clear
    input clk;                      //posedge clk
    output [d_width-1:0] data0;     //read data 0
    output [d_width-1:0] data1;     //read data 1
    reg [d_width-1:0] registers [2**a_width-1:0];   //register data
    integer i;
    
    //dual continuous read
    assign data0 = registers[reg0addr];
    assign data1 = registers[reg1addr];
    
    
    //synchronized write with synchronized active low clear
    always@(posedge clk)
    begin
        if(clr == 0)
        begin
            for(i = 0; i < 2**a_width; i = i + 1)
                registers[i] <= 0;
        end
        else if(write == 1)
        begin
            registers[writeaddr] <= data_in;
        end
    end    
    
endmodule
