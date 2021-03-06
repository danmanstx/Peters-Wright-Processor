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
module Processor( bus_in, hs_in, g_clr, g_clk, ext_int, bus_out,  hs_out, reg0, reg1, reg2, reg3, reg4, reg5,
                  reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15, ir_out, Program_counter,
                  mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, mem9, mem10, mem11, mem12, mem13, mem14, 
                  mem15, a, b, f, opcode, state1, state2, state3, stackpointer, cache_hit, data0, data1, data2, data3,
                  addr0, addr1, addr2, addr3);
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
    wire [54:0]s;
    ///////////////////
    // stage one     //
    ///////////////////
    //wires
    wire [25:0] iram_in;
    wire [23:0] icache_in;
    //wire [15:0] ir_out;
    wire [7:0]  sex_out;
    wire [7:0]  pc_in;
    wire        i_pending;
    wire [7:0]  interrupt_out;
    wire [7:0]  psr0_in;
    wire [3:0]  mask_in;
    wire [33:0] psr0_out;
    wire [24:0] psr1_out;    // second stage pipeline output
    wire        ien_out;
    wire [7:0]  ipcr_out;
    wire [7:0]  peek_out;
    wire [7:0]  rbra_out;
    wire        i_odv;
    wire        d_odv;
    wire        bubble;
    wire        stack_enable;
    wire        not_ien_out;
    ////////////--------------------------------------------------------------------------------------------
    // assigns for testing
    ////////////
    //assign i_odv=1;
    assign d_odv=1;
    ////////////--------------------------------------------------------------------------------------------*/
    // test bench things
    ///////////////////////////
    // registers
    output [7:0]  reg0;
    output [7:0]  reg1;
    output [7:0]  reg2;
    output [7:0]  reg3;
    output [7:0]  reg4;
    output [7:0]  reg5;
    output [7:0]  reg6;
    output [7:0]  reg7;
    output [7:0]  reg8;
    output [7:0]  reg9;
    output [7:0]  reg10;
    output [7:0]  reg11;
    output [7:0]  reg12;
    output [7:0]  reg13;
    output [7:0]  reg14;
    output [7:0]  reg15;
    // IR_out
    output [15:0] ir_out;
    // PC_out
    output [7:0] Program_counter;
    assign Program_counter = icache_in[7:0];
    //memory
    output [7:0] mem0;
    output [7:0] mem1;
    output [7:0] mem2;
    output [7:0] mem3;
    output [7:0] mem4;
    output [7:0] mem5;
    output [7:0] mem6;
    output [7:0] mem7;
    output [7:0] mem8;
    output [7:0] mem9;
    output [7:0] mem10;
    output [7:0] mem11;
    output [7:0] mem12;
    output [7:0] mem13;
    output [7:0] mem14;
    output [7:0] mem15;
    // alu
    output [7:0] b;
    output [7:0] a;
    wire   [7:0] mux_out_a;
    assign a = mux_out_a[7:0];
    output [7:0] f;
    // opcode and states
    output [5:0] opcode;
    output [5:0] state1;
    output [5:0] state2;
    output [5:0] state3;
    // stack pointer
    output [3:0] stackpointer;
    // cache hit and miss
    output      cache_hit;
    output [7:0] data0;
    output [7:0] data1;
    output [7:0] data2;
    output [7:0] data3;

    output [7:0] addr0;
    output [7:0] addr1;
    output [7:0] addr2;
    output [7:0] addr3;
    //different ram fiels to load different programs
    ///////////////////////////////////////////////
    
    //RAM_test #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    //RAM_fibonacci #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    //RAM_straightflow #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    //RAM_bubblesort #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    //RAM_subroutine #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    //RAM_interrupts #(.d_width(16),.a_width(8))     I_RAM (icache_in[7:0], s[1], g_clk, g_clr, s[0], icache_in[23:8] );   // 256x16 instruction random access memory
    
    ////////////////////////////////////////////////
    // RAM AND CACHE
    ////////////////////////////////////////////////
    RAM_fibonacci #(.d_width(16),.a_width(8))   I_RAM (iram_in[7:0], iram_in[8], g_clk, g_clr, iram_in[9], iram_in[25:10] );   // 256x16 instruction random access memory
    cache #(.d_width(16),.a_width(8))   I_CACHE (icache_in[7:0], icache_in[23:8], s[1], s[0], iram_in[7:0], iram_in[25:10], 
                                                 iram_in[9], iram_in[8], i_odv, g_clr, g_clk, cache_hit, data0, data1, data2,
                                                 data3, addr0, addr1, addr2, addr3); // 4x16 instruction cache
    
    
    ///////////////////////////////////////////////
    // functional units for stage one
    ///////////////////////////////////////////////
   
    ls_reg #(.n(16))                    IR ( icache_in[23:8], s[2], g_clr, g_clk, ir_out[15:0]);                                                    // 16 bit instruction register
    sign_extend                         SEX ( ir_out[5:0], sex_out[7:0]);                                                                           // sign extend from IR to mux
    n_bit_PC #(.a_width(8))             PC ( pc_in[7:0], {s[5],s[4]}, g_clr, g_clk, icache_in[7:0]);                                                //  8 bit program counter
    MUX_mxn #(.d_width(8),.s_lines(2))  PC_MUX_0 ( {interrupt_out[7:0],ipcr_out[7:0],peek_out[7:0],rbra_out[7:0]}, {s[7],s[6]}, pc_in[7:0]);        // 4x8 mux for program counter
    MUX_mxn #(.d_width(8),.s_lines(2))  PSR0_MUX ( {8'h00,sex_out[7:0],ir_out[9:2],ir_out[15:8]}, {s[13],s[12]}, psr0_in[7:0]);                     // 4x8 mux for pipelined stage register instruction
    ls_reg #(.n(8))                     IPCR ( icache_in[7:0], s[3], g_clr, g_clk, ipcr_out[7:0]);                                                  // 8 bit interrupt program counter  register
    or                                  RS_OR (stack_enable, s[53], s[9]);
    stack #(.width(8),.depth(4))        RETURN_STACK ( peek_out[7:0], icache_in[7:0], s[54], stack_enable, g_clk, g_clr);                           // return stack
    psr #(.size(34),.ri_lsb(8))         PSR0( {s[19],s[18:15],s[24:20],icache_in[7:0],psr0_in[7:0],ir_out[5:2],ir_out[9:6]}, psr0_out[33:0], s[14], // pipeline stage register zero
                                               s[27], s[26], bubble, s[52], g_clr, g_clk); 
    ls_reg #(.n(1))                     I_EN( s[11], s[10], g_clr, g_clk, ien_out);
    not                                 IEN_NOT( not_ien_out, ien_out);
 
    ///////////////////
    // stage two     //
    ///////////////////
    //wires
    wire       cmp_out_a;
    wire       cmp_out_b;
    //wire [7:0] mux_out_a;
    wire [7:0] mux_out_b;
    //wire [7:0] b;
    wire       cout;
    wire       v;
    wire       z;
    //wire [7:0] f;
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
    wire        and_out;

    //functional units
    register_file                          REG_FILE ( s[48],psr0_out[3:0], psr0_out[7:4], psr1_out[5:2], psr1_out[13:6], g_clr, g_clk, rdata0[7:0], rdata1[7:0], reg0, reg1, 
                                                      reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, reg14, reg15 );      // register file 
    comparator #(.width(4))                CMP_A (psr0_out[3:0], psr1_out[5:2], and_out, cmp_out_a);             // comparator for mux 2x8 that feeds later into alu input A
    comparator #(.width(4))                CMP_B (psr0_out[7:4], psr1_out[5:2], and_out, cmp_out_b);             // comparator for mux 2x8 that feeds later into alu input B
    MUX_mxn #(.d_width(8),.s_lines(1))     MUX_A ({psr1_out[13:6],rdata0[7:0]}, cmp_out_a, mux_out_a[7:0]);           // 2x8 mux that feeds into alu_A_MUX
    MUX_mxn #(.d_width(8),.s_lines(1))     MUX_B ({psr1_out[13:6],rdata1[7:0]}, cmp_out_b, mux_out_b[7:0]);           // 2x8 mux that feeds into alu_B_MUX
    MUX_mxn #(.d_width(8),.s_lines(2))     ALU_B_MUX ({rin_out,mdr_out[7:0],psr0_out[15:8],mux_out_b[7:0]}, {s[29],s[28]}, b[7:0]);   // 4x8 mux that feeds directly into alu input B
    n_bit_ALU #(.n(8),.m(3))               ALU  (mux_out_a[7:0], b[7:0], psr0_out[29], psr0_out[32:30], f[7:0], cout, v, z);                       // this is the all powerful ALU
    ls_reg #(.n(8))                        RIN  (bus_in[7:0], s[30], g_clr, g_clk, rin_out[7:0]);
    psr #(.size(25),.ri_lsb(14))           PSR1 ({s[44:43],psr0_out[33],branch_mux_out[7:0],f[7:0],psr0_out[3:0],z,v},psr1_out[24:0], s[38], s[50], 1'b0, 1'b0, 1'b0, g_clr, g_clk);        // pipeline stage register one
    ls_reg #(.n(1))                        PC_W (pc_w_in, s[32], g_clr, g_clk, pc_w );
    not                                    Z_NOT(z_not, z);
    MUX_mxn #(.d_width(1),.s_lines(2))     PC_MUX_1 ({z_not,f[7],1'b1,1'b0},{s[35],s[39]},pc_w_in);
    n_bit_adder #(.n(8))                   BRANCH_ADDER(psr0_out[23:16], psr0_out[15:8], branch_adder_out[7:0]);
    MUX_mxn #(.d_width(8),.s_lines(2))     BRANCH_MUX({rdata1[7:0],branch_adder_out[7:0],rdata0[7:0],psr0_out[15:8]}, {s[34],s[33]}, branch_mux_out[7:0]);
    ls_reg #(.n(8))                        RBRA (branch_mux_out[7:0], s[31], g_clr, g_clk, rbra_out[7:0]);
    n_bit_adder #(.n(8))                   DISP_ADDER(rdata1[7:0],psr0_out[15:8], disp_adder_out[7:0]);
    MUX_mxn #(.d_width(8),.s_lines(2))     DISP_MUX({disp_adder_out[7:0],rdata1[7:0],rdata0[7:0],psr0_out[15:8]}, {s[37],s[36]}, disp_mux_out[7:0]);
    ls_reg #(.n(8))                        R_OUT (f[7:0], s[42], g_clr, g_clk, bus_out[7:0]);               // 8 bit r out
    or                                     BUBBLE_OR (bubble, pc_w, pc_w_in);
    ///////////////////
    // stage three   //
    ///////////////////
    // wires
    wire [17:0] dram_in;
    wire [7:0]  dcache_addr_in;
    //wire        d_odv;
    wire        or_out;
    // functional units
    ls_reg #(.n(4))                     IR_MASK ( psr1_out[21:18], s[49], g_clr, g_clk, mask_in[3:0]);                 // IR mask register
    //RAM #(.d_width(8),.a_width(8))    D_RAM   ( dram_in[7:0], dram_in[8], g_clk, g_clr, dram_in[9], dram_in[17:10], mem0, mem1, mem2, mem3, mem4, mem5,
    //                                              mem6, mem7, mem8, mem9, mem10, mem11, mem12, mem13, mem14, mem15 );   // 256x8 data random access memory
    RAM #(.d_width(8),.a_width(8))      D_RAM   ( dcache_addr_in[7:0], or_out, g_clk, g_clr, s[46], buffer_out[7:0], mem0, mem1, mem2, mem3, mem4, mem5,
                                                  mem6, mem7, mem8, mem9, mem10, mem11, mem12, mem13, mem14, mem15 );   // 256x8 data random access memory
    //cache                             D_CACHE ( dcache_addr_in[7:0], buffer_out[7:0], s[46], or_out, dram_in[7:0], dram_in[17:10], dram_in[9], dram_in[8], d_odv, g_clr, g_clk);  // 4x8 data cache
    or                                  OR_GATE ( or_out, s[47],s[40]);
    and                                 AND_GATE( and_out, psr1_out[22], s[51]);
    ls_reg #(.n(8))                     MDR     ( buffer_out[7:0], s[41], g_clr, g_clk, mdr_out[7:0]);
    MUX_mxn #(.d_width(8),.s_lines(1))  data_Cache_MUX ({psr1_out[21:14],disp_mux_out[7:0]}, s[45], dcache_addr_in[7:0]);  // 4x8 mux that feeds into the data cache address in
    /////////////////////////////////
    // generate for tristate buffers
    /////////////////////////////////
    genvar x;
    generate
    for(x = 0; x < 8; x = x+1)
    begin:buffers
        bufif0 D_BUF    (buffer_out[x],psr1_out[x+6],s[46]);
    end
    endgenerate
    ///////////////////
    // controller
    // and
    // MHVPIS
    ///////////////////

    controller            CNTRL   (ir_out[15:10], g_clr, g_clk, i_odv, d_odv, hs_out, hs_in, i_pending, s[54:0], psr0_out[28:24], psr1_out[24:23], pc_w, opcode, state1, state2, state3 );   // this is the controller
    MHVPIS                INT_SYS ( {ext_int, s[25], v, z}, mask_in[3:0], g_clr, not_ien_out, i_pending, interrupt_out[7:0], g_clk, s[8]);                   // hardware vector priority interrupt system
endmodule
