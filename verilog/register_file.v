`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:04 02/08/2011 
// Design Name: 
// Module Name:    register_file 
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
module register_file(write,reg0addr,reg1addr,writeaddr,data_in,clr,clk,data0,data1);
	parameter n = 4;							//register width
	parameter m = 3;							//address width (2**m) registers
	input write;								//write data_in to writeaddr when write = 1
	input [m-1:0] reg0addr;					//read register 0 address (data to data0)
	input [m-1:0] reg1addr;					//read register 1 address (data to data1)
	input [m-1:0] writeaddr;				//address of register to write data_in when writing
	input [n-1:0] data_in;					//data to write when writing
	input clr;									//synchronous active low clear
	input clk;									//posedge clk
	output [n-1:0] data0;					//read data 0
	output [n-1:0] data1;					//read data 1
	reg [n-1:0] registers [2**m-1:0];	//register data
	integer i;
	
	//dual continuous read
	assign data0 = registers[reg0addr];
	assign data1 = registers[reg1addr];
	
	
	//synchronized write with synchronized active low clear
	always@(posedge clk)
	begin
		if(clr == 0)
		begin
			for(i = 0; i < 2**m; i = i + 1)
				registers[i] <= 0;
		end
		else if(write == 1)
		begin
			registers[writeaddr] <= data_in;
		end
	end	
	
endmodule
