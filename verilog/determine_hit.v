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
module determine_hit(addr, entry_addrs, cnt, valid, sel, dec, hit);
    //parameters
    parameter d_width = 8;                  //data bus width
    parameter a_width = 8;                  //address line width
    //inputs
    input [a_width-1:0] addr;               //input address
    input [a_width-1:0] entry_addrs [3:0];  //entry address values
    input [1:0] cnt [3:0];                  //entry counts
    input [3:0] valid;                      //entry valid values
    //outputs
    output [1:0] sel;                       //sel=i if hit at entry i, else hiZ
    output [3:0] dec;                       //dec[i]=1 if decrementing cnt[i]
    output hit;                             //hit=1 if hit, hit=0 if miss

    always@(addr or entry_addrs or valid)
    begin
        else if((addr == entry_addrs[0]) && (valid[0] == 1'b1))
        begin
            //hit on entry 0
            hit = 1'b1;
            sel = 2'b00;
            dec[0] = 1'b0;
            if(cnt[0] > cnt[1])
                dec[1] = 1'b0;
            else
                dec[1] = 1'b1;
            if(cnt[0] > cnt[2])
                dec[2] = 1'b0;
            else
                dec[2] = 1'b1;
            if(cnt[0] > cnt[3])
                dec[3] = 1'b0;
            else
                dec[3] = 1'b1;
        end
        else if((addr == entry_addrs[1]) && (valid[1] == 1'b1))
        begin
            //hit on entry 1
            hit = 1'b1;
            sel = 2'b01;
            dec[1] = 1'b0;
            if(cnt[1] > cnt[0])
                dec[0] = 1'b0;
            else
                dec[0] = 1'b1;
            if(cnt[1] > cnt[2])
                dec[2] = 1'b0;
            else
                dec[2] = 1'b1;
            if(cnt[1] > cnt[3])
                dec[3] = 1'b0;
            else
                dec[3] = 1'b1;
        end
        else if((addr == entry_addrs[2]) && (valid[2] == 1'b1))
        begin
            //hit on entry 2
            hit = 1'b1;
            sel = 2'b10;
            dec[2] = 1'b0;
            if(cnt[2] > cnt[0])
                dec[0] = 1'b0;
            else
                dec[0] = 1'b1;
            if(cnt[2] > cnt[1])
                dec[1] = 1'b0;
            else
                dec[1] = 1'b1;
            if(cnt[2] > cnt[3])
                dec[3] = 1'b0;
            else
                dec[3] = 1'b1;
        end
        else if((addr == entry_addrs[3]) && (valid[3] == 1'b1))
        begin
            //hit on entry 3
            hit = 1'b1;
            sel = 2'b11;
            dec[3] = 1'b0;
            if(cnt[3] > cnt[0])
                dec[0] = 1'b0;
            else
                dec[0] = 1'b1;
            if(cnt[3] > cnt[1])
                dec[1] = 1'b0;
            else
                dec[1] = 1'b1;
            if(cnt[3] > cnt[2])
                dec[2] = 1'b0;
            else
                dec[2] = 1'b1;
        end
        else
        begin
            //miss
            if((cnt[0] == 2'b00) || (valid[0] == 1'b0))
            begin
                hit = 1'b0;
                sel = 2'b00;
                dec = 4'b0111;
            end
            else if((cnt[1] == 2'b00) || (valid[1] == 1'b0))
            begin
                hit = 1'b0;
                sel = 2'b01;
                dec = 4'b1011;
            end
            else if((cnt[2] == 2'b00) || (valid[2] == 1'b0))
            begin
                hit = 1'b0;
                sel = 2'b10;
                dec = 4'b1101;
            end
            else    //replace 3
            begin
                hit = 1'b0;
                sel = 2'b11;
                dec = 4'b1110;
            end
        end
    end


endmodule
