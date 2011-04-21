`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  University of Kentucky
// Engineer: Danny Peters and John Wright
// 
// Create Date:    20:42:06 04/20/2011 
// Design Name: 
// Module Name:    controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module controller(opcode, g_clr, g_clk, i_odv, d_odv, hs_out, hs_in, s);
    ////////////////////////
    // inputs
    ////////////////////////
    input [5:0]   opcode;
    input         g_clk;
    input         i_odv;
    input         d_odv;
    input         hs_in;
    ////////////////////////
    // outputs
    ////////////////////////
    output [27:0] s;
    output        g_clr;
    output        hs_out;
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
    //////////////////////////////////////////
    // register to hold state and next state
    //////////////////////////////////////////
    reg [5:0] state0;
    reg [5:0] state1;
    reg [5:0] state2;
    //////////////////////////////////////////
    // always block to begin state machine
    //////////////////////////////////////////
    always @ (posedge g_clk)
    begin
            case(state0)
            T0:
            begin
                if(ps1r == 0)   state0 <= T0;
                else
                begin
                    if(i_pending == 1) state0 <= T1;
                    else               state0 <= T3;
                end
            end
            T1:
            begin
                state0 <= T2;
            end
            T2:
            begin
                state0 <= T3;
            end
            T3:
            begin
                if(i_dov == 1)  state0 <= T4;
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
            T5:
            begin
                state0 <= T0;
            end
            T6:
            begin
                state0 <= T52;
            end
            T7:
            begin
                state0 <= T0;
            end
            T8:
            begin
                state0 <= T52;
            end
            T9:
            begin
                state0 <= T0;
            end
            T10:
            begin
                state0 <=T52;
            end
            T11:
            begin
                state0 <= T0;
            end
            T12:
            begin
                state0 <= T52;
            end
            T13:
            begin
                state0 <= T0;
            end
            T14:
            begin
                state0 <= T0;
            end
            T15:
            begin
                state0 <= T0;
            end
            T16:
            begin
                state0 <= T52;
            end
            T17:
            begin
                state0 <= T0;
            end
            T18:
            begin
                state0 <= T52;
            end
            T19:
            begin
                state0 <= T0;
            end
            T20:
            begin
                state0 <= T52;
            end
            T21:
            begin
                state0 <= T0;
            end
            T22:
            begin
                state0 <= T52;
            end
            T23:
            begin
                state0 <= T0;
            end
            T24:
            begin
                state0 <= T52;
            end
            T25:
            begin
                state0 <= T0;
            end
            T26:
            begin
                state0 <= T52;
            end
            T27:
            begin
                state0 <= T0;
            end
            T28:
            begin
                state0 <= T52;
            end
            T29:
            begin
                state0 <= T0;
            end
            T30:
            begin
                state0 <= T52;
            end
            T31:
            begin
                state0 <= T0;
            end
            T32:
            begin
                state0 <= T52;
            end
            T33:
            begin
                state0 <= T0;
            end
            T34:
            begin
                state0 <= T52;
            end
            T35:
            begin
                state0 <= T0;
            end
            T36:
            begin
                state0 <= T0;
            end
            T37:
            begin
                state0 <= T0;
            end
            T38:
            begin
                state0 <= T0;
            end
            T39:
            begin
                state0 <= T0;
            end
            T40:
            begin
                state0 <= T0;
            end
            T41:
            begin
                state0 <= T0;
            end
            T42:
            begin
                state0 <= T0;
            end
            T43:
            begin
                state0 <= T0;
            end
            T44:
            begin
                state0 <= T0;
            end
            T45:
            begin
                state0 <= T52;
            end
            T46:
            begin
                state0 <= T52;
            end
            T47:
            begin
                state0 <= T52;
            end
            T48:
            begin
                state0 <= T0;
            end
            T49:
            begin
                state0 <= T0;
            end
            T50:
            begin
                state0 <= T0;
            end
            T51:
            begin
                state0 <= T0;
            end
            T52:
            begin
                if(i_odv == 1) state0 <= T53;
                else           state0 <=T52;

            end
            T53:
            begin
                state0 <= T0;
            end
            default: state0 <= T0;
            endcase
    end
    always @(posedge g_clk)
    begin
        case(state1)
        T0:
        begin
            if(ps2r == 0) state1 <= T0;
            else
            begin

            end
        end
        T1:
        begin
        end
        T2:
        begin
        end
        T3:
        begin
        end
        endcase
    end
endmodule
