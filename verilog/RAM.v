`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:09:55 02/09/2011 
// Design Name: 
// Module Name:    RAM 
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
module RAM(addr,ce,clk,clr,rw,data);
	parameter n = 4;						//bus width
	parameter m = 3;						//address width (2**m memory locations)
	input [m-1:0] addr;					//address (m bits wide)
	input ce;								//chip enable (func. when ce=1, HiZ when ce=0)
	input clk;								//posedge clock
	input clr;								//synch active low clear
	input rw;								//read when rw=1 write when rw=0
	inout [n-1:0] data;					//data in/out bus
	reg [n-1:0] data_out_reg;			//data output register
	reg [n-1:0] memory [2**m-1:0];	//memory values
	wire bufctrl;							//buffer control
	integer i;
	
	//read/write synchronous loop
	always@(posedge clk)
	begin
		if(ce == 1)	//only read or write if chip is enabled
		begin
			if(clr == 0)	//clear contents
			begin
				data_out_reg <= 0;
				for(i = 0; i < 2**m; i = i+1)
				begin
					memory[i] <= 0;
				end
			end
			else if(rw == 0)	//write data
			begin
				memory[addr] <= data;
			end
			else	//read data
			begin
				data_out_reg <= memory[addr];
			end
		end
	end
	
	genvar j;
	
	assign bufctrl = (rw && ce);	//buffer only when rw=1 and ce=1 (read and chip enabled)
	
	//data direction buffers for inout
	generate
	for(j = 0; j < n; j = j+1)
	begin:buffers
		bufif1 RW_BUF	(data[j],data_out_reg[j],bufctrl);
	end
	endgenerate

endmodule
