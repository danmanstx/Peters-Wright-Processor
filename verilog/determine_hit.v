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
module determine_hit(addr, w_entry_addrs, w_cnt, valid, sel, dec, hit);
    //parameters
    parameter a_width = 8;                  //address line width
    //inputs
    input [a_width-1:0] addr;               //input address
    input [(a_width*4)-1:0] w_entry_addrs;  //entry address values (as 1d vector)
        wire [a_width-1:0] entry_addrs [3:0];   //2d wrapper
    input [7:0] w_cnt;                      //entry counts (as 1d vector)
        wire [1:0] cnt [3:0];                   //2d wrapper
    input [3:0] valid;                      //entry valid values
    //outputs
    output reg [1:0] sel;                   //sel=i if hit at entry i, else hiZ
    output reg [3:0] dec;                   //dec[i]=1 if decrementing cnt[i]
    output reg hit;                         //hit=1 if hit, hit=0 if miss

    //assign wrappers
    assign entry_addrs[0] = w_entry_addrs[a_width-1:0];
    assign entry_addrs[1] = w_entry_addrs[(a_width*2)-1:a_width];
    assign entry_addrs[2] = w_entry_addrs[(a_width*3)-1:(a_width*2)];
    assign entry_addrs[3] = w_entry_addrs[(a_width*4)-1:(a_width*3)];
    assign cnt[0] = w_cnt[1:0];
    assign cnt[1] = w_cnt[3:2];
    assign cnt[2] = w_cnt[5:4];
    assign cnt[3] = w_cnt[7:6];
    
    always@(addr or entry_addrs[0] or entry_addrs[1] or entry_addrs[2] or entry_addrs[3]
        or valid or cnt[0] or cnt[1] or cnt[2] or cnt[3])
    begin
        if((addr == entry_addrs[0]) && (valid[0] == 1))
        begin
            hit <= 1;
            sel <= 2'b00;
            dec[0] <= 0;
            if(cnt[0] < cnt[1])
                dec[1] <= 1;
            else
                dec[1] <= 0;
            if(cnt[0] < cnt[2])
                dec[2] <= 1;
            else
                dec[2] <= 0;
            if(cnt[0] < cnt[3])
                dec[3] <= 1;
            else
                dec[3] <= 0;
        end
        else if((addr == entry_addrs[1]) && (valid[1] == 1))
        begin
            hit <= 1;
            sel <= 2'b01;
            dec[1] <= 0;
            if(cnt[1] < cnt[0])
                dec[0] <= 1;
            else
                dec[0] <= 0;
            if(cnt[1] < cnt[2])
                dec[2] <= 1;
            else
                dec[2] <= 0;
            if(cnt[1] < cnt[3])
                dec[3] <= 1;
            else
                dec[3] <= 0;
        end
        else if((addr == entry_addrs[2]) && (valid[2] == 1))
        begin
            hit <= 1;
            sel <= 2'b10;
            dec[2] <= 0;
            if(cnt[2] < cnt[0])
                dec[0] <= 1;
            else
                dec[0] <= 0;
            if(cnt[2] < cnt[1])
                dec[1] <= 1;
            else
                dec[1] <= 0;
            if(cnt[2] < cnt[3])
                dec[3] <= 1;
            else
                dec[3] <= 0;
        end
        else if((addr == entry_addrs[3]) && (valid[3] == 1))
        begin
            hit <= 1;
            sel <= 2'b11;
            dec[3] <= 0;
            if(cnt[3] < cnt[0])
                dec[0] <= 1;
            else
                dec[0] <= 0;
            if(cnt[3] < cnt[1])
                dec[1] <= 1;
            else
                dec[1] <= 0;
            if(cnt[3] < cnt[2])
                dec[2] <= 1;
            else
                dec[2] <= 0;
        end
        else if(valid[0] == 1'b0)
        begin
            hit <= 0;
            dec <= 4'b1110;
            sel <= 2'b00;
        end
        else if(valid[1] == 1'b0)
        begin
            hit <= 0;
            dec <= 4'b1101;
            sel <= 2'b01;
        end
        else if(valid[2] == 21'b0)
        begin
            hit <= 0;
            dec <= 4'b1011;
            sel <= 2'b10;
        end
        else if(valid[3] == 1'b0)
        begin
            hit <= 0;
            dec <= 4'b0111;
            sel <= 2'b11;
        end
        else if(cnt[0] == 2'b00)
        begin
            hit <= 0;
            dec <= 4'b1110;
            sel <= 2'b00;
        end
        else if(cnt[1] == 2'b00)
        begin
            hit <= 0;
            dec <= 4'b1101;
            sel <= 2'b01;
        end
        else if(cnt[2] == 2'b00)
        begin
            hit <= 0;
            dec <= 4'b1011;
            sel <= 2'b10;
        end
        else
        begin
            hit <= 0;
            dec <= 4'b0111;
            sel <= 2'b11;
        end
    end


endmodule
