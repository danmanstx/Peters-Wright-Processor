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
//The cache delay is modeled using a FSM.
//
///////////////////////////////////////////////////////////////////////////////////////
module cache(addr_in, data_in, rw_in, ce_in, addr_out, data_out, rw_out, ce_out, odv, clr, clk);
    //parameters
    parameter d_width = 8;      //data bus width
    parameter a_width = 8;      //address line width

    //inputs to the cache
    input [a_width-1:0] addr_in;        //address in
    reg [a_width-1:0] addr_in_reg;      //register that stores address in
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
    output reg odv;                     //output data valid

    //control inputs
    input clr;                      //synchronous active low clear
    input clk;                      //clock

    //cache entries
    reg [3:0] valid;                //entry valid
    reg [1:0] cnt [3:0];            //count (for LRU replacement)
    reg [d_width-1:0] data [3:0];   //entry data
    reg [a_width-1:0] addr [3:0];   //entry addresses

    //other registers and wires
    reg [3:0] state;
    wire hit;                       //hit=1 for a hit, hit=0 for a miss
    wire [1:0] sel;                 //sel=i if hit at entry i
    reg [1:0] sel_reg;              //register to store sel between ccs
    wire [3:0] dec;                 //dec[i]=1 if decrementing cnt[i]
    integer i;

    //wire wrappers
    wire [(a_width*4)-1:0] w_addr;
    wire [7:0] w_cnt;
    assign w_addr[a_width-1:0] = addr[0];
    assign w_addr[(a_width*2)-1:a_width] = addr[1];
    assign w_addr[(a_width*3)-1:(a_width*2)] = addr[2];
    assign w_addr[(a_width*4)-1:(a_width*3)] = addr[3];
    assign w_cnt[1:0] = cnt[0];
    assign w_cnt[3:2] = cnt[1];
    assign w_cnt[5:4] = cnt[2];
    assign w_cnt[7:6] = cnt[3];
    
    //modules
    determine_hit DETERMINE_HIT (addr_in, _addr, _cnt, valid, sel, dec, hit);
    
    /////////////////////////////////////////
    //FSM
    /////////////////////////////////////////
    always@(posedge clk)
    begin
        if(clr == 0)
            state <= 0;
        else
        begin
            case(state)
            0: begin
                if(hit == 1)
                    state <= 0;
                else
                    state <= 1;
            end
            1:  begin
                if(rw == 1)
                    state <= 2;
                else
                    state <= 3;
            end
            2:  state <= 4;
            3:  state <= 4;
            4:  state <= 5;
            5:  state <= 6;
            6:  state <= 7;
            7:  state <= 8;
            8:  state <= 0;
            default: state <= 0;
        end
    end
    
    /////////////////////////////////////////
    //FSM
    /////////////////////////////////////////

endmodule
