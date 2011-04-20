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
module RAM(addr,ce,clk,clr,rw,data);
	parameter d_width;					//data bus width
	parameter a_width;					//address width (2**m memory locations)
	input [a_width-1:0] addr;			//address (m bits wide)
	input ce;								//chip enable (func. when ce=1, HiZ when ce=0)
	input clk;								//posedge clock
	input clr;								//synch active low clear
	input rw;								//read when rw=1 write when rw=0
	inout [d_width-1:0] data;			//data in/out bus
	reg [d_width-1:0] data_out_reg;	//data output register
	reg [d_width-1:0] memory [2**a_width-1:0];	//memory values
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
				for(i = 0; i < 2**a_width; i = i+1)
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
	for(j = 0; j < d_width; j = j+1)
	begin:buffers
		bufif1 RW_BUF	(data[j],data_out_reg[j],bufctrl);
	end
	endgenerate

endmodule
