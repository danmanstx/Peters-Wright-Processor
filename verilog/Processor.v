`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//Processor.v
//
//                  this is the top level for the processor, all of the other
//                  functional units are called and connected here.
//
///////////////////////////////////////////////////////////////////////////////////////
module Processor(bus_in, ext_int, bus_out, hs_in, g_clr, g_clk, hs_out);
    // inputs
    input [7:0]  bus_in;      // this is an input that is called bus_in
    input        hs_in;       // this is an input used for handshaking
    input        g_clk;       // this is the clock input
    input        ext_int;     // this is an external interrupt input
    input        g_clr;       // global clear
    // outputs
    output [7:0] bus_out;     // this is an output called bus_out
    output       hs_out;     // this is another input used for handshaking
    //wires
    wire [50:0]s;
    ///////////////////
    // stage one     //
    ///////////////////
    //wires
    wire [25:0] iram_in;
    wire [23:0] icache_in;
    wire [15:0] ir_out;
    wire [7:0]  sex_out;
    wire [7:0]  pc_in;
    wire        i_pending;
    wire [7:0]  pc_out;
    wire [7:0]  psr0_in;
    wire [3:0]  mask_in;
    wire [33:0] psr0_out;
    wire [24:0] psr1_out;    // second stage pipeline output
    wire        ien_out;
    wire [7:0]  ipcr_out;
    wire [7:0]  peek_out;
	wire [7:0]  rbra_out;
    ////////////--------------------------------------------------------------------------------------------
    // assigns for testing
    //////////
    assign i_odv=1;
    ////////////--------------------------------------------------------------------------------------------*/
    
    // functional units
    RAM_bubblesort #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    //RAM_bubblesort #(.d_width(16),.a_width(8))   I_RAM (iram_in[7:0], iram_in[8], g_clk, g_clr, iram_in[9], iram_in[25:10] );   // 256x16 instruction random access memory
    //cache #(.d_width(16),.a_width(8))   I_CACHE (icache_in[7:0], icache_in[23:8], s[1], s[0], iram_in[7:0], iram_in[25:10], iram_in[9], iram_in[8], i_odv, g_clr, g_clk); // 4x16 instruction cache
    ls_reg #(.n(16))                    IR (icache_in[23:8], s[2], g_clr, g_clk, ir_out[15:0]);                                         // 16 bit instruction register
    sign_extend                         SEX (ir_out[5:0], sex_out[7:0]);                                                                // sign extend from IR to mux
    n_bit_PC #(.a_width(8))             PC (pc_in[7:0], {s[5],s[4]}, g_clr, g_clk, icache_in[7:0]);                                     //  8 bit program counter
    MUX_mxn #(.d_width(8),.s_lines(2))  PC_MUX_0 ({pc_out[7:0],ipcr_out[7:0],peek_out[7:0],rbra_out[7:0]}, {s[6],s[7]}, pc_in[7:0]);      // 4x8 mux for program counter
    MUX_mxn #(.d_width(8),.s_lines(2))  PSR0_MUX ({8'h00,sex_out[7:0],ir_out[9:2],ir_out[15:8]}, {s[12],s[13]}, psr0_in[7:0]);          // 4x8 mux for pipelined stage register instruction
    ls_reg #(.n(8))                     IPCR (icache_in[7:0], s[3], g_clr, g_clk, ipcr_out[7:0]);                                       // 8 bit interrupt program counter  register
    stack                               RETURN_STACK (peek_out[7:0], icache_in[7:0], s[8], s[9], g_clk, g_clr, full, not_empty );       // return stack
    psr #(.size(34),.ri_lsb(8))         PSR0({s[19],s[18:15],s[24:20],icache_in[7:0],psr0_in[7:0],ir_out[5:2],ir_out[9:6]}, psr0_out[33:0], s[14], s[27], s[26], g_clr, g_clk); // pipeline stage register zero
    ls_reg #(.n(1))                     I_EN(s[11],s[10], g_clr, g_clk, ien_out);
    
    ///////////////////
    // stage two     //
    ///////////////////
    //wires
    wire       cmp_out_a;
    wire       cmp_out_b;
    wire [7:0] mux_out_a;
    wire [7:0] mux_out_b;
    wire [7:0] a;
    wire [7:0] b;
    wire       cout;
    wire       v;
    wire       z;
    wire [7:0] f;
    wire [7:0] rin_out;
    wire [7:0] rdata0;
    wire [7:0] rdata1;
    wire [7:0] buffer_out;
    wire [7:0] mdr_out;
    wire [7:0] branch_mux_out;
    wire       z_not;
    wire       pc_w_in;
    wire [7:0] branch_adder_out;
    wire [7:0] disp_adder_out;
    wire [7:0] disp_mux_out;

    //functional units
    register_file                          REG_FILE ( s[48],psr0_out[3:0], psr0_out[7:4], psr1_out[6:3], psr1_out[14:7], g_clr, g_clk, rdata0[7:0], rdata1[7:0]);      // register file 
    comparator #(.width(4))                CMP_A (psr0_out[3:0], psr1_out[6:3], psr1_out[23], cmp_out_a);             // comparator for mux 2x8 that feeds later into alu input A
    comparator #(.width(4))                CMP_B (psr0_out[3:0], psr1_out[6:3], psr1_out[23], cmp_out_b);             // comparator for mux 2x8 that feeds later into alu input B
    MUX_mxn #(.d_width(8),.s_lines(1))     MUX_A ({psr1_out[14:7],rdata0[7:0]}, cmp_out_a, mux_out_a[7:0]);           // 2x8 mux that feeds into alu_A_MUX
    MUX_mxn #(.d_width(8),.s_lines(1))     MUX_B ({psr1_out[14:7],rdata1[7:0]}, cmp_out_b, mux_out_b[7:0]);           // 2x8 mux that feeds into alu_B_MUX
    MUX_mxn #(.d_width(8),.s_lines(2))     ALU_B_MUX ({rin_out,mdr_out[7:0],psr0_out[15:8],mux_out_b[7:0]}, {s[28],s[29]}, b[7:0]);   // 4x8 mux that feeds directly into alu input B
    n_bit_ALU #(.n(8),.m(3))               ALU  (mux_out_a[7:0], b[7:0], s[10], psr0_out[32:29], f[7:0], cout, v, z);                       // this is the all powerful ALU
    ls_reg #(.n(8))                        RIN  (bus_in[7:0], s[30], g_clr, g_clk, rin_out[7:0]);
    psr #(.size(25),.ri_lsb(14))            PSR1 ({s[44:43],psr0_out[33],branch_mux_out[7:0],f[7:0],psr0_out[7:4],cout,z,v},psr1_out[24:0], s[38], s[50], 1'b0, g_clr, g_clk);        // pipeline stage register one
    ls_reg #(.n(1))                        PC_W (pc_w_in, s[32], g_clr, g_clk, pc_w );
    not                                    Z_NOT(z_not, z);
    MUX_mxn #(.d_width(1),.s_lines(2))     PC_MUX_1 ({z_not,f[7],1'b1,1'b0},{s[39],s[35]},pc_w_in);
    n_bit_adder #(.n(8))                   BRANCH_ADDER(psr0_out[23:16], psr0_out[15:8], branch_adder_out[7:0]);
    MUX_mxn #(.d_width(8),.s_lines(2))     BRANCH_MUX({rdata1[7:0],branch_adder_out[7:0],rdata0[7:0],psr0_out[15:8]}, {s[33],s[34]}, branch_mux_out[7:0]);
    ls_reg #(.n(8))                        RBRA (branch_mux_out[7:0], s[31], g_clr, g_clk, rbra_out[7:0]);
    n_bit_adder #(.n(8))                   DISP_ADDER(rdata1[7:0],psr0_out[15:8], disp_adder_out[7:0]);
    MUX_mxn #(.d_width(8),.s_lines(2))      DISP_MUX({disp_adder_out[7:0],rdata1[7:0],rdata0[7:0],psr0_out[15:8]}, {s[36],s[37]}, disp_mux_out[7:0]);
    ls_reg                                 R_OUT (f[7:0], s[42], g_clr, g_clk, bus_out[7:0]);               // 8 bit r out
    
    ///////////////////
    // stage three   //
    ///////////////////
    // wires
    wire [17:0] dram_in;
    wire [7:0]  dcache_addr_in;
    wire        d_odv;
    wire        or_out;
    // functional units
    ls_reg #(.n(4))                     IR_MASK ( psr1_out[22:15], s[49], g_clr, g_clk, mask_in[3:0]);                 // IR mask register
    RAM #(.d_width(8),.a_width(8))      D_RAM   ( dram_in[7:0], dram_in[8], g_clk, g_clr, dram_in[9], dram_in[17:10]);   // 256x8 data random access memory
    cache                               D_CACHE ( dcache_addr_in[7:0], buffer_out[7:0], s[46], or_out, dram_in[7:0], dram_in[17:10], dram_in[9], dram_in[8], d_odv, g_clr, g_clk);  // 4x8 data cache
    bufif1                              D_buf   ( buffer_out[7:0], psr1_out[14:7], s[46]);
    or                                  OR_GATE ( or_out, s[47],s[40]);
    ls_reg #(.n(8))                     MDR     ( buffer_out[7:0], s[41], g_clr, g_clk, mdr_out[7:0]);
    MUX_mxn #(.d_width(8),.s_lines(1))  data_Cache_MUX ({psr1_out[22:15],disp_mux_out[7:0]}, s[45], dcache_addr_in[7:0]);  // 4x8 mux that feeds into the data cache address in
   
    ///////////////////
    // controller
    // and
    // MHVPIS
    ///////////////////
    
    controller            CNTRL   (ir_out[15:10], g_clr, g_clk, i_odv, d_odv, hs_out, hs_in, i_pending, s[50:0], psr0_out[28:24], psr1_out[24:23], pc_w);   // this is the controller
    MHVPIS                INT_SYS ( {psr1_out[1],psr1_out[0],s[25],ext_int}, mask_in, g_clr, ien_out, i_pending, pc_out[7:0]);                            // hardware vector priority interrupt system
endmodule
