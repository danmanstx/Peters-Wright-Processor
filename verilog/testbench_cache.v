`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//testbench_cache.v
//
//A testbench for the cache module
//
///////////////////////////////////////////////////////////////////////////////////////
module testbench_cache(clk, clr);
    //parameters
    parameter d_width = 8;      //data bus width
    parameter a_width = 8;      //address line width

    //inputs
    input clk;                  //clock
    input clr;                  //clear

    //connection wires to RAM
    wire [a_width-1:0] addr_toram;
    wire [d_width-1:0] data_toram;
    wire ce_toram;
    wire rw_toram;

    //connection wires and regs to cache
    wire odv;
    reg [a_width-1:0] addr_tocache;
    reg [d_width-1:0] data_tocache;
    reg rw_tocache;
    reg ce_tocache;
    parameter [7:0] testvectors = {8'b00000001,8'b00000010,8'b00000100,8'b00001000,8'b00010000,8'b00100000,8'b01000000,8'b10000000};

    RAM   #(.d_width(d_width),.a_width(a_width)) dataram   (addr_toram, ce_toram, clk, clr, rw_toram, data_toram);
    cache #(.d_width(d_width),.a_width(a_width)) datacache (addr_tocache , data_tocache,rw_tocache ,ce_tocache, addr_toram, data_toram, rw_toram, ce_toram, odv, clr, clk);
    
    always@(posedge clk)
    begin
        
    end
    
    
    
    
    
    
    
endmodule
