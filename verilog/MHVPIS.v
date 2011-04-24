`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////
//John Wright & Danny Peters
//University of Kentucky
//EE480 Spring 2011
//DV Final Project
//
//MHVPIS.v
//
//A maskable hardware vectorized priority interrupt system.
//
//  Priority:
//    3- external interrupt signal
//    2- illegal opcode
//    1- overflow
//    0- zero
//
///////////////////////////////////////////////////////////////////////////////////////
module MHVPIS(irupt_in, mask_in, clr, enable, i_pending, PC_out);
    input [3:0] irupt_in;               //4-bit vector for interrupt input signals
    input [3:0] mask_in;                //4-bit mask input vector
    input clr;                          //system-wide clr (active low) to initialize address registers
    input enable;                       //enable 1=enabled 0=disabled
    output i_pending;                   //interrupt pending 1=pending, 0=not pending
    output [7:0] PC_out;                //address output to ISR
    wire [3:0] w_mask;                  //input wire to 4-bit priority encoder
    wire [1:0] encoder_out;             //output from 4-bit priority encoder
    reg [31:0] addresses;               //ISR addresses
    
    and (w_mask[0],irupt_in[0],mask_in[0]);
    and (w_mask[1],irupt_in[1],mask_in[1]);
    and (w_mask[2],irupt_in[2],mask_in[2]);
    and (w_mask[3],irupt_in[3],mask_in[3]);
    
    //module encoder(in,enable,out,valid);
    encoder ENCODER0 (w_mask,enable,encoder_out,i_pending);
    //Choose PC_out
    MUX_mxn #(.d_width(8),.s_lines(2)) PCMUX (addresses,encoder_out,PC_out);

    //during system-wide clear (initialization) set address registers
    always@(clr)
    begin
        if(clr == 0)
        begin
            addresses[7:0] = 8'b00010001;   //isr0 --> zero ALU out interrupt service routine
            addresses[15:8] = 8'b00110011;  //isr1 --> arithmetic overflow interrupt service routine
            addresses[23:16] = 8'b11110000; //isr2 --> illegal opcode interrupt service routine
            addresses[31:24] = 8'b10101010; //isr3 --> external interrupt service routine
        end
    end
    
endmodule
