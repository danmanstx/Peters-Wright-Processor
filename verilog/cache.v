`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//cache.v
//
//A parameterized cache module.  The cache is fully associative and implements the
//least recently utilized replacement algorithm.  The cache contains four entries.
//
///////////////////////////////////////////////////////////////////////////////////////
module cache(addr_in,data_in,rw_in,ce_in,addr_out,data_out,rw_out,ce_out,odv,clr,clk);
    //parameters
    parameter d_width = 8;      //data bus width
    parameter a_width = 8;      //address line width
    
    //inputs to the cache
    input [a_width-1:0] addr_in;        //address in
    inout [d_width-1:0] data_in;        //data bus into the cache
    reg [d_width-1:0] data_in_reg;      //data in register (for output)
    input rw_in;                        //read if rw=1 write if rw=0
    input ce_in;                        //chip enable (func. when ce=1, HiZ when ce=0)
    
    //outputs to RAM
    output reg [a_width-1:0] addr_out;  //address out
    inout [d_width-1:0] data_out;       //data bus from the cache
    reg [d_width-1:0] data_out_reg;     //data out register (for output)
    output reg rw_out;                  //pass from input
    output reg ce_out;                  //pass from output
    
    //control inputs/outputs
    output odv;                     //output data valid
    input clr;                      //synchronous active low clear
    input clk;                      //clock
    
    //cache entries
    reg [3:0] valid;                //entry valid
    reg [1:0] cnt [3:0];            //count (for LRU replacement)
    reg [d_width-1:0] data [3:0];   //entry data
    reg [a_width-1:0] addr [3:0];   //entry addresses
    reg [2:0] timer;                //timer for 
    integer i;
    
    always@(posedge clk)
    begin
        ce_out <= ce_in;
        rw_out <= rw_in;
        if(clr == 0)                //clear contents
        begin
            
        end
        if(ce_in == 1)              //only read or write if chip is enabled
        begin
            if(clr == 1)
            begin
            
            end
        end
    end

    genvar j;

    assign in_bufctrl = (rw_in && ce_in);       //buffer only when rw_in=1 and ce_in=1
    assign out_bufctrl = (~rw_in && ce_in);     //buffer only when rw_in=0 and ce_in=1
    
    //data direction buffers for inout
    generate
    for(j = 0; j < d_width; j = j+1)
    begin:buffers
        bufif1 RW_BUF_IN (data_in[j],data_in_reg[j],in_bufctrl);
        bufif1 RW_BUF_OUT (data_out[j],data_out_reg[j],out_bufctrl);
    end
    endgenerate

endmodule
