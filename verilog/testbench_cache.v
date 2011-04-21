`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//testbench_cache.v
//
//A test bench for testing the cache functionality.  Not used in final design.
//
///////////////////////////////////////////////////////////////////////////////////////
module testbench_cache(clr, clk);
    parameter d_width = 4;          //data bus width
    parameter a_width = 8;          //address line width
    input clr;                      //clear
    input clk;                      //clock
    
    //wires----------------------------------------------------------------------------------------------------------------------------------------
    wire [d_width-1:0] data_to_c;
    wire [a_width-1:0] addr_to_r;
    wire [d_width-1:0] data_to_r;
    wire ce_to_r;
    wire rw_to_r;
    
    //modules--------------------------------------------------------------------------------------------------------------------------------------
    //module cache(addr_in, data_in, rw_in, ce_in, addr_out, data_out, rw_out, ce_out, odv, clr, clk);
    cache #(.d_width(d_width),.a_width(a_width))       T_cache (addr, data_to_c, rw, ce, addr_to_r, data_to_r, rw_to_r, ce_to_r, odv, clr, clk);
    
    //module RAM(addr, ce, clk, clr, rw, data);
    RAM #(.d_width(d_width),.a_width(a_width))         T_RAM (addr_to_r, ce_to_r, clk, clr, rw_to_r, data_to_r);

    
    
endmodule
