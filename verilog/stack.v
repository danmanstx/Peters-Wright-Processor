`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Kentucky
// Engineers: Danny Peters and John Wright 
// 
// Create Date:    4/21/11
// Design Name: 
// Module Name:    stack
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module stack(peek, push, c, en, clk, clr,  full, empty);
parameter width = 8;
parameter depth = 1;
input c;                              // this is the control line
input en;                             // this is the enable
input clk;                            // this is a clocked input
input clr;                            // this is for the global clear
input [width-1:0]push;                // get the value in to push
output [width-1:0]peek;               // the value that would be popped
output reg full;                      // output that is 1 if the stack is full and 0 otherwise
output reg not_empty;                 // output that is 1 when the stack isn't empty and 0 when it is
reg [depth-1:0]ptr;                   // stack pointer
reg [width-1:0]data[(2**depth)-1:0];  // this is a register that holds the data

always @(posedge clk)
begin
    if(clr)
    begin
        data <= 0;
        ptr <= 0;
        full <= 0;
        non_empty <= 0;
    end
    else
    begin
        if(en == 0)
            peek <= data[ptr];
        else
        begin
            if(c == 0)  //pop
                if(not_empty == 1)
                begin
                    full <= 0;
                    ptr <= ptr - 1;
                    peek <= data[ptr-1];
                    if(ptr-1 == 0)
                        not_empty <= 0;
                end
            else       // c=1, push
                if(full == 0)
                begin
                    not_empty <= 1;
                    ptr <= ptr + 1;
                    data[ptr+1] <= push;
                    if(ptr == (2**depth)-2)
                        full <= 1;
                end
        end
    end
end
endmodule

