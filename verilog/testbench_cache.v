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
    integer i;
    integer rw;

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
    reg [d_width-1:0] data_tocache_reg;
    wire [d_width-1:0] data_tocache;
    reg rw_tocache;
    reg ce_tocache;
    parameter [7:0] test_addr = {8'b00000001,8'b00000010,8'b00000100,8'b00001000,8'b00010000,8'b00100000,8'b01000000,8'b10000000};
    parameter [7:0] test_data = {8'b00000000,8'b00000001,8'b00000010,8'b00000011,8'b00000100,8'b00000101,8'b00000110,8'b00000111};

    RAM   #(.d_width(d_width),.a_width(a_width)) dataram   (addr_toram, ce_toram, clk, clr, rw_toram, data_toram);
    cache #(.d_width(d_width),.a_width(a_width)) datacache (addr_tocache , data_tocache,rw_tocache ,ce_tocache, addr_toram, data_toram, rw_toram, ce_toram, odv, clr, clk);
    
    always@(posedge clk)
    begin
        if(clr == 0)
        begin
            i <= 0;
            rw <= 0;
            addr_tocache <= 0;
            data_tocache_reg <= 0;
            rw_tocache <= 0;
            ce_tocache <= 0;
        end
        else
        begin
            if(rw <= 0)
            begin
                if(odv == 1)
                    if(i == 7)
                    begin
                        i <= 6;
                        rw <= 1;
                    end
                    else
                        i <= i + 1;
                rw_tocache <= 0;
                ce_tocache <= 1;
                addr_tocache <= test_addr[i];
                data_tocache_reg <= test_data[i];
            end
            else
            begin
                if(odv == 1)
                    i <= (i - 1) % 8;
                rw_tocache <= 1;
                ce_tocache <= 1;
                addr_tocache <= test_addr[i];
            end
        end
    end
    
    genvar j;
    
    generate
    for(j = 0; j < d_width; j = j + 1)
    begin:buffers
        bufif1 BUFFER (data_tocache[j], data_tocache_reg[j], rw_tocache);
    end
    endgenerate
    
    
    
    
    
endmodule
