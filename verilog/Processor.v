`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Kentucky
// Engineers: Danny Peters and John Wright 
// 
// Create Date:    17:35:56 04/19/2011 
// Design Name: 
// Module Name:    Processor 
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
module Processor(in, external_interrupt, out, hsk_1, hsk_2, clk);
	// inputs
        input in; 				// this is an input that is called in
	input hsk_1; 				// this is an input used for handshaking
	input hsk_2; 				// this is another input used for handshaking
	input clk;				// this is the clock input
	input external_interrupt;		// this is an external interrupt input
	// outputs
	output out;				// this is an output called out
	///////////////////
	// controller    //
	///////////////////
	badasscontroller	controller (/* in and outs*/);						// this is the bad ass controller
	MHVPIS			wtf (/*irupt_in, mask_in, clr, enable, i_pending, PC_out*/);		// hardware vector priority interrupt system
	///////////////////
	// stage one	  //
	///////////////////
	RAM #(.n(16),.m(8))			I_RAM (/* addr,ce,clk,clr,rw,data*/ );		// 256x16 instruction random access memory
	cache					I_CACHE (/* in and outs*/);			// 4x16 instruction cache
	ls_reg					IMAR (/* in and outs*/);			// 8 bit instruction memory address register
	ls_reg					IR (/* in and outs*/);				// 16 bit instruction register
	sign_extend				SEX (/* in, out*/ );				// sign extend from IR to mux
	n_bit_PC #(.n(8)) 			program_counter (/*ld_in,ctrl,clr,clk,out*/);	//  8 bit program counter
	MUX_mxn #(.d_width(8),.s_lines(2)) 	PC_MUX (/*in,sel,out*/ );			// 2x8 mux for program counter
	MUX_mxn #(.d_width(8),.s_lines(4)) 	PSR0_MUX (/*in,sel,out*/ );			// 4x8 mux for pipelined stage register instruction
 	ls_reg					PSR0 (/* in and outs*/ );			// pipeline stage register zero
	///////////////////
	// stage two     //
	///////////////////
	register_file				registerfile (/* in and outs*/ );		// register file 
	comparator #(.width(4))			CMP_MUX_A (/* in,sel,out*/);			// comparator for mux 2x8 that feeds later into alu input A
	comparator #(.width(8))			CMP_MUX_B (/* in,sel,out*/);			// comparator for mux 2x8 that feeds later into alu input B
	MUX_mxn #(.d_width(8),.s_lines(2))	MUX_MUX_A (/* in,sel,out*/ );			// 2x8 mux that feeds into alu_A_MUX
	MUX_mxn #(.d_width(8),.s_lines(2))	MUX_MUX_B (/* in,sel,out*/ );			// 2x8 mux that feeds into alu_B_MUX
	MUX_mxn #(.d_width(8),.s_lines(2))	alu_A_MUX (/* in,sel,out*/ );			// 2x8 mux that feeds directly into alu input A
	MUX_mxn #(.d_width(8),.s_lines(4))    	alu_B_MUX (/* in,sel,out*/ );			// 4x8 mux that feeds directly into alu input B
	n_bit_ALU				alu (/*a,b,cin,ctrl,f,cout,v,z*/ );		// this is the all powerful ALU
	lss_reg #(.n(8))			LSS_Ralu (/* in and outs*/);			// lss register for the alu result
	ls_reg					PSR1(/* in and outs*/ );			// pipeline stage register one
	///////////////////
	// stage three   //
	///////////////////
	ls_reg					R_OUT (/* in and outs*/ );			// 8 bit r out
	RAM #(.n(8),.m(8))			D_RAM (/*addr,ce,clk,clr,rw,data*/ );		// 256x8 data random access memory
	cache					D_CACHE ( /* in and outs*/ );			// 4x8 data cache
	MUX_mxn #(.d_width(8),.s_lines(4))		data_Cache_MUX (/* in,sel,out*/);	// 4x8 mux that feeds into the data cache address in
	
	
endmodule
