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
module Processor(bus_in, ext_int, out, hsk_1, hsk_2, g_clk);
	// inputs
    input [7:0] bus_in;           // this is an input that is called in
	input       hsk_1;       // this is an input used for handshaking
	input       hsk_2;       // this is another input used for handshaking
	input       g_clk;       // this is the clock input
	input [3:0] ext_int;     // this is an external interrupt input
	// outputs
	output      out;        // this is an output called out
    //wires
    wire [55:0]s;
	///////////////////
	// stage one	  //
	///////////////////
	//wires
    wire [25:0] iram_in;
    wire [23:0] icache_in;
    wire [7:0]  imar_in;
    wire [15:0] ir_out;
    wire [7:0]  sex_out;
    wire [7:0]  pc_in;
    wire        i_pending;
    wire [7:0]  pc_out;
    wire [7:0]  psr0_in;
    wire [3:0]  mask_in;
    wire [23:0] psr0_out;
    // functional units
	RAM #(.d_width(16),.a_width(8))     I_RAM (iram_in[7:0], iram_in[8], g_clk, g_clr, iram_in[9], iram_in[25:10] );   // 256x16 instruction random access memory
	cache #(.d_width(16),.a_width(8))   I_CACHE (icache_in[7:0], icache_in[23:8], s[1], s[0], iram_in[7:0], iram_in[25:10], iram_in[9], iram_in[8], i_odv, g_clr, g_clk); // 4x16 instruction cache
	ls_reg #(.n(8))                     IMAR (imar_in[7:0], s[3], g_clr, g_clk, icache_in[7:0]);                       // 8 bit instruction memory address register
	ls_reg #(.n(16))                    IR (icache_in[23:8], s[2], g_clr, g_clk, ir_out[15:0]);                        // 16 bit instruction register
	sign_extend                         SEX (ir_out[5:0], sex_out[7:0]);										       // sign extend from IR to mux
	n_bit_PC #(.n(8))                   program_counter (pc_in[7:0], {s[5],s[4]}, g_clr, g_clk, imar_in[7:0]);         //  8 bit program counter
	MUX_mxn #(.d_width(8),.s_lines(1))  PC_MUX (in, i_pending, pc_in[7:0]);                                            // 2x8 mux for program counter
	MUX_mxn #(.d_width(8),.s_lines(2))  PSR0_MUX ({ir_out[15:7],ir_out[9:2],sex_out[7:0],8'h00}, {s[7],s[6]}, psr0_in[7:0]); // 4x8 mux for pipelined stage register instruction
 	ls_reg #(.n(24))                    PSR0 ({ir_out[9:6],ir_out[5:2],psr0_in[7:0],imar_in[7:0]}, s[9], g_clr, g_clk, psr0_out[23:0]); // pipeline stage register zero
	///////////////////
	// stage two     //
	///////////////////
	//wires
    wire cmp_out_a;
    wire cmp_out_b;
    wire [7:0]mux_out_a;
    wire [7:0]mux_out_b;
    wire [7:0]a;
    wire [7:0]b;
    wire cout;
    wire v;
    wire z;
    wire rin_out[7:0];
    wire ralu_out[7:0];
    wire psr1_out[23:0];
    //functional units
	register_file                               registerfile ( s[27],psr0_out[3:0], psr0_out[7:4],/* writeaddr,data_in, */g_clr, g_clk,/* data0, data1*/);      // register file 
	comparator #(.width(4))						CMP_MUX_A (psr0_out[3:0], /*B, En,*/ cmp_out_a);             // comparator for mux 2x8 that feeds later into alu input A
	comparator #(.width(8))						CMP_MUX_B (/* in,sel,out*/);				                 // comparator for mux 2x8 that feeds later into alu input B
	MUX_mxn #(.d_width(8),.s_lines(1))          MUX_MUX_A (/* in,sel,out*/ );                                // 2x8 mux that feeds into alu_A_MUX
	MUX_mxn #(.d_width(8),.s_lines(1))          MUX_MUX_B (/* in,sel,out*/ );				                 // 2x8 mux that feeds into alu_B_MUX
	MUX_mxn #(.d_width(8),.s_lines(1))          alu_A_MUX ({mux_out_a[7:0],psr0_out[23:16]}, s[14], a[7:0]); // 2x8 mux that feeds directly into alu input A
	MUX_mxn #(.d_width(8),.s_lines(2))          alu_B_MUX ({mux_out_b[7:0],psr0_out[15:8],/*NEED 10*/, rin_out[7:0]}, {s[16],s[15]}, b[7:0]);   // 4x8 mux that feeds directly into alu input B
	n_bit_ALU                                   alu (a[7:0], b[7:0], s[10], {s[13],s[12],s[11]},f[7:0], cout, v, z);                            // this is the all powerful ALU
	lss_reg #(.n(8))                            Ralu (f[7:0], s[17], g_clr, g_clk,ralu_out[7:0]);				// lss register for the alu result
    ls_reg #(.n(8))                             Rin (bus_in[7:0], s[19], g_clr, g_clk, rin_out[7:0])
    ls_reg #(.n(24))                            PSR1 ({v,z,cout,psr0_out[7:4],ralu_out[7:0],psr0[15:8], /* NEED RWB*/}, s[20], g_clr, g_clk, psr1_out[23:0]);        // pipeline stage register one
	///////////////////
	// stage three   //
	///////////////////
	// ls_reg                                   R_OUT (/*in,c,clr,clk,out*/ );                  // 8 bit r out
	// RAM #(.n(8),.m(8))						D_RAM (/*addr,ce,clk,clr,rw,data*/ );           // 256x8 data random access memory
	// cache									D_CACHE ( /* in and outs*/ );                   // 4x8 data cache
	// MUX_mxn #(.d_width(8),.s_lines(4))		data_Cache_MUX (/* in,sel,out*/);               // 4x8 mux that feeds into the data cache address in
		///////////////////
	// controller    //
	///////////////////
	//badasscontroller      controller (/* in and outs*/);                                 // this is the bad ass controller
	MHVPIS                wtf ( ext_int, mask_in, g_clr, i_en, i_pending, pc_out[7:0]);  // hardware vector priority interrupt system
endmodule
