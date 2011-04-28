`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//RAM.v
//
//A parameterized random access memory implemented using registers.  To simulate the
//longer read time that a true RAM would take, a hardware counter is used in the cache.
//
///////////////////////////////////////////////////////////////////////////////////////
module RAM( addr, ce, clk, clr, rw, data, mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, mem9, mem10, mem11,
            mem12, mem13, mem14, mem15 );
    parameter d_width = 8;              //data bus width
    parameter a_width = 8;              //address width (2**m memory locations)
    input [a_width-1:0] addr;           //address (m bits wide)
    input ce;                           //chip enable (func. when ce=1, HiZ when ce=0)
    input clk;                          //posedge clock
    input clr;                          //synch active low clear
    input rw;                           //read when rw=1 write when rw=0
    inout [d_width-1:0] data;           //data in/out bus
    reg [d_width-1:0] data_out_reg;     //data output register
    reg [d_width-1:0] memory [2**a_width-1:0];  //memory values
    wire bufctrl;                               //buffer control
    integer i;
    
    output [7:0] mem0;
    assign mem0 = memory[0];
    output [7:0] mem1;
    assign mem1 = memory[1];
    output [7:0] mem2;
    assign mem2 = memory[2];
    output [7:0] mem3;
    assign mem3 = memory[3];
    output [7:0] mem4;
    assign mem4 = memory[4];
    output [7:0] mem5;
    assign mem5 = memory[5];
    output [7:0] mem6;
    assign mem6 = memory[6];
    output [7:0] mem7;
    assign mem7 = memory[7];
    output [7:0] mem8;
    assign mem8 = memory[8];
    output [7:0] mem9;
    assign mem9 = memory[9];
    output [7:0] mem10;
    assign mem10 = memory[10];
    output [7:0] mem11;
    assign mem11 = memory[11];
    output [7:0] mem12;
    assign mem12 = memory[12];
    output [7:0] mem13;
    assign mem13 = memory[13];
    output [7:0] mem14;
    assign mem14 = memory[14];
    output [7:0] mem15;
    assign mem15 = memory[15];
    
    
    
    
    //read/write synchronous loop
    always@(posedge clk)
    begin
        if(clr == 0)        //clear contents
        begin
            data_out_reg <= 0;
            for(i = 0; i < 2**a_width; i = i+1)
            begin
                memory[i] <= 0;
            end
        end
        if(ce == 1)         //only read or write if chip is enabled
        begin
            if(clr == 1)    //do nothing on a clear
            begin
                if(rw == 0) //write data
                begin
                    memory[addr] <= data;
                end
                else        //read data
                begin
                    data_out_reg <= memory[addr];
                end
            end
        end
    end
    
    genvar j;
    
    assign bufctrl = (rw && ce);    //buffer only when rw=1 and ce=1 (read and chip enabled)
    
    //data direction buffers for inout
    generate
    for(j = 0; j < d_width; j = j+1)
    begin:buffers
        bufif1 RW_BUF    (data[j],data_out_reg[j],bufctrl);
    end
    endgenerate

endmodule
