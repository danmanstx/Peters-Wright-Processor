`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:14:22 04/19/2011 
// Design Name: 
// Module Name:    comparator 
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
module comparator(A, B, En, out);
    parameter width = 8;
    input [width-1:0]A;
    input [width-1:0]B;
    input En;
    output out;
	 reg out;
	 
	always @ (A or B or En )
	begin
		if(En)
		begin
			assign out = A >= B ? 1'b1 :1'b0;
		end
		else
		begin
			assign out = 0;
		end
	end

endmodule
