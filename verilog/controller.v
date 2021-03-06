`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//controller.v
//
//                  this is the controller
//
///////////////////////////////////////////////////////////////////////////////////////
module controller(opcode, clr, clk, i_odv, d_odv, hs_out, hs_in, i_pending, s_w, st1, st2, pc_w, opcode_out, state1_out, state2_out, state3_out);
    ////////////////////////
    // inputs
    ////////////////////////
    input [5:0]   opcode;
    input         i_pending;
    input         clk;
    input         clr;
    input         pc_w;
    input         i_odv;
    input         d_odv;
    input         hs_in;
    input [4:0]   st1;
    input [1:0]   st2;
    //////////////////////////////////////////
    // register to hold state and next state
    //////////////////////////////////////////
    reg [5:0] state0;
    reg [5:0] state1;
    reg [5:0] state2;
    reg ps0r;
    reg ps1r;
    reg ps2r;
    reg d_rdy;
    /////////////////////////
    // outputs
    ////////////////////////
    reg [0:54] s;
    output [0:54] s_w;
    output [5:0] opcode_out;
    assign opcode_out = opcode;
    output [5:0] state1_out;
    assign state1_out = state0;
    output [5:0] state2_out;
    assign state2_out = state1;
    output [5:0] state3_out;
    assign state3_out = state2;
    ///////////////////////////////////
    // generate to flip select lines
    ///////////////////////////////////
    genvar j;
    generate
    for(j=0;j<55;j=j+1)
    begin:reverse_s
        assign s_w[j] = s[54-j]; 
    end
    endgenerate
    
    output reg  hs_out;
    /////////////////////////////
    // parameters for each state
    /////////////////////////////
    parameter T0=7'b0000000;  parameter T1=7'b0000001;  parameter T2=7'b0000010;  parameter T3=7'b0000011;
    parameter T4=7'b0000100;  parameter T5=7'b0000101;  parameter T6=7'b0000110;  parameter T7=7'b0000111;
    parameter T8=7'b0001000;  parameter T9=7'b0001001;  parameter T10=7'b0001010; parameter T11=7'b0001011;
    parameter T12=7'b0001100; parameter T13=7'b0001101; parameter T14=7'b0001110; parameter T15=7'b0001111;
    parameter T16=7'b0010000; parameter T17=7'b0010001; parameter T18=7'b0010010; parameter T19=7'b0010011;
    parameter T20=7'b0010100; parameter T21=7'b0010101; parameter T22=7'b0010110; parameter T23=7'b0010111;
    parameter T24=7'b0011000; parameter T25=7'b0011001; parameter T26=7'b0011010; parameter T27=7'b0011011;
    parameter T28=7'b0011100; parameter T29=7'b0011101; parameter T30=7'b0011110; parameter T31=7'b0011111;
    parameter T32=7'b0100000; parameter T33=7'b0100001; parameter T34=7'b0100010; parameter T35=7'b0100011;
    parameter T36=7'b0100100; parameter T37=7'b0100101; parameter T38=7'b0100110; parameter T39=7'b0100111;
    parameter T40=7'b0101000; parameter T41=7'b0101001; parameter T42=7'b0101010; parameter T43=7'b0101011;
    parameter T44=7'b0101100; parameter T45=7'b0101101; parameter T46=7'b0101110; parameter T47=7'b0101111;
    parameter T48=7'b0110000; parameter T49=7'b0110001; parameter T50=7'b0110010; parameter T51=7'b0110011;
    parameter T52=7'b0110100; parameter T53=7'b0110101; parameter T54=7'b0110110; parameter T55=7'b0110111;
    parameter T56=7'b0111000; parameter T57=7'b0111001; parameter T58=7'b0111010; parameter T59=7'b0111011;
    parameter T60=7'b0111100; parameter T61=7'b0111101; parameter T62=7'b0111110; parameter T63=7'b0111111;
    parameter T64=7'b1000000; parameter T65=7'b1000001; parameter T66=7'b1000010; parameter T67=7'B1000011;
    parameter T68=7'b1000100;
    
    ///////////////////////////////////////////////////////
    // always block to begin state machine for first stage
    ///////////////////////////////////////////////////////
    always @ (posedge clk)
    begin
        if(clr == 0)    state0 <= 0;
        else
        begin
            case(state0)
            T0:
            begin
                if(ps2r == 0)   state0 <= T0;
                else
                    if(pc_w == 1)            state0 <= T54;
                    else if(i_pending == 1)  state0 <= T1;
                    else                     state0 <= T3;
            end
            T1: state0 <= T2;
            T2: state0 <= T3;
            T3:
            begin
                if(i_odv == 1)  state0 <= T4;
                else            state0 <= T3;
            end
            T4:
            begin
                case(opcode)
                    6'o00: state0 <= T5;
                    6'o01: state0 <= T6;
                    6'o02: state0 <= T7;
                    6'o03: state0 <= T8;
                    6'o04: state0 <= T9;
                    6'o05: state0 <= T10;
                    6'o06: state0 <= T11;
                    6'o07: state0 <= T12;
                    6'o10: state0 <= T13;
                    6'o11: state0 <= T14;
                    6'o12: state0 <= T15;
                    6'o13: state0 <= T16;
                    6'o14: state0 <= T17;
                    6'o15: state0 <= T18;
                    6'o16: state0 <= T19;
                    6'o17: state0 <= T20;
                    6'o20: state0 <= T21;
                    6'o21: state0 <= T22;
                    6'o22: state0 <= T23;
                    6'o23: state0 <= T24;
                    6'o24: state0 <= T25;
                    6'o25: state0 <= T26;
                    6'o26: state0 <= T27;
                    6'o27: state0 <= T28;
                    6'o30: state0 <= T29;
                    6'o31: state0 <= T30;
                    6'o32: state0 <= T31;
                    6'o33: state0 <= T32;
                    6'o34: state0 <= T33;
                    6'o35: state0 <= T34;
                    6'o36: state0 <= T35;
                    6'o37: state0 <= T36;
                    6'o40: state0 <= T37;
                    6'o41: state0 <= T38;
                    6'o42: state0 <= T39;
                    6'o43: state0 <= T40;
                    6'o44: state0 <= T41;
                    6'o45: state0 <= T42;
                    6'o46: state0 <= T43;
                    6'o47: state0 <= T44;
                    6'o50: state0 <= T45;
                    6'o51: state0 <= T46;
                    6'o52: state0 <= T47;
                    6'o53: state0 <= T48;
                    6'o54: state0 <= T49;
                    6'o55: state0 <= T50;
                    default: state0 <=T51;
                endcase
            end
            T5:  state0 <= T0;
            T6:  state0 <= T52;
            T7:  state0 <= T0;
            T8:  state0 <= T52;
            T9:  state0 <= T0;
            T10: state0 <= T52;
            T11: state0 <= T0;
            T12: state0 <= T52;
            T13: state0 <= T0;
            T14: state0 <= T52;
            T15: state0 <= T0;
            T16: state0 <= T52;
            T17: state0 <= T0;
            T18: state0 <= T52;
            T19: state0 <= T0;
            T20: state0 <= T52;
            T21: state0 <= T0;
            T22: state0 <= T52;
            T23: state0 <= T0;
            T24: state0 <= T52;
            T25: state0 <= T0;
            T26: state0 <= T52;
            T27: state0 <= T0;
            T28: state0 <= T52;
            T29: state0 <= T0;
            T30: state0 <= T52;
            T31: state0 <= T0;
            T32: state0 <= T52;
            T33: state0 <= T0;
            T34: state0 <= T52;
            T35: state0 <= T0;
            T36: state0 <= T0;
            T37: state0 <= T0;
            T38: state0 <= T0;
            T39: state0 <= T0;
            T40: state0 <= T0;
            T41: state0 <= T0;
            T42: state0 <= T0;
            T43: state0 <= T0;
            T44: state0 <= T0;
            T45: state0 <= T52;
            T46: state0 <= T52;
            T47: state0 <= T52;
            T48: state0 <= T0;
            T49: state0 <= T0;
            T50: state0 <= T0;
            T51: state0 <= T0;
            T52:
            begin
                if(i_odv == 1) state0 <= T53;
                else           state0 <=T52;
            end
            T53: state0 <= T0;
            T54:
            begin
                if(i_pending ==1) state0 <= T1;
                else              state0 <= T55;
            end
            T55: state0 <= T3;
            default: state0 <= T0;
            endcase
            end
    end
    ///////////////////////////////////////////
    // always block for first state machine's
    //  logic
    ///////////////////////////////////////////
    always @(state0)
    begin
         case(state0)
            T0:  s[0:26] = 27'b110000000000000000000000000;
            T1:  s[0:26] = 27'b000111110011000000000000000;
            T2:  s[0:26] = 27'b110000111000000000000000000;
            T3:  s[0:26] = 27'b111000000000000000000000000;
            T4:  s[0:26] = 27'b111001000000000000000000000;
            T5:  s[0:26] = 27'b000000000000001001011001000;
            T6:  s[0:26] = 27'b110000000000001001011000000;
            T7:  s[0:26] = 27'b000000000000001001010100000;
            T8:  s[0:26] = 27'b110000000000001001011100000;
            T9:  s[0:26] = 27'b000000000000001000011001000;
            T10: s[0:26] = 27'b110000000000001000011000000;
            T11: s[0:26] = 27'b000000000000001000010100000;
            T12: s[0:26] = 27'b110000000000001000011100000;
            T13: s[0:26] = 27'b000000000000001100011001000;
            T14: s[0:26] = 27'b110000000000001100011000000;
            T15: s[0:26] = 27'b000000000000001100010100000;
            T16: s[0:26] = 27'b110000000000001100011100000;
            T17: s[0:26] = 27'b000000000000001010011001000;
            T18: s[0:26] = 27'b110000000000001010011000000;
            T19: s[0:26] = 27'b000000000000001010010100000;
            T20: s[0:26] = 27'b110000000000001010011100000;
            T21: s[0:26] = 27'b000000000000001111011001000;
            T22: s[0:26] = 27'b110000000000001111011000000;
            T23: s[0:26] = 27'b000000000000001111010100000;
            T24: s[0:26] = 27'b110000000000001111011100000;
            T25: s[0:26] = 27'b000000000000001000111001000;
            T26: s[0:26] = 27'b110000000000001000111000000;
            T27: s[0:26] = 27'b000000000000001000110100000;
            T28: s[0:26] = 27'b110000000000001000111100000;
            T29: s[0:26] = 27'b000000000000001100111001000;
            T30: s[0:26] = 27'b110000000000001100111000000;
            T31: s[0:26] = 27'b000000000000001100110100000;
            T32: s[0:26] = 27'b110000000000001100111100000;
            T33: s[0:26] = 27'b000000000000011011100010000;
            T34: s[0:26] = 27'b000000000000011011101010000;
            T35: s[0:26] = 27'b000000000000011011100110000;
            T36: s[0:26] = 27'b000000000000011011101110000;
            T37: s[0:26] = 27'b000000000000101000000001000;
            T38: s[0:26] = 27'b000000000100101000000001000;
            T39: s[0:26] = 27'b000011100000001000001000100;
            T40: s[0:26] = 27'b000011010010001000000000000;
            T41: s[0:26] = 27'b000000000000001111111001000;
            T42: s[0:26] = 27'b000000000000001111110100000;
            T43: s[0:26] = 27'b000000000000001111100101000;
            T44: s[0:26] = 27'b000000000000001111101101000;
            T45: s[0:26] = 27'b110000000000001111110011000;
            T46: s[0:26] = 27'b110000000000001111111000000;
            T47: s[0:26] = 27'b110000000000001011101011000;
            T48: s[0:26] = 27'b000000000000101111100111000;
            T49: s[0:26] = 27'b000000000000001111100111100;
            T50: s[0:26] = 27'b000000000000001011100000100;
            T51: s[0:26] = 27'b000000000000001000000000010;
            T52: s[0:26] = 27'b111000000000000000000000000;
            T53: s[0:26] = 27'b111001000000000000000000001;
            T54: s[0:26] = 27'b111011000000000000000000000;
            T55: s[0:26] = 27'b110000000000000000000000000;
            default: s[0:26] = 27'b00000000000000000000000000;
        endcase
        if(state0 == T3)
            s[52] = 1;
        else
            s[52] = 0;
    end
    //////////////////////////
    // state machine 2
    /////////////////////////
    always @(posedge clk)
    begin
        if(clr == 0)    state1 <= 0;
        else
        begin
        case(state1)
        T0:
            if(ps0r ==1) state1 <= T32;
            else         state1 <= T0;
        T1:   state1 <= T0;//JW
        T2:   state1 <= T0;
        T3:   state1 <= T0;//JW
        T4:   state1 <= T0;
        T5:
            if(d_rdy == 1) state1 <= T6;
            else           state1 <= T5;
        T6: 
            if(d_odv == 1) state1 <= T7;
            else           state1 <= T6;
        T7:   state1 <= T0;
        T8: 
            if(d_rdy == 1) state1 <= T9;
            else           state1 <= T8;
        T9:
            if(d_odv == 1) state1 <= T10;
            else           state1 <= T9;
        T10:  state1 <= T0;
        T11:  state1 <= T0;
        T12:
            if(d_rdy == 1) state1 <= T13;
            else           state1 <= T12;
        T13:
            if(d_odv == 1) state1 <= T0;
            else           state1 <= T13;
        T14:   state1 <= T0;
        T15:
            if(d_rdy == 1) state1 <= T16;
            else           state1 <= T15;
        T16:
            if(d_odv == 1) state1 <= T0;
            else           state1 <= T16;
        T17:   state1 <= T0;
        T18:   state1 <= T0;
        T19:   state1 <= T0;
        T20:
            if(d_rdy == 1) state1 <= T21;
            else           state1 <= T20;
        T21:
            if(d_odv == 1) state1 <= T30;
            else           state1 <= T21;
        T22:
            if(d_rdy == 1) state1 <= T23;
            else           state1 <= T22;
        T23:
            if(d_odv == 1) state1 <= T0;
            else           state1 <= T23;
        T24:   state1 <= T0;
        T25:   state1 <= T0;
        T26:
            if(hs_in == 1)  state1 <= T27;
            else            state1 <= T26;
        T27:
            if(hs_in == 1) state1 <= T27;
            else           state1 <= T0;
        T28:
            if(hs_in == 1) state1 <= T29;
            else           state1 <= T28;
        T29:
            if(hs_in == 1) state1 <= T29;
            else           state1 <= T0;
        T30:   state1 <= 0;
        T32:
            case(st1)
            0:  state1 <= T18;
            1:  state1 <= T3;
            2:  state1 <= T5;
            3:  state1 <= T8;
            4:  state1 <= T11;
            5:  state1 <= T12;
            6:  state1 <= T14;
            7:  state1 <= T15;
            8:  state1 <= T17;
            9:  state1 <= T1;
            10: state1 <= T19;
            11: state1 <= T20;
            12: state1 <= T22;
            13: state1 <= T24;
            14: state1 <= T25;
            15: state1 <= T26;
            16: state1 <= T28;
            17: state1 <= T2;
            default: state1 <= 0;
            endcase
        default: state1 <= T0;
        endcase
        end
    end
    /////////////////////////////////////////
    // logic for second stage state
    // machine
    /////////////////////////////////////////
    always @(state1)
    begin
        case(state1)
            T0:  s[27:44] = 18'b100000000000000011;
            T1:  s[27:44] = 18'b100000000001000011;
            T2:  s[27:44] = 18'b100000000001000000;
            T3:  s[27:44] = 18'b110000000001000011;
            T4:  s[27:44] = 18'b100000000001000011;
            T5:  s[27:44] = 18'b000000000010010011;
            T6:  s[27:44] = 18'b101000000011011011;
            T7:  s[27:44] = 18'b101000000001000011;
            T8:  s[27:44] = 18'b000000000110010011;
            T9:  s[27:44] = 18'b101000000111011011;
            T10: s[27:44] = 18'b101000000001000011;
            T11: s[27:44] = 18'b100011011001100000;
            T12: s[27:44] = 18'b000000000000000011;
            T13: s[27:44] = 18'b101011011101110000;
            T14: s[27:44] = 18'b100011011001000000;
            T15: s[27:44] = 18'b000000000000000011;
            T16: s[27:44] = 18'b101011011101010000;
            T17: s[27:44] = 18'b100011000001100000;
            T18: s[27:44] = 18'b100000000001000000;
            T19: s[27:44] = 18'b100000100001000010;
            T20: s[27:44] = 18'b000000100010011010;
            T21: s[27:44] = 18'b101000100011011010;
            T22: s[27:44] = 18'b000000000000011011;
            T23: s[27:44] = 18'b101000000001011011;
            T24: s[27:44] = 18'b100000000001000010;
            T25: s[27:44] = 18'b100000000001000001;
            T26: s[27:44] = 18'b000100000000000011;
            T27: s[27:44] = 18'b111000000001000000;
            T28: s[27:44] = 18'b000000000000000111;
            T29: s[27:44] = 18'b100000000001000100;
            T30: s[27:44] = 18'b101000100001000010;
            T32: s[27:44] = 18'b100001000000000011;
            default: s[27:44] = 18'b0000000000000000;
        endcase
        if(state1 == T2)
            s[53:54] = 2'b11;
        else
            s[53:54] = 2'b00;
    end
    ////////////////////////
    // third stage state
    // machine
    ////////////////////////
    always @ (posedge clk)
    begin
        if(clr == 0)    state2 <= 0;
        else
        begin
        case(state2)
        T0:
            if(ps1r == 1)   state2 <= T4;
            else            state2 <= T0;
                
        T1:  state2 <= T0;
        T2:
            if(d_odv == 1)  state2 <= T0;
            else            state2 <= T2;
        T3:  state2 <= T0;
        T4: case(st2)
                    0:  state2 <= T0;
                    1:  state2 <= T2;
                    2:  state2 <= T3;
                    3:  state2 <= T1;
                    default: state2 <= T0;
            endcase
        default: state2 <= T0;
        endcase
        end
    end

    ////////////////////////////////
    // stage three logic
    ////////////////////////////////
    always @ (state2)
    begin
        case(state2)
            T0: s[45:51] = 7'b0100010;
            T1: s[45:51] = 7'b0101001;
            T2: s[45:51] = 7'b1010000;
            T3: s[45:51] = 7'b0100100;
            T4: s[45:51] = 7'b0100001;
            default: s[45:51] = 7'b0000000;
        endcase
    end
    ////////////////////////////////
    // always block to set ps0r
    ////////////////////////////////
    always @ (posedge clk)
    begin
        if(state0 == 0)     ps0r = 1;
        else                ps0r = 0;
    end
    /////////////////////////////////
    // always block to set ps1r
    ////////////////////////////////
    always @ (state1)
    begin
        if(state1 == 0) ps1r = 1;
        else            ps1r = 0;
    end
    /////////////////////////////////
    // always block to set ps2r
    ////////////////////////////////
    always @ (state2)
    begin
        if(state2 == 0) ps2r = 1;
        else            ps2r = 0;
    end
    /////////////////////////////////
    // always block to set d_rdy
    ////////////////////////////////
    always @(state2)
    begin
        case(state2)
            0:d_rdy=1;
            1:d_rdy=1;
            2:d_rdy=0;
            3:d_rdy=1;
            default:d_rdy=1;
        endcase
    end
    /////////////////////////////////
    // always block to set hs_out
    ////////////////////////////////
    always @(state1)
    begin
        case(state1)
            T27: hs_out = 1;
            T29: hs_out = 1;
            default: hs_out = 0;
        endcase
    end

endmodule

