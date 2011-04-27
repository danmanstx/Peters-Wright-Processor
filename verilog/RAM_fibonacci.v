`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//RAM_<name>.v
//
//An auto-generated ROM module implemented as a RAM.  Generated using the RomBuilder
//tool.
//
///////////////////////////////////////////////////////////////////////////////////////
module RAM_fibonacci(addr, ce, clk, clr, rw, data);
    parameter d_width = 16;              //data bus width
    parameter a_width = 8;              //address width (2**m memory locations)
    input [a_width-1:0] addr;           //address (m bits wide)
    input ce;                           //chip enable (func. when ce=1, HiZ when ce=0)
    input clk;                          //posedge clock
    input clr;                          //synch active low clear
    input rw;                           //read when rw=1 write when rw=0
    inout [d_width-1:0] data;           //data in/out bus
    reg [d_width-1:0] data_out_reg;     //data output register
    reg [d_width-1:0] memory [2**a_width-1:0];  //memory values
    wire bufctrl;                               //buffer control
    
    initial
    begin
        memory[0] = 16'b1010010000000000;
        memory[1] = 16'b0000101000000000;
        memory[2] = 16'b1000010000010000;
        memory[3] = 16'b1000000000001100;
        memory[4] = 16'b0111000000000011;
        memory[5] = 16'b1010010001000000;
        memory[6] = 16'b0000000000000000;
        memory[7] = 16'b1000100000000000;
        memory[8] = 16'b1001000011000000;
        memory[9] = 16'b0010010011000000;
        memory[10] = 16'b0000000100000000;
        memory[11] = 16'b0111000011000011;
        memory[12] = 16'b1010010001000000;
        memory[13] = 16'b0000000100000000;
        memory[14] = 16'b1000100000000000;
        memory[15] = 16'b0010010000000000;
        memory[16] = 16'b0000000100000000;
        memory[17] = 16'b1000010000010000;
        memory[18] = 16'b1001000011000000;
        memory[19] = 16'b0010010011000000;
        memory[20] = 16'b0000000100000000;
        memory[21] = 16'b1001100011000100;
        memory[22] = 16'b0010010000000000;
        memory[23] = 16'b0000000100000000;
        memory[24] = 16'b1001010100000000;
        memory[25] = 16'b0001000001010000;
        memory[26] = 16'b0001010000000000;
        memory[27] = 16'b0000001000000000;
        memory[28] = 16'b1000100000000000;
        memory[29] = 16'b0000000000000000;
        memory[30] = 16'b0000000000000000;
        memory[31] = 16'b0000000000000000;
        memory[32] = 16'b0000000000000000;
        memory[33] = 16'b0000000000000000;
        memory[34] = 16'b0000000000000000;
        memory[35] = 16'b0000000000000000;
        memory[36] = 16'b0000000000000000;
        memory[37] = 16'b0000000000000000;
        memory[38] = 16'b0000000000000000;
        memory[39] = 16'b0000000000000000;
        memory[40] = 16'b0000000000000000;
        memory[41] = 16'b0000000000000000;
        memory[42] = 16'b0000000000000000;
        memory[43] = 16'b0000000000000000;
        memory[44] = 16'b0000000000000000;
        memory[45] = 16'b0000000000000000;
        memory[46] = 16'b0000000000000000;
        memory[47] = 16'b0000000000000000;
        memory[48] = 16'b0000000000000000;
        memory[49] = 16'b0000000000000000;
        memory[50] = 16'b0000000000000000;
        memory[51] = 16'b0000000000000000;
        memory[52] = 16'b0000000000000000;
        memory[53] = 16'b0000000000000000;
        memory[54] = 16'b0000000000000000;
        memory[55] = 16'b0000000000000000;
        memory[56] = 16'b0000000000000000;
        memory[57] = 16'b0000000000000000;
        memory[58] = 16'b0000000000000000;
        memory[59] = 16'b0000000000000000;
        memory[60] = 16'b0000000000000000;
        memory[61] = 16'b0000000000000000;
        memory[62] = 16'b0000000000000000;
        memory[63] = 16'b0000000000000000;
        memory[64] = 16'b0000000000000000;
        memory[65] = 16'b0000000000000000;
        memory[66] = 16'b0000000000000000;
        memory[67] = 16'b0000000000000000;
        memory[68] = 16'b0000000000000000;
        memory[69] = 16'b0000000000000000;
        memory[70] = 16'b0000000000000000;
        memory[71] = 16'b0000000000000000;
        memory[72] = 16'b0000000000000000;
        memory[73] = 16'b0000000000000000;
        memory[74] = 16'b0000000000000000;
        memory[75] = 16'b0000000000000000;
        memory[76] = 16'b0000000000000000;
        memory[77] = 16'b0000000000000000;
        memory[78] = 16'b0000000000000000;
        memory[79] = 16'b0000000000000000;
        memory[80] = 16'b0000000000000000;
        memory[81] = 16'b0000000000000000;
        memory[82] = 16'b0000000000000000;
        memory[83] = 16'b0000000000000000;
        memory[84] = 16'b0000000000000000;
        memory[85] = 16'b0000000000000000;
        memory[86] = 16'b0000000000000000;
        memory[87] = 16'b0000000000000000;
        memory[88] = 16'b0000000000000000;
        memory[89] = 16'b0000000000000000;
        memory[90] = 16'b0000000000000000;
        memory[91] = 16'b0000000000000000;
        memory[92] = 16'b0000000000000000;
        memory[93] = 16'b0000000000000000;
        memory[94] = 16'b0000000000000000;
        memory[95] = 16'b0000000000000000;
        memory[96] = 16'b0000000000000000;
        memory[97] = 16'b0000000000000000;
        memory[98] = 16'b0000000000000000;
        memory[99] = 16'b0000000000000000;
        memory[100] = 16'b0000010010010100;
        memory[101] = 16'b0000000000000000;
        memory[102] = 16'b0000000000000000;
        memory[103] = 16'b0000000000000000;
        memory[104] = 16'b0000000000000000;
        memory[105] = 16'b0000000000000000;
        memory[106] = 16'b0000000000000000;
        memory[107] = 16'b0000000000000000;
        memory[108] = 16'b0000000000000000;
        memory[109] = 16'b0000000000000000;
        memory[110] = 16'b0000000000000000;
        memory[111] = 16'b0000000000000000;
        memory[112] = 16'b0000000000000000;
        memory[113] = 16'b0000000000000000;
        memory[114] = 16'b0000000000000000;
        memory[115] = 16'b0000000000000000;
        memory[116] = 16'b0000000000000000;
        memory[117] = 16'b0000000000000000;
        memory[118] = 16'b0000000000000000;
        memory[119] = 16'b0000000000000000;
        memory[120] = 16'b0000010010010100;
        memory[121] = 16'b0000000000000000;
        memory[122] = 16'b0000000000000000;
        memory[123] = 16'b0000000000000000;
        memory[124] = 16'b0000000000000000;
        memory[125] = 16'b0000000000000000;
        memory[126] = 16'b0000000000000000;
        memory[127] = 16'b0000000000000000;
        memory[128] = 16'b0000000000000000;
        memory[129] = 16'b0000000000000000;
        memory[130] = 16'b0000000000000000;
        memory[131] = 16'b0000000000000000;
        memory[132] = 16'b0000000000000000;
        memory[133] = 16'b0000000000000000;
        memory[134] = 16'b0000000000000000;
        memory[135] = 16'b0000000000000000;
        memory[136] = 16'b0000000000000000;
        memory[137] = 16'b0000000000000000;
        memory[138] = 16'b0000000000000000;
        memory[139] = 16'b0000000000000000;
        memory[140] = 16'b0000010010010100;
        memory[141] = 16'b0000000000000000;
        memory[142] = 16'b0000000000000000;
        memory[143] = 16'b0000000000000000;
        memory[144] = 16'b0000000000000000;
        memory[145] = 16'b0000000000000000;
        memory[146] = 16'b0000000000000000;
        memory[147] = 16'b0000000000000000;
        memory[148] = 16'b0000000000000000;
        memory[149] = 16'b0000000000000000;
        memory[150] = 16'b0000000000000000;
        memory[151] = 16'b0000000000000000;
        memory[152] = 16'b0000000000000000;
        memory[153] = 16'b0000000000000000;
        memory[154] = 16'b0000000000000000;
        memory[155] = 16'b0000000000000000;
        memory[156] = 16'b0000000000000000;
        memory[157] = 16'b0000000000000000;
        memory[158] = 16'b0000000000000000;
        memory[159] = 16'b0000000000000000;
        memory[160] = 16'b0000010010010100;
        memory[161] = 16'b0000000000000000;
        memory[162] = 16'b0000000000000000;
        memory[163] = 16'b0000000000000000;
        memory[164] = 16'b0000000000000000;
        memory[165] = 16'b0000000000000000;
        memory[166] = 16'b0000000000000000;
        memory[167] = 16'b0000000000000000;
        memory[168] = 16'b0000000000000000;
        memory[169] = 16'b0000000000000000;
        memory[170] = 16'b0000000000000000;
        memory[171] = 16'b0000000000000000;
        memory[172] = 16'b0000000000000000;
        memory[173] = 16'b0000000000000000;
        memory[174] = 16'b0000000000000000;
        memory[175] = 16'b0000000000000000;
        memory[176] = 16'b0000000000000000;
        memory[177] = 16'b0000000000000000;
        memory[178] = 16'b0000000000000000;
        memory[179] = 16'b0000000000000000;
        memory[180] = 16'b0000000000000000;
        memory[181] = 16'b0000000000000000;
        memory[182] = 16'b0000000000000000;
        memory[183] = 16'b0000000000000000;
        memory[184] = 16'b0000000000000000;
        memory[185] = 16'b0000000000000000;
        memory[186] = 16'b0000000000000000;
        memory[187] = 16'b0000000000000000;
        memory[188] = 16'b0000000000000000;
        memory[189] = 16'b0000000000000000;
        memory[190] = 16'b0000000000000000;
        memory[191] = 16'b0000000000000000;
        memory[192] = 16'b0000000000000000;
        memory[193] = 16'b0000000000000000;
        memory[194] = 16'b0000000000000000;
        memory[195] = 16'b0000000000000000;
        memory[196] = 16'b0000000000000000;
        memory[197] = 16'b0000000000000000;
        memory[198] = 16'b0000000000000000;
        memory[199] = 16'b0000000000000000;
        memory[200] = 16'b0000000000000000;
        memory[201] = 16'b0000000000000000;
        memory[202] = 16'b0000000000000000;
        memory[203] = 16'b0000000000000000;
        memory[204] = 16'b0000000000000000;
        memory[205] = 16'b0000000000000000;
        memory[206] = 16'b0000000000000000;
        memory[207] = 16'b0000000000000000;
        memory[208] = 16'b0000000000000000;
        memory[209] = 16'b0000000000000000;
        memory[210] = 16'b0000000000000000;
        memory[211] = 16'b0000000000000000;
        memory[212] = 16'b0000000000000000;
        memory[213] = 16'b0000000000000000;
        memory[214] = 16'b0000000000000000;
        memory[215] = 16'b0000000000000000;
        memory[216] = 16'b0000000000000000;
        memory[217] = 16'b0000000000000000;
        memory[218] = 16'b0000000000000000;
        memory[219] = 16'b0000000000000000;
        memory[220] = 16'b0000000000000000;
        memory[221] = 16'b0000000000000000;
        memory[222] = 16'b0000000000000000;
        memory[223] = 16'b0000000000000000;
        memory[224] = 16'b0000000000000000;
        memory[225] = 16'b0000000000000000;
        memory[226] = 16'b0000000000000000;
        memory[227] = 16'b0000000000000000;
        memory[228] = 16'b0000000000000000;
        memory[229] = 16'b0000000000000000;
        memory[230] = 16'b0000000000000000;
        memory[231] = 16'b0000000000000000;
        memory[232] = 16'b0000000000000000;
        memory[233] = 16'b0000000000000000;
        memory[234] = 16'b0000000000000000;
        memory[235] = 16'b0000000000000000;
        memory[236] = 16'b0000000000000000;
        memory[237] = 16'b0000000000000000;
        memory[238] = 16'b0000000000000000;
        memory[239] = 16'b0000000000000000;
        memory[240] = 16'b0000000000000000;
        memory[241] = 16'b0000000000000000;
        memory[242] = 16'b0000000000000000;
        memory[243] = 16'b0000000000000000;
        memory[244] = 16'b0000000000000000;
        memory[245] = 16'b0000000000000000;
        memory[246] = 16'b0000000000000000;
        memory[247] = 16'b0000000000000000;
        memory[248] = 16'b0000000000000000;
        memory[249] = 16'b0000000000000000;
        memory[250] = 16'b0000000000000000;
        memory[251] = 16'b0000000000000000;
        memory[252] = 16'b0000000000000000;
        memory[253] = 16'b0000000000000000;
        memory[254] = 16'b0000000000000000;
        memory[255] = 16'b0000000000000000;
    end

    //read/write synchronous loop
    always@(posedge clk)
    begin
        if(clr == 0)        //clear contents
        begin
            data_out_reg <= 0;
            memory[0] <= 16'b1010010000000000;
            memory[1] <= 16'b0000101000000000;
            memory[2] <= 16'b1000010000010000;
            memory[3] <= 16'b1000000000001100;
            memory[4] <= 16'b0111000000000011;
            memory[5] <= 16'b1010010001000000;
            memory[6] <= 16'b0000000000000000;
            memory[7] <= 16'b1000100000000000;
            memory[8] <= 16'b1001000011000000;
            memory[9] <= 16'b0010010011000000;
            memory[10] <= 16'b0000000100000000;
            memory[11] <= 16'b0111000011000011;
            memory[12] <= 16'b1010010001000000;
            memory[13] <= 16'b0000000100000000;
            memory[14] <= 16'b1000100000000000;
            memory[15] <= 16'b0010010000000000;
            memory[16] <= 16'b0000000100000000;
            memory[17] <= 16'b1000010000010000;
            memory[18] <= 16'b1001000011000000;
            memory[19] <= 16'b0010010011000000;
            memory[20] <= 16'b0000000100000000;
            memory[21] <= 16'b1001100011000100;
            memory[22] <= 16'b0010010000000000;
            memory[23] <= 16'b0000000100000000;
            memory[24] <= 16'b1001010100000000;
            memory[25] <= 16'b0001000001010000;
            memory[26] <= 16'b0001010000000000;
            memory[27] <= 16'b0000001000000000;
            memory[28] <= 16'b1000100000000000;
            memory[29] <= 16'b0000000000000000;
            memory[30] <= 16'b0000000000000000;
            memory[31] <= 16'b0000000000000000;
            memory[32] <= 16'b0000000000000000;
            memory[33] <= 16'b0000000000000000;
            memory[34] <= 16'b0000000000000000;
            memory[35] <= 16'b0000000000000000;
            memory[36] <= 16'b0000000000000000;
            memory[37] <= 16'b0000000000000000;
            memory[38] <= 16'b0000000000000000;
            memory[39] <= 16'b0000000000000000;
            memory[40] <= 16'b0000000000000000;
            memory[41] <= 16'b0000000000000000;
            memory[42] <= 16'b0000000000000000;
            memory[43] <= 16'b0000000000000000;
            memory[44] <= 16'b0000000000000000;
            memory[45] <= 16'b0000000000000000;
            memory[46] <= 16'b0000000000000000;
            memory[47] <= 16'b0000000000000000;
            memory[48] <= 16'b0000000000000000;
            memory[49] <= 16'b0000000000000000;
            memory[50] <= 16'b0000000000000000;
            memory[51] <= 16'b0000000000000000;
            memory[52] <= 16'b0000000000000000;
            memory[53] <= 16'b0000000000000000;
            memory[54] <= 16'b0000000000000000;
            memory[55] <= 16'b0000000000000000;
            memory[56] <= 16'b0000000000000000;
            memory[57] <= 16'b0000000000000000;
            memory[58] <= 16'b0000000000000000;
            memory[59] <= 16'b0000000000000000;
            memory[60] <= 16'b0000000000000000;
            memory[61] <= 16'b0000000000000000;
            memory[62] <= 16'b0000000000000000;
            memory[63] <= 16'b0000000000000000;
            memory[64] <= 16'b0000000000000000;
            memory[65] <= 16'b0000000000000000;
            memory[66] <= 16'b0000000000000000;
            memory[67] <= 16'b0000000000000000;
            memory[68] <= 16'b0000000000000000;
            memory[69] <= 16'b0000000000000000;
            memory[70] <= 16'b0000000000000000;
            memory[71] <= 16'b0000000000000000;
            memory[72] <= 16'b0000000000000000;
            memory[73] <= 16'b0000000000000000;
            memory[74] <= 16'b0000000000000000;
            memory[75] <= 16'b0000000000000000;
            memory[76] <= 16'b0000000000000000;
            memory[77] <= 16'b0000000000000000;
            memory[78] <= 16'b0000000000000000;
            memory[79] <= 16'b0000000000000000;
            memory[80] <= 16'b0000000000000000;
            memory[81] <= 16'b0000000000000000;
            memory[82] <= 16'b0000000000000000;
            memory[83] <= 16'b0000000000000000;
            memory[84] <= 16'b0000000000000000;
            memory[85] <= 16'b0000000000000000;
            memory[86] <= 16'b0000000000000000;
            memory[87] <= 16'b0000000000000000;
            memory[88] <= 16'b0000000000000000;
            memory[89] <= 16'b0000000000000000;
            memory[90] <= 16'b0000000000000000;
            memory[91] <= 16'b0000000000000000;
            memory[92] <= 16'b0000000000000000;
            memory[93] <= 16'b0000000000000000;
            memory[94] <= 16'b0000000000000000;
            memory[95] <= 16'b0000000000000000;
            memory[96] <= 16'b0000000000000000;
            memory[97] <= 16'b0000000000000000;
            memory[98] <= 16'b0000000000000000;
            memory[99] <= 16'b0000000000000000;
            memory[100] <= 16'b0000010010010100;
            memory[101] <= 16'b0000000000000000;
            memory[102] <= 16'b0000000000000000;
            memory[103] <= 16'b0000000000000000;
            memory[104] <= 16'b0000000000000000;
            memory[105] <= 16'b0000000000000000;
            memory[106] <= 16'b0000000000000000;
            memory[107] <= 16'b0000000000000000;
            memory[108] <= 16'b0000000000000000;
            memory[109] <= 16'b0000000000000000;
            memory[110] <= 16'b0000000000000000;
            memory[111] <= 16'b0000000000000000;
            memory[112] <= 16'b0000000000000000;
            memory[113] <= 16'b0000000000000000;
            memory[114] <= 16'b0000000000000000;
            memory[115] <= 16'b0000000000000000;
            memory[116] <= 16'b0000000000000000;
            memory[117] <= 16'b0000000000000000;
            memory[118] <= 16'b0000000000000000;
            memory[119] <= 16'b0000000000000000;
            memory[120] <= 16'b0000010010010100;
            memory[121] <= 16'b0000000000000000;
            memory[122] <= 16'b0000000000000000;
            memory[123] <= 16'b0000000000000000;
            memory[124] <= 16'b0000000000000000;
            memory[125] <= 16'b0000000000000000;
            memory[126] <= 16'b0000000000000000;
            memory[127] <= 16'b0000000000000000;
            memory[128] <= 16'b0000000000000000;
            memory[129] <= 16'b0000000000000000;
            memory[130] <= 16'b0000000000000000;
            memory[131] <= 16'b0000000000000000;
            memory[132] <= 16'b0000000000000000;
            memory[133] <= 16'b0000000000000000;
            memory[134] <= 16'b0000000000000000;
            memory[135] <= 16'b0000000000000000;
            memory[136] <= 16'b0000000000000000;
            memory[137] <= 16'b0000000000000000;
            memory[138] <= 16'b0000000000000000;
            memory[139] <= 16'b0000000000000000;
            memory[140] <= 16'b0000010010010100;
            memory[141] <= 16'b0000000000000000;
            memory[142] <= 16'b0000000000000000;
            memory[143] <= 16'b0000000000000000;
            memory[144] <= 16'b0000000000000000;
            memory[145] <= 16'b0000000000000000;
            memory[146] <= 16'b0000000000000000;
            memory[147] <= 16'b0000000000000000;
            memory[148] <= 16'b0000000000000000;
            memory[149] <= 16'b0000000000000000;
            memory[150] <= 16'b0000000000000000;
            memory[151] <= 16'b0000000000000000;
            memory[152] <= 16'b0000000000000000;
            memory[153] <= 16'b0000000000000000;
            memory[154] <= 16'b0000000000000000;
            memory[155] <= 16'b0000000000000000;
            memory[156] <= 16'b0000000000000000;
            memory[157] <= 16'b0000000000000000;
            memory[158] <= 16'b0000000000000000;
            memory[159] <= 16'b0000000000000000;
            memory[160] <= 16'b0000010010010100;
            memory[161] <= 16'b0000000000000000;
            memory[162] <= 16'b0000000000000000;
            memory[163] <= 16'b0000000000000000;
            memory[164] <= 16'b0000000000000000;
            memory[165] <= 16'b0000000000000000;
            memory[166] <= 16'b0000000000000000;
            memory[167] <= 16'b0000000000000000;
            memory[168] <= 16'b0000000000000000;
            memory[169] <= 16'b0000000000000000;
            memory[170] <= 16'b0000000000000000;
            memory[171] <= 16'b0000000000000000;
            memory[172] <= 16'b0000000000000000;
            memory[173] <= 16'b0000000000000000;
            memory[174] <= 16'b0000000000000000;
            memory[175] <= 16'b0000000000000000;
            memory[176] <= 16'b0000000000000000;
            memory[177] <= 16'b0000000000000000;
            memory[178] <= 16'b0000000000000000;
            memory[179] <= 16'b0000000000000000;
            memory[180] <= 16'b0000000000000000;
            memory[181] <= 16'b0000000000000000;
            memory[182] <= 16'b0000000000000000;
            memory[183] <= 16'b0000000000000000;
            memory[184] <= 16'b0000000000000000;
            memory[185] <= 16'b0000000000000000;
            memory[186] <= 16'b0000000000000000;
            memory[187] <= 16'b0000000000000000;
            memory[188] <= 16'b0000000000000000;
            memory[189] <= 16'b0000000000000000;
            memory[190] <= 16'b0000000000000000;
            memory[191] <= 16'b0000000000000000;
            memory[192] <= 16'b0000000000000000;
            memory[193] <= 16'b0000000000000000;
            memory[194] <= 16'b0000000000000000;
            memory[195] <= 16'b0000000000000000;
            memory[196] <= 16'b0000000000000000;
            memory[197] <= 16'b0000000000000000;
            memory[198] <= 16'b0000000000000000;
            memory[199] <= 16'b0000000000000000;
            memory[200] <= 16'b0000000000000000;
            memory[201] <= 16'b0000000000000000;
            memory[202] <= 16'b0000000000000000;
            memory[203] <= 16'b0000000000000000;
            memory[204] <= 16'b0000000000000000;
            memory[205] <= 16'b0000000000000000;
            memory[206] <= 16'b0000000000000000;
            memory[207] <= 16'b0000000000000000;
            memory[208] <= 16'b0000000000000000;
            memory[209] <= 16'b0000000000000000;
            memory[210] <= 16'b0000000000000000;
            memory[211] <= 16'b0000000000000000;
            memory[212] <= 16'b0000000000000000;
            memory[213] <= 16'b0000000000000000;
            memory[214] <= 16'b0000000000000000;
            memory[215] <= 16'b0000000000000000;
            memory[216] <= 16'b0000000000000000;
            memory[217] <= 16'b0000000000000000;
            memory[218] <= 16'b0000000000000000;
            memory[219] <= 16'b0000000000000000;
            memory[220] <= 16'b0000000000000000;
            memory[221] <= 16'b0000000000000000;
            memory[222] <= 16'b0000000000000000;
            memory[223] <= 16'b0000000000000000;
            memory[224] <= 16'b0000000000000000;
            memory[225] <= 16'b0000000000000000;
            memory[226] <= 16'b0000000000000000;
            memory[227] <= 16'b0000000000000000;
            memory[228] <= 16'b0000000000000000;
            memory[229] <= 16'b0000000000000000;
            memory[230] <= 16'b0000000000000000;
            memory[231] <= 16'b0000000000000000;
            memory[232] <= 16'b0000000000000000;
            memory[233] <= 16'b0000000000000000;
            memory[234] <= 16'b0000000000000000;
            memory[235] <= 16'b0000000000000000;
            memory[236] <= 16'b0000000000000000;
            memory[237] <= 16'b0000000000000000;
            memory[238] <= 16'b0000000000000000;
            memory[239] <= 16'b0000000000000000;
            memory[240] <= 16'b0000000000000000;
            memory[241] <= 16'b0000000000000000;
            memory[242] <= 16'b0000000000000000;
            memory[243] <= 16'b0000000000000000;
            memory[244] <= 16'b0000000000000000;
            memory[245] <= 16'b0000000000000000;
            memory[246] <= 16'b0000000000000000;
            memory[247] <= 16'b0000000000000000;
            memory[248] <= 16'b0000000000000000;
            memory[249] <= 16'b0000000000000000;
            memory[250] <= 16'b0000000000000000;
            memory[251] <= 16'b0000000000000000;
            memory[252] <= 16'b0000000000000000;
            memory[253] <= 16'b0000000000000000;
            memory[254] <= 16'b0000000000000000;
            memory[255] <= 16'b0000000000000000;
        end
        if(ce == 1)         //only read or write if chip is enabled
        begin
            if(clr == 1)    //do nothing on a clear
            begin
                if(rw == 0) //write data
                begin
                    memory[addr] <= data;
                end
                else        //read data
                begin
                    data_out_reg <= memory[addr];
                end
            end
        end
    end
    
    genvar j;
    
    assign bufctrl = (rw && ce);    //buffer only when rw=1 and ce=1 (read and chip enabled)
    
    //data direction buffers for inout
    generate
    for(j = 0; j < d_width; j = j+1)
    begin:buffers
        bufif1 RW_BUF    (data[j],data_out_reg[j],bufctrl);
    end
    endgenerate

endmodule
