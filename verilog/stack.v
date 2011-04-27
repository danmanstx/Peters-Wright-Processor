`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//stack.v
//
//A parameterized stack with a synchronous active low clear and synchronous peek.
//    c    clr  funct
//    x    0    clear register to 0s
//    0    1    store
//    1    1    load from input
//
///////////////////////////////////////////////////////////////////////////////////////
module stack(peek, push, c, en, clk, clr);
    parameter width = 8;
    parameter depth = 1;
    input                     c;                // pop when c=1.  push when c=0.
    input                    en;                // this is the enable
    input                   clk;                // this is a clocked input
    input                   clr;                // this is for the global clear
    input      [width-1:0] push;                // get the value in to push
    output reg [width-1:0] peek;                // the value that would be popped
    reg     full;                               // output that is 1 if the stack is full and 0 otherwise
    reg     empty;                              // output that is 1 when the stack isn't empty and 0 when it is
    reg     [depth-1:0]  ptr;                   // stack pointer
    reg     [width-1:0] data [(2**depth)-1:0];  // this is a register that holds the data
    integer i;
    
    always @(posedge clk)
    begin
        if(clr == 0)
        begin
            for(i=0;i<(2**depth);i=i+1)
            begin
                data[i] <= 0;
            end
            peek <= 0;
            ptr <= 0;
            full <= 0;
            empty <= 1;
        end
        else
        begin
            if(en == 0)
            begin
                if(empty == 0)
                    peek <= data[ptr];
                else
                    peek <= push;
            end
            else
            begin
                if(c == 1)  //pop
                begin
                    if(empty == 0)
                    begin
                        if(ptr == 0)
                        begin
                            empty <= 1;
                            peek <= push;
                            ptr <= 0;   //stays at 0
                            full <= 0;
                        end
                        else
                        begin
                            empty <= 0;
                            peek <= data[ptr-1];
                            ptr <= ptr-1;
                            full <= 0;
                        end
                    end
                end
                else       // c=0, push
                begin
                    if(empty == 1)
                    begin
                        empty <= 0;
                        peek <= push;
                        data[0] <= push;
                        ptr <= 0;
                        full <= 0;
                    end
                    else if(full == 0)
                    begin
                        if(ptr == (2**depth)-2)
                        begin
                            empty <= 0;
                            peek <= push;
                            data[(2**depth)-1] <= push;
                            ptr <= (2**depth)-1;
                            full <= 1;
                        end
                        else
                        begin
                            empty <= 0;
                            peek <= push;
                            data[ptr+1] <= push;
                            ptr <= ptr+1;
                            full <= 0;
                        end
                    end
                end
            end
        end
    end
endmodule

