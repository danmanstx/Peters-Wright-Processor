`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//hit_decrementor.v
//
//A module that is used in cache.v to choose which counters to decrement on a cache hit
//
///////////////////////////////////////////////////////////////////////////////////////
module determine_hit(addr, entry_addrs, valid, sel, dec, hit);
    //parameters
    parameter d_width = 8;                  //data bus width
    parameter a_width = 8;                  //address line width
    //inputs
    input [a_width-1:0] addr;               //input address
    input [a_width-1:0] entry_addrs [3:0];  //entry address values
    input [3:0] valid;                      //entry valid values
    //outputs
    output [1:0] sel;                       //sel=i if hit at entry i, else hiZ
    output [3:0] dec;                       //inc[i]=1 if decrementing cnt[i]
    output hit;                             //hit=1 if hit, hit=0 if miss
    
    always@(addr or entry_addrs or valid)
    begin
        else if((addr == entry_addrs[0]) && valid[0] == 1'b1)
        begin
            //hit on entry 0
            hit = 1;
            sel = 2'b00;
        end
        else if((addr == entry_addrs[1]) && valid[1] == 1'b1)
        begin
            //hit on entry 1
            hit = 1;
            sel = 2'b01;
        end
        else if((addr == entry_addrs[2]) && valid[2] == 1'b1)
        begin
            //hit on entry 2
            hit = 1;
            sel = 2'b10;
        end
        else if((addr == entry_addrs[3]) && valid[3] == 1'b1)
        begin
            //hit on entry 3
            hit = 1;
            sel = 2'b11;
        end
        else    //miss
        begin
            hit = 0;
            sel = 2'bzz;
        end
    end


endmodule
